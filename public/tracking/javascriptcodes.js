<!-- Codes by Quackit.com -->
<html>
<head>
<script type="text/JavaScript">
<!--
function timedRefresh(timeoutPeriod) {
	setTimeout("location.reload(true);",timeoutPeriod);
}
//   -->
</script>
</head>
<body onload="JavaScript:timedRefresh(5000);">
<p>This page will refresh every 5 seconds. This is because we're using the 'onload' event to call our function. We are passing in the value '5000', which equals 5 seconds.</p>
<p>But hey, try not to annoy your users too much with unnecessary page refreshes every few seconds!</p>
</body>
</html>


setInterval ( expression, interval );



you can use split method. for example, if the content of file is on
fileContent variable then you can simply use:

fileLines=fileContent.split("\n")

first line will be:
fileLines[0]

second:
fileLines[1]

third:
fileLines[2]

.....

and the number of lines:
fileLines.length



var txtFile = new XMLHttpRequest();
txtFile.open("GET", "http://my.remote.url/myremotefile.txt", true);
txtFile.onreadystatechange = function() {
  if (txtFile.readyState === 4) {  // Makes sure the document is ready to parse.
    if (txtFile.status === 200) {  // Makes sure it's found the file.
      allText = txtFile.responseText; 
      lines = txtFile.responseText.split("\n"); // Will separate each line into an array
    }
  }
}
txtFile.send(null);