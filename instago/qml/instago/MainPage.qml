import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    Button{
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.verticalCenter
            topMargin: 10
        }

        font.family: "Nokia Pure Text"
        text: qsTr("Popular Photos")
        onClicked: { pageStack.push(Qt.resolvedUrl("PopularPhotosPage.qml")) }
    }
}
