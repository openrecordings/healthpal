if(document.querySelector('#intro-video')) {


  // Dismiss
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('#dismiss-video').click(function(){
    let videoElement = document.getElementById('intro-video');
    videoElement.pause();
    $('#intro-overlay').hide(); 
  })

  $('.overlay-video').mouseover(function(){
    $('#dismiss-video').show();
  })

  $('.overlay-video').mouseout(function(){
    $('#dismiss-video').hide();
  })

  // On-boarding
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('#watch-now').click(function(){
    let videoElement = document.getElementById('intro-video');
    $('#intro-text-container').hide();
    videoElement.play();
  })

  $('#watch-later').click(function(){
    window.location = '/dont_onboard';
  })

  $('#never-watch').click(function(){
    window.location = '/set_onboarded';
  })

  // Help page
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $('#play-intro-video').click(function() {
    $('#intro-overlay').show();
  })

  // Onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    let videoElement = document.getElementById('intro-video');
    videoElement.onended = function(){
      window.location = '/set_onboarded';
    }
  });

}
