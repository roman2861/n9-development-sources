// *************************************************** //
// Locations Script
//
// This script handles the location based data for a
// given image.
// Note that only authenticated users can request
// location based data.
// It's used by the ImageDetailPage and UserFeedPage.
// *************************************************** //


// include other scripts used here
Qt.include("authenticationhandler.js");
Qt.include("helpermethods.js");
Qt.include("networkhandler.js");


// get location based data for a given location id
// data will be used to fill the location detail page
function getLocationData(locationId)
{
    console.log("Getting location data for id: " + locationId);

    errorMessage.visible = false;
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

                    var imageCache = new Array();
                    var locationLatitude = "";
                    var locationLongitude = "";
                    var locationHeadline = "";

                    for ( var index in jsonObject.data )
                    {
                        // get image object
                        imageCache = getImageDataFromObject(jsonObject.data[index]);

                        // add image object to gallery list
                        locationGallery.addToGallery({
                                                            "url":imageCache["thumbnail"],
                                                            "index":imageCache["imageid"]
                                                        });

                        locationLatitude = imageCache["locationLatitude"];
                        locationLongitude = imageCache["locationLongitude"];
                        locationHeadline = imageCache["location"];

                        // console.log("Appended list with URL: " + imageCache["thumbnail"] + " and ID: " + imageCache["imageid"]);
                    }

                    locationCenter.position.coordinate.latitude = locationLatitude;
                    locationCenter.position.coordinate.longitude = locationLongitude;
                    locationMap.center = locationCenter.position.coordinate;
                    locationName.text = locationHeadline;

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    locationMetadata.visible = true;
                    locationGallery.visible = true;

                    console.log("Done loading location data");
                }
                else
                {
                    // either the request is not done yet or an error occured
                    // check for both and act accordingly
                    if ( (network.requestIsFinished) && (network.errorData['code'] != null) )
                    {
                        // console.log("error found: " + network.errorData['error_message']);

                        // hide messages and notifications
                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;

                        // show the stored error
                        errorMessage.showErrorMessage({
                                                          "d_code":network.errorData['code'],
                                                          "d_error_type":network.errorData['error_type'],
                                                          "d_error_message":network.errorData['error_message']
                                                      });

                        // clear error message objects again
                        network.clearErrors();
                    }
                }
            }

    var instagramUserdata = auth.getStoredInstagramData();
    var url = instagramkeys.instagramAPIUrl + "/v1/locations/" + locationId + "/media/recent?access_token=" + instagramUserdata["access_token"];

    console.log(url);

    req.open("GET", url, true);
    req.send();
}
