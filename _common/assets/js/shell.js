//------------------------------------------------------------------------------------------------------------------------------------------
/**
* Silently execute a powershell command. 
*/
function powershell(command_string, interactive, pause){
    start = 'start \"\"'
    if (pause == 1){
        pause = '&pause'
    } else {
        pause = ''
    }
    if (interactive == 0){
        hidden = '-w hidden -nologo'
        start = ''
    } else {
        hidden = ''
    }    
    var clipboardData_orig = window.clipboardData.getData("Text");
    window.clipboardData.setData("Text",command_string); 
    var clipboardData = window.clipboardData.getData("Text");
    console.log("Powershell command is: " + clipboardData)
    command = String.format("%comspec% /c {0} PowerShell -ExecutionPolicy Unrestricted -noprofile {1} -Command $commands=$(\"add-type -AssemblyName System.Windows.Forms;$clipboardData = [System.Windows.Forms.Clipboard]::GetText() -split '\\r\\n';[String]::Join( ';', $(  ( $clipboardData ) ))\");Invoke-Expression $commands 2>&1;{2} | clip", start, hidden, pause);
    console.log("Invoked Powershell command via: " + command)
    WshShell.run(command,0,true);
    console.log("STDOUT: " + window.clipboardData.getData("Text"));
    setTimeout(function(t){
    window.clipboardData.setData("Text",clipboardData_orig); 
    }, 2000);
    return               
}
//------------------------------------------------------------------------------------------------------------------------------------------
/**
* Silently execute a cmd shell command via intermediary script
*/
function cmd(command_string){

    // Instantiate  Windows Script Host FileSystemObject
    INTERMEDIARY_SCRIPT_NAME = '.cmd.commands.bat'
    INTERMEDIARY_SCRIPT_FILE = CWD+INTERMEDIARY_SCRIPT_NAME
    OUTPUTFILENAME = '.cmd.commands.log'
    OUTPUTFILE = CWD+OUTPUTFILENAME
    var result = "";       
    try {
        var file = FileManager.OpenTextFile(INTERMEDIARY_SCRIPT_FILE, ForWriting, true);
        file.write(command_string);
        file.Close();
        WshShell.run('%comspec% /c '+INTERMEDIARY_SCRIPT_FILE+' >> "'+OUTPUTFILE+'"',0,true);
    } catch (error) {
        // File does not exist or is empty. 
        // Just keep result as an empty string, but alert us
        alert(error)
    }
    try {
        FileManager.DeleteFile(INTERMEDIARY_SCRIPT_FILE);
    } catch (error) {}
    return result;
}
//------------------------------------------------------------------------------------------------------------------------------------------
/**
* Invoke a cmd shell
*/
function shell(exe, command_string, cmd_keep_open, cmd_new_window, program_window_style, wait_for_exit){
    // exe = WshShell.ExpandEnvironmentStrings(exe)
    if (command_string == null && cmd_keep_open != "/k"){
        console.log(String.format('Skipped invocation for {0}: command String is null, yet data-cmd-keep-open is not set to /k', exe))
        return
    }
    command = String.format("{0} {1} {2} {3}", exe, cmd_keep_open, cmd_new_window, command_string) // e.g. cmd /c "" "" echo hello or cmd /c start "" echo hello
    try {
        console.log("Invoked shell as per " + command)
        console.log(String.format("Line in code is: WshShell.exec('{0}')",command))
        if (WshShell != null) {
            r = WshShell.exec(command)
            console.log("Reading STDOUT ...")
            var OutStream = r.StdOut;
            var StdOut = '""';
            while (!OutStream.atEndOfStream) {
            StdOut = StdOut + OutStream.readAll();
            } 
            console.log("StdOut: \n " + StdOut)
            return true
        }
    } catch (error) {
        alert(error)
        return false
    }

}
//------------------------------------------------------------------------------------------------------------------------------------------    


