module SolarSystem (..) where

-- MODEL

type alias Planet =
  {
    radius: Float, -- Radius from the center of the solar system
    angle: Float, -- Angle at the angular orbit
    speed: Float -- Angular speed
  }
type alias Model =
  {
    planets: List Planet
  }

type Action
  = AddPlanet | RemoveLastPlanet | Tick

newPlanet: Float -> Planet
newPlanet radius = { radius = radius, angle = 0, speed = 1 }

initialModel : Model
initialModel = { planets = [] }

-- UPDATE

fullRadius = 2 * pi

-- TODO more sensible implementation
normalizeAngle angle =
  if angle > fullRadius
    then normalizeAngle (angle - fullRadius)
    else angle

tick planet =
  let
    oldAngle = planet.angle
    newAngle = normalizeAngle (oldAngle + planet.speed)
  in
    { planet | angle = newAngle }

update : Action -> Model -> Model
update action model =
  case action of
    AddPlanet ->
      { model | planets = model.planets ++ [newPlanet (toFloat (List.length model.planets))] }
    RemoveLastPlanet ->
      let
        removeLast planets = if List.length planets == 0 then [] else List.take (List.length planets - 1) planets
      in
        { model | planets = removeLast model.planets }
    Tick ->
        { model | planets = List.map tick model.planets}
