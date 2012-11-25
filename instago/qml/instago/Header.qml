// *************************************************** //
// Header Component
//
// The header component is used by the application pages.
// It displays a rectangle with a given background image
// and text.
// *************************************************** //

import QtQuick 1.1

import "js/globals.js" as Globals

Rectangle {
    id: header

    // text property for the header
    // set text will be shown in the header
    property alias text : headerText.text

    // image property for the header
    // given image will be shown (640x80)
    property alias source : headerImage.source

    // property if reload button is visible
    property alias reloadButtonVisible : headerReloadContainer.visible

    // signal if the reload button has been pressed
    signal reloadButtonClicked()

    // signal if the header bar has been pressed
    signal headerBarClicked()

    // place it on top
    anchors {
        top: parent.top;
        left: parent.left;
        right: parent.right
    }

    // full width, height is 80 px
//    width: parent.width;
    height: 80


    // image element that holds the image property
    Image {
        id: headerImage
        source: "img/top_header.png"
    }


    // text element that holds the text property
    Text {
        id: headerText

        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.pixelSize: 30
        font.family: "Nokia Pure Text Light"
        elide: Text.ElideRight;
        color: "white"

        text: ""
    }


    // container for reload button
    // this is used mainly to increase the size of the tap area
    Rectangle {
        id: headerReloadContainer

        anchors {
            right: parent.right
            rightMargin: 30
            top: parent.top
            topMargin: 5
            bottom: parent.bottom
            bottomMargin: 5
        }

        z: 10
        width: 70
        color: "transparent"

        visible: false


        // Reload button top right in the header
        Image {
            id: headerReloadButton

            anchors.centerIn: parent;

            width: 40
            height: 40

            source: "image://theme/icon-m-toolbar-refresh-white"
        }


        // use reload container as tap area
        MouseArea {
            anchors.fill: parent

            onCanceled:
            {
                headerReloadButton.source = "image://theme/icon-m-toolbar-refresh-white"
            }

            onPressed:
            {
                headerReloadButton.source = "image://theme/icon-m-toolbar-refresh-selected"
            }

            onReleased:
            {
                headerReloadButton.source = "image://theme/icon-m-toolbar-refresh-white"
                reloadButtonClicked();
            }
        }
    }


    // use whole header bar as tap area
    MouseArea {
        anchors.fill: parent

        onClicked:
        {
            headerBarClicked();
        }
    }
}
