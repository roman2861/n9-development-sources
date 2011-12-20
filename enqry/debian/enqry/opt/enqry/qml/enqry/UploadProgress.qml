import QtQuick 1.0
import com.nokia.meego 1.0
import HttpUp 1.0
import "js/globals.js" as Globals

Rectangle {
    id: rctUploadProgress
    visible: false;

    property alias progress: pbUploadProgress.value
    property alias analyzetext: txtUploadAnalyze.visible
    property alias analyzebusy: bsyUploadAnalyze.visible

    Text {
        id : txtUploadHeadline
        visible: true

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: rctUploadProgress.top
        }

        color: "#0088AF"
        font.pointSize: 30
        font.family: "Nokia Pure Text Light"

        width: 400
        wrapMode: Text.WordWrap

        text: "Uploading QR code";
    }


    Text {
        id : txtUploadMaintext
        visible: true

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: txtUploadHeadline.bottom
            topMargin: 10
        }

        color: "black"
        font.family: "Nokia Pure Text"
        font.pointSize: 17

        width: 400
        wrapMode: Text.WordWrap

        text: "The image is uploaded to ZXing.org and checked for QR codes. Please stand by.";
    }


    ProgressBar {
           id: pbUploadProgress
           width: 300

           minimumValue: 0
           maximumValue: 100

           value: 0

           anchors {
               horizontalCenter: parent.horizontalCenter
               top: txtUploadMaintext.bottom
               topMargin: 50
           }
    }


    BusyIndicator {
        id: bsyUploadAnalyze
        visible: false

        anchors {
            left: pbUploadProgress.left
            top: pbUploadProgress.bottom
            topMargin: 5
        }

        running: true
    }


    Text {
        id : txtUploadAnalyze
        visible: false

        anchors {
            top: pbUploadProgress.bottom
            left: bsyUploadAnalyze.right
            topMargin: 5
            leftMargin: 5
        }

        color: "black"
        font.family: "Nokia Pure Text"
        font.pointSize: 17

        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignLeft

        text: "Upload complete.<br />Analyzing image.";
    }
}
