import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    states: [
        State {
            name: "stResetCounter"
            PropertyChanges {
                target: rctResetCounterDialog
                visible: true
            }

            PropertyChanges {
                target: btnIncreaseCounter
                enabled: false
                }

            PropertyChanges {
                target: btnResetCounter
                enabled: false
                }
        }
    ]

    Text {
        id: txtCounter
        anchors.centerIn: parent
        text: "0"
        font.pointSize: 100
    }

    Button{
        id: btnIncreaseCounter

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: txtCounter.bottom
            topMargin: 10
        }
        text: qsTr("Increase counter")

        onClicked: {
            var count = parseInt(txtCounter.text)
            count = count+1
            txtCounter.text = count
        }
    }

    Button{
        id: btnResetCounter

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: btnIncreaseCounter.bottom
            topMargin: 10
        }
        text: qsTr("Reset counter")

        onClicked: {
            mainPage.state = "stResetCounter"
        }
    }

    ResetCounterDialog{
        id: rctResetCounterDialog
    }
}
