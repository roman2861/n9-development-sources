// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

// https://api.instagram.com/v1/media/popular?client_id=3bbd61a332384e66a46026c3dbbfaadc

Page {
    tools: commonTools
/*
    //! property holding the status of the orientation of the page
    property bool isPortrait: imageselectortab.width > imageselectortab.height ? false : true

    Text {
        id: blankscreentext
        text: "No images"
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        visible: ((gridview.count === 0) && (foldermodel.status !== 1))
        color: "black"
        font.pixelSize: 40
    }

    //! List view to display the file system of the device
    GridView {
        id: gridview
        anchors.fill: parent
        anchors { top: parent.top; left: parent.left; leftMargin: isPortrait ? 0 : 30 }
        cellWidth: 152
        cellHeight: 152

        //! Setting the model for the grid view of the thumbnails
        model:  DocumentGalleryModel {
            id: foldermodel
            rootType: DocumentGallery.Image
            properties: ["url"]
            sortProperties: ["url"]
        }

        //! Delegate to display the thumbnails.
        delegate: Item {
            id: name

            //! Thumbnail display of images found in the Document Gallery
            Item {
                width: 150
                height: 150

                //! Loading smaller images not to use more memory than needed.
                //! Image is scaled to fill cell and cropped if necessary.
                Image {
                    id: imagethumbnail
                    anchors.fill: parent
                    source: model.filePath
                    sourceSize.width: 158
                    fillMode: Image.PreserveAspectCrop
                    clip: true
                    asynchronous: true

                    onStatusChanged: {
                        if (status === Image.Error)
                            errormsg.text = "Unable to load image";
                    }

                    Label {
                        id: errormsg
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        color: "black"
                    }
                }
            }
        }
    }

    //!  On this page status bar need to be hidden
    Component.onCompleted: rootWindow.showStatusBar = false
    Component.onDestruction: rootWindow.showStatusBar = true
*/

    Rectangle {
        id: container
        width: 360
        height: 360
        Text {
            text: "Hello World"
            anchors.centerIn: parent
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                container.testFunction("abcde");
            }
        }

        function testFunction(code){
            console.log("Trying..")
            var req = new XMLHttpRequest();
            req.onreadystatechange = function()
                    {
                        console.log("Ready state = ", req.readyState)
                        if (req.readyState == XMLHttpRequest.DONE) {

                            console.log("Checking result ")
                            console.log("Status: ", req.status)
                            console.log("Response: ", req.responseText)
                            console.log("Response Length: ", req.responseText.length)

                            var jsonObject = eval('(' + req.responseText + ')');
                            for ( var index in jsonObject.data )
                            {
                                console.log(jsonObject.data[index].images["thumbnail"]["url"]);
                            }
                        }
                    }

            req.open("GET", "https://api.instagram.com/v1/media/popular?client_id=3bbd61a332384e66a46026c3dbbfaadc", true);
            req.send();
        }
    }

}
