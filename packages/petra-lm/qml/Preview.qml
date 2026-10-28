import QtQuick
import Quickshell

ShellRoot {
    id: root

    readonly property bool greeter: true
    readonly property bool preview: true
    readonly property bool busy: false
    readonly property bool failed: false
    readonly property bool automaticAttempt: false
    readonly property bool echoResponse: false
    readonly property string prompt: "password"
    property string message: ""

    signal clearPassword()
    signal automaticAttemptFinished()

    function submit(response) {
        message = "Preview only — authentication is disabled.";
        clearPassword();
    }

    function cancel() { Qt.quit(); }

    FloatingWindow {
        title: "petra-lm preview"
        visible: true
        implicitWidth: 1280
        implicitHeight: 720
        color: "#11111b"

        SessionView {
            anchors.fill: parent
            controller: root
        }
    }
}
