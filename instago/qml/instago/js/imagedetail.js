// Globals contain the instagram API keys
Qt.include("instagramkeys.js");
Qt.include("authentication.js");
Qt.include("helpermethods.js");


// load an image with a given Instagram media id
// the image data will be used to fill the ImageDetailPage
// note that the image data is different for an authenticated
// user vs an unknown one
function loadImage(imageId)
{
    // console.log("Loading image " + imageId);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState === XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        console.debug("bad status: " + req.status);
                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;
                        networkErrorMesage.visible = true;

                        return;
                    }

                    var jsonObject = eval('(' + req.responseText + ')');

                    // get image object
                    var imageCache = new Array();
                    imageCache = getImageDataFromObject(jsonObject.data);

                    // apply image object to page components
                    imageData.originalImage = imageCache["originalimage"];
                    imageData.imageId = imageCache["imageid"];
                    imageData.username = imageCache["username"];
                    imageData.profilePicture = imageCache["profilepicture"];
                    imageData.userId = imageCache["userid"];
                    imageData.likes = imageCache["likes"] + " people liked this";
                    imageData.linkToInstagram = imageCache["linktoinstagram"];
                    imageData.caption = imageCache["caption"];
                    imageData.createdTime = imageCache["createdtime"];

                    // if they don't have an Instagram page, the share button needs to be deactivated
                    if (imageCache["linktoinstagram"] === "")
                    {
                        iconShare.visible = false;
                        iconShareDeactivated.visible = true;
                    }

                    // check if user has already liked the image and set icons accordingly
                    if (imageCache["userhasliked"])
                    {
                        iconLiked.visible = true;
                    }
                    else
                    {
                        iconUnliked.visible = true;
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    contentFlickableContainer.visible = true;

                    // console.log("Done loading image");
                }
            }

    // only authenticated users have user_has_liked nodes in their response data
    // thus the request should be done with the access token whenever possible
    var url = "";
    if (isAuthenticated())
    {
        var instagramUserdata = getStoredInstagramData();
        url = "https://api.instagram.com/v1/media/" + imageId + "/?access_token=" + instagramUserdata["access_token"];
    }
    else
    {
        url = "https://api.instagram.com/v1/media/" + imageId + "/?client_id=" + instagramClientId;
    }

    req.open("GET", url, true);
    req.send();
}
