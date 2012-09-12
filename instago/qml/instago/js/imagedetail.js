var arrPopularImages = [];
var iCurrentIndex = 0;


function showDetailImageFromGallery(imageGallery, imageIndex)
{
    arrPopularImages = imageGallery;
    iCurrentIndex = imageIndex;
//    console.log("Showing image with index " + iCurrentIndex + " and name " + arrPopularImages[iCurrentIndex]["originalimage"])

    // fill image components
    detailImage.source = arrPopularImages[iCurrentIndex]["originalimage"];
    userprofilePicture.source = arrPopularImages[iCurrentIndex]["profilepicture"];

    // fill text components
    userprofileUsername.text = arrPopularImages[iCurrentIndex]["username"];
    userprofileCreatedtime.text = arrPopularImages[iCurrentIndex]["createdtime"];
    userprofileUserID.text = arrPopularImages[iCurrentIndex]["userid"];
    metadataLikes.text = arrPopularImages[iCurrentIndex]["likes"] + " like this";
    metadataImageCaption.text = arrPopularImages[iCurrentIndex]["username"] + ": " + arrPopularImages[iCurrentIndex]["caption"];
    metadataInstagramURL.text = arrPopularImages[iCurrentIndex]["linktoinstagram"];

    // this is magic: since metadataImageCaption.height gives me garbage I calculate the height by multiplying the number of lines with the line height
    metadataImageCaption.height = Math.floor(((metadataImageCaption.text.length / 42) + (metadataImageCaption.text.split("\n").length - 1)) * 24 );
    // console.log("Lines: " + metadataImageCaption.lineCount + "und height: " + metadataImageCaption.lineHeight + " = " + metadataImageCaption.lineCount / metadataImageCaption.lineHeight);

    // this is fed to the flickable container as content height
    contentFlickableContainer.contentHeight = (userprofileContainer.height + detailImageContainer.height + 100 + metadataImageCaption.height);
    // console.log("total: " + contentFlickableContainer.contentHeight + " userprofile: " + userprofileContainer.height + " detailimage: " + detailImageContainer.height + " +100 and caption: " + metadataImageCaption.height);
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
