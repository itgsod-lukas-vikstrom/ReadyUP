$ ->
  $("#Members").load(location.href + " #Members")
  window.runs = 0
#CountDownTimer hund.innerHTML, "countdown"

  #setInterval 'autoRefresh_div', 5000


###CountDownTimer = (time, id) ->
  selector = document.getElementById(id)
  end = new Date("02/02/2015 #{time}" )
  _second = 1000
  _minute = _second * 60
  _hour = _minute * 60
  _day = _hour * 24
  showRemaining = ->
    now = new Date()
    distance = end - now
    if distance <= 0
      clearInterval timer
      alert 'Alla är redo'
      return
    hours = Math.floor((distance % _day) / _hour)
    minutes = Math.floor((distance % _hour) / _minute)
    seconds = Math.floor((distance % _minute) / _second)
    if minutes < 10
      minutes = "0" + minutes
    selector.innerHTML = ("#{hours}:#{minutes}:#{seconds}");
  timer = setInterval showRemaining, 1000###

setInterval () ->
  $("#Members").load(location.href + " #Members")
  console.log('reloaded')
  window.currentusers = document.getElementById("current").innerHTML
  window.roomsize = document.getElementById("roomsize").innerHTML
  fullroom(window.runs)
  if windows.currentusers != window.roomsize
    window.runs = 0

,2000

fullroom = (runs) ->
  if window.currentusers == window.roomsize && runs == 0
    alert("Alla är redo")
    window.runs = 1
  console.log("hej")
#setInterval 'autoRefresh()', 5000

#Popup = (name, time) ->
 # alert 'Name = ' + name + ' URL = ' + url
 # return