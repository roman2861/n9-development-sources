import QtQuick 1.0


Rectangle{
    id: header
    property alias text : txtHeader.text

    anchors {
        top: parent.top;
        left: parent.left;
        right: parent.right
    }

    width: parent.width ;
    height: parent.height/10
    color: "#0088AF"

    Text {
        id: txtHeader
        anchors
        {
            verticalCenter: parent.verticalCenter
        }
        x: 20
        font.pointSize: 25
        font.family: "Nokia Pure Text Light"
        text: qsTr(text)
        color: "white"
    }
}
