import QtQuick
import QtQuick.Controls
import QtQuick.Window

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 800
    title: "Driver Information Display"
    property real maxSpeed: 240
    property bool splashActive: true

    // Splash Screen Component
    Rectangle {
        id: splashScreen
        anchors.fill: parent
        z: 1000
        color: "black"
        visible: splashActive

        Column {
            anchors.centerIn: parent
            spacing: 30

            Image {
                source: "qrc:/ITI_Logo.svg"
                width: 500
                height: 500
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter // Center the button inside the column
            }

            Column {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: "INVEHICLE DRIVER INFORMATION DISPLAY UNIT"
                    color: "white"
                    font {
                        pixelSize: 32
                        bold: true
                        family: "Arial"
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Developed By: Ali Elmansoury"
                    color: "#aaaaaa"
                    font {
                        pixelSize: 24
                        family: "Arial"
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "ITI-9M-Embedded Systems Track"
                    color: "#aaaaaa"
                    font {
                        pixelSize: 24
                        family: "Arial"
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Text {
            text: "Initializing system..."
            color: "white"
            font.pixelSize: 24
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 50
            }
        }

        SequentialAnimation {
            id: splashAnimation
            running: true

            OpacityAnimator {
                target: splashScreen
                from: 0
                to: 1
                duration: 1000
            }

            PauseAnimation {
                duration: 4000
            }

            OpacityAnimator {
                target: splashScreen
                from: 1
                to: 0
                duration: 1000
            }

            onFinished: {
                splashActive = false
                mainContent.visible = true
            }
        }
    }

    // Main Application Content
    Rectangle {
        id: mainContent
        anchors.fill: parent
        visible: false
        color: "black"

        Rectangle {
            id: gauge
            width: Math.min(parent.width, parent.height) * 0.7
            height: width
            anchors.centerIn: parent
            radius: width / 2
            color: "transparent"
            border.color: "#777"
            border.width: 3
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#222" }
                GradientStop { position: 0.8; color: "#111" }
                GradientStop { position: 1.0; color: "#000" }
            }

            Repeater {
                model: 13
                delegate: Item {
                    property real angle: ((index * 20) / maxSpeed * 240 - 210) * Math.PI / 180
                    x: gauge.width / 2 + Math.cos(angle) * gauge.width * 0.42
                    y: gauge.height / 2 + Math.sin(angle) * gauge.height * 0.42
                    Text {
                        text: index * 20
                        color: "white"
                        font.pixelSize: gauge.width * 0.06
                        font.bold: true
                        anchors.centerIn: parent
                    }
                }
            }

            Rectangle {
                id: needle
                width: gauge.width * 0.012
                height: gauge.height * 0.4
                color: "#ff3333"
                antialiasing: true
                anchors.centerIn: parent
                transformOrigin: Item.Bottom
                rotation: {
                    var minAngle = -90
                    var maxAngle = 90
                    return minAngle + (gpioManager.speed / maxSpeed) * (maxAngle - minAngle)
                }
                Behavior on rotation {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.OutBack
                    }
                }
            }

            Rectangle {
                width: gauge.width * 0.07
                height: gauge.width * 0.07
                radius: width / 2
                color: "#666"
                border.color: "black"
                border.width: 2
                anchors.centerIn: parent
            }

            Rectangle {
                width: gauge.width * 0.25
                height: gauge.width * 0.1
                radius: 10
                color: "#333"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: gauge.height * 0.25
                Text {
                    id: speedText
                    text: Math.round(gpioManager.speed)
                    color: gpioManager.speed > 180 ? "#ff4444" : "white"
                    font.pixelSize: gauge.width * 0.08
                    font.bold: true
                    anchors.centerIn: parent
                }
            }
        }

        Column {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                margins: 20
            }
            spacing: 15

            Slider {
                id: speedSlider
                width: gauge.width * 0.4
                from: 0
                to: maxSpeed
                stepSize: 10
                value: gpioManager.speed
                onValueChanged: gpioManager.setSpeed(value)
            }

            Button {
                text: "Reset Speed"
                font.pixelSize: 20
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: gpioManager.resetSpeed()
            }
        }

        Column {
            id: leftSignalCol
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 150
            }
            spacing: 100

            Button {
                width: 100
                height: 50
                icon.height: 50
                icon.width: 50
                id: leftSignalButton
                icon.source: "qrc:/left-turn-signal.png"
                onClicked: gpioManager.toggleLeftLED()
                opacity: gpioManager.leftLedActive ? 0.6 : 1.0
                Behavior on opacity { NumberAnimation { duration: 100 } }
                anchors.horizontalCenter: parent.horizontalCenter // Center the button inside the column
            }

            AnimatedImage {
                id: leftCarSignal
                source: "qrc:/carLeftSignal.gif"
                width: 300
                height: 200
                playing: gpioManager.leftLedActive
                anchors.horizontalCenter: parent.horizontalCenter // Center the button inside the column
            }
        }

        Column {
            id: rightSignalCol
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 150
            }
            spacing: 100

            Button {
                width: 100
                height: 50
                icon.height: 50
                icon.width: 50
                id: rightSignalButton
                icon.source: "qrc:/right-turn-signal.png"
                onClicked: gpioManager.toggleRightLED()
                opacity: gpioManager.rightLedActive ? 0.6 : 1.0
                Behavior on opacity { NumberAnimation { duration: 100 } }
                anchors.horizontalCenter: parent.horizontalCenter // Center the button inside the column
            }

            AnimatedImage {
                id: rightCarSignal
                source: "qrc:/carRightSignal.gif"
                width: 300
                height: 200
                playing: gpioManager.rightLedActive
                anchors.horizontalCenter: parent.horizontalCenter // Center the button inside the column
            }
        }
    }
}
