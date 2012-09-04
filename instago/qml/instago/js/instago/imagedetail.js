var arrPopularImages = [];
var bPopularPhotosLoaded = false;
var iCurrentIndex = 0;
var sPressedImage = "";

function showDetailImageFromGallery(imageGallery, imageIndex)
{
    arrPopularImages = imageGallery;
    iCurrentIndex = imageIndex;
    console.log("Showing image with index " + iCurrentIndex + " and name " + arrPopularImages[iCurrentIndex]["originalimage"])
    detailImage.source = arrPopularImages[iCurrentIndex]["originalimage"];
    imageCaption.text = arrPopularImages[iCurrentIndex]["caption"];
}

function nextPopularImage()
{
    if (iCurrentIndex < (arrPopularImages.length-1))
    {
        iCurrentIndex += 1;
    } else {
        iCurrentIndex = 0;
    }

    console.log("Showing image with index " + iCurrentIndex + " and name " + arrPopularImages[iCurrentIndex])
    currentImage.source = arrPopularImages[iCurrentIndex];
}


function prevPopularImage()
{
    if (iCurrentIndex > 0)
    {
        iCurrentIndex -= 1;
    } else {
        iCurrentIndex = (arrPopularImages.length-1);
    }

    console.log("Showing image with index " + iCurrentIndex + " and name " + arrPopularImages[iCurrentIndex])
    currentImage.source = arrPopularImages[iCurrentIndex];
}
