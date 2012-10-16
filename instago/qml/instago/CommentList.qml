// *************************************************** //
// Comment List Component
//
// The comment list component is used by the application
// pages. It displays the comments for a given media id
// with their respective metadata
// The list is flickable and clips.
// *************************************************** //

import QtQuick 1.0

Rectangle {
    id: commentList

    // signal to clear the list contents
    signal clearList()
    onClearList: {
        commentListModel.clear();
    }

    // signal to add a new item
    // item is given as array:
    // "username":USER_USERNAME
    // "fullname":USER_FULLNAME
    // "profilepicture":USER_PROFILEPICTURE
    // "userid":USER_USERID
    // "index":ITEM_INDEX
    signal addToList( variant items )
    onAddToList: {
        commentListModel.append(items);
    }

    // general style definition
    color: "transparent"
    width: parent.width;
    height: parent.height;


    // this is the main container component
    // it contains the actual user items
    Component {
        id: commentListDelegate

        // this is an individual list item
        Item {
            id: commentItem
            width: commentList.width
            height: 110


            // use the whole item as tap surface
            // all taps on the item will be handled by the itemClicked event
            MouseArea {
                anchors.fill: parent
                onClicked:
                {
                    // console.log("Profile tapped. Id was: " + d_userid);
                    pageStack.push(Qt.resolvedUrl("UserDetailPage.qml"), {userId: d_userid});
                }
            }


            // this is the rectangle that holds the profile picture image
            // its used as an empty default rect that is filled if the image could be loaded
            Rectangle {
                id: commentListProfilepicture

                anchors {
                    top: parent.top
                    topMargin: 10
                    left: parent.left
                    leftMargin: 10
                }

                width: 80
                height: 80

                // light gray color to mark loading image
                color: "gainsboro"

                // the actual profile image
                Image {
                    anchors.fill: parent
                    source: d_profilepicture
                }
            }


            // the Instagram username of the user
            Text {
                id: commentListUsername

                anchors {
                    top: parent.top;
                    topMargin: 10;
                    left: commentListProfilepicture.right;
                    leftMargin: 5;
                    right: parent.right;
                    rightMargin: 5;
                }

                height: 35

                font.family: "Nokia Pure Text Light"
                font.pixelSize: 30
                wrapMode: Text.Wrap

                text: d_username
            }


            // the actual comment content
            Text {
                id: commentListComment

                anchors {
                    top: commentListUsername.bottom
                    topMargin: 5;
                    left: commentListProfilepicture.right;
                    leftMargin: 10;
                    right: parent.right;
                    rightMargin: 5;
                }

                height: 20

                font.family: "Nokia Pure Text"
                font.pixelSize: 18
                wrapMode: Text.Wrap

                text: d_comment
            }


            // separator
            Image {
                id: commentListSeparator

                anchors {
                    top: commentListProfilepicture.bottom
                    topMargin: 15
                    left: parent.left;
                    leftMargin: 5;
                    right: parent.right;
                    rightMargin: 5;
                }

                source: "image://theme/meegotouch-separator-background-horizontal"

                fillMode: Image.TileHorizontally
            }

        }
    }


    // this is just an id
    // the model is defined in the array
    ListModel {
        id: commentListModel
    }


    // the actual list view component
    // this will be the main component and contain all the items
    ListView {
        id: commentListView

        anchors.fill: parent;
        // anchors.margins: 5

        focus: true

        // clipping needs to be true so that the size is limited to the container
        clip: true

        // define model and delegate
        model: commentListModel
        delegate: commentListDelegate
    }
}
