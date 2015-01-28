$ ->
  CountDownTimer "19:25", "countdown"

CountDownTimer = (time, id) ->
  selector = document.getElementById(id)
  end = new Date("01/29/2015 #{time}" )
  _second = 1000
  _minute = _second * 60
  _hour = _minute * 60
  _day = _hour * 24
  showRemaining = ->
    now = new Date()
    distance = end - now
    if distance <= 0
      clearInterval timer
     # post('/remove_checkin', {id: '1'});
      return
    hours = Math.floor((distance % _day) / _hour)
    minutes = Math.floor((distance % _hour) / _minute)
    #seconds = Math.floor((distance % _minute) / _second)
    if minutes < 10
      minutes = "0" + minutes
    selector.innerHTML = ("#{hours}:#{minutes}");
  timer = setInterval showRemaining, 1000

post = (path, params, method) ->
  method = method or "post" # Set method to post by default if not specified.
  form = document.createElement("form")
  form.setAttribute "method", method
  form.setAttribute "action", path
  for key of params
    if params.hasOwnProperty(key)
      hiddenField = document.createElement("input")
      hiddenField.setAttribute "type", "hidden"
      hiddenField.setAttribute "name", key
      hiddenField.setAttribute "value", params[key]
      form.appendChild hiddenField
  document.body.appendChild form
  form.submit()
  return
