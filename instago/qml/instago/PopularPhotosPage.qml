// *************************************************** //
// Popular Photos Page
//
// The popular photos page is shown as default starting
// page.
// It shows a grid of the current popular photos that
// can be tapped.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

import "js/globals.js" as Globals
import "js/authentication.js" as Authentication
import "js/popularphotos.js" as PopularPhotosScript

Page {
    // use the main navigation toolbar
    tools: mainNavigationToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // load the gallery content as soon as the page is ready
    Component.onCompleted: {
        PopularPhotosScript.loadImages();

        // show main buttons if the user is logged in
        if (Authentication.isAuthorized())
        {
            iconHome.visible = true;
            iconPopular.visible = true;
            iconNone.visible = false;
        }
        else
        {
            iconHome.visible = false;
            iconPopular.visible = false;
            iconNone.visible = true;
        }
    }

    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header.png"
        text: qsTr("Popular")

        // Reload button top right in the header
        Image {
            anchors {
                right: parent.right
                rightMargin: 30
                top: parent.top
                topMargin: 20
                bottom: parent.bottom
                bottomMargin: 20
            }

            width: 40
            z: 10

            source: "image://theme/icon-m-toolbar-refresh-white"

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    // console.log("Refresh clicked");
                    imageGallery.visible = false;
                    networkErrorMesage.visible = false;
                    loadingIndicator.running = true;
                    loadingIndicator.visible = true;
                    PopularPhotosScript.loadImages();
                }
            }
        }
    }


    // show the loading indicator as long as the page is not ready
    BusyIndicator {
        id: loadingIndicator

        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: "large" }

        running:  true
        visible: true
    }


    // error indicator that is shown when a network error occured
    NetworkErrorMessage {
        id: networkErrorMesage

        anchors {
            top: pageHeader.bottom;
            topMargin: 3;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onMessageTap: {
            // console.log("Refresh clicked")
            networkErrorMesage.visible = false;
            imageGallery.visible = false;
            loadingIndicator.running = true;
            loadingIndicator.visible = true;
            PopularPhotosScript.loadImages();
        }
    }


    // the actual image gallery that contains the the popular photos
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
}
