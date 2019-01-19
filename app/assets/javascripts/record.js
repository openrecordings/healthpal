$(document).ready(function() {
	function hasGetUserMedia() {
		return !!(navigator.mediaDevices &&
			navigator.mediaDevices.getUserMedia);
	}

	if (hasGetUserMedia()) {
	  console.log('getUserMedia found');	
	} else {
	  console.log('getUserMedia not found');	
	}
});

// For video recording:
//const constraints = {
//  video: true
//};
//
//const video = document.querySelector('video');
//
//navigator.mediaDevices.getUserMedia(constraints).
//  then((stream) => {video.srcObject = stream});
