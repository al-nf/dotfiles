import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam
import Quickshell.Wayland

ShellRoot {
    id: root

    readonly property bool greeter: false
    readonly property bool preview: false
    property bool busy: false
    property bool failed: false
    property bool automaticAttempt: false
    property bool echoResponse: false
    property string prompt: "password"
    property string message: ""
    property string pendingResponse: ""
    property bool hasPendingResponse: false
    property bool suspendPending: Quickshell.env("PETRA_LM_SUSPEND") === "1"

    signal clearPassword()
    signal automaticAttemptFinished()

    function submit(response, automatic) {
        if (busy)
            return;
        automaticAttempt = !!automatic;
        failed = false;
        busy = true;
        message = automatic ? "" : "Unlocking…";
        if (pam.responseRequired) {
            pam.respond(response);
        } else {
            pendingResponse = response;
            hasPendingResponse = true;
            if (!pam.start()) {
                automaticAttempt = false;
                pendingResponse = "";
                hasPendingResponse = false;
                busy = false;
                failed = true;
                message = "Couldn’t start authentication. Please try again.";
                clearPassword();
            }
        }
    }

    function cancel() {
        automaticAttempt = false;
        pam.abort();
        pendingResponse = "";
        hasPendingResponse = false;
        busy = false;
        echoResponse = false;
        prompt = "password";
        message = "";
        clearPassword();
    }

    PamContext {
        id: pam
        config: "petra-lock"

        onPamMessage: {
            root.echoResponse = responseVisible;
            if (responseRequired) {
                if (root.hasPendingResponse && !responseVisible) {
                    const response = root.pendingResponse;
                    root.pendingResponse = "";
                    root.hasPendingResponse = false;
                    respond(response);
                } else {
                    root.pendingResponse = "";
                    root.hasPendingResponse = false;
                    root.busy = false;
                    root.prompt = message;
                    root.message = "";
                    root.clearPassword();
                }
            } else if (message.length > 0 && !root.automaticAttempt) {
                root.message = message;
                root.failed = messageIsError;
            }
        }

        onCompleted: result => {
            const keepPassword = root.automaticAttempt;
            root.automaticAttempt = false;
            root.pendingResponse = "";
            root.hasPendingResponse = false;
            root.busy = false;
            root.echoResponse = false;
            if (result === PamResult.Success) {
                root.clearPassword();
                sessionLock.locked = false;
                Qt.quit();
            } else {
                root.failed = !keepPassword;
                root.prompt = "password";
                root.message = keepPassword ? "" : "Couldn’t unlock. Please try again.";
                if (keepPassword)
                    root.automaticAttemptFinished();
                else
                    root.clearPassword();
            }
        }
    }

    Process {
        id: suspendProcess
        command: [Quickshell.env("PETRA_LM_SYSTEMCTL") || "/run/current-system/sw/bin/systemctl", "suspend"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0)
                root.message = "Couldn’t suspend. Check system permissions and sleep settings.";
        }
    }

    WlSessionLock {
        id: sessionLock
        locked: true
        onSecureChanged: {
            if (secure && root.suspendPending) {
                root.suspendPending = false;
                suspendProcess.running = true;
            }
        }

        WlSessionLockSurface {
            color: "#11111b"

            SessionView {
                anchors.fill: parent
                controller: root
            }
        }
    }
}
