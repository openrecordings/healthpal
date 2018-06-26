const UPDATE_MS = 200; // Interval between calls to watch_player
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

  self.interval = null;
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

    var position = self.audio.currentTime;

    // Jump back to the beginning of file after finishing.
    if (self.paused) {
      if (position > 0 && position+1 >= self.duration) {
        self.audio.currentTime = 0;
      }
    }

    if (position != self.last_position) {
      self.last_position = position;

      if (self.timer) self.timer.set_time(position);

      var active = false;
      var scrolled = false;
      $('.segment').each(function() {
        var start = parseFloat($(this).data('starttime'));
        var end = parseFloat($(this).data('endtime'));
        if (start <= position && (end == 0 || end > position)) {
          self.highlight(start, end);
          active = true;
          $(this).addClass('playing');
          if(!scrolled){
            self.scroll_to($(this));
            scrolled = true;
          }
        } else {
          $(this).removeClass('playing');
        }
      });
      if (!active) self.highlight(0, 0); // if there's not an active highlight, turn off any highlights
    }
  };

  if (self.player.data('file')) {
    self.audio = document.createElement('audio');
    self.audio.setAttribute('src','/send_audio/' + self.player.data('file'));
    self.audio.load();
    self.player.html(self.audio);
    self.audio.currentTime = 9999; // Jump to end to help figure out duration
    self.duration = 0; // Cause progress bar range to be reset
    if (self.interval) clearTimeout(self.interval);
    self.interval = window.setInterval(self.watch_player, UPDATE_MS);
  }

  self.last_position = 0;
  self.paused = true;
  self.duration = 0;
  self.last_scroll = 0;
  self.timer = new timerState({});

  // Scroll the utterance list to center the given element
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
  };

  self.set_audio = function (url) {
    self.audio = document.createElement('audio');
    self.audio.setAttribute('src',url);
    self.audio.load();
    self.player.html(self.audio);
    self.audio.currentTime = 9999; // Jump to end to help figure out duration
    self.duration = 0; // Cause progress bar range to be reset
    if (self.interval) clearTimeout(self.interval);
    self.interval = setInterval(self.watch_player, UPDATE_MS);
  };

  // Return file duration
  self.get_max = function () {
    return self.timer.get_max();
  };

  // Highlight a range in the play progress bar
  self.highlight = function (start, end) {
    if (start == 0 && end == 0) {
      $('#timerbar').css('background', '#fff');
    } else {
      if (end == 0) end = self.duration;
      start = 100 * start / self.duration;
      end = 100 * end / self.duration;
      var background = 'linear-gradient(to right, #fff ' + start + '%, #bfd ' + start + '%, #bfd ' + end + '%, #fff ' + end + '%)';
      $('#timerbar').css('background', background);
    }
  };

  // Play audio from clicked time
  self.seek = function (segment) {
    var t = segment.data('starttime');
    var endt = segment.data('endtime') + 1;
    self.audio.currentTime = t;
    self.audio.play();
    self.highlight(t, endt);
  };

  // Clear all selected filters
  $("#clear-filters").click(function(e) {
    $('.filter').each(function (x) {
      if ($(this).hasClass('btn-success')) $(this).click();
    });
  });

  // Play audio from the clicked location
  $(".timebar").click(function(e) {
    var cloc = (e.pageX - $(this).offset().left);
    if (cloc < 5) cloc = 0; // Make it easier to click the start
    self.audio.currentTime = cloc * self.get_max() / $(this).width();
    self.audio.play();
  });

  // Play/Pause button
  $('#playaudio').click(function() {
    if (self.audio.paused) self.audio.play();
    else self.audio.pause();
  });

  $('#stepforward').click(function() {
    self.audio.currentTime += 10;
  });

  $('#stepbackward').click(function() {
    self.audio.currentTime -= 10;
  });

};

$(document).ready(function(){

  player = new playerClass();

  // Toggle a tag filter
  $('.tag-toggle').click(function() {
    var tag_type = '.oralfilter' + $(this).html().slice(0, 3);
    var content = false; // If nothing's selected, we'll show all
    if ($(this).hasClass('btn-success')) { // Turn off a tag
      $(tag_type).removeClass('btn-success');
      $(this).removeClass('btn-success');
      $(this).addClass('btn-tag');
    } else {                               // Turn on a tag
      $(this).addClass('btn-success');
      $(this).removeClass('btn-tag');
      $(tag_type).addClass('btn-success');
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

  // Register listener for selecting a different user's recordings
  $('#recordings-user-select').change(function(){
    window.location.replace('/my_recordings/' + $(this).val());
  });

  // Table row click listeners for segments
  $('.segment').click(function() {
    player.seek($(this));
  });

  // Table row click listeners for recording index page
  $('.recording-select').click(function() {
    window.location = $(this).data('href');
  });

});

