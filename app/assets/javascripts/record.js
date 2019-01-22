const videoElement = document.querySelector('video');
const audioSelect = document.querySelector('select#audioSource');
const videoSelect = document.querySelector('select#videoSource');
var streamRecorder;
var recordStream;

// Wrap entire file in conditional, verifying that we are on the recording page
if(videoElement && audioSelect &&  videoSelect) {

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
    recordStream = stream;
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

  function startStream(){
    navigator.mediaDevices.enumerateDevices()
      .then(gotDevices).then(getStream).catch(handleError);
  }

  // Recording. Started with https://stackoverflow.com/a/16784618
  //////////////////////////////////////////////////////////////////////////////////////////////////
  function onVideoFail(e) {
    console.log('webcam fail!', e);
  };

  function startRecording() {
    console.log('startRecording');
    // var mediaRecorder = new MediaRecorder(recordStream);
    // mediaRecorder.mimeType = 'video/webm';
    // mediaRecorder.ondataavailable = function(blob) {
    //   videoElement.srcObject = recordStream;
    //   postMediaToServer(videoElement.srcObject);
    // };
    // mediaRecorder.start(3000)
    // setTimeout(stopRecording, 10000);
  }

  function stopRecording() {
    // TODO
  }

  function postMediaToServer(mediaBlob) {
    // var data = {};
    // data.video = mediaBlob;
    // data.metadata = 'test metadata';
    // data.action = "upload_video";
    // jQuery.post('/upload', data, onUploadSuccess);
  }

  function onUploadSuccess() {
    console.log('video uploaded');
  }

  // Audio level measurement starts here
  ////////////////////////////////////////////////////////////////////////////////////////////////
  // https://github.com/cwilso/volume-meter/blob/master/volume-meter.js

  /*
  The MIT License (MIT)

  Copyright (c) 2014 Chris Wilson

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  */

  /*

  Usage:
  audioNode = createAudioMeter(audioContext,clipLevel,averaging,clipLag);

  audioContext: the AudioContext you're using.
  clipLevel: the level (0 to 1) that you would consider "clipping".
     Defaults to 0.98.
  averaging: how "smoothed" you would like the meter to be over time.
     Should be between 0 and less than 1.  Defaults to 0.95.
  clipLag: how long you would like the "clipping" indicator to show
     after clipping has occured, in milliseconds.  Defaults to 750ms.

  Access the clipping through node.checkClipping(); use node.shutdown to get rid of it.
  */

  function createAudioMeter(audioContext,clipLevel,averaging,clipLag) {
    var processor = audioContext.createScriptProcessor(512);
    processor.onaudioprocess = volumeAudioProcess;
    processor.clipping = false;
    processor.lastClip = 0;
    processor.volume = 0;
    processor.clipLevel = clipLevel || 0.98;
    processor.averaging = averaging || 0.95;
    processor.clipLag = clipLag || 750;

    // this will have no effect, since we don't copy the input to the output,
    // but works around a current Chrome bug.
    processor.connect(audioContext.destination);

    processor.checkClipping =
      function(){
        if (!this.clipping)
          return false;
        if ((this.lastClip + this.clipLag) < window.performance.now())
          this.clipping = false;
        return this.clipping;
      };

    processor.shutdown =
      function(){
        this.disconnect();
        this.onaudioprocess = null;
      };

    return processor;
  }

  function volumeAudioProcess( event ) {
    var buf = event.inputBuffer.getChannelData(0);
      var bufLength = buf.length;
    var sum = 0;
      var x;

    // Do a root-mean-square on the samples: sum up the squares...
      for (var i=0; i<bufLength; i++) {
        x = buf[i];
        if (Math.abs(x)>=this.clipLevel) {
          this.clipping = true;
          this.lastClip = window.performance.now();
        }
        sum += x * x;
      }

      // ... then take the square root of the sum.
      var rms =  Math.sqrt(sum / bufLength);

      // Now smooth this out with the averaging factor applied
      // to the previous sample - take the max here because we
      // want "fast attack, slow release."
      this.volume = Math.max(rms, this.volume*this.averaging);
  }

  // Audio level display starts here
  ////////////////////////////////////////////////////////////////////////////////////////////////
  // https://ourcodeworld.com/articles/read/413/how-to-create-a-volume-meter-measure-the-sound-
  // level-in-the-browser-with-javascript
  /*
  The MIT License (MIT)

  Copyright (c) 2014 Chris Wilson

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  */
  if(videoElement.length > 0 && audioSelect.length > 0 && videoSelect.length > 0){
    var audioContext = null;
    var meter = null;
    var canvasContext = null;
    var WIDTH=500;
    var HEIGHT=50;
    var rafID = null;

    function onMicrophoneDenied() {
        alert('Stream generation failed.');
    }

    var mediaStreamSource = null;

    function onMicrophoneGranted(stream) {
        // Create an AudioNode from the stream.
        mediaStreamSource = audioContext.createMediaStreamSource(stream);

        // Create a new volume meter and connect it.
        meter = createAudioMeter(audioContext);
        mediaStreamSource.connect(meter);

        // kick off the visual updating
        onLevelChange();
    }

    function onLevelChange( time ) {
        // clear the background
        canvasContext.clearRect(0,0,WIDTH,HEIGHT);

        // check if we're currently clipping
        if (meter.checkClipping())
            canvasContext.fillStyle = "red";
        else
            canvasContext.fillStyle = "green";

        // draw a bar based on the current volume
        canvasContext.fillRect(0, 0, meter.volume * WIDTH * 1.4, HEIGHT);

        // set up the next visual callback
        rafID = window.requestAnimationFrame( onLevelChange );
    }
  }
      
// Audio meter display starts here
////////////////////////////////////////////////////////////////////////////////////////////
function startAudioMeter(){
  let video = document.getElementById('record-video');
  // grab our canvas
  canvasContext = document.getElementById('record-audio-meter').getContext("2d");
  // monkeypatch Web Audio
  window.AudioContext = window.AudioContext || window.webkitAudioContext;
  // grab an audio context
  audioContext = new AudioContext();
  // Attempt to get audio input
  try {
      // ask for an audio input
      navigator.mediaDevices.getUserMedia(
      {
          "audio": {
              "mandatory": {
                  "googEchoCancellation": "false",
                  "googAutoGainControl": "false",
                  "googNoiseSuppression": "false",
                  "googHighpassFilter": "false"
              },
              "optional": []
          },
      }, onMicrophoneGranted, onMicrophoneDenied);
  } catch (e) {
      alert('getUserMedia threw exception :' + e);
  }
}

  // onload
  //////////////////////////////////////////////////////////////////////////////////////////////////
  $(document).ready(function() {
    if (hasGetUserMedia()) {
      $('#media-start-button').click(function(){
        startStream();
        startAudioMeter();
      })

      $('#record-start-button').click(function(){ startRecording(); })

      $('#record-stop-button').click(function(){
        stopRecording();
        stopStream();
      })
      
      // TODO: handle turning tracks on/off
      // Initialize to recording nothing
      // let audioTrackOn = false;
      // let videoTrackOn = false;
      //
      // Listen for a/v selection and set stream to record audio and/or video
      // $("[name='requested-media']").click(function(){
      //   let requestedMedia = $(this).data('requested-media');
      //   switch(requestedMedia){
      //     case 'audio':
      //       audioTrackOn = true;
      //       break;
      //     case 'video':
      //       videoTrackOn = true;
      //       break;
      //     case 'audio-video':
      //       audioTrackOn = true;
      //       videoTrackOn = true;
      //   }
      // })
      } else {
      //TODO: Alert the user
      console.log('getUserMedia not found');  
    }
  });
// Close conditional wrapping entire file
}
