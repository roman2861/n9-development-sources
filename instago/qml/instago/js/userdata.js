// Globals contain the instagram API keys
Qt.include("instagramkeys.js");
Qt.include("authentication.js");
Qt.include("helpermethods.js");


// load the user data for a given Instagram user id
// the user data will be used to fill the UserMetadata component
function loadUserProfile(userId)
{
    // console.log("Loading user profile for user " + userId);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState === XMLHttpRequest.DONE)
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
                    userprofileBio.visible = true;

                    // hide loading indicator
                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;

                    // console.log("Done loading user profile");
                }
            }

    var url = "";
    if (isAuthenticated())
    {
        // we need the auth token for users that are private
        var instagramUserdata = getStoredInstagramData();
        url = "https://api.instagram.com/v1/users/" + userId + "?access_token=" + instagramUserdata["access_token"];
    }
    else
    {
        // calls with the client id can only show public users
        url = "https://api.instagram.com/v1/users/" + userId + "?client_id=" + instagramClientId;
    }

    req.open("GET", url, true);
    req.send();
}


// load the image stream for a given user from Instagram
// the image data will be used to fill the standard ImageGallery component
function loadUserImages(userId, paginationId)
{
    // console.log("Loading user image list for user " + userId + " and pagination id: " + paginationId);

    if (paginationId === 0)
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
                if (req.readyState === XMLHttpRequest.DONE)
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

                    if (paginationId === 0)
                    {
                        userprofileGallery.clearGallery();
                    }

                    var imageCache = new Array();
                    for ( var index in jsonObject.data )
                    {
                        // get image object
                        imageCache = getImageDataFromObject(jsonObject.data[index]);

                        // add image object to gallery list
                        userprofileGallery.addToGallery({
                                                            "url":imageCache["thumbnail"],
                                                            "index":imageCache["imageid"]
                                                        });

                        // console.log("Appended list with URL: " + imageCache["thumbnail"] + " and ID: " + imageCache["imageid"]);
                    }

                    // check if the page has a following page in the pagination list
                    // if so then remember it in the gallery component
                    if (jsonObject.pagination.next_max_id !== null)
                    {
                        userprofileGallery.paginationNextMaxId = jsonObject.pagination.next_max_id;
                    }

                    if (paginationId === 0)
                    {
                        // initial loading
                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;
                        userprofileGallery.visible = true;
                    }
                    else
                    {
                        // loading additional images
                        notification.hide();
                        notification.useTimer = true;
                    }

                    // console.log("Done loading user image list");
                }
            }

    var instagramUserdata = getStoredInstagramData();
    var url = "https://api.instagram.com/v1/users/" + userId + "/media/recent/?count=30&access_token=" + instagramUserdata["access_token"];
    if (paginationId !== 0)
    {
        url += "&max_id=" + paginationId;
    }

    req.open("GET", url, true);
    req.send();
}


// load the user follower data for a given Instagram user id
// the user data will be used to fill the UserList component
function loadUserFollowers(userId)
{
    // console.log("Loading user follower data for user " + userId);

    loadingIndicator.running = true;
    loadingIndicator.visible = true;

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
                    var jsonObject = eval('(' + req.responseText + ')');

                    userprofileFollowers.clearList();

                    var userCache = new Array();
                    for ( var index in jsonObject.data )
                    {
                        userCache = [];

                        userCache["username"] = jsonObject.data[index].username;
                        userCache["fullname"] = jsonObject.data[index].full_name;
                        if (userCache["fullname"] === "") userCache["fullname"] = userCache["username"];
                        userCache["profilepicture"] = jsonObject.data[index].profile_picture;
                        userCache["userid"] = jsonObject.data[index].id;
                        userCache["bio"] = jsonObject.data[index].bio;

                        userprofileFollowers.addToList({
                                                           "d_username": userCache["username"],
                                                           "d_fullname": userCache["fullname"],
                                                           "d_profilepicture": userCache["profilepicture"],
                                                           "d_userid": userCache["userid"],
                                                           "d_index": index
                                                       });

                        // console.log("Appended list with URL: " + imageCache["thumbnail"] + " and ID: " + imageCache["imageid"]);
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;

                    // console.log("Done loading user followers");
                }
            }

    var url = "https://api.instagram.com/v1/users/" + userId + "/followed-by?client_id=" + instagramClientId;

    req.open("GET", url, true);
    req.send();
}


// load the user following data for a given Instagram user id
// the user data will be used to fill the UserList component
function loadUserFollowing(userId)
{
    // console.log("Loading user following data for user " + userId);

    loadingIndicator.running = true;
    loadingIndicator.visible = true;

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

                    var jsonObject = eval('(' + req.responseText + ')');

                    userprofileFollowing.clearList();

                    var userCache = new Array();
                    for ( var index in jsonObject.data )
                    {
                        userCache = [];

                        userCache["username"] = jsonObject.data[index].username;
                        userCache["fullname"] = jsonObject.data[index].full_name;
                        if (userCache["fullname"] === "") userCache["fullname"] = userCache["username"];
                        userCache["profilepicture"] = jsonObject.data[index].profile_picture;
                        userCache["userid"] = jsonObject.data[index].id;
                        userCache["bio"] = jsonObject.data[index].bio;

                        userprofileFollowing.addToList({
                                                           "d_username": userCache["username"],
                                                           "d_fullname": userCache["fullname"],
                                                           "d_profilepicture": userCache["profilepicture"],
                                                           "d_userid": userCache["userid"],
                                                           "d_index": index
                                                       });

                        // console.log("Appended list with URL: " + imageCache["thumbnail"] + " and ID: " + imageCache["imageid"]);
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;

                    // console.log("Done loading user following");
                }
            }

    var url = "https://api.instagram.com/v1/users/" + userId + "/follows?client_id=" + instagramClientId;

    req.open("GET", url, true);
    req.send();
}
