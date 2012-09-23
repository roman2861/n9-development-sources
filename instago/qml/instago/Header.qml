// *************************************************** //
// Header Component
//
// The header component is used by the application pages.
// It displays a rectangle with a given background image
// and text.
// *************************************************** //

import QtQuick 1.0

Rectangle{
    id: header

    // text property for the header
    // set text will be shown in the header
    property alias text : txtHeader.text

    // image property for the header
    // given image will be shown (640x80)
    property alias source : imgHeader.source

    // place it on top
    anchors {
        top: parent.top;
        left: parent.left;
        right: parent.right
    }

    // full width, height is 80 px
    width: parent.width;
    height: 80


    // image element that holds the image property
    Image {
        id: imgHeader
        source: source
    }


    // text element that holds the text property
    Text {
        id: txtHeader

        anchors.fill: parent

        font.pixelSize: 30
        font.family: "Nokia Pure Text Light"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: qsTr(text)
        color: "white"
    }
}
