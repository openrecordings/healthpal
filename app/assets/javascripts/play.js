if(document.querySelector('#play-pause-button')) {
  let playhead = $('#playhead');
  let timeline = $('#timeline');
  let progressBar = $('#progress-bar');

  // onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    // Apply Jquery draggable to playhead
    playhead.draggable({
      axis: 'x',
      containment:'parent',
      drag: function(event, ui){
        progressBar.css({width: event.pageX - 10});
      },
    });

    // Move playhead to click position in timeline
    timeline.click(function(event){
      let timelineWidth = $(this).width();
      let pxFromLeft = event.pageX - this.offsetLeft;
      let proportionOfWidth = pxFromLeft / timelineWidth
      playhead.css({left: event.pageX});
      progressBar.css({width: event.pageX});
    });
  });

}
