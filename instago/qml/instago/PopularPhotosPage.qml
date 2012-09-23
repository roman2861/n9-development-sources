// *************************************************** //
// Popular Photos Page
//
// The popular photos page is shown as default starting
// page.
// It shows a grid of the current popular photos that
// can be tapped.
// It also contains general menu controls for the
// application.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

import "js/globals.js" as Globals
import "js/popularphotos.js" as PopularPhotosScript

Page {
    // use the popular photos toolbar
    tools: popularPhotosToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // load the gallery content as soon as the page is ready
    Component.onCompleted: {
        PopularPhotosScript.loadImages();
    }

    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header.png"
        text: qsTr("Popular")
    }


    // show the loading indicator as long as the page is not ready
    BusyIndicator {
        id: loadingIndicator

        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: "large" }

        running:  true
        visible: true
    }


    // error indicator that is shown when the gallery could not be loaded
    Rectangle {
        id: errorIndicator

        anchors {
            top: pageHeader.bottom;
            topMargin: 3;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false
        color: "transparent"


        // the error text is a tap area that calls the reload function
        MouseArea {
            anchors.fill: parent

            onClicked:
            {
                // console.log("Refresh clicked")
                errorIndicator.visible = false;
                imageGallery.visible = false;
                loadingIndicator.running = true;
                loadingIndicator.visible = true;
                PopularPhotosScript.loadImages();
            }
        }


        // generic error message that something went wrong
        // this is most likely the case when the network went away
        Text {
            id: reloadMessage

            anchors {
                top: parent.top;
                left: parent.left;
                leftMargin: 10;
                right: parent.right;
                rightMargin: 10;
                bottom: parent.bottom;
            }

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.Wrap

            text: "Popular photo stream won't load.<br />Check your connection and tap<br />to try again."
        }

    }


    ImageGallery {
        id: imageGallery;

        anchors {
            top: pageHeader.bottom;
            topMargin: 3;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onItemClicked: {
            // console.log("Image tapped: " + imageId);
            pageStack.push(Qt.resolvedUrl("ImageDetailPage.qml"), {imageId: imageId});
        }        
    }


    // toolbar for the popular photos
    ToolBarLayout {
        id: popularPhotosToolbar
        visible: false


        // refresh the popular photos grid
        ToolIcon {
            iconId: "toolbar-refresh";
            onClicked: {
                // console.log("Refresh clicked");
                imageGallery.visible = false;
                loadingIndicator.running = true;
                loadingIndicator.visible = true;
                PopularPhotosScript.loadImages();
            }
        }


        // jump to the profile page of the current user
        ToolIcon {
            iconId: "toolbar-contact";
            onClicked: {
                pageStack.push(Qt.resolvedUrl("UserProfilePage.qml"))
            }
        }
    }
}
