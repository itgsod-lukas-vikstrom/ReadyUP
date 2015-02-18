$(document).ready(function() {
    var table = $('#table').DataTable({
        "info": false,
        "bLengthChange": false
    });
    $('#empty').click( function() {
        table.draw();
    } );
} );
$.fn.dataTable.ext.search.push(
    function( settings, data ) {
        var players = parseFloat(data[1]) || 0;
        if($('#empty').prop('checked')) {
            num = 1
        } else {
            num = 0
        }
        var min = parseInt( $('#min').val(), 10 );
        if (isNaN(num) ||
            num <= players) {
            return true;
        }
        return false;
    }
);
