import QtQuick 1.0
import com.nokia.meego 1.0

Rectangle {
    id: rctResetCounterDialog
    height: parent.height
    width: parent.width
    color: "black"
    opacity: 0.85
    z: 2
    x: 0
    visible: false

    Text {
        id: txtDialogText
        text: "Reset the counter?"
        color: "white"
        anchors.top: parent.top
        anchors.topMargin: 300
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 18
    }


    Item {
        id: itmDialogButtons
        anchors.centerIn: parent
        width: btnYes.width + btnNo.width + btnNo.anchors.leftMargin
        height: btnYes.height

        Button {
            id: btnYes
            text: "Yes"
            width: 200
            onClicked: {
                txtCounter.text = 0
                mainPage.state = ""
            }
        }

        Button {
            id: btnNo
            text: "No"
            width: 200
            anchors.left: btnYes.right
            anchors.leftMargin: 20
            onClicked: mainPage.state = ""
        }
    }
}
