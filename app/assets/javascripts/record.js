if(document.querySelector('#record-start-button')) {
  var audioElement = document.querySelector('audio');
  var streamRecorder;
  var recordStream;
  var mediaRecorder;
  var chunks = [];
	var timer = null;
  var seconds = 0;

  // Audio level measurement https://codepen.io/travisholliday/pen/gyaJk
  ////////////////////////////////////////////////////////////////////////////////////////////////
	function startMeter(){
    window.AudioContext = window.AudioContext || window.webkitAudioContext;
    var audioContext = new AudioContext();
    var analyser = audioContext.createAnalyser();
    var microphone = audioContext.createMediaStreamSource(recordStream);
    var javascriptNode = audioContext.createScriptProcessor(2048, 1, 1);
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

  // Timer
  //////////////////////////////////////////////////////////////////////////////////////////////////
  function formatTime(seconds) {
      var h = Math.floor(seconds / 3600),
          m = Math.floor(seconds / 60) % 60,
          s = seconds % 60;
      if(h < 10){h = "0" + h};
      if(m < 10){m = "0" + m};
      if(s < 10){s = "0" + s};
      return `${h}:${m}:${s}`
  }

	function startTimer(){
		timer = setInterval(clock, 1000);
	}

	function stopTimer(){
    clearInterval(timer);
    seconds = 0;
  }

  function clock(){
    seconds++;
    $('#time-display').text(formatTime(seconds));
  }

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
    window.stream = stream;
	  audioElement.srcObject = stream;
    recordStream = stream;
  }

  function getStream() {
    navigator.mediaDevices.getUserMedia({audio: true}).then(gotStream).then(startMeter).catch(handleError);
  }

  // Recording. Started with https://stackoverflow.com/a/16784618
  //////////////////////////////////////////////////////////////////////////////////////////////////
  function startRecording() {
    mediaRecorder = new MediaRecorder(recordStream);
    mediaRecorder.mimeType = 'audio/ogg';
    mediaRecorder.ondataavailable = function(e) {
      chunks.push(e.data);
    }
    mediaRecorder.start();
  }

  // As of now the callback is not being used because we are doing a redirect on the server
  function uploadAudio(){
    var blob = new Blob(chunks, {'type': 'audio/ogg'});
    $.ajax({
      type: 'POST',
      url: '/upload',
      data: blob,
      contentType: 'audio/ogg',
      processData: false
    })
  }

  function resetRecord(){
    setTimeout(function(){
      $('#save-delete-container').hide();
      $('#record-start-button').show();
      $('#time-display').text('00:00:00');
    }, 500)
  }

  // onload
  //////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    if (hasGetUserMedia()) {
      $('#record-audio').prop('muted', true);

      navigator.mediaDevices.enumerateDevices().then(getStream).catch(handleError);

      $('#record-start-button').click(function(event){
        if(!($('#record-start-button').hasClass('disabled'))){
          startRecording();
          $('#record-container').addClass('recording-pulse');
          setTimeout(function(){
            $('#record-start-button').hide();
            $('#record-stop-button').show();
          }, 200)
          startTimer();
        }
      })

      $('#record-stop-button').click(function(event){
        if(!($('#record-stop-button').hasClass('disabled'))){
          mediaRecorder.stop();
          $('#record-container').removeClass('recording-pulse');
          setTimeout(function(){
            $('#record-stop-button').hide();
            $('#save-delete-container').show();
          }, 200)
          stopTimer();
        }
      })

      $('#save-button').click(function(){
        $('#overlay').show();
        resetRecord();
        uploadAudio();
      })

      $('#delete-button').click(function(){
        var confirmation = confirm("Are you sure that you want to delete this recording? (Can't undo)");
        if(confirmation){
          resetRecord();
        }
      })

    } else {
      alert('This browser does not support audio recording.');
    }

  });
}
