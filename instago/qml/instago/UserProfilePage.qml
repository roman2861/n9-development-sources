import QtQuick 1.1
import com.nokia.meego 1.0
import "js/instago/globals.js" as Globals
import "js/instago/userprofile.js" as UserProfileScript

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

            color: "gainsboro"

            width: 120
            height: 120

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
            text: ""
            font.family: "Nokia Pure Text Light"
            font.pixelSize: 30

            anchors {
                top: parent.top;
                left: userprofilePictureContainer.right;
                leftMargin: 10;
                right: parent.right;
            }

            wrapMode: Text.Wrap
            height: 35
        }


        Rectangle {
            id: userprofileImagecount

            anchors {
                top: userprofileFullname.bottom;
                topMargin: 10
                left: userprofilePictureContainer.right;
                leftMargin: 10;
            }

            color: "gainsboro"

            width: 100
            height: 80

            Text {
                id: imagecountNumber
                text: ""
                font.family: "Nokia Pure Text Light"
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter

                anchors {
                    top: parent.top
                    topMargin: 10
                    left: parent.left
                    right: parent.right;
                }

                wrapMode: Text.Wrap
            }

            Text {
                id: imagecountText
                text: "photos"
                font.family: "Nokia Pure Text"
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                color: "darkgray"

                anchors {
                    top: imagecountNumber.bottom
                    left: parent.left
                    right: parent.right;
                    bottom: parent.bottom
                }

                wrapMode: Text.Wrap
            }
        }


        Rectangle {
            id: userprofileFollowers

            anchors {
                top: userprofileFullname.bottom;
                topMargin: 10
                left: userprofileImagecount.right;
                leftMargin: 10;
            }

            color: "gainsboro"

            width: 100
            height: 80

            Text {
                id: followersNumber
                text: ""
                font.family: "Nokia Pure Text Light"
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter

                anchors {
                    top: parent.top
                    topMargin: 10
                    left: parent.left
                    right: parent.right;
                }

                wrapMode: Text.Wrap
            }

            Text {
                id: followersText
                text: "followers"
                font.family: "Nokia Pure Text"
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                color: "darkgray"

                anchors {
                    top: followersNumber.bottom
                    left: parent.left
                    right: parent.right;
                    bottom: parent.bottom
                }

                wrapMode: Text.Wrap
            }
        }


        Rectangle {
            id: userprofileFollowing

            anchors {
                top: userprofileFullname.bottom;
                topMargin: 10
                left: userprofileFollowers.right;
                leftMargin: 10;
            }

            color: "gainsboro"

            width: 100
            height: 80

            Text {
                id: followingNumber
                text: ""
                font.family: "Nokia Pure Text Light"
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter

                anchors {
                    top: parent.top
                    topMargin: 10
                    left: parent.left
                    right: parent.right;
                }

//                height: 30

                wrapMode: Text.Wrap
            }

            Text {
                id: followingText
                text: "following"
                font.family: "Nokia Pure Text"
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                color: "darkgray"

                anchors {
                    top: followingNumber.bottom
                    left: parent.left
                    right: parent.right;
                    bottom: parent.bottom
                }

                wrapMode: Text.Wrap
            }
        }
    }

    Text {
        id: userprofileBio
        text: ""
        font.family: "Nokia Pure Text Light"
        font.pixelSize: 25

        anchors {
            top: userprofileContainer.bottom
            topMargin: 10
            left: parent.left
            leftMargin: 10
            right: parent.right;
            rightMargin: 10
            bottom: parent.bottom
        }

        wrapMode: Text.Wrap
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
