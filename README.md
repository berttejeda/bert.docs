<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Interactive HTA Documents - Powershell et, al](#interactive-hta-documents---powershell-et-al)
- [Why?](#why)
- [Implementation](#implementation)
- [Requirements](#requirements)
- [Features](#features)
- [How to use](#how-to-use)
  - [Example1: Build an HTA application from a markdown file](#example1-build-an-hta-application-from-a-markdown-file)
  - [Example2: Build an HTML file from the markdown file](#example2-build-an-html-file-from-the-markdown-file)
  - [Example3: Add powershell to your document](#example3-add-powershell-to-your-document)
  - [Example4: Invoke a cmd shell from your document](#example4-invoke-a-cmd-shell-from-your-document)
- [Appendix](#appendix)
  - [Under the hood](#under-the-hood)
    - [Powershell Invocation](#powershell-invocation)
  - [Troubleshooting](#troubleshooting)
  - [Sources](#sources)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Interactive HTA Documents - Powershell et, al
===================

# Why?

I needed a means of producing documents on the Windows platform that could better engage the reader and perform some advanced actions such as interacting with the system.

I used the boilerplate from this repo [BlackrockDigital/startbootstrap-simple-sidebar](https://github.com/BlackrockDigital/startbootstrap-simple-sidebar) to create the basis for the interactive document.

The layout is clean, and I managed to tweak it to my liking: check it out:

![screenshot](_common/assets/images/screenshot.png)

# Implementation

Here's how I accomplished my goal:

- [markdown](https://guides.github.com/features/mastering-markdown/) for easy content creation, see [default.markdown](_template/default.markdown)
- [pandoc](https://pandoc.org/installing.html) for content rendering, and for creating the single, self-contained output 
- markdown pre-processing with [pp](https://github.com/CDSoft/pp)
- [javascript ActiveX Objects](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Microsoft_JavaScript_extensions/ActiveXObject) for interaction with the Windows OS
	- `powershell` code can be embedded directly in your markdown and/or templates, enclosed in html comment tags<br /> ```<!-- -->```
	- The same goes for `cmd` commands (although not as elegantly)
- [cmder](http://cmder.net/) for making the Windows commandline so much sweeter

# Requirements

* optional:
    - **python 2.7+** (only if you plan on installing the pandoc python module, i.e. `pip install pandoc`)
    - [cmder](http://cmder.net/)(the *full* version is best, as it ships with git-bash)
* mandatory:
    - [pandoc](https://pandoc.org/installing.html)
    - [pp](https://github.com/CDSoft/pp) (Pre-compiled [binaries](https://github.com/CDSoft/pp#installation) available for Windows and Linux)

# Features

The [build.sh](build.sh)/[build.bat](build.bat) pandoc/pp wrapper scripts output a single .hta file as per specification.

The file is completely self-contained, with assets embedded as base64 objects.

I've incorporated [HTAConsole](https://github.com/jeremyben/HTAConsole) into the source, which makes it substantially easier to troubleshoot bugs.

Simply press **F12** to display the console. I use this feature throughout the codebase for printing helpful information to the console.

e.g. `console.log('some message')`

I plan on extending overall functionality to allow for wider integration of programming languages.

# How to use

If you're on Windows, you should be able to install the project reqiurements using the [bootstrap.bat](bootstrap.bat) script.

This will install `chocolatey`, `pp`, and `pandoc` on your system. It requires the `7z` command, so it'll install that as well.

The wrapper scripts [build.sh](build.sh) or [build.bat](build.bat) should help get you started with using this project.

```bash
Usage: ./build.sh/build.bat
param: --watchdir|-wd$, help: [somedir]
param: --interval|-i$, help: [t>0]
param: --vars|-V$, help: [some_pandoc_var=somevalue]
param: --source|-s$, help: [some/markdown/file.md,some/other/markdown/file2.md,includes/*]
param: --dry, help: Dry Run
param: --output|-o$, help: [some/output/file.html]
param: --watch|-w$, help: [somefile1.md,somefile2.html,*.txt,*.md,*.js,*.etc]
param: --ppvars|-p$, help: [some_preprocess_var=somevalue]
param: --help|-h$, help: display usage and exit
param: --no-aio|-aio$, help: No All-In-One
param: --template|-t$, help: [some/template/file.html]
param: --metavars|-m$, help: [some_pandoc_meta_var=somevalue]
```

Note: Although the same parameters are available to `build.bat`, I have not yet implemented the filewatcher functionality as is present in the bash equivalent.

## Example1: Build an HTA application from a markdown file

- Invoke the build script from commandline:
    - From `cmder`/`git-bash`:
        - bash script:
            - `./build.sh -s _template/default.markdown -o default.hta -t _template/templates/default.html`
        - powershell script:
            - `./build.bat -s _template\\default.markdown -o default.hta -t _template\\templates\\default.html`
	- From `powershell`:
        - `&.\build.bat -s .\_template\default.markdown -o default.hta -t .\_template\templates\default.html`
    - To issue a dry run, simply include the `--dry` flag when you call the build script
    	- Invoking any of the commands above with the `--dry` flag will display something similar to:<br />
    		`pp _template/default.markdown | pandoc -o 'default.hta' -c '_common/templates/default.css' -H '_common/templates/header.html' --template _template/templates/default.html --self-contained --standalone`
    - I've incorporated a poor man's filewatcher into the bash script which utilizes the `find` command to monitor file changes and trigger a rebuild based on specified parameters, e.g.
    	- `./build.sh -s _template/default.markdown -o default.hta -t _template/templates/default.html -w *.md,*.js,*.css,*.html -i 5`
- Invoke the build script from the hta:
    - Just click the `Rebuild` button located in the top navigation bar.<br />
    This will invoke the powershell build script so long as it is located in the same directory as the HTA<br />
    Press F5 to refresh the HTA application

## Example2: Build an HTML file from the markdown file

- Invoke the same build script from [Example1](#example1-build-an-hta-application-from-a-markdown-file), with just one difference:
    `-o default.html`

## Example3: Add powershell to your document

- Add some powershell to the [default.markdown](_template/default.markdown):

```powershell
<a href="#" id="testing" class="powershell">CLICKME: PowerShell
<!--         
Write-Host 'You executed PowerShell!'
&pause
-->
</a> 
```

As illustrated, you must enclose your commands/includes in comment tags ```<!-- -->```

Do the same, this time with a non-interactive shell session:

```powershell
<a href="#" id="testing" class="powershell" data-interactive="0">CLICKME: POWERSHELL
<!--         
'You executed powershell!'
-->
</a> 
```

- Again, but using the `!include` macro:

```html
<a href="#" id="include" class="powershell" data-interactive="0">CLICKME: PowerShell
<!--         
!include(src/include.ps1)
-->
</a>
```

Once the HTA file is rebuilt, you can refresh the HTA application by pressing F5. Your changes should have been rendered.

Again, you can access the javascript console by pressing **F12**.

You can review the STDOUT of non-interactive powershell command.

## Example4: Invoke a cmd shell from your document

- Add a link with class 'shell' to the [default.markdown](_template/default.markdown):
```cmd
<a href="#" class="shell" data-shell="cmd">Start cmd!</a>
```

Once the HTA file is rebuilt, you can refresh the HTA application by pressing F5. Your changes should have been rendered.

# Appendix

## Under the hood

### Powershell Invocation

The powershell invocation is done through a WScript.Shell ActiveX Object and clever Windows clipboard manipulation, 
so there is no need for intermediary scripts to handle the powershell code.

From [shell.js](_common/assets/js/shell.js):

```javascript
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
    command = String.format("%comspec% /c {0} PowerShell -noprofile {1} -Command $commands=$(\"Set-ExecutionPolicy Bypass -Scope Process -Force;add-type -AssemblyName System.Windows.Forms;$clipboardData = [System.Windows.Forms.Clipboard]::GetText() -split '\\r\\n';[String]::Join( ';', $(  ( $clipboardData ) ))\");Invoke-Expression $commands 2>&1;{2} | clip", start, hidden, pause);
    console.log("Invoked Powershell command via: " + command)
    WshShell.run(command,0,true);
    console.log("STDOUT: " + window.clipboardData.getData("Text"));
    setTimeout(function(t){
    window.clipboardData.setData("Text",clipboardData_orig); 
    }, 2000);
    return               
}
```

The WshShell ActiveX Object is instantiated in [default.html](_template/templates/default.html).

This is the jquery for handling hyperlinks with class 'powershell'

```javascript
/**
* For all html links (a) with class 'powershell' invoke the powershell command encased in comment strings <!--POWERSHELLCODE-->
*/
$( "a.powershell" ).click(function() {
var command_string = ''
var test = this.innerHTML.match(/<!--[\s\S]*-->/)
if (test != null){
    var regex = /<!--|-->/gi;
    command_string = test[0].replace(regex,'')
}else {
    command_string = heredoc(function () {/*
    'You must specify powershell commands for this link by encasing these in comment strings'
        'e.g.'
        '<a href="#" class="powershell">'
        '<!--'
            'Hello World!'
        '-->'
        '</a>'
        &pause
    */}); 
    alert(command_string)   
    return
}
var pause=this.getAttribute('data-pause')
if (pause != 1){
    pause = 0
}
var interactive=this.getAttribute('data-interactive')
if (interactive != 0){
    interactive = 1
}
powershell(command_string, interactive, pause);
}); 
```

see [ui.js](_common/assets/js/ui.js):

Note the use of custom 'data-*' html attributes, keeping in compliance at least with HTML5.

## Troubleshooting

If you encounter errors in your document(s), try building with the `--no-aio/-a` flag, as with:

- `./build.sh -s _template/default.markdown -o default.hta -t _template/templates/default.html --no-aio`

This will invoke the `pandoc` command without the `--standalone` and `--self-contained` flags, which results in a document that offers itself more willingly to inspection.

Happy debugging :)

## Sources

- [BlackrockDigital/startbootstrap-simple-sidebar](https://github.com/BlackrockDigital/startbootstrap-simple-sidebar): An off canvas sidebar navigation Bootstrap HTML template created by Start Bootstrap
- [jeremyben/HTAConsole](https://github.com/jeremyben/HTAConsole): HTA Console is a basic but practical Javascript Console Log to help debugging HTML Applications.
- [stack overflow - Get String in YYYYMMDD format from JS date object?](https://stackoverflow.com/questions/3066586/get-string-in-yyyymmdd-format-from-js-date-object)
- [stack overflow - Javascript heredoc - Stack Overflow](https://stackoverflow.com/questions/4376431/javascript-heredoc)
- [stack overflow - jquery - JavaScript sleep/wait before continuing - Stack Overflow](https://stackoverflow.com/questions/16873323/javascript-sleep-wait-before-continuing)
- [All You Need to Know About the HTML5 Data Attribute](https://webdesign.tutsplus.com/tutorials/all-you-need-to-know-about-the-html5-data-attribute--webdesign-9642)
- [ stack overflow - JavaScript equivalent to printf/String.Format - Stack Overflow](https://stackoverflow.com/questions/610406/javascript-equivalent-to-printf-string-format)
