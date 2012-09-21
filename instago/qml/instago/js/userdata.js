// Globals contain the instagram API keys
Qt.include("instagramkeys.js");
Qt.include("authentication.js");


// load the user data for a given Instagram user id
// the user data will be used to fill the UserMetadata component
function loadUserProfile(userId)
{
    console.log("Loading user profile for user " + userId);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    var userData = [];
                    var jsonObject = eval('(' + req.responseText + ')');

                    userData["username"] = jsonObject.data.username;
                    pageHeader.text = qsTr("@" + userData["username"]);

                    userData["fullname"] = jsonObject.data.full_name;
                    if (userData["fullname"] == "") userData["fullname"] = userData["username"];
                    userprofileMetadata.fullname = userData["fullname"];

                    userData["profilepicture"] = jsonObject.data.profile_picture;
                    userprofileMetadata.profilepicture = userData["profilepicture"];

                    userData["numberofphotos"] = jsonObject.data.counts["media"];
                    if (userData["numberofphotos"] > 10000) userData["numberofphotos"] = Math.floor(userData["numberofphotos"] / 1000) + "K";
                    userprofileMetadata.imagecount = userData["numberofphotos"];

                    userData["numberoffollowers"] = jsonObject.data.counts["followed_by"];
                    if (userData["numberoffollowers"] > 10000) userData["numberoffollowers"] = Math.floor(userData["numberoffollowers"] / 1000) + "K";
                    userprofileMetadata.followers = userData["numberoffollowers"];

                    userData["numberoffollows"] = jsonObject.data.counts["follows"];
                    if (userData["numberoffollows"] > 10000) userData["numberoffollows"] = Math.floor(userData["numberoffollows"] / 1000) + "K";
                    userprofileMetadata.following = userData["numberoffollows"];

                    userData["bio"] = jsonObject.data.bio;
                    userprofileBio.text = qsTr(userData["bio"]);

                    console.log("Done loading user profile");
                }
            }

    req.open("GET", "https://api.instagram.com/v1/users/" + userId + "?client_id=" + instagramClientId, true);
    req.send();
}


// load the image stream for a given user from Instagram
// the image data will be used to fill the standard ImageGallery component
function loadUserImages(userId, max_id)
{
    console.log("Loading user image list for user " + userId + " and max_id: " + max_id);

    loadingIndicator.running = true;
    loadingIndicator.visible = true;

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
                        errorIndicator.visible = true;

                        return;
                    }

                    // console.debug("content: " + req.responseText);
                    var jsonObject = eval('(' + req.responseText + ')');

                    if (max_id === 0)
                    {
                        userprofileGallery.clearGallery();
                    }

                    for ( var index in jsonObject.data )
                    {
                        var imageData = new Array();

                        if (index <= 17)
                        {
                            imageData["thumbnail"] = jsonObject.data[index].images["thumbnail"]["url"];
                            imageData["originalimage"] = jsonObject.data[index].images["standard_resolution"]["url"];
                            imageData["linktoinstagram"] = jsonObject.data[index].link;
                            imageData["imageid"] = jsonObject.data[index].id;

                            if (jsonObject.data[index].caption !== null)
                            {
                                imageData["caption"] = jsonObject.data[index].caption["text"];
                            }
                            else
                            {
                                imageData["caption"] = "";
                            }

                            imageData["username"] = jsonObject.data[index].user["username"];
                            imageData["profilepicture"] = jsonObject.data[index].user["profile_picture"];
                            imageData["userid"] = jsonObject.data[index].user["id"];
                            imageData["likes"] = jsonObject.data[index].likes["count"];

                            imageData["createdtime"] = jsonObject.data[index].created_time;
                            var time = new Date(imageData["createdtime"] * 1000);
                            var timeStr = time.getMonth() + "/" + time.getDate() + "/" + time.getFullYear() + ", " +
                                    time.getHours() + ":" + time.getMinutes();
                            imageData["createdtime"] = timeStr;

                            userprofileGallery.addToGallery({
                                                        "url":imageData["thumbnail"],
                                                        "index":imageData["imageid"]
                                                    });
                            // console.log("Appended list with URL: " + imageData["thumbnail"] + " and ID: " + index);
                        }
                    }

                    if (jsonObject.pagination.next_max_id != null)
                    {
                        paginationNextMaxId = jsonObject.pagination.next_max_id;
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    userprofileGallery.visible = true;

                    console.log("Done loading user image list");
                }
            }

    var instagramUserdata = getStoredInstagramData();
    var url = "https://api.instagram.com/v1/users/" + userId + "/media/recent/?count=15&access_token=" + instagramUserdata["access_token"];
    if (max_id !== 0)
    {
        url += "&max_id=" + max_id;
    }

    console.log(url);
    req.open("GET", url, true);
    req.send();
}
