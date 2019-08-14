(function($){
        $('.child').change(function(){
        // create var for parent .checkall and group
        var group = $(this).data('group'),
            checkall = $('.selectall[data-group="'+group+'"]');
    
        // do we have some checked? Some unchecked? Store as boolean variables
        var someChecked = $('.child[data-group="'+group+'"]:checkbox:checked').length > 0;
        var someUnchecked = $('.child[data-group="'+group+'"]:checkbox:not(:checked)').length > 0;
    
        // if we have some checked and unchecked, set .checkall, of the correct group, to indeterminate. 
        // If all are checked, set .checkall to checked
        checkall.prop("indeterminate", someChecked && someUnchecked);
        checkall.prop("checked", someChecked || !someUnchecked);
               
    // fire change() when this loads to ensure states are updated on page load
    }).change();
    
    // clicking .checkall will check all children in the same group.
    $('.selectall').click(function() {
        var group = $(this).data('group');
        $('.child[data-group="'+group+'"]').prop('checked', this.checked).change(); 
    });
}(window.jQuery));

function install () {
    var strConstCancel = "You have chosen to cancel.";
    var strPathHistory = "c:\\history"
    var strPathSSO = "\\\\lvh.com\\distrib\$\\sw\\sso\\v8.0\\sso80_81svr.exe";
    var strPathLWCE = "\\\\lvh.com\\distrib\$\\sw\\lcj\\lcj_webframework33.exe";
    var strPathMSO2K3 = "\\\\lvh.com\\microsoftapps$\\sw\\msoff2003pro\\install office 2003 full.cmd";
    var strPathMSOUT2K7 = "\\\\lvh.com\\microsoftapps$\\SW\\MSOfficeEnterprise2007\\Outlook2007.EXE";
    var strPathTSYS = "\\\\lvh.com\\distrib$\\sw\\tsystem 3\\tsystem3.exe";
    var strSemiforeMV = "metavision_icu.@!@"
    var strPathKIX = "\\\\lvh.com\\sysvol\\lvh.com\\scripts\\kix32.exe";
    $("input:checked").each(function() {
        var command_string=this.getAttribute('data-cmd-command')
        var cmd_keep_open=this.getAttribute('data-cmd-keep-open')
        var cmd_new_window=this.getAttribute('data-cmd-new-window')
        var program_window_style=this.getAttribute('data-window-style')
        var wait_for_exit=this.getAttribute('data-wait')
        cmd_keep_open = (cmd_keep_open == 1) ? '/k':'/c'
        cmd_new_window = (cmd_new_window == 1) ? 'start \"\"':''
        // Specify WScript.Shell .Run parameters
        // Read more: .Run - VBScript - SS64.com
        // https://ss64.com/vb/run.html
        program_window_style = (program_window_style != null) ? program_window_style:1
        wait_for_exit = (wait_for_exit == 1) ? true:false
        shell('%comspec%', command_string, cmd_keep_open, cmd_new_window, program_window_style, wait_for_exit)
    }
    );
    alert("Installation tasks finished!");
}