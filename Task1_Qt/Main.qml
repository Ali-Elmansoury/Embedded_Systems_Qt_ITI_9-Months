import QtQuick

Window {
    width: 900
    height: 480
    visible: true
    title: "Text Shapes"

    Row {
        anchors.centerIn: parent
        spacing: 20

        // First Shape (Blue & Red)
        Rectangle {
            width: 125
            height: 125
            color: "blue"
            border.color: "blue"
            border.width: 10
            radius: 20

            Rectangle {
                width: 100
                height: 100
                color: "red"
                anchors.centerIn: parent

                Text {
                    anchors.centerIn: parent
                    text: "Hello"
                    font {
                        family: "Arial"
                        pixelSize: 15
                        bold: true
                    }
                }
            }
        }

        // Second Shape (Green & Yellow)
        Rectangle {
            width: 125
            height: 125
            color: "green"
            border.color: "darkgreen"
            border.width: 10
            radius: 20

            Rectangle {
                width: 100
                height: 100
                color: "yellow"
                anchors.centerIn: parent

                Text {
                    anchors.centerIn: parent
                    text: "World"
                    font {
                        family: "Arial"
                        pixelSize: 15
                        bold: true
                    }
                }
            }
        }

        // Third Shape (Purple & Orange)
        Rectangle {
            width: 125
            height: 125
            color: "purple"
            border.color: "darkviolet"
            border.width: 10
            radius: 20

            Rectangle {
                width: 100
                height: 100
                color: "orange"
                anchors.centerIn: parent

                Text {
                    anchors.centerIn: parent
                    text: "I'm"
                    font {
                        family: "Arial"
                        pixelSize: 15
                        bold: true
                    }
                }
            }
        }

        // Fourth Shape (Teal & Pink)
        Rectangle {
            width: 125
            height: 125
            color: "teal"
            border.color: "darkcyan"
            border.width: 10
            radius: 20

            Rectangle {
                width: 100
                height: 100
                color: "pink"
                anchors.centerIn: parent
                radius: 10

                Text {
                    anchors.centerIn: parent
                    text: "Ali"
                    font {
                        family: "Arial"
                        pixelSize: 15
                        bold: true
                    }
                }
            }
        }

        // Fifth Shape (Circle - Brown)
        Rectangle {
            width: 125
            height: 125
            color: "lightblue"
            border.color: "darkred"
            border.width: 10
            radius: 62  // Full rounding to create a circle

            Text {
                anchors.centerIn: parent
                text: "Elmansoury"
                font {
                    family: "Arial"
                    pixelSize: 15
                    bold: true
                }
            }
        }
    }
}
