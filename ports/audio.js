function setupAudio(solarsystem) {
	solarsystem.ports.audio.subscribe(audio);

	var saw = new Wad({
		source : 'sawtooth',
		env: {
			attack: 0.03,
			decay: 0.02,
			sustain: 1.0,
			hold: 0.3,
			release: 0.1
		}
	});
	var bass = new Wad({
			    source : 'sine',
			    env : {
			        attack : 0.02,
			        decay : 0.1,
			        sustain : 0.9,
			        hold : 0.4,
			        release : 0.1
			    }
			});

	function getInstrument(instrument) {
		if (instrument === 'saw') {
			return saw;
		} else {
			return bass;
		}
	}

	function playNote(freq, instrument) {
		console.log('playNote: ' + freq + ' using: ' + instrument);
	  if (freq > 20 && freq < 20000){
	    getInstrument(instrument).play({pitch: freq});
	  } else {
	    console.log('Frequency is outside human hearing: ' + freq);
	  }
	}

	function audio(freqs) {
		for (var i = 0; i < freqs.length; i++) {
			playNote(freqs[i][0], freqs[i][1]);
		}
	}
}
