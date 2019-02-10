if(document.querySelector('#play-pause-button')) {
  const playVolume = 1.0;
  let autoScrollDisabled = false;

  function log(msg){
    console.log(msg);
  }

  function showPage(){
    $('#play-view').removeClass('invisible');
  }

  function stripeTable(){
    $('.tag-row:visible:odd').addClass('odd-row');
    $('.tag-row:visible:even').addClass('even-row');
  }

  function loadAudio(){
    let audioElement = document.getElementById('audio-element');
    audioElement.loop = true;
    audioElement.volume = playVolume;
    $('#duration').text(toMmSs(audioElement.duration));
    skipToTime(0);
    // TODO Remove. Temporary hack to delete tmp file on server
    setTimeout(function(){
      $.get('rm_tmp_file/' + $(audioElement).data('recording-id'));
    }, 60000);
  }

  $.arrayIntersect = function(a, b)
  {
    return $.grep(a, function(i)
    {
      return $.inArray(i, b) > -1;
    });
  };

  function handleFilterClick(filterButton){
    $(filterButton).toggleClass('filter-on');
    $(filterButton).find('#check-glyph').toggleClass('hidden');
    let tagTypeIdsFiltered = [];
    $('.filter-button').each(function(){
      if($(this).hasClass('filter-on')){
        tagTypeIdsFiltered.push($(this).data('tag-type-id') )
      }
    })
    $('.tag-row').each(function (){
      let rowTagTypeIds = $(this).data('tag-type-ids');
      if(!$.arrayIntersect(rowTagTypeIds, tagTypeIdsFiltered).length){
        $(this).hide();
      } else {
        $(this).show();
      }
    })
  }

  function playerListener(){
    let audioElement = document.getElementById('audio-element');
    audioElement.ontimeupdate = function(){
      let currentTime = audioElement.currentTime;
      $('#current-time').text(toMmSs(currentTime));
      skipToTime(currentTime, false);
      updateTableHighlighting(currentTime);
      scrollTable();
    };
  }

  function scrollTable() {
    let highlightedCells = document.querySelector('.highlighted-cell')
    if(highlightedCells && !autoScrollDisabled){
        highlightedCells.scrollIntoView({
        behavior: 'smooth',
        block: 'center'
      });
    }
  }

  function toMmSs(seconds){
    let mm = Math.floor(seconds / 60);
    let ss = parseInt(seconds - mm * 60);
    return `${mm.toString().padStart(2,'0')}:${ss.toString().padStart(2,'0')}`
  }

  function updateTableHighlighting(currentTime){
    $('.tag-cell').removeClass('highlighted-cell');
    let highlightRow = $('.tag-row').filter(function(){
      return $(this).data('start-time') <= currentTime && $(this).data('end-time') >= currentTime
    })
    if(!autoScrollDisabled){
      highlightRow.find('td').addClass('highlighted-cell');
    }
  }

  function skipToTime(newTime, updatePlayer = true){
    let audioElement = document.getElementById('audio-element');
    let timeline = $('#timeline');
    let playhead = $('#playhead');
    let progressBar = $('#progress-bar');
    let duration = $(audioElement).prop('duration');
    if(newTime < 0){newTime = 0 };
    if(newTime > duration){newTime = duration};
    if(updatePlayer){
      // Update is driven by UI event - move player time
      audioElement.currentTime = newTime;
    } else {
      // Update is driven by current play time - move playhead
      let timelineWidth = $('#timeline').width()
      let PxPerSec = timelineWidth / duration;
      let newPx = PxPerSec * newTime 
      playhead.css({left: newPx});
      progressBar.css({width: newPx + 10});
    }
  }

  function skipToEventPosition(event){
    let audioElement = document.getElementById('audio-element');
    let eventX = event.pageX;
    let timeline = $('#timeline');
    let timelinePosition = timeline.position();
    let playhead = $('#playhead');
    let currentTime = $(audioElement).prop('currentTime');
    let duration = $(audioElement).prop('duration');
    let secPerPx = duration / $('#timeline').width();
    let newTime = secPerPx * eventX;
    let progressBar = $('#progress-bar');
    playhead.css({left: eventX});
    if(timelinePosition.left + timeline.width() >= eventX){
      progressBar.css({width: timelinePosition.left + eventX - 10});
    }
    $(audioElement).prop('currentTime', newTime);
  }

  // Timeline clicks and drags
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

  // Playback control button clicks
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('#rewind-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    skipToTime(0);
  })

  $('#back-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    skipToTime(audioElement.currentTime - 10);
  })

  $('#play-pause-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    if (audioElement.paused) {
       audioElement.play();
    }   
    else {
       audioElement.pause();
    }
    $('#play-glyph, #pause-glyph, #play-label, #pause-label').toggleClass('hidden');
  })

  $('#forward-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    skipToTime(audioElement.currentTime + 10);
  })

  $('#mute-button').click(function(){
    let audioElement = document.getElementById('audio-element');
    if (audioElement.volume > 0) {
       audioElement.volume = 0;
    }   
    else {
       audioElement.volume = playVolume;
    }
    $('#mute-glyph, #unmute-glyph, #mute-label, #unmute-label').toggleClass('hidden');
  })
  
  // Tag Table
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('.click-to-seek').click(function(){
    skipToTime($(this).data('start-time'))
  })

  $('#tag-table').mouseover(function(){
    autoScrollDisabled = true;
  })

  $('#tag-table').mouseout(function(){
    autoScrollDisabled = false;
  })

  // Sidebar
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('.filter-button').click(function(){
    handleFilterClick(this);
  })

  // Onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    stripeTable();
    loadAudio();
    playerListener();
    showPage();
  });
}
