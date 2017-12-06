const update_ms = 200; // Interval between calls to watch_player
var player = null;

// Player
var playerClass = function (data) {
  'use strict';

  var self = this;
  self.data = $.extend(true, {
    id: '#recording-container'
  }, data);
  self.player = $(self.data.id);
  if (self.player.length <= 0) return null;

  // Update the UI based on the player's state
  self.watch_player = function () {
    // Get the audio duration once it's been loaded
    if (self.duration == 0) {
      if (isFinite(self.audio.duration)) {
        self.duration = self.audio.duration;
        self.timer.set_max(self.duration);
      }
    }

    // Update the play/pause button if needed
    if (self.audio.paused != self.paused) {
      if (self.paused) {
        $('#playaudio span').removeClass('glyphicon-play');
        $('#playaudio span').addClass('glyphicon-pause');
      } else {
        $('#playaudio span').addClass('glyphicon-play');
        $('#playaudio span').removeClass('glyphicon-pause');
      }
      self.paused = !self.paused;
    }

    var position =  Math.floor(self.audio.currentTime);

    // Jump back to the beginning after file after finishing.
    if (self.paused) {
      if (position > 0 && position+1 >= self.duration) {
        self.audio.currentTime = 0;
      }
    }

    if (position != self.last_position) {
      self.last_position = position;

      if (self.timer) self.timer.set_time(self.audio.currentTime);

      var active = false;
      $('.segment').each(function() {
        var start = parseFloat($(this).data('starttime'));
        var end = parseFloat($(this).data('endtime'));
        if (start <= position && (end == 0 || end > position)) {
          self.highlight(start, end);
          active = true;
          $(this).addClass('playing');
          self.scroll_to($(this));
        } else {
          $(this).removeClass('playing');
        }
      });
      if (!active) self.highlight(); // if there's not an active highlight, turn off any highlights
    }
  }


  if (self.player.data('file')) {
    self.audio = document.createElement('audio');
    self.audio.setAttribute('src','/send_audio/' + self.player.data('file'));
    self.audio.load();
    self.player.html(self.audio);
    self.audio.currentTime = 9999; // Jump to end to help figure out duration
    window.setInterval(self.watch_player, update_ms);
  }

  self.last_position = 0;
  self.paused = true;
  self.duration = 0;
  self.last_scroll = 0;
  self.timer = new timerState({});

  self.scroll_to = function (el) {
    if (self.paused) return;
    var elOffset = el.offset().top;
    var elHeight = el.height();
    var windowHeight = $(window).height();
    var offset;

    if (elHeight < windowHeight) {
      offset = elOffset - ((windowHeight / 2) - (elHeight / 2)) - 50;
    } else {
      offset = elOffset;
    }
    if (offset != self.last_scroll) {
      self.last_scroll = offset;
      $('html, body').animate({scrollTop:offset}, 700);
    }
  }

  // Play audio from clicked time
  $('.seek').click(function() {
    var t = parseFloat($(this).parents('.segment').data('starttime'));
    var endt = parseFloat($(this).parents('.segment').data('endtime')) + 1;
    self.audio.currentTime = t;
    self.audio.play();
    self.highlight(t, endt)
  });

  $(".timebar").click(function(e) {
    var cloc = (e.pageX - $(this).offset().left);
    if (cloc < 5) cloc = 0; // Make it easier to click the start
    self.audio.currentTime = cloc * self.get_max() / $(this).width();
    self.audio.play();
  });

  $('#playaudio').click(function() {
    if (self.audio.paused) self.audio.play();
    else self.audio.pause();
  });

  self.get_max = function () {
    return self.timer.get_max();
  }

  self.highlight = function (start = 0, end = 0) {
    if (start == 0 && end == 0) {
      $('#timerbar').css('background', '#fff');
    } else {
      if (end == 0) end = self.duration;
      start = 100 * start / self.duration;
      end = 100 * end / self.duration;
      var background = 'linear-gradient(to right, #fff ' + start + '%, #dfe ' + start + '%, #dfe ' + end + '%, #fff ' + end + '%)'
      $('#timerbar').css('background', background);
    }
  }

}

$(document).ready(function(){

  player = new playerClass();

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
    if (!content) $('.segment').show(); // If no tags are selected, show all
  });

})
