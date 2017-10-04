$(document).ready(function(){
	var audio = document.createElement('audio');
	audio.setAttribute('src','/send_audio/28');
	audio.setAttribute('controls','controls');
	audio.load();
	document.body.append(audio);
})
