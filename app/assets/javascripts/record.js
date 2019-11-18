if(window.location.pathname == '/record') {
  var audioElement = document.querySelector('audio');
  var streamRecorder;
  var recordStream;
  var mediaRecorder;
  var chunks = [];
  var timer = null;
  var seconds = 0;
  var amplitude = 0;
  var canvas = document.querySelector('#audio-meter')
  var canvasContext = canvas.getContext('2d');
  var canvasStyle = window.getComputedStyle(canvas);
  const circleColor = '#89aadf';
  const baseRadius = 20;
  const radiusAmplitudeMultiplier = 0.5;
  const radiusDeltaBetweenCircles = 10;
  const circlesArray = [];
  const animationDuration = 1000;
  var animationTime = 0;
  const animationTimeMultiplier = .02;
  const animationFrameDuration = 200;

  // Audio level measurement
  ////////////////////////////////////////////////////////////////////////////////////////////////
  function monitorAmplitude(){
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
    javascriptNode.onaudioprocess = function() {
      var array = new Uint8Array(analyser.frequencyBinCount);
      analyser.getByteFrequencyData(array);
      var values = 0;
      var length = array.length;
      for (var i = 0; i < length; i++) {
        values += (array[i] * 1.2);
      }
      amplitude = values / length;
    }
  }

  function animateMeter(){
    var startTime = now();
    setInterval(function(){
      if(animationTime > animationDuration){
        animationTime = 0;
        startTime = now();
      } else {
        animationTime = now() - startTime;
      }
      drawCircles();
    }, animationFrameDuration);
  }

  function drawCircles(){
    canvasContext.clearRect(0, 0, canvas.width, canvas.height);
    // Inner circle. Not animated.
    var radius = getRadius({baseRadius: baseRadius, amplitude: amplitude, animate: 0});
    drawCircle({opacity: 1.0, radius: radius});
    // Outer animated circle
    var radius2 = getRadius({baseRadius: baseRadius + (2 * radiusDeltaBetweenCircles)});
    drawCircle({opacity: 0.2, radius: radius2});
    // Middle animated circle
    //if(animationTime >= animationDuration / 3){
    //  var radius = getRadius({baseRadius: baseRadius + (1 * radiusDeltaBetweenCircles), amplitude: amplitude});
    //  drawCircle({opacity: 0.4, radius: amplitude});
    //}
    //// Inner animated circle
    //if(animationTime >= 2 * animationDuration / 3){
    //  var radius = getRadius({baseRadius: baseRadius + radiusDeltaBetweenCircles, amplitude: amplitude});
    //  drawCircle({opacity: 0.4, radius: amplitude});
    //}
  }

  function getRadius({baseRadius, animate=1}){
    return baseRadius + (animate * animationTimeMultiplier * animationTime) + (radiusAmplitudeMultiplier * amplitude);
  }

  function drawCircle({opacity, radius}){
    $('.record-button-label').text(parseInt(radius));
    canvasContext.beginPath();
    canvasContext.arc(canvas.width / 2, canvas.height / 2, radius, 0, Math.PI * 2, false);
    canvasContext.fillStyle = circleColor;
		canvasContext.globalAlpha = opacity;
    canvasContext.fill();
  }
  
  function setCanvasSize(){
    canvasWidth = parseInt(canvasStyle.getPropertyValue('width'), 10);
    canvasHeight = parseInt(canvasStyle.getPropertyValue('height'), 10);
    canvas.width = canvasWidth;
    canvas.height = canvasHeight;
  }

  function now(){
    return new Date().getTime();
  }

  $(window).resize(function() {
    setCanvasSize();
  });

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
    navigator.mediaDevices.getUserMedia({audio: true}).then(gotStream).then(monitorAmplitude).catch(handleError);
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
      setCanvasSize();
      animateMeter();
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
