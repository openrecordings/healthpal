$(document).ready(function() {
  let playhead = $('#playhead');
  let timeline = $('#timeline');

  // Apply Jquery draggable to playhead
  playhead.draggable({
    axis: 'x',
    containment: 'parent'
  });

  // Move playhead to click position in timeline
  timeline.click(function(event){
    let timelineWidth = $(this).width();
    let pxFromLeft = event.pageX - this.offsetLeft;
    let proportionOfWidth = pxFromLeft / timelineWidth
    playhead.css( {left: event.pageX} );
  });

});
