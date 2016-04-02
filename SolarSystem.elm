module SolarSystem (..) where

import Array as Array
import Maybe as Maybe
import Notes as Notes
import Models exposing (Model, Planet)
import SongMapper
-- MODEL



type Action
  = AddPlanet
  | ClearPlanets
  | Tick
  | AddNote Float
  | ClickAddPlanet Float
  | CanvasSizeUpdate (Int, Int)
  | NoOp
  | ParallaxUpdate (Float, Float)
  | SoundSelected String

toPlanets : List Float -> List Planet
toPlanets notes =
  let
    interval = 0.19
    indexes = [1..(List.length notes)]
    zipped = List.map2 (,) notes indexes
    toPlanet (note, index) = {
      radius = note,
      angle = (toFloat index) * interval,
      speed = 0.02,
      ticksSinceHit = 100,
      instrument = "saw"
    }
  in
    List.map toPlanet zipped

newPlanet: Int -> Planet
newPlanet index =
  let
    index = index % (Array.length Notes.defaultScale)
    radius = Array.get index Notes.defaultScale
             |> Maybe.withDefault Notes.c1
  in
    {
      radius = radius,
      angle = 0,
      speed = 0.03,
      ticksSinceHit = 0,
      instrument = (getInstrument radius)
    }

getInstrument : Float -> String
getInstrument r =
  case (round r) % 2 of
    0 -> "saw"
    _ -> "bass"


newPlanetWithFreq : Float -> Planet
newPlanetWithFreq freq =
    { radius = freq, angle = 0, speed = 0.03, ticksSinceHit = 0, instrument = "bass" }

roundToScale: Float -> Float
roundToScale origFreq =
  let
    scale = Array.toList Notes.defaultScale
    compareDifferences (_, diff1) (_, diff2) = compare diff1 diff2
    sorted = List.map (\f -> (f, abs (f - origFreq))) scale
          |> List.sortWith compareDifferences
          |> List.map fst
  in
    Maybe.withDefault Notes.c3 (List.head sorted)


initialModel : Model
initialModel =
  let
    -- Empty case:
    -- planets = []
    -- Example melody
    -- planets = toPlanets (List.reverse Notes.melody)
    planets = SongMapper.songToPlanets Notes.song1
  in
    { planets = planets, lastClick = "", canvasSize = (800, 800), parallax = (0, 0), sounds = "piano" }

-- UPDATE
fullRadius : Float
fullRadius = 2 * pi

hitEffectTickCount : Int
hitEffectTickCount = 10

-- TODO more sensible implementation
normalizeAngle : Float -> Float
normalizeAngle angle =
  if angle > fullRadius
    then normalizeAngle (angle - fullRadius)
    else angle

tick : Planet -> Planet
tick planet =
  let
    oldAngle = planet.angle
    newAngle = normalizeAngle (oldAngle + planet.speed)
    isHit = (newAngle /= (oldAngle + planet.speed))
    tickCount = if isHit then 0 else planet.ticksSinceHit + 1
  in
    {
      planet | angle = newAngle, ticksSinceHit = tickCount
    }

update : Action -> Model -> Model
update action model =
  case action of
    AddPlanet ->
      { model | planets = model.planets ++ [newPlanet (List.length model.planets)] }
    ClearPlanets ->
        { model | planets = [] }
    Tick ->
        { model | planets = List.map tick model.planets}
    AddNote freq ->
        { model | planets = model.planets ++ [newPlanetWithFreq freq] }
    ClickAddPlanet x ->
        { model | planets = model.planets ++ [newPlanetWithFreq (roundToScale x)] }
    CanvasSizeUpdate s ->
        { model | canvasSize = s}
    SoundSelected s ->
        { model | sounds = (Debug.log "sound selected" s)}
    NoOp -> model
    ParallaxUpdate p ->
      { model | parallax = p }
