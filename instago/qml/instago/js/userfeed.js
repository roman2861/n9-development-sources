// Globals contain the instagram API keys
Qt.include("instagramkeys.js")
Qt.include("authentication.js");


// load the popular image stream from Instagram
// the image data will be used to fill the standard ImageGallery component
function loadUserFeed()
{
    // console.log("Loading user feed");

    // clear feed list
    feedListModel.clear();

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
                        networkErrorMesage.visible = true;

                        return;
                    }

                    // console.debug("content: " + req.responseText);
                    var jsonObject = eval('(' + req.responseText + ')');

                    // var for image cache
                    var imageCache = new Array();

                    for ( var index in jsonObject.data )
                    {
                        imageCache = [];
                        imageCache["thumbnail"] = jsonObject.data[index].images["thumbnail"]["url"];
                        imageCache["originalImage"] = jsonObject.data[index].images["standard_resolution"]["url"];
                        imageCache["imageId"] = jsonObject.data[index].id;
                        imageCache["username"] = jsonObject.data[index].user["username"];
                        imageCache["profilePicture"] = jsonObject.data[index].user["profile_picture"];
                        imageCache["userId"] = jsonObject.data[index].user["id"];
                        imageCache["likes"] = jsonObject.data[index].likes["count"];

                        // images that are new and just updated may not have an Instagram page yet
                        // their link will thus be null
                        imageCache["linkToInstagram"] = ensureVariableNotNull(jsonObject.data[index].link);

                        imageCache["caption"] = ensureVariableNotNull(jsonObject.data[index].caption["text"]);
                        imageCache["createdTime"] = formatInstagramTime(jsonObject.data.created_time);

                        feedListModel.append({
                                                 "d_originalImage":imageCache["originalImage"],
                                                 "d_username":imageCache["username"],
                                                 "d_createdTime":imageCache["createdTime"],
                                                 "d_likes":imageCache["likes"],
                                                 "d_linkToInstagram":imageCache["linkToInstagram"],
                                                 "d_imageId":imageCache["imageId"],
                                                 "d_userId":imageCache["userId"],
                                                 "d_createdTime":imageCache["createdTime"],
                                                 "d_profilePicture":imageCache["profilePicture"]
                                             });

                        // console.log("Appended list with ID: " + imageCache["imageId"] + " in index: " + index);
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    feedList.visible = true;

                    // console.log("Done loading user feed");
                }
            }

    var instagramUserdata = getStoredInstagramData();
    var url = "https://api.instagram.com/v1/users/self/feed?access_token=" + instagramUserdata["access_token"];
    req.open("GET", url, true);
    req.send();
}
