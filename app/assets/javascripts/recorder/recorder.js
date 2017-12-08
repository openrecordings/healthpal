// fork getUserMedia for multiple browser versions, for the future
// when more browsers support MediaRecorder

var timer;
var blob;
var chunks = [];

State = {
  BEGIN: 'begin-record',
  RECORDING: 'recording',
  RECORDED: 'recorded',
}

navigator.getUserMedia = ( navigator.getUserMedia ||
                       navigator.webkitGetUserMedia ||
                       navigator.mozGetUserMedia ||
                       navigator.msGetUserMedia);

if ($('.record').length > 0) {
  setState(State.BEGIN);
  var soundClips = document.querySelector('.sound-clips');

  // visualiser setup - create web audio api context
  var audioCtx = new (window.AudioContext || webkitAudioContext)();

  //main block for doing the audio recording
  if (navigator.getUserMedia) {
    var constraints = { audio: true };
    var onSuccess = function(stream) {
      var mediaRecorder = new MediaRecorder(stream);
      visualize(stream);
      $('.record').click(function() {
        timer.start();
        setState(State.RECORDING);
        mediaRecorder.start();
      });
      $('.stop').click(function() {
        timer.stop();
        mediaRecorder.stop();
        // mediaRecorder.requestData();
        setState(State.RECORDED);
      });
      mediaRecorder.onstop = function(e) {
        var clipName = new Date().toLocaleString();
        var clipContainer = document.createElement('article');
        var clipLabel = document.createElement('p');
        var audio = document.createElement('audio');
        clipContainer.classList.add('clip');
        //audio.setAttribute('controls', '');
        if(clipName === null) {
          clipLabel.textContent = 'My unnamed clip';
        } else {
          clipLabel.textContent = clipName;
        }
        clipContainer.appendChild(audio);
        //clipContainer.appendChild(clipLabel);
        $('#clipLabel').html(clipLabel);
        soundClips.appendChild(clipContainer);
        //audio.controls = true;
        blob = new Blob(chunks, { 'type' : 'audio/ogg; codecs=opus' });
        chunks = [];
        var audioURL = window.URL.createObjectURL(blob);
        player.set_audio(audioURL);
        audio.src = audioURL;
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
  console.log("upload");
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
  window.location.href = '/recording_saved';
}

function setState(state) {
  $('.state').hide();
  $('.' + state).show();
}

$(document).ready(function(){
  timer = new timerState({id: '#rectimer'});
  $('#deleteButton').click(function() {
    var response = confirm('Are you sure you want to delete this recording?');
    if(response == true){
      setState(State.BEGIN);
    }
  });
  $('#uploadButton').click(function() {upload(blob)});
});
