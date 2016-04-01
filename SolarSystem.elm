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

defaultNotes = Array.fromList [Notes.c4, Notes.d4, Notes.e4, Notes.f4, Notes.g4, Notes.a4, Notes.b4, Notes.c5, Notes.c5, Notes.d5, Notes.e5, Notes.f5, Notes.g5, Notes.a5, Notes.b5, Notes.c6]

newPlanet: Int -> Planet
newPlanet index =
  let
    index = index % (Array.length defaultNotes)
    radius = Array.get index defaultNotes
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
