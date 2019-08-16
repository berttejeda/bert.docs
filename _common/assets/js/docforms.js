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
    // Check if elevated
    var exec = WshShell.Exec("cacls %SYSTEMROOT%\\system32\\config");
    var result = exec.StdOut.ReadAll();
    var is_admin = (result.indexOf("denied")!=-1);
    if (is_admin){
        alert("This function requires elevated privileges, relaunching ...");
        run_as_admin()
    }
    $("input:checked").each(function() {
        var command_string=$(this).data('cmdCommand')
        var cmd_keep_open=$(this).data('cmdKeepOpen')
        var cmd_new_window=$(this).data('cmdNewWindow')
        var program_window_style=$(this).data('windowStyle')
        var wait_for_exit=$(this).data('wait')
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