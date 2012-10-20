// *************************************************** //
// Image Detail Component
//
// The image detail component is used when a specific
// Instagram image should be displayed.
// The image is shown as well as userdata of the user
// that uploaded it.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1

import "js/globals.js" as Globals
import "js/authenticationhandler.js" as Authentication

Rectangle {
    id: imageDetail

    // userdata and image metadata
    property alias username: imagedetailUsername.text
    property alias profilePicture: imagedetailUserpicture.source
    property alias timeAndLocation: imagedetailTimeAndLocation.text

    // actual image
    property alias originalImage: imagedetailImage.source

    // image metadata
    property alias caption: imagedetailMetadataCaption.text
    property alias likes: imagedetailMetadataLikes.text
    property alias comments: imagedetailMetadataComments.text

    // additional data
    property string linkToInstagram: ""
    property string imageId: ""
    property string userId: ""
    property string userHasLiked: ""

    // define signals to make the interactions accessible
    signal detailImageClicked
    signal captionChanged


    // general style definition
    color: "transparent"
    width: parent.width


    // container for the user name and data
    Rectangle {
        id: imagedetailUserprofileContainer

        anchors {
            top: parent.top;
            topMargin: 5;
            left: parent.left;
            right: parent.right;
        }

        // no background color
        color: "transparent"

        // full width, height is 60 px
        width: parent.width;
        height: 60


        // use the whole user profile as tap surface
        MouseArea {
            anchors.fill: parent
            onClicked:
            {
                // console.log("Profile tapped. Id was: " + userId);
                pageStack.push(Qt.resolvedUrl("UserDetailPage.qml"), {userId: userId});
            }
        }


        // user profile picture (60x60)
        Rectangle {
            id: imagedetailUserpictureContainer

            anchors {
                top: parent.top;
                left: parent.left;
                leftMargin: 5;
            }

            // light gray color to mark loading image
            color: "gainsboro"

            width: 60
            height: 60

            // user profile image
            Image {
                id: imagedetailUserpicture

                anchors.fill: parent
                smooth: true
            }
        }


        // username
        Text {
            id: imagedetailUsername

            anchors {
                top: parent.top;
                left: imagedetailUserpictureContainer.right;
                leftMargin: 5;
                right: parent.right;
            }

            height: 30

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.Wrap

            // actual user name
            text: ""
        }


        // creation time
        Text {
            id: imagedetailTimeAndLocation

            anchors {
                top: imagedetailUsername.bottom;
                left: imagedetailUserpictureContainer.right;
                leftMargin: 5;
                right: parent.right;
            }

            height: 20

            font.family: "Nokia Pure Text"
            font.pixelSize: 18
            wrapMode: Text.Wrap

            // date / time + location the image was created
            text: ""
        }
    }    


    // container for the detail image and its loader
    Rectangle {
        id: imagedetailImageContainer

        anchors {
            top: imagedetailUserprofileContainer.bottom;
            topMargin: 5;
            left: parent.left;
            leftMargin: 5;
            right: parent.right;
            rightMargin: 5;
        }

        // full width, height is 470 px
        // effectively this is 470 x 470 (max width - border)
        width: parent.width;
        height: 470

        // light gray color to mark loading image
        color: "gainsboro"


        // show the loading indicator as long as the page is not ready
        BusyIndicator {
            id: imagedetailLoadingIndicator

            anchors.centerIn: parent

            platformStyle: BusyIndicatorStyle { size: "large" }
            running:  true
            visible: true
        }


        // the actual detail image
        // it's set to 470 px although the actual detail image size is 612x612
        Image {
            id: imagedetailImage

            anchors.top: imagedetailImageContainer.top
            width: parent.width
            height: parent.height
            smooth: true

            // invisible until loading is finished
            visible: false;

            // this listens to the loading progress
            // visibility properties are changed when finished
            onProgressChanged: {
                if (imagedetailImage.progress == 1.0)
                {
                    imagedetailLoadingIndicator.running = false;
                    imagedetailLoadingIndicator.visible = false;
                    imagedetailImage.visible = true;
                }
            }
        }


        // use the whole detail image as tap surface
        MouseArea {
            anchors.fill: parent
            onDoubleClicked:
            {
                detailImageClicked();
            }
        }
    }


    // container for the metadata
    Rectangle {
        id: imagedetailMetadataContainer

        anchors {
            top: imagedetailImageContainer.bottom;
            topMargin: 5;
            left: parent.left;
            right: parent.right;
        }

        // full width, height is dynamic
        width: parent.width;

        // no background color
        color: "transparent"


        // likes icon
        Image {
            id: imagedetailMetadataLikeIcon

            anchors {
                top: parent.top;
                topMargin: 2;
                left: parent.left;
            }

            width: 28
            height: 28
            z: 10

            source: "image://theme/icon-m-toolbar-frequent-used-dimmed"
        }


        // number of likes
        Text {
            id: imagedetailMetadataLikes

            anchors {
                top: parent.top;
                left: imagedetailMetadataLikeIcon.right;
                leftMargin: 5;
                right: parent.right;
            }

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.Wrap

            // number of likes
            // text will be given by the js function
            text: ""

            // use the whole user profile as tap surface
            MouseArea {
                anchors.fill: parent
                onClicked:
                {
                    if ( (likes != "0 people liked this") && (Authentication.auth.isAuthenticated()) )
                    {
                        // console.log("Likes tapped for: " + imageId);
                        pageStack.push(Qt.resolvedUrl("ImageLikesPage.qml"), {imageId: imageId});
                    }
                }
            }
        }


        // comments icon
        Image {
            id: imagedetailMetadataCommentIcon

            anchors {
                top: imagedetailMetadataLikes.bottom;
                topMargin: 2;
                left: parent.left;
            }

            width: 28
            height: 28
            z: 10

            source: "image://theme/icon-m-toolbar-new-chat-dimmed"
        }


        // number of comments
        Text {
            id: imagedetailMetadataComments

            anchors {
                top: imagedetailMetadataLikes.bottom;
                left: imagedetailMetadataCommentIcon.right;
                leftMargin: 5;
                right: parent.right;
            }

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.Wrap

            // number of comments
            // text will be given by the js function
            text: ""

            // use the whole user profile as tap surface
            MouseArea {
                anchors.fill: parent
                onClicked:
                {
                    if ( (comments != "0 comments") && (Authentication.auth.isAuthenticated()) )
                    {
                        // console.log("Comments tapped for: " + imageId);
                        pageStack.push(Qt.resolvedUrl("ImageCommentsPage.qml"), {imageId: imageId});
                    }
                }
            }
        }


        // image caption
        // this is pretty much unlimited length by instagram so it has to be cut
        Text {
            id: imagedetailMetadataCaption

            anchors {
                top: imagedetailMetadataComments.bottom
                topMargin: 10
                left: parent.left;
                leftMargin: 5;
                right: parent.right;
                rightMargin: 5;
            }

            font.family: "Nokia Pure Text"
            font.pixelSize: 20
            wrapMode: TextEdit.Wrap

            // image description
            // text will be given by the js function
            // beware that the length is not limited by Instagram
            // this might be LONG!
            text: ""
            onTextChanged: {
                captionChanged();
            }
        }
    }
}
