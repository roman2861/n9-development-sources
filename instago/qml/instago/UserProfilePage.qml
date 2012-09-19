// *************************************************** //
// User Profile Page
//
// The user profile page shows the personal information
// of the currently logged in user.
// If the user is not logged in, then a link to the
// login process is shown.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.0

import "js/globals.js" as Globals
import "js/authentication.js" as Authentication
import "js/userdata.js" as UserDataScript

Page {
    // use the detail view toolbar
    tools: profileToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // check if the user is already logged in
    Component.onCompleted: {
        if (Authentication.isAuthorized())
        {
            // user is authorized with Instagram
            console.log("User is authorized");

            // load profile data for user
            var instagramUserdata = Authentication.getStoredInstagramData();
            UserDataScript.loadUserProfile(instagramUserdata["id"]);

            // activate profile containers
            userprofileMetadata.visible = true;
            userprofileContentHeadline.visible = true;
            userprofileBio.visible = true;
            profiletoolbarLogout.visible = true;
        }
        else
        {
            // user is not authorized with Instagram
            console.log("User is not authorized");

            // activate error container
            userprofileNoTokenContainer.visible = true;
        }
    }

    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header.png"
        text: qsTr("You")
    }


    // container if user is not authenticated
    Rectangle {
        id: userprofileNoTokenContainer

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false;

        // no background color
        color: "transparent"


        // headline
        Text {
            id : userprofileNoTokenHeadline

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: userprofileNoTokenText.top
                bottomMargin: 20
            }

            width: 400

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.WordWrap

            text: "Please log in";
        }


        // description
        Text {
            id : userprofileNoTokenText

            anchors {
                centerIn: parent
            }

            width: 400

            font.family: "Nokia Pure Text"
            font.pixelSize: 20

            wrapMode: Text.WordWrap
            textFormat: Text.RichText

            text: "You are not connected to Instagram yet,<br />only the public features are available at the moment.<br /><br />Please connect to Instagram to use features like your news stream, following other users<br />or liking other users photos.";
        }


        // login button
        Button {
            id: userprofileNoTokenLogin

            anchors {
                left: parent.left;
                leftMargin: 30;
                right: parent.right;
                rightMargin: 30;
                top: userprofileNoTokenText.bottom;
                topMargin: 30;
            }

            text: "Login"

            onClicked: {
                pageStack.push(Qt.resolvedUrl("LoginPage.qml"))
            }
        }
    }

    UserMetadata {
        id: userprofileMetadata;

        anchors {
            top: pageHeader.bottom;
            topMargin: 10;
            left: parent.left;
            right: parent.right;
        }

        visible: false

        onProfilepictureClicked: {
            userprofileGallery.visible = false;
            userprofileBio.visible = true;
            userprofileContentHeadline.text = "Your Bio";
        }

        onImagecountClicked: {
            userprofileBio.visible = false;
            userprofileContentHeadline.text = "Your Photos";

            var instagramUserdata = Authentication.getStoredInstagramData();
            UserDataScript.loadUserImages(instagramUserdata["id"]);
            userprofileGallery.visible = true;
        }

        onFollowersClicked: {

        }

        onFollowingClicked: {

        }
    }


    // container headline
    // container is only visible if user is authenticated
    Text {
        id: userprofileContentHeadline

        anchors {
            top: userprofileMetadata.bottom
            topMargin: 10
            left: parent.left
            leftMargin: 10
            right: parent.right;
            rightMargin: 10
        }

        height: 30
        visible: false

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 25
        wrapMode: Text.Wrap

        // content container headline
        // text will be given by the content switchers
        text: "Your Bio"
    }


    // bio of the user
    // container is only visible if user is authenticated
    Text {
        id: userprofileBio

        anchors {
            top: userprofileContentHeadline.bottom
            topMargin: 10
            left: parent.left
            leftMargin: 10
            right: parent.right;
            rightMargin: 10
            bottom: parent.bottom
        }

        visible: false

        font.family: "Nokia Pure Text"
        font.pixelSize: 20
        wrapMode: Text.Wrap

        // user bio
        // text will be given by the js function
        // beware that the length is not limited by Instagram
        // this might be LONG!
        text: ""
    }


    // gallery of user images
    // container is only visible if user is authenticated
    ImageGallery {
        id: userprofileGallery;

        anchors {
            top: userprofileContentHeadline.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onItemClicked: {
            console.log("Image tapped: " + imageId);
            pageStack.push(Qt.resolvedUrl("ImageDetailPage.qml"), {imageId: imageId});
        }
    }


    // show the loading indicator as long as the page is not ready
    BusyIndicator {
        id: loadingIndicator

        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: "large" }

        running:  false
        visible: false
    }


    // toolbar for the detail page
    ToolBarLayout {
        id: profileToolbar
        visible: false


        // jump back to the popular photos page
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }


        // logout
        ToolIcon {
            id: profiletoolbarLogout
            iconId: "toolbar-delete";
            visible: false;

            onClicked: {
                Authentication.deleteStoredInstagramData();
                pageStack.pop(Qt.resolvedUrl("PopularPhotosPage.qml"));
            }
        }


        // jump to the about page
        ToolIcon {
            iconId: "toolbar-settings";
            onClicked: {
                pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
    }
}
