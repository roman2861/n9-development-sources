.pragma library

// Globals contain the instagram API keys
Qt.include("instagramkeys.js")

// storage for Instagram tokens
var instagramTokenCode = "";
var instagramPermanentToken = "";


function checkUrlForToken(url)
{
    var currentURL = url.toString();

    if ( (currentURL.indexOf(instagramRedirectUrl) == 0) && (currentURL.indexOf("code=") > 0) )
    {
        var tokenStartPosition = currentURL.indexOf("code=");
        instagramTokenCode = currentURL.substr((tokenStartPosition+5));

        if (instagramTokenCode.length > 0)
        {
            console.log("Found Instagram token code: " + instagramTokenCode);
            requestPermanentToken(instagramTokenCode);
        }
    }
}


function requestPermanentToken(tokenCode)
{
    var req = new XMLHttpRequest();
    console.log("Requesting permanent token");
    req.onreadystatechange = function()
            {
                console.log("Ready state: " + req.readyState);
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    if (req.status != 200)
                    {
                        console.debug("Bad status: " + req.status);
                        return;
                    }

                    console.debug("content: " + req.responseText);
                    var jsonObject = eval('(' + req.responseText + ')');

                    if (jsonObject.error == null)
                    {
                        console.log("Found Instagram permanent token code: " + jsonObject);
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


function storeInstagramData(instagramObject)
{
    var db = openDatabaseSync("Instago", "1.1", "Instago persistent data", 1);
    db.transaction(function(tx) {
                       tx.executeSql('CREATE TABLE IF NOT EXISTS userdata(id TEXT, access_token TEXT)');
                   });

    var dataStr = "INSERT INTO userdata VALUES(?, ?)";
    var data = [instagramObject["user"].id, instagramObject.access_token];
    db.transaction(function(tx) {
                       tx.executeSql(dataStr, data);
                   });
}


function getStoredInstagramToken()
{
    var instagramUserdata = new Array();
    var db = openDatabaseSync("Instago", "1.0", "Instago persistent data storage", 1);
/*
    db.transaction(function(tx) {
                       tx.executeSql('DROP TABLE userdata');
                   });
*/
    db.transaction(function(tx) {
                       tx.executeSql('CREATE TABLE IF NOT EXISTS userdata(id TEXT, access_token TEXT)');
                   });

    db.transaction(function(tx) {
                       var rs = tx.executeSql("SELECT * FROM userdata");
                       if (rs.rows.length > 0)
                       {
                           console.log("Data found with token: " + rs.rows.item(0).access_token);
                           instagramUserdata = rs.rows.item(0);
                       }
                       else
                       {
                           console.log("No data found");
                       }
                   });

    return instagramUserdata;
}
