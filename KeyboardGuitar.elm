module KeyboardGuitar where

import Char
import Maybe
import Notes
import Keyboard
import SolarSystem exposing (..)

actionSignal : Signal SolarSystem.Action
actionSignal =
  Signal.map SolarSystem.AddChord keys

keys : Signal Notes.Chord
keys =
  Keyboard.presses
  |> Signal.map Char.fromCode
  |> Signal.map toChord
  |> Signal.filter (\maybe -> maybe /= Maybe.Nothing ) (Maybe.Just {notes = []})
  |> Signal.map (\maybe -> Maybe.withDefault {notes = []} maybe)

toChord: Char -> Maybe Notes.Chord
toChord ch =
  let
    chLower = Char.toLower ch
  in
    List.filter (\(c, _) -> c == chLower) mappings
    |> List.head
    |> Maybe.map snd

mappings : List (Char, Notes.Chord)
mappings =
  [
    ('a', Notes.am),
    ('c', Notes.c),
    ('g', Notes.g),
    ('f', Notes.f)
  ]
