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
	var shortSine = new Wad({
	    source : 'sine',
	    env : {
	        attack : 0,
	        decay : 0,
	        sustain : 0.5,
	        hold : 0,
	        release : 0.1
	    }
	});
	var longSine = new Wad({
	    source : 'sine',
	    env : {
	        attack : 0,
	        decay : 0,
	        sustain : 1.9,
	        hold : 0.4,
	        release : 0.2
	    }
	});
	var snareLoud = new Wad({
		 source : 'noise',
		 env : {
			 attack : 0.001,
			 decay : 0.01,
			 sustain : 0.8,
			 hold : 0.03,
			 release : 0.02
		 },
		 filter : {
			 type : 'bandpass',
			 frequency : 300,
			 q : 0.180
		 }
	});
	var instruments = {
		"saw": saw,
		"bass": bass,
		"shortSine": shortSine,
		"longSine": longSine,
		"hihatOpen": new Wad(Wad.presets.hiHatOpen),
		"hihatClosed": new Wad(Wad.presets.hiHatClosed),
		"snare": new Wad(Wad.presets.snare),
		"snareLoud": snareLoud,
		"piano": new Wad(Wad.presets.piano),
		"ghost": new Wad(Wad.presets.ghost),
	}
	var defaultInstrument = instruments["piano"];

	function getInstrument(instrument) {
		return instruments[instrument] || defaultInstrument;
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
