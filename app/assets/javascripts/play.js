const update_ms = 200; // Interval between calls to watch_player
var audio;
var last_position;
var paused = true;
var scrollactive = false;
var duration = 0;
var last_scroll = 0;

function scroll_to(el) {
  if (paused) return;
  var elOffset = el.offset().top;
  var elHeight = el.height();
  var windowHeight = $(window).height();
  var offset;

  last_el = el;
  if (elHeight < windowHeight) {
    offset = elOffset - ((windowHeight / 2) - (elHeight / 2)) - 50;
  }
  else {
    offset = elOffset;
  }
  if (offset != last_scroll) {
    last_scroll = offset;
    $('html, body').animate({scrollTop:offset}, 700);
  }
}

// Check the player's current position.  Highlight any currently playing segments.
function watch_player() {
  if (duration == 0) {
    duration = audio.duration;
    if (!isFinite(duration)) duration = 0;
    timer.set_max(duration);
  }
  if (audio.paused != paused) {
    if (paused) {
      paused = false;
      $('#playaudio span').removeClass('glyphicon-play');
      $('#playaudio span').addClass('glyphicon-pause');
    } else {
      paused = true;
      $('#playaudio span').addClass('glyphicon-play');
      $('#playaudio span').removeClass('glyphicon-pause');
    }
  }
  var position =  Math.floor(audio.currentTime);
  if (paused) {
    if (position > 0 && position+1 >= duration) {
      audio.currentTime = 0;
      scrollactive = true;
    }
  }

  if (timer) {
    timer.set_time(audio.currentTime);
  }

  if (position != last_position) {
    last_position = position;
    var active = false;
    $('.segment').each(function() {
      var start = parseFloat($(this).data('starttime'));
      var end = parseFloat($(this).data('endtime'));
      if (start <= position && (end == 0 || end > position)) {
        highlight(start, end);
        active = true;
        $(this).addClass('playing');
        scroll_to($(this));
      } else {
        $(this).removeClass('playing');
      }
    });
    if (!active) highlight();
  }
}

function highlight(start = 0, end = 0) {
  if (start == 0 && end == 0) {
    $('#timerbar').css('background', '#fff');
  } else {
    if (end == 0) end = duration;
    start = 100 * start / duration;
    end = 100 * end / duration;
    var bgc = 'linear-gradient(to right, #fff ' + start + '%, #dfe ' + start + '%, #dfe ' + end + '%, #fff ' + end + '%)'
    $('#timerbar').css('background', bgc);
  }
}

$(document).ready(function(){
  // Play audio from clicked time
  $('.seek').click(function() {
    var t = parseFloat($(this).parents('.segment').data('starttime'));
    var endt = parseFloat($(this).parents('.segment').data('endtime')) + 1;
    audio.currentTime = t;
    audio.play();
    highlight(t, endt)
  });

  $(".timebar").click(function(e) {
    var cloc = (e.pageX - $(this).offset().left);
    if (cloc < 5) cloc = 0;
    audio.currentTime = cloc * timer.get_max() / $(this).width();
    audio.play();
  });


  // Toggle a tag filter
  $('.tag-toggle').click(function() {
    var content = false; // If nothing's selected, we'll show all
    if ($(this).hasClass('btn-success')) { // Turn off a tag
      $(this).removeClass('btn-success');
      $(this).addClass('btn-tag');
    } else {                               // Turn on a tag
      $(this).addClass('btn-success');
      $(this).removeClass('btn-tag');
    }
    // Hide all rows, then unhide any that contain an activated tag
    $('.segment').hide();
    $('.tag-toggle.btn-success').each(function() {
      var tnum = $(this).data('tnum');
      $('.segment').each(function() {
        if ($(this).find('td').eq(1).text().includes(tnum)) {
          $(this).show();
          content = true;
        }
      });
    });
    if (!content) $('.segment').show();
  });

  $('#playaudio').click(function() {
    if (audio.paused) audio.play();
    else audio.pause();
  });

  var player = $('#recording-container');
  if (player && player.data('file')) {
    if (audio == null) { // Initialize the player
      audio = document.createElement('audio');

      audio.setAttribute('src','/send_audio/' + player.data('file'));
      //audio.setAttribute('controls','controls');
      audio.load();
      player.html(audio);
      audio.currentTime = 9999;
      window.setInterval(watch_player, update_ms);
    }
  }
})
