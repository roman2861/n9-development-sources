import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("Hello world!")
        visible: true
    }

    Button{
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: label.bottom
            topMargin: 10
        }
        text: qsTr("Go back!")
        onClicked: { pageStack.pop() }
    }
}
