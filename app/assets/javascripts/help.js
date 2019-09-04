if(document.querySelector('#intro-video')) {

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

  // Onload
  /////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    let videoElement = document.getElementById('intro-video');
    videoElement.onended = function(){
      window.location = '/set_onboarded';
    }
  });

}
