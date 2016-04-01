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
    hit: Bool
  }
type alias Model =
  {
    planets: List Planet
  }

type Action
  = AddPlanet | RemoveLastPlanet | Tick

newPlanet: Int -> Planet
newPlanet index =
  let
    index = index % (Array.length Notes.defaultScale)
    radius = Array.get index Notes.defaultScale
             |> Maybe.withDefault Notes.c1
  in
    { radius = radius, angle = 0, speed = 0.1, hit = False }

initialModel : Model
initialModel =
  let
    planets = []
  in
    { planets = planets }

-- UPDATE

fullRadius : Float
fullRadius = 2 * pi

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
    hit = (newAngle /= (oldAngle + planet.speed))
  in
    {
      planet | angle = newAngle, hit = hit

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
