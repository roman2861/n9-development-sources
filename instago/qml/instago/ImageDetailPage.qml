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

    property string imageId: "";

    Component.onCompleted: {
        ImageDetailScript.loadImage(imageId);

        if (Authentication.isAuthorized())
        {
            iconUnliked.visible = true;
        }
    }

    // standard header for the current page
    Header {
        id: pageHeader

        source: "img/top_header.png"
        text: qsTr("Photo")
    }

    // standard info banner for action notifications
    InfoBanner {
        id: pageInfobanner
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        timerShowTime: 1500
        timerEnabled: true
    }

    // this just wraps the main content of the detail page
    Rectangle {
        id: pageContentContainer

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        // general style definition
        color: "transparent"
        width: parent.width
        height: parent.height


        // make the whole content area vertically flickable
        Flickable {
            id: contentFlickableContainer

            anchors.fill: parent

            contentWidth : parent.width
            contentHeight : parent.height

            // clipping needs to be true so that the size is limited to the container
            clip: true

            // flick up / down to see all content
            flickableDirection: Flickable.VerticalFlick


            // container for the user name and data
            Rectangle {
                id: userprofileContainer

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
                // all taps on the item will be handled by the onclick event
                MouseArea {
                    anchors.fill: parent
                    onClicked:
                    {
                        console.log("Profile tapped. Id was: " + userprofileUserID.text);
                        pageStack.push(Qt.resolvedUrl("UserDetailPage.qml"), {userId: userprofileUserID.text})
                    }
                }


                // this is just a dummy text that contains the id of the user
                Text {
                    id: userprofileUserID

                    visible: false
                    text: ""
                }


                // user profile picture (60x60)
                Rectangle {
                    id: userprofilePictureContainer

                    anchors {
                        top: parent.top;
                        left: parent.left;
                        leftMargin: 5;
                    }

                    // light gray color to mark loading image
                    color: "gainsboro"

                    width: 60
                    height: 60

                    // actual user image
                    // source will be given by the js function
                    Image {
                        id: userprofilePicture

                        anchors.fill: parent
                        smooth: true
                    }
                }


                // username
                Text {
                    id: userprofileUsername

                    anchors {
                        top: parent.top;
                        left: userprofilePictureContainer.right;
                        leftMargin: 5;
                        right: parent.right;
                    }

                    height: 30

                    font.family: "Nokia Pure Text Light"
                    font.pixelSize: 25
                    wrapMode: Text.Wrap

                    // actual user name
                    // text will be given by the js function
                    text: ""
                }


                // creation time
                Text {
                    id: userprofileCreatedtime

                    anchors {
                        top: userprofileUsername.bottom;
                        left: userprofilePictureContainer.right;
                        leftMargin: 5;
                        right: parent.right;
                    }

                    height: 20

                    font.family: "Nokia Pure Text"
                    font.pixelSize: 18
                    wrapMode: Text.Wrap

                    // date and time the image was created
                    // date will be formatted and given by the js function
                    text: ""
                }
            }


            // container for the detail image and its loader
            Rectangle {
                id: detailImageContainer

                anchors {
                    top: userprofileContainer.bottom;
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
                    id: loadingIndicator

                    anchors.centerIn: parent

                    platformStyle: BusyIndicatorStyle { size: "large" }
                    running:  true
                    visible: true
                }


                // the actual detail image
                // it's set to 480 px although the actual detail image size is 612x612
                Image {
                    id: detailImage

                    anchors.top: detailImageContainer.top
                    width: parent.width
                    height: parent.height
                    smooth: true

                    // invisible until loading is finished
                    visible: false;

                    // this listens to the loading progress
                    // visibility properties are changed when finished
                    onProgressChanged: {
                        if (detailImage.progress == 1.0)
                        {
                            loadingIndicator.running = false;
                            loadingIndicator.visible = false;
                            detailImage.visible = true;
                        }
                    }
                }
            }


            // container for the metadata
            Rectangle {
                id: metadataContainer

                anchors {
                    top: detailImageContainer.bottom;
                    topMargin: 5;
                    left: parent.left;
                    right: parent.right;
                }

                // full width, height is dynamic
                width: parent.width;

                // no background color
                color: "transparent"


                // number of likes
                Text {
                    id: metadataLikes

                    anchors {
                        top: parent.top;
                        left: parent.left;
                        leftMargin: 5;
                        right: parent.right;
                    }

                    font.family: "Nokia Pure Text Light"
                    font.pixelSize: 25
                    wrapMode: Text.Wrap

                    // number of likes
                    // text will be given by the js function
                    text: ""
                }

                // image caption
                // this is pretty much unlimited length by instagram so it has to be cut
                Text {
                    id: metadataImageCaption

                    anchors {
                        top: metadataLikes.bottom
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
                }

                // this is just a dummy text that contains the instagram url target
                Text {
                    id: metadataInstagramURL

                    text: ""
                    visible: false
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
                pageInfobanner.text = "Hey, you found a new favorite image!";
                pageInfobanner.show();

                Likes.likeImage(imageId);

                iconUnliked.visible = false;
                iconLiked.visible = true;
            }
        }


        // unlike image event
        // as the image is already liked, the star is marked
        ToolIcon {
            id: iconLiked
            iconId: "toolbar-favorite-mark";
            visible: false;
            onClicked: {
                pageInfobanner.text = "Oh, so you don't like this image anymore?";
                pageInfobanner.show();

                Likes.unlikeImage(imageId);

                iconLiked.visible = false;
                iconUnliked.visible = true;
            }
        }


        // initiate the share dialog
        ToolIcon {
            iconId: "toolbar-share";
            onClicked: {
                console.log("Share clicked for URL: " + metadataInstagramURL.text);

                // call the share dialog
                // note that this will not work in the simulator
                shareHelper.shareURL("Instago Link", metadataImageCaption.text, metadataInstagramURL.text);
            }
        }
    }
}
