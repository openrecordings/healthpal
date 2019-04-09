if(document.querySelector('#record-start-button')) {
  const audioElement = document.querySelector('audio');
  var streamRecorder;
  var recordStream;
  var mediaRecorder;
  var chunks = [];

  // Stream management. Started with https://www.html5rocks.com/en/tutorials/getusermedia/intro/ 
  //////////////////////////////////////////////////////////////////////////////////////////////////
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
	  audioElement.srcObject = stream;
    recordStream = stream;
  }

  function stopStream() {
    console.log('stop');
    mediaRecorder.stop();
    if (window.stream) {
      window.stream.getTracks().forEach(function(track) {
        track.stop();
      });
    }
  }

  function getStream() {
    console.log('get');
    navigator.mediaDevices.getUserMedia({audio: true}).then(gotStream).then(startMeter).catch(handleError);
  }

  // Recording. Started with https://stackoverflow.com/a/16784618
  //////////////////////////////////////////////////////////////////////////////////////////////////
  function onVideoFail(e) {
    console.log('webcam fail!', e);
  };

  function startRecording() {
    console.log('startRecording');
    mediaRecorder = new MediaRecorder(recordStream);
    mediaRecorder.mimeType = 'audio/ogg';
    mediaRecorder.ondataavailable = function(e) {
      chunks.push(e.data);
    }
    mediaRecorder.onstop = function(e){
      var blob = new Blob(chunks, { 'type': 'audio/ogg' });
      $.ajax({
        type: 'POST',
        url: '/upload',
        data: blob,
        contentType: 'audio/ogg',
        processData: false
      })
    }
    mediaRecorder.start();
  }

  function onUploadSuccess() {
    console.log('video uploaded');
  }

  // Audio level measurement https://codepen.io/travisholliday/pen/gyaJk
  ////////////////////////////////////////////////////////////////////////////////////////////////
	function startMeter(){
    audioContext = new AudioContext();
    analyser = audioContext.createAnalyser();
    microphone = audioContext.createMediaStreamSource(recordStream);
    javascriptNode = audioContext.createScriptProcessor(2048, 1, 1);
    analyser.smoothingTimeConstant = 0.8;
    analyser.fftSize = 1024;
    microphone.connect(analyser);
    analyser.connect(javascriptNode);
    javascriptNode.connect(audioContext.destination);
    canvasContext = document.querySelector('#audio-meter').getContext("2d");
    javascriptNode.onaudioprocess = function() {
      var array = new Uint8Array(analyser.frequencyBinCount);
      analyser.getByteFrequencyData(array);
      var values = 0;
      var length = array.length;
      for (var i = 0; i < length; i++) {
        values += (array[i] * 1.2);
      }
      var average = values / length;
      canvasContext.clearRect(0, 0, 50, 200);
      canvasContext.fillStyle = '#f9d56d';
      canvasContext.fillRect(0, 200 - average, 50, 200);
    }
  }

  // Controls
  //////////////////////////////////////////////////////////////////////////////////////////////////
  function toggleDisabled(){
    $('#record-start-button').toggle();
    $('#record-stop-button').toggle();
  }

  // onload
  //////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    if (hasGetUserMedia()) {
      $('#record-audio').prop('muted', true);

      navigator.mediaDevices.enumerateDevices().then(getStream).catch(handleError);

      $('#record-start-button').click(function(event){
        if(!($('#record-start-button').hasClass('disabled'))){
          $('#record-container').addClass('recording-pulse');
          toggleDisabled();
          //startRecording();
        }
      })

      $('#record-stop-button').click(function(event){
        if(!($('#record-stop-button').hasClass('disabled'))){
          $('#record-container').removeClass('recording-pulse');
          toggleDisabled();
          //stopStream();
        }
      })
    } else {
      //TODO: Alert the user
      console.log('getUserMedia not found');  
    }

  });
}
