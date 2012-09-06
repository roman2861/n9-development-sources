// Globals contain the instagram API keys
Qt.include("instagramkeys.js")

var arrUserProfile = [];

function loadUserProfile(userId)
{
    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    console.log("Loading user profile");

                    var jsonObject = eval('(' + req.responseText + ')');

                    arrUserProfile = [];
                    arrUserProfile["username"] = jsonObject.data.username;
                    pageHeader.text = qsTr(arrUserProfile["username"]);

                    arrUserProfile["fullname"] = jsonObject.data.full_name;
                    if (arrUserProfile["fullname"] == "") arrUserProfile["fullname"] = arrUserProfile["username"];
                    userprofileFullname.text = arrUserProfile["fullname"];

                    arrUserProfile["profilepicture"] = jsonObject.data.profile_picture;
                    userprofilePicture.source = arrUserProfile["profilepicture"];

                    arrUserProfile["numberofphotos"] = jsonObject.data.counts["media"];
                    if (arrUserProfile["numberofphotos"] > 10000) arrUserProfile["numberofphotos"] = Math.floor(arrUserProfile["numberofphotos"] / 1000) + "K";
                    imagecountNumber.text = arrUserProfile["numberofphotos"];

                    arrUserProfile["numberoffollowers"] = jsonObject.data.counts["followed_by"];
                    if (arrUserProfile["numberoffollowers"] > 10000) arrUserProfile["numberoffollowers"] = Math.floor(arrUserProfile["numberoffollowers"] / 1000) + "K";
                    followersNumber.text = arrUserProfile["numberoffollowers"];

                    arrUserProfile["numberoffollows"] = jsonObject.data.counts["follows"];
                    if (arrUserProfile["numberoffollows"] > 10000) arrUserProfile["numberoffollows"] = Math.floor(arrUserProfile["numberoffollows"] / 1000) + "K";
                    followingNumber.text = arrUserProfile["numberoffollows"];

                    arrUserProfile["bio"] = jsonObject.data.bio;
                    userprofileBio.text = qsTr(arrUserProfile["bio"]);

                    // console.log("Appended list with URL: " + arrPopularImages[index]["thumbnail"] + " and ID: " + index);

                    console.log("Done loading user profile");
                }
            }

    req.open("GET", "https://api.instagram.com/v1/users/" + userId + "?client_id=" + instagramClientId, true);
    req.send();
}
