var audio
var last_position
var reset = true

function watch_player() {
  var position =  Math.floor(audio.currentTime);

  if (reset) { // once clip length is known, go to start of file
    reset = false;
    audio.currentTime = 0;
  }
  if (position != last_position) {
    last_position = position;
    console.log(position);
    $(".segment").each(function() {
      var start = parseFloat($(this).data("starttime"));
      var end = parseFloat($(this).data("endtime"));
      if (start <= position && (end == 0 || end > position)) {
        $(this).addClass("playing");
      } else {
        $(this).removeClass("playing");
      }
    });
  }
}

$(document).ready(function(){

  $(".seek").click(function() {
    var t = $(this).parent().parent().data('starttime')
    audio.currentTime = t
    audio.play()
  })

  var player = $("#recording-container");
  if (player && player.data('file')) {
    if (audio == null) {
      audio = document.createElement('audio');

      audio.setAttribute('src','/send_audio/' + player.data('file'));
      audio.setAttribute('controls','controls');
      audio.load();
      player.html(audio)
      audio.currentTime = 99999 // Jump to the end in order to find clip length
      window.setInterval(watch_player, 200);
    }
  }
})
