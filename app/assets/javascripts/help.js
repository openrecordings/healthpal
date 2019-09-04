if(document.querySelector('#intro-video')) {

  $('#watch-now').click(function(){
    $('#intro-text-container').hide();
    let videoElement = document.getElementById('intro-video');
    videoElement.play();
  })

}
