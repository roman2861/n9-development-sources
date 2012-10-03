// Globals contain the instagram API keys
Qt.include("instagramkeys.js");
Qt.include("helpermethods.js");


// load the popular image stream from Instagram
// the image data will be used to fill the standard ImageGallery component
function loadImages()
{
    // console.log("Loading popular photos");

    // clear feed list
    imageGallery.clearGallery();

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
                    var jsonObject = eval('(' + req.responseText + ')');

                    var imageCache = new Array();
                    for ( var index in jsonObject.data )
                    {
                        if (index <= 17)
                        {
                            imageCache["thumbnail"] = jsonObject.data[index].images["thumbnail"]["url"];
                            imageCache["originalimage"] = jsonObject.data[index].images["standard_resolution"]["url"];
                            imageCache["linktoinstagram"] = jsonObject.data[index].link;
                            imageCache["imageid"] = jsonObject.data[index].id;
                            imageCache["caption"] = ensureVariableNotNull(jsonObject.data[index].caption["text"]);
                            imageCache["username"] = jsonObject.data[index].user["username"];
                            imageCache["profilepicture"] = jsonObject.data[index].user["profile_picture"];
                            imageCache["userid"] = jsonObject.data[index].user["id"];
                            imageCache["likes"] = jsonObject.data[index].likes["count"];

                            // format time
                            imageCache["createdtime"] = formatInstagramTime(jsonObject.data[index].created_time);

                            imageGallery.addToGallery({
                                                        "url":imageCache["thumbnail"],
                                                        "index":imageCache["imageid"]
                                                    });

                            // console.log("Appended list with URL: " + imageCache["thumbnail"] + " and ID: " + imageCache["imageid"]);
                        }
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    imageGallery.visible = true;

                    // console.log("Done loading popular photos");
                }
            }

    req.open("GET", "https://api.instagram.com/v1/media/popular?client_id=" + instagramClientId, true);
    req.send();
}
