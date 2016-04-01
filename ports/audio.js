function setupAudio(solarsystem) {
	solarsystem.ports.audio.subscribe(audio);

	var saw = new Wad({source : 'sawtooth'});
	var bass = new Wad({
			    source : 'sine',
			    env : {
			        attack : 0.02,
			        decay : 0.1,
			        sustain : 0.9,
			        hold : 0.4,
			        release : 0.1
			    },
			    filter : {
			        type : 'bandpass',
			        frequency : 100,
			        q : 0.180
			    }
			});
	function playNote(freq) {
		console.log('playNote: ' + freq);
	  if (freq > 20 && freq < 20000){
	    bass.play({pitch: freq});
	  } else {
	    console.log('Frequency is outside human hearing: ' + freq);
	  }
	}
	function audio(freqs) {
		console.log('audio.js: ' + freqs);
		for (var i = 0; i < freqs.length; i++) {
			playNote(freqs[i]);
		}
	}
}
