<!DOCTYPE html>
<html>
<head>
    <HTA:APPLICATION
    ID="LAB-LOADER.$VERSION_STRING$"
    APPLICATIONNAME="LAB LOADER"
    CAPTION="Yes"
    BORDER="thick"
    ICON="magnify.exe"
    SHOWINTASKBAR="Yes"
    SYSMENU=""
    WINDOWSTATE="maximize"
    VERSION="$VERSION_STRING$"
    INNERBORDER="No"
    SELECTION="Yes"
    MAXIMIZEBUTTON="yes"
    MINIMIZEBUTTON="yes"
    NAVIGABLE="Yes"
    CONTEXTMENU=""
    BORDERSTYLE=""
    SCROLL="Yes"
    SCROLLFLAT="No"
    SINGLEINSTANCE="Yes"
    >    
    <script type="text/javascript">
    var WshShell = new ActiveXObject("WScript.Shell");
    // Check if elevated
    var exec = WshShell.Exec("cacls %SYSTEMROOT%\\system32\\config");
    var result = exec.StdOut.ReadAll();
    var is_admin = (result.indexOf("denied")!=-1);
    if (is_admin){
        r = confirm("This loader requires elevated privileges, Press OK to Relaunch or Cancel to end operation ...");
        if (r == true) {
          var hta_path = window.document.location.pathname;      
          var objShell = new ActiveXObject("Shell.Application");
          objShell.ShellExecute("C:\\Windows\\System32\\mshta.exe", hta_path, '', 'runas', 1)
          self.close()
        } else {
          self.close()
        }        
    }    
    </script>      
    <script type="text/JScript">
      onload = function() {
      // Instantiate WinHttp object for executing HTTP requests
      var WinHttpReq = new ActiveXObject("WinHttp.WinHttpRequest.5.1");
      var method = 'GET'
      var uri = '$LAB_URI$'
      var uri_fallback = '$LAB_URI_FALLBACK$'
      // If we're behind a firewall or proxy, 
      // the 'catch' in the below try/catch block will most likely get triggered
      try {
          var WinHttpRequestOption_EnableRedirects = 6;
          WinHttpReq.SetTimeouts(1000, 1000, 1000, 1000);
          WinHttpReq.option(WinHttpRequestOption_EnableRedirects) = false;
          WinHttpReq.Open(method, uri, false);
          WinHttpReq.SetRequestHeader("User-Agent", "Mozilla/4.0 (compatible; MyApp 1.0; Windows NT 5.1)");
          WinHttpReq.Send();
          if(WinHttpReq.status === 200){
              document.location.replace(uri)
          } else {
              document.location.replace(uri_fallback)
          } 
      } catch (e) {
          // Stubbornly try to load the uri Anway, but only if it didn't timeout
          var timed_out = (e.description.indexOf("timed")!=-1);
          if (timed_out){
            document.location.replace(uri_fallback)
          } else{
            document.location.replace(uri)
          }
      }
      }
    </script>
</head>
<body>
ATTEMPTING TO LOAD DOCUMENT ...  
</body>
</html>