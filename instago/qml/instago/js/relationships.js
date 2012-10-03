// Globals contain the instagram API keys
Qt.include("instagramkeys.js")
Qt.include("authentication.js");


// set the relationship with a given user
function setRelationship(userId, relationship)
{
    // console.log("Setting relationship fot user " + userId + " to " + relationship);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState === XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        // console.debug("bad status: " + req.status);
                        return;
                    }

                    // console.log("Done changing relationship");
                }
            }

    var instagramUserdata = getStoredInstagramData();
    var params = "access_token=" + instagramUserdata["access_token"] + "&action=" + relationship;

    var url = "https://api.instagram.com/v1/users/" + userId + "/relationship";
    req.open("POST", url, true);
    req.send(params);
}


// get the relationship status of a given user
function getRelationship(userId)
{
    // console.log("Getting relationship for user " + userId);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState === XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        // console.debug("bad status: " + req.status);
                        return;
                    }

                    // console.log("content: " + req.responseText);

                    var jsonObject = eval('(' + req.responseText + ')');

                    // check if user is already followed
                    if (jsonObject.data.outgoing_status === "follows")
                    {
                        userprofileBio.unfollowButtonVisible = true;
                    }
                    // else check if the user is not followed yet
                    else if (jsonObject.data.outgoing_status === "none")
                    {
                        userprofileBio.followButtonVisible = true;
                    }

                    // console.log("Done getting relationship");
                }
            }

    var instagramUserdata = getStoredInstagramData();
    var url = "https://api.instagram.com/v1/users/" + userId + "/relationship?access_token=" + instagramUserdata["access_token"];

    req.open("GET", url, true);
    req.send();
}
