// *************************************************** //
// Likes Script
//
// This script handles the adding / removal of likes
// for a given image.
// Note that only authenticated users can like images.
// It's used by the ImageDetailPage and UserFeedPage.
// *************************************************** //


// include other scripts used here
Qt.include("instagramkeys.js");
Qt.include("authenticationhandler.js");
Qt.include("networkhandler.js");

// general network handler that acts upon the http request
var network = new NetworkHandler();

// general authentication handler that provides user authentication methods
var auth = new AuthenticationHandler();


// like a given image
// second parameter is true if the associated components should be updated
function likeImage(imageId, updateComponents)
{
    // console.log("Liking image " + imageId);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // this handles the result for each ready state
                var jsonObject = network.handleHttpResult(req);

                // jsonObject contains either false or the http result as object
                if (jsonObject)
                {
                    if (updateComponents)
                    {
                        // console.log("Updating components");

                        var numberOfLikes = parseInt(imageData.likes);
                        numberOfLikes += 1;
                        imageData.likes = numberOfLikes + " people liked this";

                        iconUnliked.visible = false;
                        iconLiked.visible = true;
                    }

                    // console.log("Done liking image");
                }
            }

    var auth = new AuthenticationHandler();
    var instagramUserdata = auth.getStoredInstagramData();
    var params = "access_token=" + instagramUserdata["access_token"];

    var url = "https://api.instagram.com/v1/media/" + imageId + "/likes";
    req.open("POST", url, true);
    req.send(params);
}


// unlike a given image
// second parameter is true if the associated components should be updated
function unlikeImage(imageId, updateComponents)
{
    // console.log("Unliking image " + imageId);

    var auth = new AuthenticationHandler();
    var instagramUserdata = auth.getStoredInstagramData();
    networkHelper.sendDeleteRequest("https://api.instagram.com/v1/media/" + imageId + "/likes?access_token=" + instagramUserdata["access_token"]);

    var numberOfLikes = parseInt(imageData.likes);
    numberOfLikes -= 1;
    imageData.likes = numberOfLikes + " people liked this";

    iconLiked.visible = false;
    iconUnliked.visible = true;

    // console.log("Done unliking image");
}
