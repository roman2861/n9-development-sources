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
import "js/authenticationhandler.js" as Authentication
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
        var auth = new Authentication.AuthenticationHandler();
        if (auth.isAuthenticated())
        {
            iconHome.visible = true;
            iconPopular.visible = true;
            // iconNews.visible = true;
            iconNone.visible = false;
        }
        else
        {
            iconHome.visible = false;
            iconPopular.visible = false;
            iconNews.visible = false;
            iconNone.visible = true;
        }
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: "Popular"
        reloadButtonVisible: true

        onReloadButtonClicked: {
            // console.log("Refresh clicked");
            imageGallery.visible = false;
            errorMessage.visible = false;
            loadingIndicator.running = true;
            loadingIndicator.visible = true;
            PopularPhotosScript.loadImages();
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
    ErrorMessage {
        id: errorMessage

        anchors {
            top: pageHeader.bottom;
            topMargin: 3;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onErrorMessageClicked: {
            // console.log("Refresh clicked")
            errorMessage.visible = false;
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
