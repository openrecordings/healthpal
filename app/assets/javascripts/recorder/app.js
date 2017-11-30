// fork getUserMedia for multiple browser versions, for the future
// when more browsers support MediaRecorder

State = {
  BEGIN: 'begin-record',
  RECORDING: 'recording',
  RECORDED: 'recorded',
  UPLOADED: 'uploaded'
}

navigator.getUserMedia = ( navigator.getUserMedia ||
                       navigator.webkitGetUserMedia ||
                       navigator.mozGetUserMedia ||
                       navigator.msGetUserMedia);

// set up basic variables for app

var record = document.querySelector('.record');
if ($('.record').length > 0) {
  setState(State.BEGIN);
  var stop = document.querySelector('.stop');
  var soundClips = document.querySelector('.sound-clips');
  var progress = document.createElement('progress');
  progress.value = 0;

  // disable stop button while not recording
  stop.disabled = true;

  // visualiser setup - create web audio api context
  var audioCtx = new (window.AudioContext || webkitAudioContext)();

  //main block for doing the audio recording
  if (navigator.getUserMedia) {
    var constraints = { audio: true };
    var chunks = [];
    var onSuccess = function(stream) {
      var mediaRecorder = new MediaRecorder(stream);
      visualize(stream);
      record.onclick = function() {
        setState(State.RECORDING);
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
        setState(State.RECORDED);
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
        clipContainer.appendChild(progress);
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
            setState(State.BEGIN);
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
      alert('The following error occured: ' + err);
    }

    navigator.getUserMedia(constraints, onSuccess, onError);
  } else {
    alert('getUserMedia not supported on your browser!');
  }
}
var mem = new Array();
var memi = 0;
var gain = 7;

function visualize(stream) {
  var source = audioCtx.createMediaStreamSource(stream);
  var analyser = audioCtx.createAnalyser();
  analyser.fftSize = 2048;
  var bufferLength = analyser.frequencyBinCount;
  var dataArray = new Float32Array(bufferLength);
  source.connect(analyser);
  HEIGHT = $("#vui").height();
  draw();
  function draw() {
    requestAnimationFrame(draw);
    analyser.getFloatTimeDomainData(dataArray);
    var sumAmpSquared = dataArray.reduce((a, b) => a + Math.pow(b, 2.0), 0.0);
    var rms = Math.pow((sumAmpSquared * 1.0 / dataArray.length), 0.5);
    var rmsPixels = rms * HEIGHT;
    mem[memi++&15] = rmsPixels;
    var level = HEIGHT - ((mem.reduce((a, b) => a + b, 0)) / mem.length * gain);
    $("#vu1").css({height: level + 'px'});
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
          progress.value = percentComplete;
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
  setState(State.UPLOADED);
}

function hideControls() {
  $('.main-controls').hide();
}

function showControls() {
  $('.main-controls').show();
}

function setState(state) {
  $('.state').hide();
  $('.' + state).show();
}
