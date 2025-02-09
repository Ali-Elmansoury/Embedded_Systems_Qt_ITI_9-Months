import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Loading Pics from Different Sources")

    // Property to track if any image is visible
    property bool imageVisible: false

    // Button states
    property bool button1: false
    property bool button2: false
    property bool button3: false
    property bool button4: false

    property int buttonWidth: 250
    property int buttonHeight: 75

    Column {
        spacing: 100
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 50

        Button {
            id: btn1
            width: buttonWidth
            height: buttonHeight
            enabled: !imageVisible || button1 // Enable this button if its image is visible
            background: Rectangle {
                color: "lightblue"
                radius: 5
            }
            contentItem: Text {
                text: button1 ? "Hide Image" : "Load pic from path"
                font.pixelSize: 15
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }
            onClicked: {
                button1 = !button1
                button2 = false
                button3 = false
                button4 = false
                updateImageVisibility()
            }
        }

        Button {
            id: btn2
            width: buttonWidth
            height: buttonHeight
            enabled: !imageVisible || button2 // Enable this button if its image is visible
            background: Rectangle {
                color: "lightgreen"
                radius: 5
            }
            contentItem: Text {
                text: button2 ? "Hide Image" : "Load pic from working dir"
                font.pixelSize: 15
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }
            onClicked: {
                button1 = false
                button2 = !button2
                button3 = false
                button4 = false
                updateImageVisibility()
            }
        }
    }

    Column {
        spacing: 100
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 50

        Button {
            id: btn3
            width: buttonWidth
            height: buttonHeight
            enabled: !imageVisible || button3 // Enable this button if its image is visible
            background: Rectangle {
                color: "lightcoral"
                radius: 5
            }
            contentItem: Text {
                text: button3 ? "Hide Image" : "Load pic from resources file"
                font.pixelSize: 15
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                button1 = false
                button2 = false
                button3 = !button3
                button4 = false
                updateImageVisibility()
            }
        }

        Button {
            id: btn4
            width: buttonWidth
            height: buttonHeight
            enabled: !imageVisible || button4 // Enable this button if its image is visible
            background: Rectangle {
                color: "lightgoldenrodyellow"
                radius: 5
            }
            contentItem: Text {
                text: button4 ? "Hide Image" : "Load pic from URL"
                font.pixelSize: 15
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                button1 = false
                button2 = false
                button3 = false
                button4 = !button4
                updateImageVisibility()
            }
        }
    }

    Item {
        id: picFrame
        height: 600
        width: 900
        anchors.centerIn: parent

        Image {
            id: picP
            height: picFrame.height
            width: picFrame.width
            anchors.centerIn: parent
            source: "file:/home/ali/Downloads/infotainment_kia.jpg"
            visible: button1
            Text {
                id: image1Text
                text: qsTr("Method(1): Loading pic from path")
                y: picP.y + picP.height
                x: picP.x
            }
        }

        Image {
            id: picWD
            height: picFrame.height
            width: picFrame.width
            anchors.centerIn: parent
            source: "file:infotainment_bmw.png"
            visible: button2
            Text {
                id: image2Text
                text: qsTr("Method(2): Loading pic from working dir")
                y: picWD.y + picWD.height
                x: picWD.x
            }
        }

        Image {
            id: picR
            height: picFrame.height
            width: picFrame.width
            anchors.centerIn: parent
            source: "qrc:/infotainment-system.png"
            visible: button3
            Text {
                id: image3Text
                text: qsTr("Method(3): Loading pic from resources file")
                y: picR.y + picR.height
                x: picR.x
            }
        }

        Image {
            id: picI
            height: picFrame.height
            width: picFrame.width
            anchors.centerIn: parent
            source: "https://www.envistaforensics.com/media/2r0mern4/adobestock_448754698.jpeg?quality=80"
            asynchronous: true
            visible: button4
            Text {
                id: image4Text
                text: qsTr("Method(4): Loading pic from URL")
                y: picI.y + picI.height
                x: picI.x
            }
        }
    }

    // Function to update the image visibility state
    function updateImageVisibility() {
        imageVisible = button1 || button2 || button3 || button4
    }
}
