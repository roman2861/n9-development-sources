// *************************************************** //
// Comments Script
//
// This script handles the adding / removal of comments
// for a given image.
// Note that only authenticated users can comment images.
// It's used by the ImageDetailPage, UserFeedPage
// and ImageCommentPage.
// *************************************************** //


// include other scripts used here
Qt.include("authenticationhandler.js");
Qt.include("networkhandler.js");


// get all comments for a given image
// comments will be used to fill a UserList component
function getCommentsForImage(imageId)
{
    // console.log("Getting comments for image " + imageId);

    loadingIndicator.running = true;
    loadingIndicator.visible = true;

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // this handles the result for each ready state
                var jsonObject = network.handleHttpResult(req);

                // jsonObject contains either false or the http result as object
                if (jsonObject)
                {
                    imageComments.clearList();

                    var commentCache = new Array();
                    for ( var index in jsonObject.data )
                    {
                        commentCache = [];

                        commentCache["username"] = jsonObject.data[index].from["username"];
                        commentCache["fullname"] = jsonObject.data[index].from["full_name"];
                        if (commentCache["fullname"] === "") commentCache["fullname"] = commentCache["username"];
                        commentCache["profilepicture"] = jsonObject.data[index].from["profile_picture"];
                        commentCache["userid"] = jsonObject.data[index].from["id"];
                        commentCache["comment"] = jsonObject.data[index].text;

                        imageComments.addToList({
                                                    "d_username": commentCache["username"],
                                                    "d_fullname": commentCache["fullname"],
                                                    "d_profilepicture": commentCache["profilepicture"],
                                                    "d_userid": commentCache["userid"],
                                                    "d_comment": commentCache["comment"],
                                                    "d_index": index
                                                });
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;

                    // console.log("Done loading like list");
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
    var url = instagramAPIUrl + "/v1/media/" + imageId + "/comments/?access_token=" + instagramUserdata["access_token"];

    req.open("GET", url, true);
    req.send();
}
