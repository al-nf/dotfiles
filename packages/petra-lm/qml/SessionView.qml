import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Io

Item {
    id: view

    required property var controller
    readonly property real scaleFactor: Math.max(0.7, Math.min(width / 1600, height / 900))
    property date now: new Date()
    property string pendingPassword: ""
    property string pendingPowerAction: ""
    property string powerError: ""

    function clearPassword() {
        pendingPassword = "";
        password.clear();
        password.forceActiveFocus();
    }

    function checkNextPassword() {
        if (controller.busy || pendingPassword.length === 0)
            return;
        const response = pendingPassword;
        pendingPassword = "";
        controller.submit(response, true);
    }

    function requestPower(action) {
        powerError = "";
        pendingPowerAction = action;
        powerDialog.open();
    }

    function confirmPower() {
        const action = pendingPowerAction;
        if (action !== "reboot" && action !== "poweroff")
            return;
        powerDialog.close();
        pendingPowerAction = "";
        if (controller.preview) {
            powerError = "Preview only — power controls are disabled.";
            return;
        }
        powerProcess.exec(["/run/current-system/sw/bin/systemctl", action]);
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: view.now = new Date()
    }

    Process {
        id: powerProcess
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0)
                view.powerError = "Power action failed. Check system permissions.";
        }
    }

    Connections {
        target: view.controller
        function onClearPassword() { view.clearPassword(); }
        function onAutomaticAttemptFinished() { Qt.callLater(view.checkNextPassword); }
    }

    Image {
        anchors.fill: parent
        source: Qt.resolvedUrl("wallpaper.jpg")
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0; color: "#dc11111b" }
            GradientStop { position: 0.52; color: "#6011111b" }
            GradientStop { position: 1; color: "#1811111b" }
        }
    }

    Item {
        width: Math.min(parent.width - 64, 496 * view.scaleFactor)
        height: content.implicitHeight
        anchors.left: parent.left
        anchors.leftMargin: Math.max(32, parent.width * 0.09)
        anchors.verticalCenter: parent.verticalCenter

        ColumnLayout {
            id: content
            width: parent.width
            spacing: 16 * view.scaleFactor

            /*
            Label {
                text: "P E T R A"
                color: "#cba6f7"
                font.pixelSize: 13 * view.scaleFactor
                font.weight: Font.DemiBold
                font.letterSpacing: 4
            }
            */

            Label {
                text: Qt.formatDateTime(view.now, "HH:mm")
                color: "#f5f1ed"
                font.pixelSize: 104 * view.scaleFactor
                font.weight: Font.Light
                font.letterSpacing: -5
            }

            Label {
                text: Qt.formatDateTime(view.now, "dddd, MMMM d")
                color: "#cdd6f4"
                font.family: "JetBrains Mono"
                font.letterSpacing: 0
                font.pixelSize: 20 * view.scaleFactor
            }

            Rectangle {
                Layout.topMargin: 12 * view.scaleFactor
                Layout.bottomMargin: 12 * view.scaleFactor
                width: 48 * view.scaleFactor
                height: 2
                color: "#cba6f7"
            }

            /*
            Label {
                text: view.controller.greeter ? "L O G I N" : "UNLOCK"
                color: "#f5f1ed"
                font.pixelSize: 27 * view.scaleFactor
                font.weight: Font.Medium
            }
            */

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 12 * view.scaleFactor
                spacing: 12 * view.scaleFactor

                TextField {
                    id: password
                    Layout.fillWidth: true
                    implicitHeight: 52 * view.scaleFactor
                    focus: true
                    font.family: "JetBrains Mono"
                    font.letterSpacing: 0
                    enabled: !view.controller.busy || view.controller.automaticAttempt
                    onEnabledChanged: if (enabled) forceActiveFocus()
                    echoMode: view.controller.echoResponse ? TextInput.Normal : TextInput.Password
                    passwordCharacter: "∗"
                    placeholderText: view.controller.prompt
                    placeholderTextColor: "#a6adc8"
                    color: "#cdd6f4"
                    font.pixelSize: 16 * view.scaleFactor
                    leftPadding: 18
                    rightPadding: 18
                    selectByMouse: true
                    inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                    onTextChanged: {
                        if (!view.controller.preview && !view.controller.echoResponse) {
                            view.pendingPassword = text;
                            view.checkNextPassword();
                        }
                    }
                    onAccepted: {
                        if (!enabled || view.controller.busy)
                            return;
                        view.pendingPassword = "";
                        const response = text;
                        clear();
                        view.controller.submit(response, false);
                    }
                    Keys.onEscapePressed: {
                        clear();
                        view.controller.cancel();
                    }
                    background: Rectangle {
                        radius: 14 * view.scaleFactor
                        color: "#d91e1e2e"
                    }
                }

                Button {
                    id: powerButton
                    Layout.alignment: Qt.AlignVCenter
                    implicitWidth: 44 * view.scaleFactor
                    implicitHeight: 40 * view.scaleFactor
                    padding: 0
                    horizontalPadding: 0
                    verticalPadding: 0
                    text: "Power options"
                    Accessible.name: text
                    onClicked: powerMenu.opened ? powerMenu.close() : powerMenu.open()
                    background: Rectangle {
                        radius: 10 * view.scaleFactor
                        color: powerButton.hovered || powerMenu.opened ? "#8045455a" : "#601e1e2e"
                    }
                    contentItem: Item {
                        Shape {
                            id: powerIcon
                            x: (parent.width - boundingRect.width) / 2 - boundingRect.x
                            y: (parent.height - boundingRect.height) / 2 - boundingRect.y
                            width: 22 * view.scaleFactor
                            height: width
                            preferredRendererType: Shape.CurveRenderer

                            ShapePath {
                                strokeColor: "#cdd6f4"
                                strokeWidth: 1.8 * view.scaleFactor
                                fillColor: "transparent"
                                capStyle: ShapePath.RoundCap
                                startX: powerIcon.width * 0.765
                                startY: powerIcon.height * 0.277
                                PathArc {
                                    x: powerIcon.width * 0.235
                                    y: powerIcon.height * 0.277
                                    radiusX: powerIcon.width * 0.375
                                    radiusY: powerIcon.height * 0.375
                                    useLargeArc: true
                                    direction: PathArc.Clockwise
                                }
                            }

                            ShapePath {
                                strokeColor: "#cdd6f4"
                                strokeWidth: 1.8 * view.scaleFactor
                                fillColor: "transparent"
                                capStyle: ShapePath.RoundCap
                                startX: powerIcon.width * 0.5
                                startY: powerIcon.height / 12
                                PathLine {
                                    x: powerIcon.width * 0.5
                                    y: powerIcon.height * 0.5
                                }
                            }
                        }
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                Layout.minimumHeight: 20 * view.scaleFactor
                text: view.controller.message
                color: view.controller.failed ? "#f38ba8" : "#a6adc8"
                font.pixelSize: 13 * view.scaleFactor
                wrapMode: Text.WordWrap
            }

            Label {
                Layout.fillWidth: true
                text: view.powerError
                visible: text.length > 0
                color: "#f38ba8"
                font.pixelSize: 12 * view.scaleFactor
                wrapMode: Text.WordWrap
            }
        }
    }

    Menu {
        id: powerMenu
        parent: powerButton
        x: powerButton.width - width
        y: powerButton.height + 8 * view.scaleFactor
        width: 200 * view.scaleFactor
        padding: 6 * view.scaleFactor
        font.family: "JetBrains Mono"
        font.pixelSize: 14 * view.scaleFactor
        background: Rectangle {
            radius: 12 * view.scaleFactor
            color: "#f21e1e2e"
        }

        MenuItem {
            id: restartItem
            text: "Restart"
            onTriggered: view.requestPower("reboot")
            background: Rectangle {
                radius: 8 * view.scaleFactor
                color: restartItem.highlighted ? "#45475a" : "transparent"
            }
            contentItem: Text {
                text: restartItem.text
                font: restartItem.font
                color: "#cdd6f4"
                verticalAlignment: Text.AlignVCenter
            }
        }

        MenuItem {
            id: shutdownItem
            text: "Shut Down"
            onTriggered: view.requestPower("poweroff")
            background: Rectangle {
                radius: 8 * view.scaleFactor
                color: shutdownItem.highlighted ? "#45475a" : "transparent"
            }
            contentItem: Text {
                text: shutdownItem.text
                font: shutdownItem.font
                color: "#cdd6f4"
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Dialog {
        id: powerDialog
        x: (view.width - width) / 2
        y: (view.height - height) / 2
        width: Math.min(view.width - 64, 380 * view.scaleFactor)
        padding: 24 * view.scaleFactor
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape
        onClosed: {
            view.pendingPowerAction = "";
            password.forceActiveFocus();
        }
        background: Rectangle {
            radius: 16 * view.scaleFactor
            color: "#1e1e2e"
        }
        contentItem: ColumnLayout {
            spacing: 24 * view.scaleFactor

            Label {
                Layout.fillWidth: true
                text: view.pendingPowerAction === "reboot" ? "Restart this computer?" : "Shut down this computer?"
                font.family: "JetBrains Mono"
                font.pixelSize: 16 * view.scaleFactor
                color: "#cdd6f4"
                wrapMode: Text.WordWrap
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12 * view.scaleFactor

                Button {
                    id: cancelPowerButton
                    Layout.fillWidth: true
                    text: "Cancel"
                    implicitHeight: 40 * view.scaleFactor
                    font.family: "JetBrains Mono"
                    font.pixelSize: 13 * view.scaleFactor
                    onClicked: powerDialog.close()
                    background: Rectangle {
                        radius: 8 * view.scaleFactor
                        color: cancelPowerButton.hovered ? "#45475a" : "#313244"
                    }
                    contentItem: Text {
                        text: cancelPowerButton.text
                        font: cancelPowerButton.font
                        color: "#cdd6f4"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    id: confirmPowerButton
                    Layout.fillWidth: true
                    text: view.pendingPowerAction === "reboot" ? "Restart" : "Shut Down"
                    implicitHeight: 40 * view.scaleFactor
                    font.family: "JetBrains Mono"
                    font.pixelSize: 13 * view.scaleFactor
                    onClicked: view.confirmPower()
                    background: Rectangle {
                        radius: 8 * view.scaleFactor
                        color: confirmPowerButton.hovered ? "#b4befe" : "#cba6f7"
                    }
                    contentItem: Text {
                        text: confirmPowerButton.text
                        font: confirmPowerButton.font
                        color: "#1e1e2e"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }

    /*
    Label {
        anchors.left: parent.left
        anchors.leftMargin: Math.max(32, parent.width * 0.09)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 36 * view.scaleFactor
        text: "afung  /  " + (view.controller.greeter ? "sign in" : "session locked")
        color: "#a6adc8"
        font.pixelSize: 12 * view.scaleFactor
        font.letterSpacing: 1
    }
    */

    opacity: 0
    Component.onCompleted: appear.start()
    NumberAnimation {
        id: appear
        target: view
        property: "opacity"
        to: 1
        duration: 220
        easing.type: Easing.OutCubic
    }
}
