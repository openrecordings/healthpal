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

