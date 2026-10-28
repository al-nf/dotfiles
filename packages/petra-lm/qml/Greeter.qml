import QtQuick
import Quickshell
import Quickshell.Services.Greetd

ShellRoot {
    id: root

    readonly property bool greeter: true
    readonly property bool preview: false
    property bool busy: false
    property bool failed: false
    property bool automaticAttempt: false
    property bool automaticInput: false
    property bool echoResponse: false
    property bool waitingForResponse: false
    property string prompt: "password"
    property string message: ""
    property string pendingResponse: ""
    property bool hasPendingResponse: false
    readonly property var sessionCommand: JSON.parse(Quickshell.env("PETRA_LM_SESSION_COMMAND") || "[]")

    signal clearPassword()
    signal automaticAttemptFinished()

    Timer {
        id: retryTimer
        interval: 200
        onTriggered: {
            root.automaticAttempt = false;
            root.busy = false;
            root.automaticAttemptFinished();
        }
    }

    function submit(response, automatic) {
        if (busy || !Greetd.available || sessionCommand.length === 0) {
            message = "Login service unavailable.";
            return;
        }
        automaticAttempt = !!automatic;
        automaticInput = !!automatic;
        failed = false;
        message = automatic ? "" : "Signing in…";
        busy = true;
        if (waitingForResponse) {
            waitingForResponse = false;
            Greetd.respond(response);
        } else {
            pendingResponse = response;
            hasPendingResponse = true;
            Greetd.createSession("afung");
        }
    }

    function cancel() {
        retryTimer.stop();
        automaticAttempt = false;
        automaticInput = false;
        pendingResponse = "";
        hasPendingResponse = false;
        waitingForResponse = false;
        Greetd.cancelSession();
        busy = false;
        message = "";
        prompt = "password";
        echoResponse = false;
        clearPassword();
    }

    Connections {
        target: Greetd

        function onAuthMessage(message, error, responseRequired, echoResponse) {
            root.echoResponse = echoResponse;
            if (responseRequired) {
                if (root.hasPendingResponse && !echoResponse) {
                    const response = root.pendingResponse;
                    root.pendingResponse = "";
                    root.hasPendingResponse = false;
                    Greetd.respond(response);
                } else {
                    root.pendingResponse = "";
                    root.hasPendingResponse = false;
                    root.waitingForResponse = true;
                    root.busy = false;
                    root.prompt = message;
                    root.message = "";
                    root.clearPassword();
                }
            } else if (!root.automaticInput) {
                root.message = message;
                root.failed = error;
            }
        }

        function onAuthFailure(message) {
            const keepPassword = root.automaticInput;
            root.pendingResponse = "";
            root.hasPendingResponse = false;
            root.waitingForResponse = false;
            root.busy = keepPassword;
            root.failed = !keepPassword;
            root.echoResponse = false;
            root.prompt = "password";
            root.message = keepPassword ? "" : "Couldn’t sign in. Please try again.";
            if (keepPassword)
                retryTimer.restart();
            else
                root.clearPassword();
        }

        function onError(error) {
            const keepPassword = root.automaticInput;
            root.pendingResponse = "";
            root.hasPendingResponse = false;
            root.waitingForResponse = false;
            root.busy = keepPassword;
            root.failed = !keepPassword;
            root.echoResponse = false;
            root.prompt = "password";
            root.message = keepPassword ? "" : "Login service error. Please try again.";
            if (keepPassword)
                retryTimer.restart();
            else
                root.clearPassword();
        }

        function onReadyToLaunch() {
            root.pendingResponse = "";
            root.hasPendingResponse = false;
            Greetd.launch(root.sessionCommand);
        }
    }

    FloatingWindow {
        title: "petra-lm"
        visible: true
        fullscreen: true
        color: "#11111b"

        SessionView {
            anchors.fill: parent
            controller: root
        }
    }
}
