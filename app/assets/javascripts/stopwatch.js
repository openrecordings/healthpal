var stopwatch = $("#stopwatch")
if (stopwatch.length > 0) {
  var seconds = 0, minutes = 0, hours = 0,
      t = null, start_time;

  function set_time(seconds) {
    hours = Math.floor(seconds / 60 / 60);
    minutes = Math.floor(seconds / 60) % 60
    seconds = seconds % 60
    
    $(stopwatch).html((hours ? (hours > 9 ? hours : "0" + hours) : "00") + ":" +
                      (minutes ? (minutes > 9 ? minutes : "0" + minutes) : "00") + ":" +
                      (seconds > 9 ? seconds : "0" + seconds));
  }
  
  function tick() {
    set_time(Math.floor(((new Date()).getTime() - start_time)/1000));
    t = setTimeout(tick, 1000);
  }

  function reset_stopwatch() {
    start_time = (new Date()).getTime();
    set_time(0);
  }

  function start_stopwatch() {
    stop_stopwatch()
    reset_stopwatch();
    t = setTimeout(tick, 1000);
  }
  
  function stop_stopwatch() {
    if (t) clearTimeout(t);
    t = null;
  }
  
  start_stopwatch();
}
