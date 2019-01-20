const videoElement = document.querySelector('video');
const audioSelect = document.querySelector('select#audioSource');
const videoSelect = document.querySelector('select#videoSource');
var streamRecorder;
var recordStream;

// Stream management. Started with https://www.html5rocks.com/en/tutorials/getusermedia/intro/ 
//////////////////////////////////////////////////////////////////////////////////////////////////
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

function gotStream(stream) {
	console.log('got');
  // Make stream available to console
	window.stream = stream;
	videoElement.srcObject = stream;
	recordStream = stream
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

// Recording. Started with https://stackoverflow.com/a/16784618
//////////////////////////////////////////////////////////////////////////////////////////////////
function onVideoFail(e) {
  console.log('webcam fail!', e);
};

function startRecording() {
	var mediaRecorder = new MediaRecorder(recordStream);
	mediaRecorder.mimeType = 'video/webm';
	mediaRecorder.ondataavailable = function (blob) {
			var blobURL = URL.createObjectURL(blob);
			postMediaToServer(blobURL);
	};
	mediaRecorder.start(3000)
  setTimeout(stopRecording, 10000);
}

function stopRecording() {
  streamRecorder.getRecordedData(postMediaToServer);
}

function postMediaToServer(blob) {
  var data = {};
  data.video = videoblob;
  data.metadata = 'test metadata';
  data.action = "upload_video";
  jQuery.post('/upload', data, onUploadSuccess);
}

function onUploadSuccess() {
  console.log('video uploaded');
}

// onload
//////////////////////////////////////////////////////////////////////////////////////////////////
$(document).ready(function() {
  if (hasGetUserMedia()) {
    navigator.mediaDevices.enumerateDevices().then(gotDevices).catch(handleError);

    $('#media-start-button').click(function(){
      getStream();
    })

    $('#record-start-button').click(function(){
      startRecording();
    })

    $('#record-stop-button').click(function(){
      stopStream();
      stopRecording();
    })
  } else {
    //TODO: Alert the user
    console.log('getUserMedia not found');	
  }

});
