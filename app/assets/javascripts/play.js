var audio
var last_position
var highlighted

function watch_player() {
  var position =  Math.floor(audio.currentTime);
  if (position != last_position) {
    last_position = position;
    console.log(position);
    var bestp = -1, best;
    $(".segment").each(function() {
      var p = parseFloat($(this).data("time"));
      if (p <= position && p > bestp) {
        bestp = p;
        best = this;
      }
    });
    if (best != highlighted) {
      console.log(position);
      if (highlighted) $(highlighted).removeClass("playing");
      $(best).addClass("playing");
      highlighted = best;
    }
  }
}

function play_from(start) {
  //audio.currentTime = 11; // jumps to 29th secs
}

$(document).ready(function(){
  // TODO: The code below works to play back a recording. We need to:
  //   - Wrap it it in a conditional that is entered only if we are on a page with a recording-container div
  //   - Get the recording_id from something like data-recording-id on the container div and use it here

  if (audio == null) {
    audio = document.createElement('audio');

    var player = $("#recording-container");
    if (player && player.data('file')) {
      audio.setAttribute('src','/send_audio/' + player.data('file'));
      audio.setAttribute('controls','controls');
      audio.load();
      audio.currentTime = 29; // jumps to 29th secs
      alert("29");

      player.html(audio)
      window.setInterval(watch_player, 200);
    }
  }
})
