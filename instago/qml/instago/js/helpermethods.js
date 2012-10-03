
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


// ensure that the given content is not empty
function ensureVariableNotNull(content)
{
    if (content !== null)
    {
        return content;
    }
    else
    {
        return "";
    }
}
