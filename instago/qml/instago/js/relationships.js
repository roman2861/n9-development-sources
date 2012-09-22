// Globals contain the instagram API keys
Qt.include("instagramkeys.js")
Qt.include("authentication.js");


// follow a given user
function setRelationship(userId, relationship)
{
    console.log("Setting relationship to user " + userId + " to " + relationship);
    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        console.debug("bad status: " + req.status);
                        return;
                    }

                    console.debug("content: " + req.responseText);
                    // var jsonObject = eval('(' + req.responseText + ')');

                    console.log("Done changing relationship");
                }
            }

    var instagramUserdata = getStoredInstagramData();
    var params = "access_token=" + instagramUserdata["access_token"] + "&action=" + relationship;

    var url = "https://api.instagram.com/v1/users/" + userId + "/relationship";
    req.open("POST", url, true);
    req.send(params);
}
