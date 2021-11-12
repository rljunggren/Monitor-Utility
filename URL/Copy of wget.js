// Javascript.  http://superuser.com/questions/25538/what-is-the-windows-equivalent-of-wget
var strURLdomain = null;

try {
	// Store command line argument.
	var strURL = WScript.Arguments(0);
	var echoSuccess = WScript.Arguments(1);
	
	var WinHttpReq = new ActiveXObject("WinHttp.WinHttpRequest.5.1");
	WinHttpReq.Open("GET", WScript.Arguments(0), /*async=*/false);
	
	// Parse web service domain and save for later.
	var n = strURL.indexOf(":8080/fp");
	strURLdomain = strURL.substring(7, n+5);

		
	// An unsuccessful connection attempt will normally throw an error on this line, 
	//	subsequent logic will not be hit.
	WinHttpReq.Send();		

	var strResponseText = WinHttpReq.ResponseText;
	if(strResponseText.indexOf("Connection successful") < 0)    
	  
	{
		throw "Not successful, possible Glassfish error...";
	}

	// Refer result back to Windows Script Host parent shell.
	if (echoSuccess == "true")
	{
		WScript.Echo(strURLdomain + " is UP.");
		//WScript.Echo(WinHttpReq.ResponseText);
	}
} 
catch (err)
{
  WScript.Echo(strURLdomain + " is DOWN. " + err.message + ".  Link: " + strURL);
  //WScript.Echo("Unsuccessful response...");
}