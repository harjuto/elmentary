module SongMapper where

import Models exposing (Planet)
import Notes

songToPlanets : Notes.Song -> List Planet
songToPlanets song =
  let
    untimedChords = toPlanetsFromChords song
    timedChords = List.indexedMap delayChord untimedChords
  in
    List.concat timedChords

toPlanetsFromChords : Notes.Song -> List (List Planet)
toPlanetsFromChords song =
  List.map toNotes song.chords

toNotes : Notes.Chord -> List Planet
toNotes chord =
  List.map toPlanet2 chord.notes

toPlanet2 : Float -> Planet
toPlanet2 note =
  let
    toPlanet (note) = {
      radius = note,
      speed = 0.03,
      ticksSinceHit = 100,
      angle = 0,
      instrument = "bass"
    }
  in
    toPlanet note

delayChord : Int -> List Planet -> List Planet
delayChord index list  =
  let
    delay (note) = {
      note | angle = (toFloat index) * 0.35
    }

  in
    List.map delay list
