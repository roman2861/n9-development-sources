// Globals contain the instagram API keys
Qt.include("instagramkeys.js");
Qt.include("authentication.js");


function loadUserProfile()
{
    var arrUserProfile = [];

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    console.log("Loading user profile");

                    var jsonObject = eval('(' + req.responseText + ')');

                    arrUserProfile = [];
                    arrUserProfile["username"] = jsonObject.data.username;
                    pageHeader.text = qsTr("You (@" + arrUserProfile["username"] + ")");

                    arrUserProfile["fullname"] = jsonObject.data.full_name;
                    if (arrUserProfile["fullname"] == "") arrUserProfile["fullname"] = arrUserProfile["username"];
                    userprofileMetadata.fullname = arrUserProfile["fullname"];

                    arrUserProfile["profilepicture"] = jsonObject.data.profile_picture;
                    userprofileMetadata.profilepicture = arrUserProfile["profilepicture"];

                    arrUserProfile["numberofphotos"] = jsonObject.data.counts["media"];
                    if (arrUserProfile["numberofphotos"] > 10000) arrUserProfile["numberofphotos"] = Math.floor(arrUserProfile["numberofphotos"] / 1000) + "K";
                    userprofileMetadata.imagecount = arrUserProfile["numberofphotos"];

                    arrUserProfile["numberoffollowers"] = jsonObject.data.counts["followed_by"];
                    if (arrUserProfile["numberoffollowers"] > 10000) arrUserProfile["numberoffollowers"] = Math.floor(arrUserProfile["numberoffollowers"] / 1000) + "K";
                    userprofileMetadata.followers = arrUserProfile["numberoffollowers"];

                    arrUserProfile["numberoffollows"] = jsonObject.data.counts["follows"];
                    if (arrUserProfile["numberoffollows"] > 10000) arrUserProfile["numberoffollows"] = Math.floor(arrUserProfile["numberoffollows"] / 1000) + "K";
                    userprofileMetadata.following = arrUserProfile["numberoffollows"];

                    arrUserProfile["bio"] = jsonObject.data.bio;
                    userprofileBio.text = qsTr(arrUserProfile["bio"]);

                    console.log("Done loading user profile");
                }
            }

    var instagramUserdata = getStoredInstagramData();
    req.open("GET", "https://api.instagram.com/v1/users/" + instagramUserdata["id"] + "?client_id=" + instagramClientId, true);
    req.send();
}

/*
function loadUserPhotos()
{
    console.log("Loading user photos");
    var arrPopularImages = [];

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        console.debug("bad status: " + req.status);
                        //loadingIndicator.running = false;
                        //loadingIndicator.visible = false;
                        //errorIndicator.visible = true;

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

                    //loadingIndicator.running = false;
                    //loadingIndicator.visible = false;
                    galleryGrid.visible = true;

                    console.log("Done loading user photos");
                }
            }

    var instagramUserdata = getStoredInstagramData();
    req.open("GET", "https://api.instagram.com/v1/users/" + instagramUserdata["id"] + "/media/recent/?count=15&access_token=" + instagramUserdata["access_token"], true);
    req.send();
}
*/
