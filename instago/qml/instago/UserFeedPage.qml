// *************************************************** //
// User Feed Page
//
// The page shows th personal feed of the user. It
// contains images and content from the people the
// user currently follows.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

import "js/globals.js" as Globals
import "js/authentication.js" as Authentication
import "js/userfeed.js" as Userfeed
import "js/likes.js" as Likes

Page {
    // use the main navigation toolbar
    tools: mainNavigationToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // load the gallery content as soon as the page is ready
    Component.onCompleted: {
        Userfeed.loadUserFeed();

        iconHome.visible = true;
        iconPopular.visible = true;
    }

    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header.png"
        text: qsTr("Your Feed")

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
                    feedList.visible = false;
                    networkErrorMesage.visible = false;

                    loadingIndicator.running = true;
                    loadingIndicator.visible = true;
                    Userfeed.loadUserFeed();
                }
            }
        }
    }

    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
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
            loadingIndicator.running = true;
            loadingIndicator.visible = true;
            Userfeed.loadUserFeed();
        }
    }


    // this is the main container component
    // it contains the actual gallery items
    Component {
        id: feedDelegate

        // this is an individual feed item
        Item {
            id: feedItem
            width: feedList.width
            height: 610

            // actual image component
            // this does all the ui stuff for the image and metadata
            ImageDetails {
                id: imageData

                // anchors.fill: parent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                originalImage: d_originalImage
                linkToInstagram: d_linkToInstagram
                imageId: d_imageId;
                username: d_username;
                profilePicture: d_profilePicture;
                userId: d_userId;
                createdTime: d_createdTime;
                likes: d_likes + " people liked this";

                onDetailImageClicked: {
                    notification.text = "Added photo to your favourites";
                    notification.show();

                    Likes.likeImage(imageId, false);
                }
            }
        }
    }


    // this is just an id
    // the model is defined in the array
    ListModel {
        id: feedListModel
    }


    // the actual grid view
    // this contains the individual items and shows them as a list
    ListView {
        id: feedList

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        focus: true
        visible: false

        // clipping needs to be true so that the size is limited to the container
        clip: true

        // define model and delegate
        model: feedListModel
        delegate: feedDelegate
    }

}
