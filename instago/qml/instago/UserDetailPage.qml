// *************************************************** //
// User Detail Page
//
// The user profile page shows the personal information
// about a specific user.
// Note that this is not the page that shows the
// profile of the currently logged in user.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.0

import "js/globals.js" as Globals
import "js/userdata.js" as UserDataScript

Page {
    // use the detail view toolbar
    tools: profileToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    property string userId: "";

    Component.onCompleted: {
        UserDataScript.loadUserProfile(userId);
    }

    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header.png"
        text: qsTr("")
    }


    UserMetadata {
        id: userprofileMetadata;

        anchors {
            top: pageHeader.bottom;
            topMargin: 10;
            left: parent.left;
            right: parent.right;
        }

//        visible: false

        onProfilepictureClicked: {
            userprofileGallery.visible = false;
            userprofileBio.visible = true;
            userprofileContentHeadline.text = "Your Bio";
        }

        onImagecountClicked: {
            userprofileBio.visible = false;
            userprofileContentHeadline.text = "Your Photos";
            UserProfileScript.loadUserImages();
            userprofileGallery.visible = true;
        }

        onFollowersClicked: {

        }

        onFollowingClicked: {

        }
    }


    // bio of the user
    Text {
        id: userprofileBio

        anchors {
            top: userprofileMetadata.bottom
            topMargin: 10
            left: parent.left
            leftMargin: 10
            right: parent.right;
            rightMargin: 10
            bottom: parent.bottom
        }

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 25
        wrapMode: Text.Wrap

        // user bio
        // text will be given by the js function
        // beware that the length is not limited by Instagram
        // this might be LONG!
        text: ""
    }


    // toolbar for the detail page
    ToolBarLayout {
        id: profileToolbar
        visible: false

        // jump back to the detail image
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}
