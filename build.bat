@@:: This prolog allows a PowerShell script to be embedded in a .CMD file.
@@:: Any non-PowerShell content must be preceeded by "@@"
@@setlocal
@@set POWERSHELL_BAT_ARGS=%*
@@if defined POWERSHELL_BAT_ARGS set POWERSHELL_BAT_ARGS=%POWERSHELL_BAT_ARGS:"=\"%
@@PowerShell -noprofile -Command Invoke-Expression $('$args=@(^&{$args} %POWERSHELL_BAT_ARGS%);'+[String]::Join(';',$((Get-Content '%~f0') -notmatch '^^@@'))) & pause & goto :EOF
Set-ExecutionPolicy Bypass -Scope Process -Force
$PREFIX = "eval"
$DEFAULT_TEMPLATE = "_template/templates/default.html"
$DEFAULT_HEADER = "_common/templates/header.html"
$DEFAULT_CSS = "_common/templates/default.css"
$t=1
$params=@{'--source|-s$' =  "[some/markdown/file.md,some/other/markdown/file2.md,includes/*]";
'--output|-o$' =  "[some/output/file.html]";
'--template|-t$' =  "[some/template/file.html]";
'--ppvars|-p$' =  "[some_preprocess_var=somevalue]";
'--help|-h$' =  "display usage and exit";
'--vars|-V$' =  "[some_pandoc_var=somevalue]";
'--metavars|-m$' =  "[some_pandoc_meta_var=somevalue]";
'--watchdir|-d$' =  "[somedir]";
'--watch|-w$' =  "[somefile1.md,somefile2.html,*.txt,*.md,*.js,*.etc]";
'--interval|-i$' =  "[t>0]";
'--dry' =  "Dry Run";
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
}
ForEach ($ARG In $ARGS) {
	ForEach ($param In $params.Keys) {
		If ($ARG -match $param){
			If (-Not $($ARGS[$i+1])){
				$expression = "`$$($param.substring(0,$param.lastindexOf('|')).replace('-','')) = 'True'"
			} else {
				$expression = "`$$($param.substring(0,$param.lastindexOf('|')).replace('-','')) = '$($ARGS[$i+1])'"
			}
			Invoke-Expression $expression
		}
	}
	$i++
}
If ($help){Usage}

