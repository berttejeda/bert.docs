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
    // Instantiate  Windows Script Host FileSystemObject
    INTERMEDIARY_SCRIPT_NAME = '.powershell.commands.bat'
    INTERMEDIARY_SCRIPT_FILE = CWD+INTERMEDIARY_SCRIPT_NAME
    OUTPUTFILENAME = '.powershell.commands.log'
    OUTPUTFILE = CWD+OUTPUTFILENAME
    var result = "";
    var clipboardData_orig = window.clipboardData.getData("Text");
    window.clipboardData.setData("Text",command_string); 
    var clipboardData = window.clipboardData.getData("Text");
    console.log("Powershell command is: " + clipboardData)
    command = String.format("%comspec% /c {0} PowerShell -noprofile {1} -Command $commands=$(\"Set-ExecutionPolicy Bypass -Scope Process -Force;add-type -AssemblyName System.Windows.Forms;$clipboardData = [System.Windows.Forms.Clipboard]::GetText() -split '\\r\\n';[String]::Join( ';', $(  ( $clipboardData ) ))\");Invoke-Expression $commands 2>&1;{2} | clip", start, hidden, pause);
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
function shell(exe, params, command_string, start){
    start = (start == 1) ? 'start \"\"':''
    if (exe == 'powershell'){
        command = '%comspec% /c powershell ' + command_string
    } else if (exe == 'cmd'){    
        command = '%comspec% /k ' + command_string
    } else {
        exe = WshShell.ExpandEnvironmentStrings(exe)
        if (FileManager.FileExists(exe)) {
        command = String.format("{0} {1} {2} {3}", exe, params, command_string, start)
        } else {
            alert(String.format("Expected path {0} not found", exe))
            return
        }
    }
    try {
        console.log(String.format("Invoked shell as per:\nexe: {0}\nparams:{1}\ncommand_string: {2}\nstart: {3}", exe, params, command_string, start))
        WshShell.run(command)
        return false
    } catch (error) {
        alert(error)
        return false
    }

}
//------------------------------------------------------------------------------------------------------------------------------------------    


