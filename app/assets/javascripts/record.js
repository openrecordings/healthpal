$(document).ready(function() {
  
  // Check for getUserMedia browser support
	function hasGetUserMedia() {
		return !!(navigator.mediaDevices &&
			navigator.mediaDevices.getUserMedia);
	}
	if (hasGetUserMedia()) {
	  console.log('getUserMedia found');	
	} else {
    //TODO: Alert the user
	  console.log('getUserMedia not found');	
	}

});

$('#record-button').click(function(){
  const constraints = {
    video: true
  };

  const video = document.querySelector('video');

  navigator.mediaDevices.getUserMedia(constraints).
    then((stream) => {video.srcObject = stream});
})
