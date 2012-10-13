// *************************************************** //
// Relationships Script
//
// This script handles the relationship processes
// between users.
// Note that only authenticated users can change
// relationship processes.
// It's used by the UserDetailPage.
// *************************************************** //


// include other scripts used here
Qt.include("instagramkeys.js");
Qt.include("authenticationhandler.js");
Qt.include("networkhandler.js");

// general network handler that acts upon the http request
var network = new NetworkHandler();

// general authentication handler that provides user authentication methods
var auth = new AuthenticationHandler();


// set the relationship with a given user
function setRelationship(userId, relationship)
{
    // console.log("Setting relationship fot user " + userId + " to " + relationship);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // this handles the result for each ready state
                var jsonObject = network.handleHttpResult(req);

                // jsonObject contains either false or the http result as object
                if (jsonObject)
                {
                    // console.log("Done changing relationship");
                }
                else
                {
                    // either the request is not done yet or an error occured
                    // check for both and act accordingly
                    if ( (network.requestIsFinished) && (network.errorData['code'] != null) )
                    {
                        errorMessage.showErrorMessage({
                                                          "d_code":network.errorData['code'],
                                                          "d_error_type":network.errorData['error_type'],
                                                          "d_error_message":network.errorData['error_message']
                                                      });
                    }
                }
            }

    var instagramUserdata = auth.getStoredInstagramData();
    var params = "access_token=" + instagramUserdata["access_token"] + "&action=" + relationship;

    var url = "https://api.instagram.com/v1/users/" + userId + "/relationship";
    req.open("POST", url, true);
    req.send(params);
}


// get the relationship status of a given user
function getRelationship(userId)
{
    // console.log("Getting relationship for user " + userId);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // this handles the result for each ready state
                var jsonObject = network.handleHttpResult(req);

                // jsonObject contains either false or the http result as object
                if (jsonObject)
                {
                    // check if user is already followed
                    if (jsonObject.data.outgoing_status === "follows")
                    {
                        userprofileBio.unfollowButtonVisible = true;
                    }

                    // check if user is not followed and not private
                    if ( (jsonObject.data.outgoing_status === "none") && (jsonObject.data.target_user_is_private === false) )
                    {
                        // console.log("User is not followed and not private")
                        userprofileBio.followButtonVisible = true;
                    }

                    // check if user is not followed and private
                    if ( (jsonObject.data.outgoing_status === "none") && (jsonObject.data.target_user_is_private === true) )
                    {
                        // console.log("User is not followed and private")
                        pageHeader.text = "User is private";
                        userprofileBio.userIsPrivateMessageVisible = true;
                        userprofileBio.requestButtonVisible = true;
                    }

                    // check if user is not followed but follow requested
                    if ( (jsonObject.data.outgoing_status === "requested") && (jsonObject.data.target_user_is_private === true) )
                    {
                        // console.log("User is not followed but follow requested")
                        pageHeader.text = "User is private";
                        userprofileBio.userIsPrivateMessageVisible = true;
                        userprofileBio.unrequestButtonVisible = true;
                    }

                    // console.log("Done getting relationship");
                }
                else
                {
                    // either the request is not done yet or an error occured
                    // check for both and act accordingly
                    if ( (network.requestIsFinished) && (network.errorData['code'] != null) )
                    {
                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;

                        errorMessage.showErrorMessage({
                                                          "d_code":network.errorData['code'],
                                                          "d_error_type":network.errorData['error_type'],
                                                          "d_error_message":network.errorData['error_message']
                                                      });
                    }
                }
            }

    var instagramUserdata = auth.getStoredInstagramData();
    var url = "https://api.instagram.com/v1/users/" + userId + "/relationship?access_token=" + instagramUserdata["access_token"];

    req.open("GET", url, true);
    req.send();
}
