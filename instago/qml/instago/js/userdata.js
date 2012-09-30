// Globals contain the instagram API keys
Qt.include("instagramkeys.js");
Qt.include("authentication.js");


// load the user data for a given Instagram user id
// the user data will be used to fill the UserMetadata component
function loadUserProfile(userId)
{
    // console.log("Loading user profile for user " + userId);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        // console.debug("bad status: " + req.status);
                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;
                        networkErrorMesage.visible = true;

                        return;
                    }

                    // console.debug("content: " + req.responseText);

                    var userCache = [];
                    var jsonObject = eval('(' + req.responseText + ')');

                    userCache["username"] = jsonObject.data.username;
                    pageHeader.text = qsTr("@" + userCache["username"]);

                    userCache["fullname"] = jsonObject.data.full_name;
                    if (userCache["fullname"] == "") userCache["fullname"] = userCache["username"];
                    userprofileMetadata.fullname = userCache["fullname"];

                    userCache["profilepicture"] = jsonObject.data.profile_picture;
                    userprofileMetadata.profilepicture = userCache["profilepicture"];

                    userCache["numberofphotos"] = jsonObject.data.counts["media"];
                    if (userCache["numberofphotos"] > 10000) userCache["numberofphotos"] = Math.floor(userCache["numberofphotos"] / 1000) + "K";
                    userprofileMetadata.imagecount = userCache["numberofphotos"];

                    userCache["numberoffollowers"] = jsonObject.data.counts["followed_by"];
                    if (userCache["numberoffollowers"] > 10000) userCache["numberoffollowers"] = Math.floor(userCache["numberoffollowers"] / 1000) + "K";
                    userprofileMetadata.followers = userCache["numberoffollowers"];

                    userCache["numberoffollows"] = jsonObject.data.counts["follows"];
                    if (userCache["numberoffollows"] > 10000) userCache["numberoffollows"] = Math.floor(userCache["numberoffollows"] / 1000) + "K";
                    userprofileMetadata.following = userCache["numberoffollows"];

                    userCache["bio"] = jsonObject.data.bio;
                    userprofileBio.text = qsTr(userCache["bio"]);

                    // activate profile containers
                    userprofileMetadata.visible = true;
                    userprofileContentHeadline.visible = true;
                    userprofileBioContainer.visible = true;

                    // hide loading indicator
                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;

                    // console.log("Done loading user profile");
                }
            }

    req.open("GET", "https://api.instagram.com/v1/users/" + userId + "?client_id=" + instagramClientId, true);
    req.send();
}


// load the image stream for a given user from Instagram
// the image data will be used to fill the standard ImageGallery component
function loadUserImages(userId, max_id)
{
    // console.log("Loading user image list for user " + userId + " and max_id: " + max_id);

    if (max_id === 0)
    {
        loadingIndicator.running = true;
        loadingIndicator.visible = true;
    }
    else
    {
        notification.useTimer = false;
        notification.text = "Loading more images..";
        notification.show();
    }

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        // console.debug("bad status: " + req.status);

                        notification.hide();
                        notification.useTimer = true;

                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;
                        networkErrorMesage.visible = true;

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

                            // console.log("Appended list with URL: " + imageData["thumbnail"] + " and ID: " + imageData["imageid"]);
                        }
                    }

                    if (jsonObject.pagination.next_max_id != null)
                    {
                        userprofileGallery.paginationNextMaxId = jsonObject.pagination.next_max_id;
                    }

                    if (max_id === 0)
                    {
                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;
                    }
                    else
                    {
                        notification.hide();
                        notification.useTimer = true;
                    }

                    userprofileGallery.visible = true;
                    // console.log("Done loading user image list");
                }
            }

    var instagramUserdata = getStoredInstagramData();
    var url = "https://api.instagram.com/v1/users/" + userId + "/media/recent/?count=15&access_token=" + instagramUserdata["access_token"];
    if (max_id !== 0)
    {
        url += "&max_id=" + max_id;
    }

    req.open("GET", url, true);
    req.send();
}
