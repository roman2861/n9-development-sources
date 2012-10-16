// *************************************************** //
// Newsfeed Script
//
// This script is used to load, format and show the
// users news related feeds.
// It's used by the NewsFeedPage.
// *************************************************** //


// include other scripts used here
Qt.include("instagramkeys.js");
Qt.include("authenticationhandler.js");
Qt.include("helpermethods.js");
Qt.include("networkhandler.js");

// general network handler that acts upon the http request
var network = new NetworkHandler();

// general authentication handler that provides user authentication methods
var auth = new AuthenticationHandler();


// load the popular image stream from Instagram
// the image data will be used to fill the standard ImageGallery component
function loadInboxFeed()
{
    // console.log("Loading user feed");

    var instagramUserdata = auth.getStoredInstagramData();
    var url = "http://instagram.com/api/v1/news/inbox?access_token=" + instagramUserdata["access_token"];
    newsInstagramWebView.url = url;
}
