const videoElement = document.querySelector('video');
const audioSelect = document.querySelector('select#audioSource');
const videoSelect = document.querySelector('select#videoSource');

// Wrap entire file in conditional, verifying that we are on the recording page
if(videoElement && audioSelect &&  videoSelect) {

  // Stream management. Started with https://www.html5rocks.com/en/tutorials/getusermedia/intro/ 
  //////////////////////////////////////////////////////////////////////////////////////////////////
  audioSelect.onchange = getStream;
  videoSelect.onchange = getStream;

  function gotDevices(deviceInfos) {
    console.log('gotDevices');
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

  function getStream() {
    console.log('getStream');
    const constraints = {
      audio: function(){
        if(audioTrackOn){
          deviceId: {exact: audioSelect.value}
        } else {
          false;
        }
      },
      video: function(){
        if(videoTrackOn){
          deviceId: {exact: videoSelect.value}
        } else {
          false;
        }
      },
    };
    navigator.mediaDevices.getUserMedia(constraints).
      then(gotStream).catch(handleError);
  }

  function gotStream(stream) {
    console.log('gotStream');
    console.log(stream);
    // Make stream available to console
    window.stream = stream;
    startRecording(stream);
  }

  // Recording. Started with https://stackoverflow.com/a/16784618
  //////////////////////////////////////////////////////////////////////////////////////////////////
  function onVideoFail(e) {
    console.log('webcam fail!', e);
  };

  function startRecording(stream) {
    console.log('startRecording');
    navigator.mediaDevices.enumerateDevices().then(gotDevices).then(getStream).catch(handleError);
    var mediaRecorder = new MediaRecorder(stream);
    videoElement.srcObject = stream;
    mediaRecorder.mimeType = 'video/webm';
    mediaRecorder.ondataavailable = function(blob) {
      postMediaToServer(videoElement.srcObject);
    };
    mediaRecorder.start(2000)
  }

  function stopRecording(stream) {
    console.log('stop');
    stream.getTracks().forEach(function(track) { track.stop(); });
  }

  function postMediaToServer(mediaBlob) {
    var data = {};
    data.video = mediaBlob;
    data.metadata = 'test metadata';
    data.action = "upload_video";
    jQuery.post('/upload', data, onUploadSuccess);
  }

  function onUploadSuccess() {
    console.log('video uploaded');
  }

  // Audio level measurement starts here
  ////////////////////////////////////////////////////////////////////////////////////////////////
        
  // Audio meter display starts here
  ////////////////////////////////////////////////////////////////////////////////////////////

  // onload
  //////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    if (hasGetUserMedia()) {
      $('#record-start-button').click(function(){ startRecording(); })
      $('#record-stop-button').click(function(){ stopRecording(); })

      // Initialize to recording nothing
      let audioTrackOn = false;
      let videoTrackOn = false;
      
      // Listen for a/v selection and set stream to record audio and/or video
      $("[name='requested-media']").click(function(){
        let requestedMedia = $(this).data('requested-media');
        switch(requestedMedia){
          case 'audio':
            audioTrackOn = true;
            break;
          case 'video':
            videoTrackOn = true;
            break;
          case 'audio-video':
            audioTrackOn = true;
            videoTrackOn = true;
        }
      })
      } else {
      //TODO: Alert the user
      console.log('getUserMedia not found');  
    }
  });

// Close conditional wrapping entire file
}
