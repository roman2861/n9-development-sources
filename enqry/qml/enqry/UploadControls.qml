import QtQuick 1.0
import com.nokia.meego 1.0
import HttpUp 1.0
import "js/globals.js" as Globals

Rectangle {
    id: rctUploadControls

    Text {
        id : txtControlHeadline
        visible: true

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: rctUploadControls.top
        }

        color: "#0088AF"
        font.pointSize: 30
        font.family: "Nokia Pure Text Light"

        width: 400
        wrapMode: Text.WordWrap

        text: "Check this QR code?";
    }


    Text {
        id : txtControlMaintext
        visible: true

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: txtControlHeadline.bottom
            topMargin: 10
        }

        color: "black"
        font.family: "Nokia Pure Text"
        font.pointSize: 17

        width: 400
        wrapMode: Text.WordWrap

        text: "Do you want to upload this image and check for QR codes in it?<br />Please note: data charges apply for the upload.";
    }


    Button {
        id: btnUpload

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: txtControlMaintext.bottom
            topMargin: 40
        }

        text: qsTr("Upload & check")
        onClicked: {
            console.log("Upload started for image " + Globals.imagePath);

            theUploader.open("http://zxing.org/w/decode");
            theUploader.addField("full", "true");
            theUploader.addField("submit", "true");
            theUploader.addFile("f", Globals.imagePath);
            theUploader.send()

            uplUploadControls.visible = false;
            uplUploadProgress.visible = true;
        }
    }


    Button {
        id: btnDiscard

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: btnUpload.bottom
            topMargin: 20
        }

        text: qsTr("Discard image")
        onClicked: { pageStack.pop(); }
    }
}
