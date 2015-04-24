$(document).ready(function() {
    var table = $('#table').DataTable({
        "aoColumnDefs": [
            { 'bSortable': false, 'aTargets': [ 4 ] }
        ],
        "info": false,
        "bLengthChange": false,
        responsive: true
    });
    $('#members').DataTable({
        "aoColumnDefs": [
            { 'bSortable': false, 'aTargets': [ 4 ] }
        ],
        "info": false,
        "bLengthChange": false,
        responsive: true,
        searching: false,
        ordering: false
    });
    $('#empty, #full').click( function() {
        table.draw();
    } );

} );
// Don't show empty groups
$.fn.dataTable.ext.search.push(
    function( settings, data ) {
        var players = parseFloat(data[1]) || 0;
        if($('#empty').prop('checked')) {
            num = 1
        } else {
            num = 0
        }
        if (num <= players) {
            return true;
        }
        return false;
    }
);
//Don't show full groups
$.fn.dataTable.ext.search.push(
    function( settings, data ) {
        var players = parseFloat(data[1]) || 0;
        var all = String(data[1]) || 0;
        var max
        var last = all.split("/").pop();
        max = parseInt(last)
        if($('#full').prop('checked')) {
            num2 = max
        } else {
            num2 = -1
        }
        if (num2 == players) {
           return false;
        }
        return true;

    }
);