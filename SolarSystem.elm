module SolarSystem (..) where

-- MODEL

type alias Model =
  { count: Int
  }

type Action
  = Increment | Decrement

initialModel : Model
initialModel = { count = 0 }

-- UPDATE

update : Action -> Model -> Model
update action model =
  case action of
    Increment ->
      { model | count = model.count + 1 }
    Decrement ->
      { model | count = model.count - 1 }
