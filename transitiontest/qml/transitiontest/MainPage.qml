import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    Button{
        anchors.centerIn: parent

        text: qsTr("Click here!")
        onClicked: { pageStack.push(Qt.resolvedUrl("hello.qml")) }
    }
}
