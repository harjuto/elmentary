var solarsystem = Elm.worker(Elm.Audio, {});

solarsystem.ports.audio.subscribe(audio);

function audio(sound) {
  console.log(sound);
}
