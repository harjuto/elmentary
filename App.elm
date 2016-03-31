-- From http://www.elm-tutorial.org/040_effects/startapp_with_effects.html
module Main (..) where

import Effects exposing (Effects, Never)
import Html exposing (div, button, text, fromElement)
import Html.Events exposing (onClick)
import SolarSystem as SolarSystem
import StartApp
import Task
import View exposing (..)


view : Signal.Address SolarSystem.Action -> SolarSystem.Model -> Html.Html
view address model =
  div []
    [
      div [] [ text (toString model.planets) ]
    , button [ onClick address SolarSystem.RemoveLastPlanet ] [ text "-" ]
    , button [ onClick address SolarSystem.AddPlanet ] [ text "+" ]
    , button [ onClick address SolarSystem.Tick ] [ text "!" ]
    , fromElement (View.canvas model)
    ]

init : ( SolarSystem.Model, Effects SolarSystem.Action )
init =
  (  SolarSystem.initialModel, Effects.none )


update : SolarSystem.Action ->  SolarSystem.Model -> ( SolarSystem.Model, Effects.Effects SolarSystem.Action )
update action model =
  (SolarSystem.update action model, Effects.none)


app : StartApp.App SolarSystem.Model
app =
  StartApp.start
    { init = init
    , inputs = []
    , update = update
    , view = view
    }


main : Signal.Signal Html.Html
main =
  app.html


port runner : Signal (Task.Task Never ())
port runner =
  app.tasks
