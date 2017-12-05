
var timer = null;

//
// Object to hold timer information
var timerState = function (data) {
  'use strict';

  var self = this;
  self.seconds = 0;
  self.data = $.extend(true, {
    id: '#timer',
  }, data);
  self.timer = $(self.data.id);
  if (self.timer.length <= 0) return null;
  self.end = new timerState({id: self.data.id + '-end'});

  self.max = 100;
  self.bodyContent = $('#body-content');
  self.t = null, self.start_time;

  self.get_time = function() {
    return self.seconds;
  }
  
  self.set_time = function (secs) {
    var seconds = Math.floor(secs);
    self.seconds = seconds;
    var hours = 0, minutes = 0;

    hours = Math.floor(seconds / 60 / 60);
    minutes = Math.floor(seconds / 60) % 60
    seconds = seconds % 60
    
    $(self.timer).html((hours ? (hours > 9 ? hours + ":" : "0" + hours + ":") : "") +
                      (minutes ? (minutes > 9 ? minutes : "0" + minutes) : "00") + ":" +
                       (seconds > 9 ? seconds : "0" + seconds));
    $("#loc").css('left', (secs*100/self.max)+'%');
  }

  self.set_max = function(t) {
    self.max = t;
    self.end.set_time(t);
  }

  self.get_max = function() {
    return self.max;
  }

  self.tick = function() {
    self.set_time(Math.floor(((new Date()).getTime() - self.start_time)/1000));
    self.t = setTimeout(self.tick, 1000);
  }

  self.reset = function() {
    self.start_time = (new Date()).getTime();
    self.set_time(0);
  }

  self.start = function() {
    self.stop()
    self.reset();
    self.t = setTimeout(self.tick, 1000);
  }
  
  self.stop = function () {
    if (self.t) clearTimeout(t);
    self.t = null;
  }
  return self;
}

$(document).ready(function () {
  timer = new timerState({});
});

