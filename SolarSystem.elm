module SolarSystem (..) where

import Array as Array
import Maybe as Maybe
import Notes as Notes

-- MODEL

type alias Planet =
  {
    radius: Float, -- Radius from the center of the solar system
    angle: Float, -- Angle at the angular orbit
    speed: Float, -- Angular speed
    ticksSinceHit: Int
  }

type alias Model =
  {
    planets: List Planet
  }

type Action
  = AddPlanet | RemoveLastPlanet | Tick

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
      ticksSinceHit = 100
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
    { radius = radius, angle = 0, speed = 0.03, ticksSinceHit = 0 }

initialModel : Model
initialModel =
  let
    -- Empty case:
    -- planets = []
    -- Example melody
    planets = toPlanets (List.reverse Notes.melody)
  in
    { planets = planets }

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
    RemoveLastPlanet ->
      let
        removeLast planets = if List.length planets == 0 then [] else List.take (List.length planets - 1) planets
      in
        { model | planets = removeLast model.planets }
    Tick ->
        { model | planets = List.map tick model.planets}
