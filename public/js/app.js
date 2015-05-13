$(function(){
    ws = new WebSocket("ws://0.0.0.0:2000");
    ws.onmessage = function(evt) {
        console.log(evt.data)
        if( evt.data.indexOf('Checked') >= 0){
            console.log('Refreshed members')
            $("table#titletable").load(location.href + " table#titletable");
            $("table#members").load(location.href + " table#members");

        }
        if ($('#chat tbody tr:last').length > 0){
            $('#chat tbody tr:last').after('<tr><td>' + evt.data + '</td></tr>');
            $('#chatmessages').scrollTop($('#chatmessages')[0].scrollHeight);
        } else {
            $('#chat tbody').append('<tr><td>' + evt.data + '</td></tr>');
        }
    };

  /*  ws.onclose = function() {

    };

    ws.onopen = function() {


    };*/


    $("form.form-stacked").submit(function(e) {
        if($("#msg").val().length > 0){
            ws.send($("#msg").val());
            $("#msg").val("");
        }
        return false;
    });

    $("#clear").click( function() {
        $('#chat tbody tr').remove();

    });

});
/*
window.addEventListener("beforeunload", function (e) {

    var confirmationMessage = 'Leaving this page will uncheck you from the room';


    (e || window.event).returnValue = confirmationMessage; //Gecko + IE
    return confirmationMessage; //Gecko + Webkit, Safari, Chrome etc.
});*/
