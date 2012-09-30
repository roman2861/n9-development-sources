// Globals contain the instagram API keys
Qt.include("instagramkeys.js")


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

                            imageGallery.addToGallery({
                                                        "url":imageData["thumbnail"],
                                                        "index":imageData["imageid"]
                                                    });

                            // console.log("Appended list with URL: " + imageData["thumbnail"] + " and ID: " + imageData["imageid"]);
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
