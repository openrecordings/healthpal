if(document.querySelector('#intro-video')) {

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
