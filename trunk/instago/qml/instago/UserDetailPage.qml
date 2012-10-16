// *************************************************** //
// User Detail Page
//
// The user profile page shows the personal information
// about a specific user.
// Note that this is not the page that shows the
// profile of the currently logged in user.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1

import "js/globals.js" as Globals
import "js/authenticationhandler.js" as Authentication
import "js/userdata.js" as UserDataScript
import "js/relationships.js" as UserRelationshipScript

Page {
    // use the detail view toolbar
    tools: profileToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // this holds the user id of the respective user
    // the property will be filled by the calling page
    property string userId: "";

    Component.onCompleted: {
        // show loading indicators while loading user data
        loadingIndicator.running = true;
        loadingIndicator.visible = true;

        // load the users profile
        UserDataScript.loadUserProfile(userId);

        // show follow button if the user is logged in
        var auth = new Authentication.AuthenticationHandler();
        if (auth.isAuthenticated())
        {
            UserRelationshipScript.getRelationship(userId);
        }
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: ""
    }

    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }


    // header with the user metadata
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
            userprofileFollowers.visible = false;
            userprofileFollowing.visible = false;
            userprofileContentHeadline.text = "Bio";

            userprofileBio.visible = true;
        }

        onImagecountClicked: {
            // user photos are only available for authenticated users
            var auth = new Authentication.AuthenticationHandler();
            if (auth.isAuthenticated())
            {
                userprofileBio.visible = false;
                userprofileFollowers.visible = false;
                userprofileFollowing.visible = false;
                userprofileContentHeadline.text = "Photos";

                UserDataScript.loadUserImages(userId, 0);

                userprofileGallery.visible = true;
            }
        }

        onFollowersClicked: {
            // follower list only available for authenticated users
            var auth = new Authentication.AuthenticationHandler();
            if (auth.isAuthenticated())
            {
                userprofileBio.visible = false;
                userprofileGallery.visible = false;
                userprofileFollowing.visible = false;
                userprofileContentHeadline.text = "Followers";

                UserDataScript.loadUserFollowers(userId, 0);

                userprofileFollowers.visible = true;
            }
        }

        onFollowingClicked: {
            // following list only available for authenticated users
            var auth = new Authentication.AuthenticationHandler();
            if (auth.isAuthenticated())
            {
                userprofileBio.visible = false;
                userprofileGallery.visible = false;
                userprofileFollowers.visible = false;
                userprofileContentHeadline.text = "Following";

                UserDataScript.loadUserFollowing(userId, 0);

                userprofileFollowing.visible = true;
            }
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
        text: "Bio"
    }


    // user bio
    // this also contains the follow / unfollow functionality
    UserBio {
        id: userprofileBio;

        anchors {
            top: userprofileContentHeadline.bottom
            topMargin: 10
            left: parent.left
            right: parent.right;
            bottom: parent.bottom
        }

        visible: false

        // follow user
        onFollowButtonClicked: {
            notification.text = "You now follow " + pageHeader.text;
            notification.show();

            UserRelationshipScript.setRelationship(userId, "follow");

            userprofileBio.followButtonVisible = false;
            userprofileBio.unfollowButtonVisible = true;
        }

        // unfollow user
        onUnfollowButtonClicked: {
            notification.text = "You unfollowed " + pageHeader.text;
            notification.show();

            UserRelationshipScript.setRelationship(userId, "unfollow");

            userprofileBio.unfollowButtonVisible = false;
            userprofileBio.followButtonVisible = true;
        }

        // request to follow user
        onRequestButtonClicked: {
            notification.text = "You requested to follow";
            notification.show();

            UserRelationshipScript.setRelationship(userId, "follow");

            userprofileBio.requestButtonVisible = false;
            userprofileBio.unrequestButtonVisible = true;
        }

        // unrequest to follow user
        onUnrequestButtonClicked: {
            notification.text = "You withdrew your request to follow";
            notification.show();

            UserRelationshipScript.setRelationship(userId, "unfollow");

            userprofileBio.unrequestButtonVisible = false;
            userprofileBio.requestButtonVisible = true;
        }
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
            // console.log("Image tapped: " + imageId);
            pageStack.push(Qt.resolvedUrl("ImageDetailPage.qml"), {imageId: imageId});
        }

        onListBottomReached: {
            if (paginationNextMaxId !== "")
            {
                UserDataScript.loadUserImages(userId, paginationNextMaxId);
            }
        }
    }


    // list of the followers
    // container is only visible if user is authenticated
    UserList {
        id: userprofileFollowers;

        anchors {
            top: userprofileContentHeadline.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false
    }


    // list of the followings
    // container is only visible if user is authenticated
    UserList {
        id: userprofileFollowing;

        anchors {
            top: userprofileContentHeadline.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false
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
            userprofileMetadata.visible = false;
            userprofileContentHeadline.visible = false;
            userprofileBio.visible = false;

            loadingIndicator.running = true;
            loadingIndicator.visible = true;
            UserDataScript.loadUserProfile(userId);
        }
    }


    // toolbar for the detail page
    ToolBarLayout {
        id: profileToolbar

        // jump back to the detail image
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}