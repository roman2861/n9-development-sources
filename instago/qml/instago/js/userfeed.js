// Globals contain the instagram API keys
Qt.include("instagramkeys.js")
Qt.include("authentication.js");
Qt.include("helpermethods.js");


// load the popular image stream from Instagram
// the image data will be used to fill the standard ImageGallery component
function loadUserFeed()
{
    // console.log("Loading user feed");

    // clear feed list
    feedListModel.clear();

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        console.debug("bad status: " + req.status);
                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;
                        networkErrorMesage.visible = true;

                        return;
                    }

                    // console.debug("content: " + req.responseText);
                    var jsonObject = eval('(' + req.responseText + ')');

                    var imageCache = new Array();
                    for ( var index in jsonObject.data )
                    {
                        // get image object
                        imageCache = getImageDataFromObject(jsonObject.data[index]);

                        // add image object to feed list
                        feedListModel.append({
                                                 "d_originalImage":imageCache["originalimage"],
                                                 "d_username":imageCache["username"],
                                                 "d_createdTime":imageCache["createdtime"],
                                                 "d_likes":imageCache["likes"],
                                                 "d_linkToInstagram":imageCache["linktoinstagram"],
                                                 "d_imageId":imageCache["imageid"],
                                                 "d_userId":imageCache["userid"],
                                                 "d_createdTime":imageCache["createdtime"],
                                                 "d_profilePicture":imageCache["profilepicture"]
                                             });

                        // console.log("Appended list with ID: " + imageCache["imageId"] + " in index: " + index);
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    feedList.visible = true;

                    // console.log("Done loading user feed");
                }
            }

    var instagramUserdata = getStoredInstagramData();
    var url = "https://api.instagram.com/v1/users/self/feed?access_token=" + instagramUserdata["access_token"];
    req.open("GET", url, true);
    req.send();
}
