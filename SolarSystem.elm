module SolarSystem (..) where

-- MODEL

type alias Planet =
  {
    radius: Float,
    angle: Float,
    speed: Float
  }
type alias Model =
  { count: Int,
    planets: List Planet
  }

type Action
  = Increment | Decrement

newPlanet: Planet
newPlanet = { radius = 1, angle = 0, speed = 1 }

initialModel : Model
initialModel = { count = 0, planets = [] }

-- UPDATE

update : Action -> Model -> Model
update action model =
  case action of
    Increment ->
      { model | count = model.count + 1, planets = model.planets ++ [newPlanet] }
    Decrement ->
      let
        removeLast planets = if List.length planets == 0 then [] else List.take (List.length planets - 1) planets
      in
        { model | count = model.count - 1, planets = removeLast model.planets }
