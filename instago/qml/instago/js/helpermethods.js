
// format an Instagram time stamp into readable format
function formatInstagramTime(instagramTime)
{
    var time = new Date(instagramTime * 1000);
    var timeStr = time.getMonth() +
            "/" + time.getDate() +
            "/" + time.getFullYear() + ", ";

    // make sure hours have 2 digits
    if (time.getHours() < 10) { timeStr += "0" + time.getHours() }
    else { timeStr += time.getHours() }

    timeStr += ":";

    // make sure minutes have 2 digits
    if (time.getMinutes() < 10) { timeStr += "0" + time.getMinutes() }
    else { timeStr += time.getMinutes() }

    return timeStr;
}


// extract all image data from an image object
// return unified image array
function getImageDataFromObject(imageObject)
{
    var imageReturnArray = new Array();

    imageReturnArray["thumbnail"] = imageObject.images["thumbnail"]["url"];
    imageReturnArray["originalimage"] = imageObject.images["standard_resolution"]["url"];
    imageReturnArray["imageid"] = imageObject.id;
    imageReturnArray["username"] = imageObject.user["username"];
    imageReturnArray["profilepicture"] = imageObject.user["profile_picture"];
    imageReturnArray["userid"] = imageObject.user["id"];
    imageReturnArray["likes"] = imageObject.likes["count"];
    imageReturnArray["createdtime"] = formatInstagramTime(imageObject.created_time);

    // image may be liked by user
    // this node is only in the result set if the user is logged in
    if (imageObject.user_has_liked !== null)
    {
        imageReturnArray["userhasliked"] = imageObject.user_has_liked;
    }
    else
    {
        imageReturnArray["userhasliked"] = "false";
    }

    // images that are new and just updated may not have an Instagram page yet
    // their link will thus be null
    if (imageObject.link !== null)
    {
        imageReturnArray["linktoinstagram"] = imageObject.link;
    }
    else
    {
        imageReturnArray["linktoinstagram"] = "";
    }

    // caption may be empty
    if (imageObject.caption !== null)
    {
        imageReturnArray["caption"] = imageObject.caption["text"];
    }
    else
    {
        imageReturnArray["caption"] = "";
    }

    return imageReturnArray;
}
