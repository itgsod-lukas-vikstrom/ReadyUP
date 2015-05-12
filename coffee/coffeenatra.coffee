$ ->
  $("#Members").load(location.href + " #Members")
  #getJson(document.URL + '/users.json', renderRoomusers)
  window.runs = 0

#getJson = (url, successFunction) ->
#  $.ajax
#    url: url,
#    dataType: 'json',
#    error: (jqXHR, textStatus, errorThrown) ->
#      console.log("Error #{textStatus}, #{errorThrown}")
#    success: successFunction
#
#renderRoomusers = (users) ->
#  userList = "<ul id='memberlist'>"
#  userList += ("<li><img src='#{user.avatar}'> #{user.name}</img></li>") for user in users
#  userList += ("</ul>")
#  console.log(users.length)
#  newSize = "<p id='roomsize'>#{users.length}</p>"
#  $('p#roomsize').replaceWith(newSize)
#  $('#memberlist').replaceWith(userList)

setInterval () ->
  #getJson(document.URL + '/users.json', renderRoomusers)
  window.currentusers = document.getElementById("current").innerHTML
  window.roomsize = document.getElementById("roomsize").innerHTML
  fullroom(window.runs)
  if window.currentusers != window.roomsize
    window.runs = 0
,2000

fullroom = (runs) ->
  if window.currentusers == window.roomsize && runs == 0
    document.getElementById('siren').play();
    alert("Alla är redo")
    document.getElementById('siren').pause()
    window.runs = 1
