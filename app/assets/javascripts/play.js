if(document.querySelector('#play-pause-button')) {
  const playVolume = 1.0;
  let autoScrollDisabled = false;

  function showPage(){
    $('#loader-container').hide();
    let videoElement = document.getElementById('video-element');
    if($(videoElement).data('is-video')){
      $('#video-play-view').removeClass('invisible');
      $(videoElement).show();
    } else {
      $('#audio-play-view').removeClass('invisible');
    }
  }

  function stripeTable(){
    $('.tag-row:visible:odd').addClass('odd-row');
    $('.tag-row:visible:even').addClass('even-row');
  }

  function togglePlayPause(){
    let videoElement = document.getElementById('video-element');
    if (videoElement.paused) {
       videoElement.play();
    }   
    else {
       videoElement.pause();
    }
    $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('hidden');
  }

  // Playback control
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function loadAudio(){
    let videoElement = document.getElementById('video-element');
    let recordingId = $(videoElement).data('recording-id');
    videoElement.volume = playVolume;
    $('#duration').text(toMmSs(videoElement.duration));
    skipToTime(0);
  }

  $.arrayIntersect = function(a, b)
  {
    return $.grep(a, function(i)
    {
      return $.inArray(i, b) > -1;
    });
  };

  function playerListener(){
    let videoElement = document.getElementById('video-element');
    videoElement.ontimeupdate = function(){
      let currentTime = videoElement.currentTime;
      $('#current-time').text(toMmSs(currentTime));
      skipToTime(currentTime, false);
      updateTableHighlighting(currentTime);
      scrollTable();
    };
  }

  function skipToTime(newTime, updatePlayer = true){
    let videoElement = document.getElementById('video-element');
    let timeline = $('#timeline');
    let playhead = $('#playhead');
    let progressBar = $('#progress-bar');
    let duration = $(videoElement).prop('duration');
    if(newTime < 0){newTime = 0 };
    if(newTime > duration){newTime = duration};
    if(updatePlayer){
      // Update is driven by UI event - move player time
      log(`skipping to UI time: ${newTime.toString()}`);
      videoElement.currentTime = newTime.toString();
    } else {
      // Update is driven by current play time - move playhead
      log(`skipping to play time: ${newTime.toString()}`);
      let timelineWidth = $('#timeline').width()
      let PxPerSec = timelineWidth / duration;
      let newPx = PxPerSec * newTime 
      playhead.css({left: newPx});
      progressBar.css({width: newPx + 10});
    }
  }

  function skipToEventPosition(event){
    let videoElement = document.getElementById('video-element');
    let eventX = event.pageX;
    let timeline = $('#timeline');
    let timelinePosition = timeline.position();
    let playhead = $('#playhead');
    let currentTime = $(videoElement).prop('currentTime');
    let duration = $(videoElement).prop('duration');
    let secPerPx = duration / $('#timeline').width();
    let newTime = secPerPx * eventX;
    let progressBar = $('#progress-bar');
    playhead.css({left: eventX});
    if(timelinePosition.left + timeline.width() >= eventX){
      progressBar.css({width: timelinePosition.left + eventX - 10});
    }
    log(`skipping to event time: ${newTime.toString()}`);
    videoElement.currentTime = newTime.toString();
  }

  // Row filtering, time display, row highlighting
  /////////////////////////////////////////////////////////////////////////////////////////////////
  function handleFilterClick(filterButton){
    $(filterButton).toggleClass('filter-on');
    $(filterButton).find('.check-glyph').toggleClass('hidden');
    let tagTypeIdsShown = [];
    $('.filter-button').each(function(){
      if($(this).hasClass('filter-on')){
        tagTypeIdsShown.push($(this).data('tag-type-id') )
      }
    })
    if(tagTypeIdsShown.length){
      $('.tag-row').each(function (){
        let rowTagTypeIds = $(this).data('tag-type-ids');
        if($.arrayIntersect(rowTagTypeIds, tagTypeIdsShown).length){
          $(this).show();
        } else {
          $(this).hide();
        }
      })
    } else {
      $('.tag-row').show();
    }
    if($('.tag-row').not(':hidden').length){
      $('#empty-result-message').hide();
    } else {
      $('#empty-result-message').show();
    }
  }

  function toMmSs(seconds){
    let mm = Math.floor(seconds / 60);
    let ss = parseInt(seconds - mm * 60);
    return `${mm.toString().padStart(2,'0')}:${ss.toString().padStart(2,'0')}`
  }

  function scrollTable() {
    let highlightedCells = document.querySelector('.highlighted-row')
    if(highlightedCells && !autoScrollDisabled){
        highlightedCells.scrollIntoView({
        behavior: 'smooth',
        block: 'center'
      });
    }
  }

  function updateTableHighlighting(currentTime){
    $('.tag-row').children().removeClass('highlighted-row');
    let highlightRow = $('.tag-row').filter(function(){
      return $(this).data('start-time') <= currentTime && $(this).data('end-time') >= currentTime
    })
    highlightRow.children().addClass('highlighted-row');
  }
  
  // Tag Table listeners
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('.click-to-seek').click(function(){
    let videoElement = document.getElementById('video-element');
    skipToTime($(this).data('start-time'))
    if(videoElement.paused){
      $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('hidden');
    }
    videoElement.play();
  })

  $('#tag-table').mouseover(function(){
    autoScrollDisabled = true;
  })

  $('#tag-table').mouseout(function(){
    autoScrollDisabled = false;
  })

  // Playback control button listeners
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('#timeline').click(function(event){
    skipToEventPosition(event);
  })

  $('#playhead').draggable({
    axis: 'x',
    eontainment: '#timeline',
    drag: function(event, ui){
      skipToEventPosition(event);
    }
  });

  $('#rewind-button').click(function(){
    let videoElement = document.getElementById('video-element');
    skipToTime(0);
  })

  $('#back-button').click(function(){
    let videoElement = document.getElementById('video-element');
    skipToTime(videoElement.currentTime - 10);
  })

  $('#play-pause-button').click(function(){
    togglePlayPause();
  })

  $('#forward-button').click(function(){
    let videoElement = document.getElementById('video-element');
    skipToTime(videoElement.currentTime + 10);
  })

  $('#mute-button').click(function(){
    let videoElement = document.getElementById('video-element');
    if (videoElement.volume > 0) {
       videoElement.volume = 0;
    }   
    else {
       videoElement.volume = playVolume;
    }
    $('#mute-glyph, #unmute-glyph, #mute-label, #unmute-label').toggleClass('hidden');
  })

  // Sidebar listeneers
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('.filter-button').click(function(){
    handleFilterClick(this);
  })

  $('#show-all-topics').click(function(){
    $('.tag-row').show();
    $('.check-glyph').addClass('hidden');

  })

  // Onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    loadAudio();
    stripeTable();
    playerListener();

    let videoElement = document.getElementById('video-element');
    videoElement.oncanplay = function(){
      showPage();
    }

  });
}
