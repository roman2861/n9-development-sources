// Globals contain the instagram API keys
Qt.include("instagramkeys.js")


var arrPopularImages = [];


function loadImages()
{
    var req = new XMLHttpRequest();
    console.log("Loading popular photos");
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

                    galleryListModel.clear();
                    for ( var index in jsonObject.data )
                    {
                        if (index <= 17)
                        {
                            arrPopularImages[index] = [];
                            arrPopularImages[index]["thumbnail"] = jsonObject.data[index].images["thumbnail"]["url"];
                            arrPopularImages[index]["originalimage"] = jsonObject.data[index].images["standard_resolution"]["url"];
                            arrPopularImages[index]["linktoinstagram"] = jsonObject.data[index].link;

                            if (jsonObject.data[index].caption !== null)
                            {
                                arrPopularImages[index]["caption"] = jsonObject.data[index].caption["text"];
                            }
                            else
                            {
                                arrPopularImages[index]["caption"] = "";
                            }

                            arrPopularImages[index]["username"] = jsonObject.data[index].user["username"];
                            arrPopularImages[index]["profilepicture"] = jsonObject.data[index].user["profile_picture"];
                            arrPopularImages[index]["userid"] = jsonObject.data[index].user["id"];
                            arrPopularImages[index]["likes"] = jsonObject.data[index].likes["count"];

                            arrPopularImages[index]["createdtime"] = jsonObject.data[index].created_time;
                            var time = new Date(arrPopularImages[index]["createdtime"] * 1000);
                            var timeStr = time.getMonth() + "/" + time.getDate() + "/" + time.getFullYear() + ", " +
                                    time.getHours() + ":" + time.getMinutes();
                            arrPopularImages[index]["createdtime"] = timeStr;

                            galleryListModel.append({
                                                        "url":arrPopularImages[index]["thumbnail"],
                                                        "index":index
                                                    });
                            // console.log("Appended list with URL: " + arrPopularImages[index]["thumbnail"] + " and ID: " + index);
                        }
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    galleryGrid.visible = true;

                    console.log("Done loading popular photos");
                }
            }

    req.open("GET", "https://api.instagram.com/v1/media/popular?client_id=" + instagramClientId, true);
    req.send();
}
