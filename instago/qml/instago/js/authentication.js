.pragma library

// Globals contain the instagram API keys
Qt.include("instagramkeys.js")


// this checks a given URL for oauth data
// this can either be a token if the authentication was successful
// or it can contain an error with respective message
function checkInstagramAuthenticationUrl(url)
{
    var currentURL = url.toString();
    var returnStatus = new Array();

    // console.log("URL: " + currentURL);

    // set default status
    returnStatus["status"] = "NOT_RELEVANT";

    // authentication was successful: the URL contains the redirect address as well the token code
    if ( (currentURL.indexOf(instagramRedirectUrl) == 0) && (currentURL.indexOf("code=") > 0) )
    {
        var instagramTokenCode = "";
        var tokenStartPosition = currentURL.indexOf("code=");
        instagramTokenCode = currentURL.substr((tokenStartPosition+5));

        if (instagramTokenCode.length > 0)
        {
            // console.log("Found Instagram token code: " + instagramTokenCode);
            requestPermanentToken(instagramTokenCode);
            returnStatus["status"] = "AUTH_SUCCESS";
        }
    }

    // an error occured: the URL contains the error parameters
    if ( (currentURL.indexOf(instagramRedirectUrl) == 0) && (currentURL.indexOf("error=") > 0) )
    {
        var stringIndexPosition = currentURL.indexOf("/?");
        var errorString = "";
        errorString = currentURL.substr((stringIndexPosition+2));

        var errorMessageList = new Array();
        errorMessageList = errorString.split("&");

        for (var index in errorMessageList)
        {
            var errorMessage = new Array();
            errorString = errorMessageList[index];
            errorMessage = errorString.split("=");
            returnStatus[errorMessage[0]] = errorMessage[1].replace(/\+/g, ' ');
        }

        // console.log("Instagram authentication error occured");
        returnStatus["status"] = "AUTH_ERROR";
    }

    return returnStatus;
}


// request a permanent token based on a temp token code
function requestPermanentToken(tokenCode)
{
    var instagramPermanentToken = "";

    // console.log("Requesting permanent token");

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // console.log("Ready state: " + req.readyState);
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        console.debug("Bad status: " + req.status);
                        return;
                    }

                    // console.debug("content: " + req.responseText);
                    var jsonObject = eval('(' + req.responseText + ')');

                    if (jsonObject.error == null)
                    {
                        // console.log("Found Instagram permanent token code: " + jsonObject);
                        instagramPermanentToken = jsonObject.access_token;
                        storeInstagramData(jsonObject);
                    }
                }
            }

    req.open("POST", instagramTokenRequestUrl, true);
    var params = "grant_type=authorization_code" +
            "&client_id=" + instagramClientId +
            "&client_secret=" + instagramClientSecret +
            "&code=" + tokenCode + "&redirect_uri=" + instagramRedirectUrl;
    req.send(params);
}


// store a permanent token for a user into the database
function storeInstagramData(instagramObject)
{
    var db = openDatabaseSync("Instago", "1.0", "Instago persistent data storage", 1);
    db.transaction(function(tx) {
                       tx.executeSql('CREATE TABLE IF NOT EXISTS userdata(id TEXT, access_token TEXT)');
                   });

    var dataStr = "INSERT INTO userdata VALUES(?, ?)";
    var data = [instagramObject["user"].id, instagramObject.access_token];
    db.transaction(function(tx) {
                       tx.executeSql(dataStr, data);
                   });
}


// get the stored permanent token for the user
function getStoredInstagramData()
{
    var instagramUserdata = new Array();
    var db = openDatabaseSync("Instago", "1.0", "Instago persistent data storage", 1);

    db.transaction(function(tx) {
                       tx.executeSql('CREATE TABLE IF NOT EXISTS userdata(id TEXT, access_token TEXT)');
                   });

    db.transaction(function(tx) {
                       var rs = tx.executeSql("SELECT * FROM userdata");
                       if (rs.rows.length > 0)
                       {
                           // console.log("Data found with token: " + rs.rows.item(0).access_token + " for user: " + rs.rows.item(0).id);
                           instagramUserdata = rs.rows.item(0);
                       }
                   });

    return instagramUserdata;
}


// check if the user is currently authenticated with Instagram
function isAuthorized()
{
    var userdata = new Array();

    // get the userdata from the persistent database
    // if data is available the user already has a token
    userdata = getStoredInstagramData();

    if (userdata.length == 0)
    {
        // user does not have a token
        // console.log("User does not have a stored token yet");
        return false;
    }

    // user already has a token
    // console.log("User already has a stored token");
    return true;
}


// logout user by deleting the current token
function deleteStoredInstagramData()
{
    var instagramUserdata = new Array();
    var db = openDatabaseSync("Instago", "1.0", "Instago persistent data storage", 1);

    db.transaction(function(tx) {
                       tx.executeSql('DROP TABLE userdata');
                   });

    return true;
}
