module SongMapper where

import Models exposing (Planet)
import Notes

songToPlanets : Notes.Song -> List Planet
songToPlanets song =
  let
    speed = song.speed
    delayBetweenChords = song.delayBetweenChords
    untimedChords = (toPlanetsFromChords speed) song
    timedChords = List.indexedMap (delayChord delayBetweenChords) untimedChords
  in
    List.concat timedChords

toPlanetsFromChords : Float -> Notes.Song -> List (List Planet)
toPlanetsFromChords speed song =
  List.map (toNotes speed) song.chords

toNotes : Float -> Notes.Chord -> List Planet
toNotes speed chord =
  List.map (toPlanet2 speed) chord.notes

toPlanet2 : Float -> Float -> Planet
toPlanet2 speed note =
  let
    toPlanet (note) = {
      radius = note,
      speed = speed,
      ticksSinceHit = 100,
      angle = 0,
      instrument = "bass"
    }
  in
    toPlanet note

delayChord : Float -> Int -> List Planet -> List Planet
delayChord delayBetweenChords index list  =
  let
    delay (note) = {
      note | angle = (toFloat index) * delayBetweenChords
    }

  in
    List.map delay list
