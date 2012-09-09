import QtQuick 1.1
import com.nokia.meego 1.0
import "js/globals.js" as Globals
import "js/userprofile.js" as UserProfileScript

Page {
    // use the detail view toolbar
    tools: profileToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    Component.onCompleted: {
        UserProfileScript.loadUserProfile(Globals.currentUserId);
    }

    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header.png"
        text: qsTr("")
    }


    // container for the user name and data
    Rectangle {
        id: userprofileContainer

        anchors {
            top: pageHeader.bottom;
            topMargin: 10;
            left: parent.left;
            right: parent.right;
        }

        color: "transparent"
        width: parent.width;
        height: 130


        // user profile picture (120x120)
        Rectangle {
            id: userprofilePictureContainer

            anchors {
                top: parent.top;
                left: parent.left;
                leftMargin: 10;
            }

            width: 120
            height: 120

            // light gray color to mark loading image
            color: "gainsboro"


            // actual user image
            Image {
                id: userprofilePicture

                anchors.fill: parent
                smooth: true
            }
        }


        // username
        Text {
            id: userprofileFullname

            anchors {
                top: parent.top;
                left: userprofilePictureContainer.right;
                leftMargin: 10;
                right: parent.right;
            }

            height: 35

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 30
            wrapMode: Text.Wrap

            // user name
            // text will be given by the js function
            text: ""
        }


        // number of images
        Rectangle {
            id: userprofileImagecount

            anchors {
                top: userprofileFullname.bottom;
                topMargin: 10
                left: userprofilePictureContainer.right;
                leftMargin: 10;
            }

            // light background to create boxes
            color: "gainsboro"

            width: 100
            height: 80


            // actual number is shown as big, centered text
            Text {
                id: imagecountNumber

                anchors {
                    top: parent.top
                    topMargin: 10
                    left: parent.left
                    right: parent.right;
                }

                font.family: "Nokia Pure Text Light"
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap

                // number of images
                // text will be given by the js function
                text: ""
            }


            // label for number of images
            Text {
                id: imagecountText

                anchors {
                    top: imagecountNumber.bottom
                    left: parent.left
                    right: parent.right;
                    bottom: parent.bottom
                }

                font.family: "Nokia Pure Text"
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                color: "darkgray"

                text: "photos"
            }
        }


        // number of followers
        Rectangle {
            id: userprofileFollowers

            anchors {
                top: userprofileFullname.bottom;
                topMargin: 10
                left: userprofileImagecount.right;
                leftMargin: 10;
            }

            // light background to create boxes
            color: "gainsboro"

            width: 100
            height: 80


            // actual number is shown as big, centered text
            Text {
                id: followersNumber

                anchors {
                    top: parent.top
                    topMargin: 10
                    left: parent.left
                    right: parent.right;
                }

                font.family: "Nokia Pure Text Light"
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap

                // number of followers
                // text will be given by the js function
                text: ""
            }


            // label for number of followers
            Text {
                id: followersText

                anchors {
                    top: followersNumber.bottom
                    left: parent.left
                    right: parent.right;
                    bottom: parent.bottom
                }

                wrapMode: Text.Wrap
                font.family: "Nokia Pure Text"
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                color: "darkgray"

                text: "followers"
            }
        }


        // number of users the actual user follows
        Rectangle {
            id: userprofileFollowing

            anchors {
                top: userprofileFullname.bottom;
                topMargin: 10
                left: userprofileFollowers.right;
                leftMargin: 10;
            }

            // light background to create boxes
            color: "gainsboro"

            width: 100
            height: 80


            // actual number is shown as big, centered text
            Text {
                id: followingNumber

                anchors {
                    top: parent.top
                    topMargin: 10
                    left: parent.left
                    right: parent.right;
                }

                font.family: "Nokia Pure Text Light"
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap

                // following
                // text will be given by the js function
                text: ""
            }


            // label for number of followings
            Text {
                id: followingText

                anchors {
                    top: followingNumber.bottom
                    left: parent.left
                    right: parent.right;
                    bottom: parent.bottom
                }

                font.family: "Nokia Pure Text"
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                color: "darkgray"
                wrapMode: Text.Wrap

                text: "following"
            }
        }
    }


    // bio of the user
    Text {
        id: userprofileBio

        anchors {
            top: userprofileContainer.bottom
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
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}
