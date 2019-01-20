// From https://www.html5rocks.com/en/tutorials/getusermedia/intro/
const videoElement = document.querySelector('video');
const audioSelect = document.querySelector('select#audioSource');
const videoSelect = document.querySelector('select#videoSource');

audioSelect.onchange = getStream;
videoSelect.onchange = getStream;

function gotDevices(deviceInfos) {
  for (let i = 0; i !== deviceInfos.length; ++i) {
    const deviceInfo = deviceInfos[i];
    const option = document.createElement('option');
    option.value = deviceInfo.deviceId;
    if (deviceInfo.kind === 'audioinput') {
      option.text = deviceInfo.label ||
        'microphone ' + (audioSelect.length + 1);
      audioSelect.appendChild(option);
    } else if (deviceInfo.kind === 'videoinput') {
      option.text = deviceInfo.label || 'camera ' +
        (videoSelect.length + 1);
      videoSelect.appendChild(option);
    } else {
      console.log('Found another kind of device: ', deviceInfo);
    }
  }
}

function handleError(error) {
  console.error('Error: ', error);
}
  
// Check for getUserMedia browser support
function hasGetUserMedia() {
	return !!(navigator.mediaDevices &&
		navigator.mediaDevices.getUserMedia);
}
if (!hasGetUserMedia()) {
	//TODO: Alert the user
	console.log('getUserMedia not found');	
}

function gotStream(stream) {
	console.log('got');
	window.stream = stream; // make stream available to console
	videoElement.srcObject = stream;
}

function stopStream() {
	console.log('stop');
	if (window.stream) {
		window.stream.getTracks().forEach(function(track) {
			track.stop();
		});
	}
}

function getStream() {
	console.log('get');
	const constraints = {
		audio: {
			deviceId: {exact: audioSelect.value}
		},
		video: {
			deviceId: {exact: videoSelect.value}
		}
	};

	navigator.mediaDevices.getUserMedia(constraints).
		then(gotStream).catch(handleError);
}

$(document).ready(function() {
  navigator.mediaDevices.enumerateDevices().then(gotDevices).catch(handleError);

  $('#record-start-button').click(function(){
    getStream();
  })

  $('#record-stop-button').click(function(){
    stopStream();
  })

});
