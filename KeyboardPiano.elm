module KeyboardPiano (..) where

import Char
import Maybe
import Notes
import Keyboard
import SolarSystem

actionSignal : Signal SolarSystem.Action
actionSignal =
  Signal.map SolarSystem.ClickAddPlanet keys

keys : Signal Float
keys =
  Keyboard.presses
  |> Signal.map Char.fromCode
  |> Signal.map toNote
  |> Signal.filter (\maybe -> maybe /= Maybe.Nothing ) (Maybe.Just 0)
  |> Signal.map (\maybe -> Maybe.withDefault 0 maybe)

toNote: Char -> Maybe Float
toNote ch =
  let
    chLower = Char.toLower ch
  in
    List.filter (\(c, _) -> c == chLower) mappings
    |> List.head
    |> Maybe.map snd

mappings : List (Char, Float)
mappings =
  [
    ('z', Notes.c4),
    ('s', Notes.cis4),
    ('x', Notes.d4),
    ('d', Notes.dis4),
    ('c', Notes.e4),
    ('v', Notes.f4),
    ('g', Notes.fis4),
    ('b', Notes.g4),
    ('h', Notes.gis4),
    ('n', Notes.a4),
    ('j', Notes.ais4),
    ('m', Notes.b4),
    (',', Notes.c5),
    ('l', Notes.cis5),
    ('.', Notes.d5),
    ('ö', Notes.dis5),
    ('-', Notes.e5),
    ('q', Notes.c5),
    ('2', Notes.cis5),
    ('w', Notes.d5),
    ('3', Notes.dis5),
    ('e', Notes.e5),
    ('r', Notes.f5),
    ('5', Notes.fis5),
    ('t', Notes.g5),
    ('6', Notes.gis5),
    ('y', Notes.a5),
    ('7', Notes.ais5),
    ('u', Notes.b5),
    ('i', Notes.c5),
    ('9', Notes.cis5),
    ('o', Notes.d5),
    ('0', Notes.dis5),
    ('p', Notes.e5),
    ('+', Notes.f5)
  ]
