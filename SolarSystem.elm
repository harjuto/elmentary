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
  = AddPlanet | RemoveLastPlanet

newPlanet: Float -> Planet
newPlanet radius = { radius = radius, angle = 0, speed = 1 }

initialModel : Model
initialModel = { planets = [] }

-- UPDATE

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
