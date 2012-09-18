// Globals contain the instagram API keys
Qt.include("instagramkeys.js")


var arrUserDetail = [];


function loadUserDetail(userId)
{
    console.log("Loading user profile");

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                }
            }

    req.open("GET", "https://api.instagram.com/v1/users/" + userId + "?client_id=" + instagramClientId, true);
    req.send();
}
