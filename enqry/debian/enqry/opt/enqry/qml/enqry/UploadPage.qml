import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import HttpUp 1.0
import "js/globals.js" as Globals

Page {
    tools: backTools
    orientationLock: PageOrientation.LockPortrait

    Header {
        id: rctUploadHeader
        text: qsTr("enQRy - Upload")
    }


    WorkerScript {
        id: wsQrhandling
        source: "js/qrlogic.js"

        onMessage: { }
    }


    HttpUploader {
        id: theUploader

        onUploadStateChanged: {
            if( uploadState == HttpUploader.Done ) {
                console.log("Upload done with status " + status);
                console.log("Error is "  + errorString);
                console.log("Response is "  + responseText);

                uplUploadProgress.visible = false;
                uplUploadResult.visible = true;

                if (errorString == "") {
                    if (responseText != "") {
                        uplUploadResult.headline = "QR code analyzed"
                        uplUploadResult.maintext = "Your QR code reads: " + responseText;
                    }
                    else {
                        uplUploadResult.headline = "No QR code found"
                        uplUploadResult.maintext = "Please make sure you get a clean image and give the camera some time to focus and try again.";
                    }

                }
                else {
                    uplUploadResult.headline = "An error occured"
                    uplUploadResult.maintext = errorString + ". Sorry, please try again.";
                }
            }
        }

        onProgressChanged: {
            console.log("Upload progress = " + progress + " in percent: " + (progress * 100));
            uplUploadProgress.progress = (progress * 100);

            if (progress == 1.0) {
                uplUploadProgress.analyzetext = true;
                uplUploadProgress.analyzebusy = true;
            }
        }
    }


    Timer {
        id: timLoadImage
        interval: 1000;
        running: false;
        repeat: false;
        triggeredOnStart: false;

        onTriggered: {
            timLoadImage.stop();

            if (Globals.imageProcessed != 1)
            {
                imgCameraPreview.source = Globals.imagePath;
                console.log("Updating image with path " + Globals.imagePath);
                Globals.imageProcessed = 1;
                timLoadImage.stop();
            }
            else
            {
                console.log("Image not loaded yet, image path is " + Globals.imagePath);
            }
        }
    }


    Rectangle {
        id: rctCameraPreview;

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: rctUploadHeader.bottom
            topMargin: 40
        }

        width: 230
        height: 230
        color: "black"

        Image {
            id : imgCameraPreview
            visible: true

            source: Globals.imagePath;
            fillMode: Image.PreserveAspectFit
            smooth: true

            width: 230
            height: 230
            rotation: 90

            Component.onCompleted: {
                console.log("Image shown with source: " + imgCameraPreview.source.toString() + " and Globals source: " + Globals.imagePath);
    //                timLoadImage.repeat = true;
                timLoadImage.start();
            }
        }
    }


    UploadControls {
        id: uplUploadControls

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: rctCameraPreview.bottom
            topMargin: 40
        }
    }


    UploadProgress {
        id: uplUploadProgress

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: rctCameraPreview.bottom
            topMargin: 40
        }
    }


    UploadResult {
        id: uplUploadResult

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: rctCameraPreview.bottom
            topMargin: 40
        }
    }

}
