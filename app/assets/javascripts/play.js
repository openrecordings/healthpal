const update_ms = 200; // Interval between calls to watch_player
var audio;
var last_position;
var reset = true;

// Check the player's current position.  Highlight any currently playing segments.
function watch_player() {
  var position =  Math.floor(audio.currentTime);

  if (reset) { // once clip length is known, go to start of file
    reset = false;
    audio.currentTime = 0;
  }
  if (position != last_position) {
    last_position = position;
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
  // Play audio from clicked time
  $(".seek").click(function() {
    var t = $(this).parent().parent().data('starttime');
    audio.currentTime = t;
    audio.play();
  });

  // Toggle a tag filter
  $(".tag-toggle").click(function() {
    var content = false; // If nothing's selected, we'll show all
    if ($(this).hasClass("btn-success")) { // Turn off a tag
      $(this).removeClass("btn-success");
      $(this).addClass("btn-tag");
    } else {                               // Turn on a tag
      $(this).addClass("btn-success");
      $(this).removeClass("btn-tag");
    }
    // Hide all rows, then unhide any that contain an activated tag
    $(".segment").addClass("hide");
    $(".tag-toggle").each(function() {
      if ($(this).hasClass("btn-success")) {
        var tnum = $(this).data("tnum");
        $(".segment").each(function() {
          if ($(this).find('td').eq(1).text().includes(tnum)) {
            $(this).removeClass("hide");
            content = true;
          }
        });
      };
    });
    if (!content) $(".segment").removeClass("hide");
  });

  var player = $("#recording-container");
  if (player && player.data('file')) {
    if (audio == null) { // Initialize the player
      audio = document.createElement('audio');

      audio.setAttribute('src','/send_audio/' + player.data('file'));
      audio.setAttribute('controls','controls');
      audio.load();
      player.html(audio);
      audio.currentTime = 99999; // Jump to the end in order to find clip length
      window.setInterval(watch_player, update_ms);
    }
  }
})
