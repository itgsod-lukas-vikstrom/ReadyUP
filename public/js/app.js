$(function(){
  ws = new WebSocket("ws://0.0.0.0:2000");
  ws.onmessage = function(evt) {
    if ($('#chat tbody tr:last').length > 0){
      $('#chat tbody tr:last').after('<tr><td>' + evt.data + '</td></tr>');
      $('#chatmessages').scrollTop($('#chatmessages')[0].scrollHeight);
    } else {
      $('#chat tbody').append('<tr><td>' + evt.data + '</td></tr>');
    }
  };

  ws.onclose = function() {
    ws.send("Leaves the chat");
  };

  ws.onopen = function() {
    //ws.send($("#server").val());
  };


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