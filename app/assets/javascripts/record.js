if (window.location.pathname == '/record') {
  // Audio
  var audioElement = document.querySelector('audio');
  var streamRecorder;
  var recordStream;
  var mediaRecorder;
  var chunks = [];
  var timer = null;
  var seconds = 0;

  // Metering
  var amplitude = 0;
  var canvas = document.querySelector('#audio-meter')
  var canvasContext = canvas.getContext('2d');
  var canvasStyle = window.getComputedStyle(canvas);
  var colorMonitoring = '#1c3e66';
  var colorRecording = 'red';
  var baseRadius = 15;
  var radiusAmplitudeMultiplier = 0.8;
  var radiusDeltaBetweenCircles = 7;
  var currentCircles = [];
  var circleLifetime = 3000;
  var animationTime = 0;
  var interCircleInterval = 1 / 3 * circleLifetime;
  var animationTimeMultiplier = .04;
  var animationFrameDuration = 15;
  var startOpacity = 0.4;
  var endOpacity = 0.0;

  // Audio level measurement
  ////////////////////////////////////////////////////////////////////////////////////////////////
  class AnimatedCircle {
    constructor() {
      this.startTime = now();
    }
    draw() {
      var currentTime = now() - this.startTime;
      var radius = baseRadius + animationTimeMultiplier * currentTime + radiusAmplitudeMultiplier * amplitude;
      var opacity = startOpacity - ((startOpacity - endOpacity) * currentTime / circleLifetime);
      if (opacity <= endOpacity) opacity = 0.0;
      drawCircle(radius, opacity);
    }
  }

  function drawCircle(radius, opacity) {
    canvasContext.save();
    canvasContext.beginPath();
    canvasContext.arc(canvas.width / 2, canvas.height / 2, radius, 0, Math.PI * 2, false);
    canvasContext.fillStyle = recordingNow() ? colorRecording : colorMonitoring;
    canvasContext.globalAlpha = opacity;
    canvasContext.fill();
    canvasContext.restore();
  }

  function animateMeter() {
    drawCircles();
    setInterval(function () {
      if (currentCircles.length == 3) currentCircles.remove(0, 0);
      currentCircles.push(new AnimatedCircle);
    }, interCircleInterval);

  }

  function drawCircles() {
    setInterval(function () {
      clearCanvas();
      drawCircle(baseRadius + radiusAmplitudeMultiplier * amplitude, startOpacity);
      currentCircles.forEach(c => c.draw());
    }, animationFrameDuration);
  }

  function clearCanvas() {
    const context = canvas.getContext('2d');
    context.clearRect(0, 0, canvas.width, canvas.height);
  }

  function monitorAmplitude() {
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
    javascriptNode.onaudioprocess = function () {
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

  function setCanvasSize() {
    canvas.width = parseInt(canvasStyle.getPropertyValue('width'), 10);
    canvas.height = parseInt(canvasStyle.getPropertyValue('height'), 10);
  }

  function now() {
    return new Date().getTime();
  }

  $(window).resize(function () {
    setCanvasSize();
  });

  // Timer
  //////////////////////////////////////////////////////////////////////////////////////////////////
  function formatTime(seconds) {
    var h = Math.floor(seconds / 3600),
      m = Math.floor(seconds / 60) % 60,
      s = seconds % 60;
    if (h < 10) { h = "0" + h };
    if (m < 10) { m = "0" + m };
    if (s < 10) { s = "0" + s };
    return `${h}:${m}:${s}`
  }

  function startTimer() {
    timer = setInterval(clock, 1000);
  }

  function pauseTimer() {
    clearInterval(timer);
  }

  function stopTimer() {
    clearInterval(timer);
    seconds = 0;
  }

  function clock() {
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
    navigator.mediaDevices.getUserMedia({ audio: true }).then(gotStream).then(monitorAmplitude).catch(handleError);
  }

  // Recording. Started with https://stackoverflow.com/a/16784618
  //////////////////////////////////////////////////////////////////////////////////////////////////
  function startRecording() {
    mediaRecorder = new MediaRecorder(recordStream);
    mediaRecorder.mimeType = 'audio/ogg';
    mediaRecorder.ondataavailable = function (e) {
      chunks.push(e.data);
      console.log(chunks.length);
      console.log('foo');
    }
    mediaRecorder.start();
  }

  function recordingNow() {
    return mediaRecorder && mediaRecorder.state == 'recording';
  }

  // As of now the callback is not being used because we are doing a redirect on the server
  function uploadAudio() {
    var blob = new Blob(chunks, { 'type': 'audio/ogg' });
    $.ajax({
      type: 'POST',
      url: '/upload',
      data: blob,
      contentType: 'audio/ogg',
      processData: false
    })
  }

  function resetRecord() {
    setTimeout(function () {
      $('#save-delete-container').hide();
      $('#record-start-button').show();
      $('#time-display').text('00:00:00');
    }, 500)
  }

  // Display is `none` initially, so ensure that display is `flex` when showing
  // Subsequent calls set display redundantly, but this keeps things simple
  jQuery.fn.showButton = function () {
    var elements = $(this[0])
    elements.css('display', 'flex');
    elements.show();
    return this;
  };

  function hideAllButtons() {
    $('.record-button, .record-button-hidden').hide();
  }

  // onload
  //////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function () {
    $('#record-audio').prop('muted', true);
    setCanvasSize();
    animateMeter();
    navigator.mediaDevices.enumerateDevices().then(getStream).catch(handleError);

    $('#record-container').removeClass('invisible');

    $('#record-start-button').click(function (event) {
      startRecording();
      startTimer();
      $('.record-button').hide();
      $('#record-pause-button').show();
    })

    $('#record-pause-button').click(function (event) {
      // TODO: Call pause instead when it's supported better
      mediaRecorder.stop();
      hideAllButtons();
      // $('#continue-button').show();
      $('#save-button').show();
      $('#delete-button').show();
      pauseTimer();
    })

    $('#continue-button').click(function () {
      mediaRecorder.resume();
      startTimer();
      hideAllButtons();
      $('#record-pause-button').show();
    })

    $('#save-button').click(function () {
      $('#overlay').addClass('visible');
      mediaRecorder.stop();
      uploadAudio();
    })

    $('#delete-button').click(function () {
      var confirmation = confirm("Are you sure that you want to delete this recording? (Can't undo)");
      if (confirmation) {
        resetRecord();
      }
    })
  });
}
