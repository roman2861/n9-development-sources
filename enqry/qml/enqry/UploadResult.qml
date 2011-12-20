import QtQuick 1.0
import com.nokia.meego 1.0
import HttpUp 1.0
import "js/globals.js" as Globals


Rectangle {
    id: rctUploadResult
    visible: false;

    property alias headline: txtResultHeadline.text
    property alias maintext: txtResultMaintext.text

    Text {
        id : txtResultHeadline
        visible: true

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: rctUploadResult.top
        }

        color: "#0088AF"
        font.pointSize: 30
        font.family: "Nokia Pure Text Light"

        width: 400
        wrapMode: Text.WordWrap

        text: "";
    }


    Text {
        id : txtResultMaintext
        visible: true

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: txtResultHeadline.bottom
            topMargin: 10
        }

        color: "black"
        font.family: "Nokia Pure Text"
        font.pointSize: 17

        width: 400
        wrapMode: Text.Wrap

        text: "";
    }
}
