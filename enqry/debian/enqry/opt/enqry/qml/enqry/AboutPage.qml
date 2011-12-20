import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: backTools
    orientationLock: PageOrientation.LockPortrait

    Header {
        id: rctAboutHeader
        text: qsTr("enQRy - About")
    }


    Text {
        id : txtHeadline
        visible: true

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: txtMaintext.top
            bottomMargin: 30
        }

        color: "#0088AF"
        font.pointSize: 30
        font.family: "Nokia Pure Text Light"

        width: 400
        wrapMode: Text.WordWrap

        text: "enQRy";
    }


    Text {
        id : txtMaintext
        visible: true

        anchors {
            centerIn: parent
        }

        color: "black"
        font.family: "Nokia Pure Text"
        font.pointSize: 17

        width: 400
        wrapMode: Text.WordWrap
        textFormat: Text.RichText

        text: "<style type='text/css'>a:link {color:#0088AF} a:visited {color:#0088AF}</style>enQRy is a QR code reader for MeeGo. It was developed as a sideproject by Dirk Songür (dirk@songuer.de).<br /><br />The application uses <a href='http://code.google.com/p/qml-http-uploader/'>qml-http-uploader</a> by jpelczar.<br /><br />The ZXing (Zebra Crossing) <a href='http://zxing.org/w/decode.jspx'>online decoder</a> is used to decode the QR codes.";
    }
}
