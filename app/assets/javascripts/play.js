var audio
var last_position

function watch_player() {
  var position =  Math.floor(audio.currentTime);
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

function play_from(start) {
  //audio.currentTime = 11; // jumps to 29th secs
}

$(document).ready(function(){
  // TODO: The code below works to play back a recording. We need to:
  //   - Wrap it it in a conditional that is entered only if we are on a page with a recording-container div
  //   - Get the recording_id from something like data-recording-id on the container div and use it here


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
      window.setInterval(watch_player, 200);
    }
  }
})
