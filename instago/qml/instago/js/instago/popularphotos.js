var arrPopularImages = [];
var bPopularPhotosLoaded = false;
var iCurrentIndex = 0;
var sPressedImage = "";

function loadImages()
{
    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    console.log("Loading popular photos");

                    var jsonObject = eval('(' + req.responseText + ')');
                    galleryListModel.clear();
                    for ( var index in jsonObject.data )
                    {
                        arrPopularImages[index] = [];
                        arrPopularImages[index]["thumbnail"] = jsonObject.data[index].images["thumbnail"]["url"];
                        arrPopularImages[index]["originalimage"] = jsonObject.data[index].images["standard_resolution"]["url"];
                        if (jsonObject.data[index].caption !== null)
                        {
                            arrPopularImages[index]["caption"] = jsonObject.data[index].caption["text"];
                        }
                        else
                        {
                            arrPopularImages[index]["caption"] = "";
                        }
                        arrPopularImages[index]["username"] = jsonObject.data[index].user["username"];

                        galleryListModel.append({
                                                    "url":arrPopularImages[index]["thumbnail"],
                                                    "index":index
                                                });
                        // console.log("Appended list with URL: " + arrPopularImages[index]["thumbnail"] + " and ID: " + index);
                    }

                    bPopularPhotosLoaded = true;
                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    galleryGrid.visible = true;

                    console.log("Done loading popular photos.");
                }
            }

    req.open("GET", "https://api.instagram.com/v1/media/popular?client_id=3bbd61a332384e66a46026c3dbbfaadc", true);
    req.send();
}
