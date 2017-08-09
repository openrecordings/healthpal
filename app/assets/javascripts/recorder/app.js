// fork getUserMedia for multiple browser versions, for the future
// when more browsers support MediaRecorder

navigator.getUserMedia = ( navigator.getUserMedia ||
                       navigator.webkitGetUserMedia ||
                       navigator.mozGetUserMedia ||
                       navigator.msGetUserMedia);

// set up basic variables for app

var record = document.querySelector('.record');
var stop = document.querySelector('.stop');
var soundClips = document.querySelector('.sound-clips');
var canvas = document.querySelector('.visualizer');
var meter = document.createElement('meter')

// disable stop button while not recording
stop.disabled = true;

// visualiser setup - create web audio api context and canvas
var audioCtx = new (window.AudioContext || webkitAudioContext)();
var canvasCtx = canvas.getContext("2d");

//main block for doing the audio recording
if (navigator.getUserMedia) {
  var constraints = { audio: true };
  var chunks = [];
  var onSuccess = function(stream) {
    var mediaRecorder = new MediaRecorder(stream);
    visualize(stream);
    record.onclick = function() {
      mediaRecorder.start();
      record.style.background = "red";

      stop.disabled = false;
      record.disabled = true;
    }
    stop.onclick = function() {
      mediaRecorder.stop();
      record.style.background = "";
      record.style.color = "";
      // mediaRecorder.requestData();

      stop.disabled = true;
      record.disabled = false;
      hideControls();
    }
    mediaRecorder.onstop = function(e) {
      var clipName = new Date().toLocaleString();
      var clipContainer = document.createElement('article');
      var clipLabel = document.createElement('p');
      var audio = document.createElement('audio');
      var deleteButton = document.createElement('button');
      var uploadButton = document.createElement('button');
      clipContainer.classList.add('clip');
      audio.setAttribute('controls', '');
      deleteButton.textContent = 'Delete';
      deleteButton.className = 'delete btn btn-primary';
      uploadButton.textContent = 'Upload';
      uploadButton.className = 'upload btn btn-primary';
      if(clipName === null) {
        clipLabel.textContent = 'My unnamed clip';
      } else {
        clipLabel.textContent = clipName;
      }
      clipContainer.appendChild(audio);
      clipContainer.appendChild(clipLabel);
      clipContainer.appendChild(uploadButton);
      clipContainer.appendChild(deleteButton);
      clipContainer.appendChild(meter);
      soundClips.appendChild(clipContainer);
      audio.controls = true;
      var blob = new Blob(chunks, { 'type' : 'audio/ogg; codecs=opus' });
      chunks = [];
      var audioURL = window.URL.createObjectURL(blob);
      audio.src = audioURL;
      deleteButton.onclick = function(e) {
        var response = confirm('Are you sure you want to delete this recording?');
        if(response == true){
          evtTgt = e.target;
          evtTgt.parentNode.parentNode.removeChild(evtTgt.parentNode);
          showControls();
        }
      }
      uploadButton.onclick = function() {upload(blob)};
      clipLabel.onclick = function() {
        var existingName = clipLabel.textContent;
        var newClipName = prompt('Enter a new name for your sound clip?');
        if(newClipName === null) {
          clipLabel.textContent = existingName;
        } else {
          clipLabel.textContent = newClipName;
        }
      }
    }
    mediaRecorder.ondataavailable = function(e) {
      chunks.push(e.data);
    }
  }

  var onError = function(err) {
    console.log('The following error occured: ' + err);
  }

  navigator.getUserMedia(constraints, onSuccess, onError);
} else {
   console.log('getUserMedia not supported on your browser!');
}

function visualize(stream) {
  var source = audioCtx.createMediaStreamSource(stream);
  var analyser = audioCtx.createAnalyser();
  analyser.fftSize = 2048;
  var bufferLength = analyser.frequencyBinCount;
  var dataArray = new Float32Array(bufferLength);
  source.connect(analyser);
  WIDTH = canvas.width
  HEIGHT = canvas.height;
  draw()
  function draw() {
    requestAnimationFrame(draw);
    analyser.getFloatTimeDomainData(dataArray);
    canvasCtx.fillStyle = 'rgb(200, 200, 200)';
    canvasCtx.fillRect(0, 0, WIDTH, HEIGHT);
    var sumAmpSquared = 0.0;
    for(var i = 0; i < bufferLength; i++) {
      sumAmpSquared += Math.pow(dataArray[i], 2.0);
    } 
    var rms = Math.pow((sumAmpSquared * 1.0 / i), 0.5);
    var rmsPixels = rms * HEIGHT * 10; // Arbitrary multiplier because RMS is typically low
    canvasCtx.fillStyle = 'rgb(100, 800, 100)';
    canvasCtx.fillRect(0, HEIGHT - rmsPixels, WIDTH, HEIGHT);
  }
}

function upload(blob) {
  var fd = new FormData();
  fd.append('data', blob);
  $.ajax({
    xhr: function() {
      var xhr = new window.XMLHttpRequest();
      xhr.upload.addEventListener("progress", function(evt) {
        if (evt.lengthComputable) {
          var percentComplete = evt.loaded / evt.total;
          meter.value = percentComplete;
          }
       }, false);
       return xhr;
    },
    type: 'POST',
    url: '/upload',
    data: fd,
    processData: false,
    contentType: false,
    success: successfulUpload
  })
}

function successfulUpload(data) {
  alert('Audio successfully uploaded.')
  $('.clip').remove();
  showControls();
}

function hideControls() {
  $('.main-controls').hide();
}

function showControls() {
  $('.main-controls').show();
}
