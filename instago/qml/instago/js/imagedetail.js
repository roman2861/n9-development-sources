// Globals contain the instagram API keys
Qt.include("instagramkeys.js");
Qt.include("authentication.js");


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
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        console.debug("bad status: " + req.status);
                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;
                        //errorIndicator.visible = true;

                        return;
                    }

                    var jsonObject = eval('(' + req.responseText + ')');

                    var imageCache = new Array();
                    imageCache["thumbnail"] = jsonObject.data.images["thumbnail"]["url"];

                    imageCache["originalImage"] = jsonObject.data.images["standard_resolution"]["url"];
                    imageData.originalImage = imageCache["originalImage"];

                    imageCache["linkToInstagram"] = jsonObject.data.link;
                    imageData.linkToInstagram = imageCache["linkToInstagram"];

                    imageCache["imageId"] = jsonObject.data.id;
                    imageData.imageId = imageCache["imageId"];

                    imageCache["username"] = jsonObject.data.user["username"];
                    imageData.username = imageCache["username"];

                    imageCache["profilePicture"] = jsonObject.data.user["profile_picture"];
                    imageData.profilePicture = imageCache["profilePicture"];

                    imageCache["userId"] = jsonObject.data.user["id"];
                    imageData.userId = imageCache["userId"];

                    imageCache["likes"] = jsonObject.data.likes["count"];
                    imageData.likes = imageCache["likes"] + " people liked this";

                    if (jsonObject.data.caption !== null)
                    {
                        imageCache["caption"] = jsonObject.data.caption["text"];
                    }
                    else
                    {
                        imageCache["caption"] = "";
                    }
                    imageData.caption = imageCache["caption"];

                    if (jsonObject.data.user_has_liked !== undefined)
                    {
                        imageCache["userHasLiked"] = jsonObject.data.user_has_liked;
                        imageData.userHasLiked = imageCache["userHasLiked"];
                        if (jsonObject.data.user_has_liked)
                        {
                            iconLiked.visible = true;
                        }
                        else
                        {
                            iconUnliked.visible = true;
                        }
                    }

                    imageCache["createdTime"] = jsonObject.data.created_time;
                    var time = new Date(imageCache["createdTime"] * 1000);
                    var timeStr = time.getMonth() +
                            "/" + time.getDate() +
                            "/" + time.getFullYear() + ", " +
                            time.getHours() + ":" + time.getMinutes();
                    imageCache["createdTime"] = timeStr;
                    imageData.createdTime = imageCache["createdTime"];

                    // console.log("Done loading image");
                }
            }

    var url = "";
    if (isAuthorized())
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
