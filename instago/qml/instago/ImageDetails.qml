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

import "js/globals.js" as Globals
import "js/authentication.js" as Authentication
import "js/imagedetail.js" as ImageDetailScript
import "js/likes.js" as Likes


Rectangle {
    id: imageDetail

    property string thumbnail: ""
    property string originalimage: ""
    property string linktoinstagram: ""
    property string imageid: ""
    property string caption: ""
    property string username: ""
    property string profilepicture: ""
    property string userid: ""
    property string userhasliked: ""
    property string likes: ""
    property string createdtime: ""
}
