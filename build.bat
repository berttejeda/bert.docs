@@:: This prolog allows a PowerShell script to be embedded in a .CMD file.
@@:: Any non-PowerShell content must be preceeded by "@@"
@@setlocal
@@set POWERSHELL_BAT_ARGS=%*
@@if defined POWERSHELL_BAT_ARGS set POWERSHELL_BAT_ARGS=%POWERSHELL_BAT_ARGS:"=\"%
@@PowerShell -noprofile -Command Invoke-Expression $('$args=@(^&{$args} %POWERSHELL_BAT_ARGS%);'+[String]::Join(';',$((Get-Content '%~f0') -notmatch '^^@@'))) & goto :EOF
Set-ExecutionPolicy Bypass -Scope Process -Force
$DEFAULT_TEMPLATE = "_template/templates/default.html"
$DEFAULT_OUTPUT_FILEEXT = "hta"
$DEFAULT_HEADER = "_common/templates/header.html"
$DEFAULT_CSS = "_common/templates/default.css"
$t=1
$params=@{'--source|-s$' =  "[some/markdown/file.md,some/other/markdown/file2.md,includes/*]";
'--output|-o$' =  "[some/output/file.html]";
'--template|-t$' =  "[some/template/file.html]";
'--ppvars|-p$' =  "[some_preprocess_var=somevalue]";
'--vars|-V$' =  "[some_pandoc_var=somevalue]";
'--metavars|-m$' =  "[some_pandoc_meta_var=somevalue]";
'--watchdir|-d$' =  "[somedir]";
'--watch|-w$' =  "[somefile1.md,somefile2.html,*.txt,*.md,*.js,*.etc]";
'--interval|-i$' =  "[t>0]";
'--no-aio|-aio$' =  "No All-In-One";
'--help|-h$' =  "display usage and exit";
'--dry|-y$' =  "Dry Run";
}
FUNCTION Usage {
    WRITE-HOST "Usage: build.bat"
	FOREACH ($param in $params.Keys) { 
		"param: '{0}' help: '{1}'" -f $param,$params[$param]
	}    	 
}
$i=0 
If (-Not $($ARGS)){
	Usage
	Exit
}
ForEach ($ARG In $ARGS) {
	$ArgValue = $($ARGS[$i+1])
	ForEach ($param In $params.Keys) {
		If ($ARG -match $param){
			If (-Not $ArgValue){
				try{
					$expression = "`$$($param.substring(0,$param.lastindexOf('|')).replace('-','')) = 'True'"
				} catch {
					Write-Host "Encountered an error in processing $param`: If this is a switch, make sure it is of the form '--switch|-s'"
					Exit
				}
			} else {
				try{
					$paramvar = $($param.substring(0,$param.lastindexOf('|')).replace('-',''))
				} catch {
					"Encountered an error in processing $param`: Value provided was $ArgValue"
					Exit
				}
				$expression = "If ( `"$paramvar`" -match 'var') { `$$paramvar += '$($ArgValue)_@DELIM@_' } else { `$$paramvar = '$($ArgValue)' }"
			}
			Invoke-Expression $expression
		}
	}
	$i++
}

@@:: Show Help If Applicable
If ($help) { Usage }

If ( get-command pandoc -ErrorAction silentlycontinue ){
	$pandoc = $(get-command pandoc).Path
} ElseIf ( Test-Path "$($PWD.PATH)\pandoc.exe" ) {
	$pandoc = "$($PWD.PATH)\pandoc.exe"
}
If (get-command pp -ErrorAction silentlycontinue){
	$pp = $(get-command pp).Path
} ElseIf ( Test-Path "$($PWD.PATH)\pp.exe" ) {
	$pp = "$($PWD.PATH)\pp.exe"
}

@@:: Check for required binaries
If ( -Not (Test-Path $pandoc) -or -Not (Test-Path $pp) ) { 
	"Error: Neither pp or pandoc were not found in your path or in the current working directory"
	Exit
}

@@:: Build pre-processor commands
$pp_commands = "&$($pp) "
If ( $ppvars ) {
    $ppvars = $ppvars.replace("_@DELIM@_"," -D ")
    $pp_commands = "$($pp_commands) -D $($ppvars.Substring(0,$ppvars.Length-3)) "    
}
$pp_commands += "$source "
@@:: Build pandoc commands
$output_file = If ($output) {$output} Else {"$($source.substring(0,$source.lastindexOf("."))).$($DEFAULT_OUTPUT_FILEEXT)"}
$pandoc_commands = "$pandoc "
$pandoc_commands += "-o '$output_file' "
$css = If ($css) {$css} Else {$DEFAULT_CSS}
$pandoc_commands += "-c '$css' "
$header = If ($header) {$header} Else {$DEFAULT_HEADER}
$pandoc_commands += "-H '$header' "
$template = If ($template) {$template} Else {$DEFAULT_TEMPLATE}
$pandoc_commands += "--template $template "
If ($vars) {
	If ($vars -match "_@DELIM@_"){
		$vars = $vars.replace("_@DELIM@_"," -V ")
		$pandoc_commands += "-V $($vars.Substring(0,$vars.Length-3)) "
	} else {
		$pandoc_commands += "-V $vars "
	}
}
If ($metavars) {
	$metavars = $metavars.replace("_@DELIM@_"," --metadata ")
	$pandoc_commands += "--metadata $($metavars.Substring(0,$metavars.Length-11)) "
}

@@:: Check if we want a non-all-in-one document
If ( -Not $noaio ) {
	$pandoc_commands += "--self-contained "
	$pandoc_commands += " --standalone "
}

@@:: Echo commands if this is a Dry Run
If ($dry) {
	Write-Host "$pp_commands | $pandoc_commands"

} else {
	try{
		"Invoking build commands."
		Invoke-Expression "$pp_commands | $pandoc_commands"
		"Done. Output file is $output_file"
	} catch {
		"Failed to execute commands`:"
		"$pp_commands | $pandoc_commands"
		"Errors`:"
		$_.Exception
	}
}
