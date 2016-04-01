-- From http://www.elm-tutorial.org/040_effects/startapp_with_effects.html
module Main (..) where

import Effects exposing (Effects, Never)
import Html exposing (div, button, text, fromElement)
import Html.Events exposing (onClick)
import Time
import Time exposing (..)
import KeyboardPiano
import SolarSystem
import StartApp
import View exposing (..)
import Style exposing (..)


view : Signal.Address SolarSystem.Action -> SolarSystem.Model -> Html.Html
view address model =
  div [ Style.container ]
    [
      div [ Style.canvas ] [fromElement (View.canvas model)]
    , div [ Style.controls ] [
        div [] [ text model.lastClick ]
      , button [ onClick address SolarSystem.ClearPlanets ] [ text "-" ]
      , button [ onClick address SolarSystem.AddPlanet ] [ text "+" ]
      , button [ onClick address SolarSystem.Tick ] [ text "!" ]
      -- , div [] [ text (toString model.planets) ]
    ]

    ]

init : ( SolarSystem.Model, Effects SolarSystem.Action )
init =
  (  SolarSystem.initialModel, Effects.none )


update : SolarSystem.Action ->  SolarSystem.Model -> ( SolarSystem.Model, Effects.Effects SolarSystem.Action )
update action model =
  let
    newModel = SolarSystem.update action model
  in
    (SolarSystem.update action model, Effects.none)

timeSignal : Signal Time.Time
timeSignal =
  Time.fps 30

tickSignal : Signal SolarSystem.Action
tickSignal =
  Signal.map (\_ -> SolarSystem.Tick) timeSignal


app : StartApp.App SolarSystem.Model
app =
  StartApp.start
    { init = init
    , inputs = [tickSignal, View.actionSignal, KeyboardPiano.actionSignal]
    , update = update
    , view = view
    }

hitPlanets : Signal (List SolarSystem.Planet)
hitPlanets =
  Signal.map (.planets) app.model
    |> Signal.map (List.filter ( \planet -> planet.ticksSinceHit == 0))
    |> Signal.filter (\ps -> not (List.isEmpty ps)) []

main : Signal.Signal Html.Html
main =
  app.html

getSound : SolarSystem.Planet -> (Int, String)
getSound planet =
  (round (planet.radius), planet.instrument)

port audio : Signal (List (Int, String))
port audio =
  hitPlanets
  |> Signal.map (\ps -> List.map getSound ps )
