// Globals contain the instagram API keys
Qt.include("instagramkeys.js")
Qt.include("authentication.js");


// like a given image
function likeImage(imageId, update)
{
    // console.log("Liking image " + imageId);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        // console.debug("bad status: " + req.status);
                        return;
                    }

                    // console.debug("content: " + req.responseText);
                    // var jsonObject = eval('(' + req.responseText + ')');

                    if (update)
                    {
                        var numberOfLikes = parseInt(imageData.likes);
                        numberOfLikes += 1;
                        imageData.likes = numberOfLikes + " people liked this";

                        iconUnliked.visible = false;
                        iconLiked.visible = true;
                    }

                    // console.log("Done liking image");
                }
            }

    var instagramUserdata = getStoredInstagramData();
    var params = "access_token=" + instagramUserdata["access_token"];

    var url = "https://api.instagram.com/v1/media/" + imageId + "/likes";
    req.open("POST", url, true);
    req.send(params);
}


// unlike a given image
function unlikeImage(imageId, update)
{
    // console.log("Unliking image " + imageId);
    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        // console.debug("bad status: " + req.status);
                        return;
                    }

                    // console.debug("content: " + req.responseText);
                    // var jsonObject = eval('(' + req.responseText + ')');

                    if (update)
                    {
                        var numberOfLikes = parseInt(imageData.likes);
                        numberOfLikes -= 1;
                        imageData.likes = numberOfLikes + " people liked this";

                        iconLiked.visible = false;
                        iconUnliked.visible = true;
                    }

                    // console.log("Done unliking image");
                }
            }

    var instagramUserdata = getStoredInstagramData();
    var params = "access_token=" + instagramUserdata["access_token"];

    var url = "https://api.instagram.com/v1/media/" + imageId + "/likes";
    req.open("DELETE", url, true);
    req.send(params);
}
