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

                    var imageData = new Array();
                    imageData["thumbnail"] = jsonObject.data.images["thumbnail"]["url"];

                    imageData["originalimage"] = jsonObject.data.images["standard_resolution"]["url"];
                    detailImage.source = imageData["originalimage"];

                    imageData["linktoinstagram"] = jsonObject.data.link;
                    instagramUrl = imageData["linktoinstagram"];

                    imageData["imageid"] = jsonObject.data.id;

                    if (jsonObject.data.caption !== null)
                    {
                        imageData["caption"] = jsonObject.data.caption["text"];
                    }
                    else
                    {
                        imageData["caption"] = "";
                    }
                    metadataImageCaption.text = imageData["caption"];

                    imageData["username"] = jsonObject.data.user["username"];
                    userprofileUsername.text = imageData["username"];

                    imageData["profilepicture"] = jsonObject.data.user["profile_picture"];
                    userprofilePicture.source = imageData["profilepicture"];

                    imageData["userid"] = jsonObject.data.user["id"];
                    userId = imageData["userid"];

                    imageData["userhasliked"] = jsonObject.data.user_has_liked;
                    userHasLiked = imageData["userhasliked"];
                    if (isAuthorized())
                    {
                        if (!userHasLiked)
                        {
                            iconUnliked.visible = true;
                        }
                        else
                        {
                            iconLiked.visible = true;
                        }
                    }

                    imageData["likes"] = jsonObject.data.likes["count"];
                    metadataLikes.text = imageData["likes"] + " people liked this";

                    imageData["createdtime"] = jsonObject.data.created_time;
                    var time = new Date(imageData["createdtime"] * 1000);
                    var timeStr = time.getMonth() +
                            "/" + time.getDate() +
                            "/" + time.getFullYear() + ", " +
                            time.getHours() + ":" + time.getMinutes();
                    imageData["createdtime"] = timeStr;
                    userprofileCreatedtime.text = imageData["createdtime"];

                    // this is magic: since metadataImageCaption.height gives me garbage I calculate the height by multiplying the number of lines with the line height
                    metadataImageCaption.height = Math.floor(((metadataImageCaption.text.length / 42) + (metadataImageCaption.text.split("\n").length - 1)) * 24 );
                    // console.log("Lines: " + metadataImageCaption.lineCount + "und height: " + metadataImageCaption.lineHeight + " = " + metadataImageCaption.lineCount / metadataImageCaption.lineHeight);

                    // this is fed to the flickable container as content height
                    contentFlickableContainer.contentHeight = (userprofileContainer.height + detailImageContainer.height + 100 + metadataImageCaption.height);
                    // console.log("total: " + contentFlickableContainer.contentHeight + " userprofile: " + userprofileContainer.height + " detailimage: " + detailImageContainer.height + " +100 and caption: " + metadataImageCaption.height);

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
