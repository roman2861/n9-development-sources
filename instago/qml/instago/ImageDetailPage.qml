// *************************************************** //
// Image Detail Page
//
// The image detail page is shown when a specific
// Instagram image is displayed.
// The page has a number of features that can be
// applied to the image as well as the user that
// uploaded it.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1
import QtShareHelper 1.0

import "js/globals.js" as Globals
import "js/authentication.js" as Authentication
import "js/imagedetail.js" as ImageDetailScript
import "js/likes.js" as Likes

Page {
    // use the detail view toolbar
    tools: detailViewToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // the image id that is shown
    // the property will be filled by the calling page
    property string imageId: "";

    Component.onCompleted: {
        // load image data for the given image
        ImageDetailScript.loadImage(imageId);
    }

    // standard header for the current page
    Header {
        id: pageHeader

        source: "img/top_header.png"
        text: qsTr("Photo")
    }

    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }


    // make the whole content area vertically flickable
    Flickable {
        id: contentFlickableContainer

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        contentWidth : parent.width
        contentHeight : parent.height

        // clipping needs to be true so that the size is limited to the container
        clip: true

        // flick up / down to see all content
        flickableDirection: Flickable.VerticalFlick


        // actual image component
        // this does all the ui stuff for the image and metadata
        ImageDetails {
            id: imageData

            anchors.fill: parent

            onDetailImageClicked: {
                if (Authentication.isAuthorized())
                {
                    if (iconLiked.visible === false)
                    {
                        notification.text = "Hey, you found a new favorite image!";
                        notification.show();

                        Likes.likeImage(imageId);
                    }
                    else
                    {
                        notification.text = "You already like this image..";
                        notification.show();
                    }
                }
            }
        }
    }


    // this is the share helper component that makes the share dialog available
    ShareHelper {
        id: shareHelper
    }


    // toolbar for the detail page
    ToolBarLayout {
        id: detailViewToolbar
        visible: false

        // jump back to the popular photos page
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }


        // like image event
        // as the image is not liked yet, the star is unmarked
        ToolIcon {
            id: iconUnliked
            iconId: "toolbar-favorite-unmark";
            visible: false;
            onClicked: {
                notification.text = "Hey, you found a new favorite image!";
                notification.show();

                Likes.likeImage(imageId);
            }
        }


        // unlike image event
        // as the image is already liked, the star is marked
        ToolIcon {
            id: iconLiked
            iconId: "toolbar-favorite-mark";
            visible: false;
            onClicked: {
                notification.text = "Oh, so you don't like this image anymore?"
                notification.show();

                Likes.unlikeImage(imageId);
            }
        }


        // initiate the share dialog
        ToolIcon {
            iconId: "toolbar-share";
            onClicked: {
                console.log("Share clicked for URL: " + imageData.linkToInstagram);

                // call the share dialog
                // note that this will not work in the simulator
                shareHelper.shareURL("Instago Link", imageData.caption, imageData.linkToInstagram);
            }
        }
    }
}
