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
import QtNetworkHelper 1.0

import "js/globals.js" as Globals
import "js/authenticationhandler.js" as Authentication
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
        text: "Photo"
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

        contentWidth: parent.width
        contentHeight: parent.height

        visible: false

        // clipping needs to be true so that the size is limited to the container
        clip: true

        // flick up / down to see all content
        flickableDirection: Flickable.VerticalFlick

        // actual image component
        // this does all the ui stuff for the image and metadata
        ImageDetails {
            id: imageData

            // anchors.fill: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            onDetailImageClicked: {
                if (Authentication.auth.isAuthenticated())
                {
                    if (iconLiked.visible === false)
                    {
                        notification.text = "Added photo to your favourites";
                        notification.show();

                        Likes.likeImage(imageId, true);
                    }
                    else
                    {
                        notification.text = "You already like this image";
                        notification.show();
                    }
                }
            }

            onCaptionChanged: {
                // this is magic: since metadataImageCaption.height gives me garbage I calculate the height by multiplying the number of lines with the line height
                var numberOfLines = 0;

                // check how many lines the user manually added with line breaks
                var captionLines = new Array();
                captionLines = caption.split("\n");

                // walk through each line and check how long they are and if they wrap around
                for (var lineIndex in captionLines)
                {
                    numberOfLines += Math.floor( (captionLines[lineIndex].length / 50) + 1 );
                }

                // transform the number of lines into the actual height
                var itemheight = numberOfLines * 25;
                height = itemheight + 640;

                // that number is fed to the flickable container as content height
                contentFlickableContainer.contentHeight = height;
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
            contentFlickableContainer.visible = false;
            loadingIndicator.running = true;
            loadingIndicator.visible = true;
            ImageDetailScript.loadImage(imageId);
        }
    }


    // this is the share helper component that makes the share dialog available
    ShareHelper {
        id: shareHelper
    }


    // this is the network helper component that makes the network helper methods available
    NetworkHelper {
        id: networkHelper
    }


    // toolbar for the detail page
    ToolBarLayout {
        id: detailViewToolbar

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

            iconId: "toolbar-frequent-used-dimmed";
            visible: false;

            onClicked: {
                notification.text = "Added photo to your favourites";
                notification.show();

                Likes.likeImage(imageId, true);
            }
        }


        // unlike image event
        // as the image is already liked, the star is marked
        ToolIcon {
            id: iconLiked

            iconId: "toolbar-frequent-used";
            visible: false;

            onClicked: {
                notification.text = "Removed photo from your favourites"
                notification.show();

                Likes.unlikeImage(imageId, true);
            }
        }


        // initiate the share dialog
        ToolIcon {
            id: iconShare

            iconId: "toolbar-share";

            onClicked: {
                // console.log("Share clicked for URL: " + imageData.linkToInstagram);

                // call the share dialog
                // note that this will not work in the simulator
                shareHelper.shareURL("Instago Link", imageData.caption, imageData.linkToInstagram);
            }
        }


        // initiate the share dialog
        ToolIcon {
            id: iconShareDeactivated

            iconId: "toolbar-share-dimmed";
            visible: false;
        }
    }
}
