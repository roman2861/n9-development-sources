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
                            // get image object
                            imageCache = getImageDataFromObject(jsonObject.data[index]);

                            // add image object to gallery list
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
