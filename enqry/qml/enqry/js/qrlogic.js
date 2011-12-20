WorkerScript.onMessage = function(message) {
    var postData = "";

    xmlhttp = new XMLHttpRequest();
    xmlhttp.open("POST", message.url, true);
    console.log("Posting to " + message.url)
    xmlhttp.setRequestHeader('Content-Type', 'multipart/form-data')
    xmlhttp.send(postData)

    xmlhttp.onreadystatechange=function() {
      if (xmlhttp.readyState==4) {
        WorkerScript.sendMessage( {response: xmlhttp.responseText} );
      }
    }
    xmlhttp.send(null)
}
