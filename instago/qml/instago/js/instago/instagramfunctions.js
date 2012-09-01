var arrPopularImages = [];
var iCurrentIndex = 0;

function loadPopularImages(){
    console.log("Trying..")
    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                console.log("Ready state = ", req.readyState)
                if (req.readyState == XMLHttpRequest.DONE) {

                    console.log("Checking result ")
                    console.log("Status: ", req.status)
                    console.log("Response: ", req.responseText)
                    console.log("Response Length: ", req.responseText.length)

                    var jsonObject = eval('(' + req.responseText + ')');
                    for ( var index in jsonObject.data )
                    {
                        console.log("Original Object: " + jsonObject.data[index].images["thumbnail"]["url"]);
                        arrPopularImages[index] = jsonObject.data[index].images["thumbnail"]["url"];
                        console.log("New Object: " + arrPopularImages[index] + " with Index: " + index);
                    }

                    console.log("Showing image with index " + iCurrentIndex + " and name " + arrPopularImages[iCurrentIndex])
                    currentImage.source = arrPopularImages[iCurrentIndex];
                }
            }

    req.open("GET", "https://api.instagram.com/v1/media/popular?client_id=3bbd61a332384e66a46026c3dbbfaadc", true);
    req.send();
}


function nextPopularImage() {
    if (iCurrentIndex < (arrPopularImages.length-1))
    {
        iCurrentIndex += 1;
    } else {
        iCurrentIndex = 0;
    }

    console.log("Showing image with index " + iCurrentIndex + " and name " + arrPopularImages[iCurrentIndex])
    currentImage.source = arrPopularImages[iCurrentIndex];
}


function prevPopularImage() {
    if (iCurrentIndex > 0)
    {
        iCurrentIndex -= 1;
    } else {
        iCurrentIndex = (arrPopularImages.length-1);
    }

    console.log("Showing image with index " + iCurrentIndex + " and name " + arrPopularImages[iCurrentIndex])
    currentImage.source = arrPopularImages[iCurrentIndex];
}
