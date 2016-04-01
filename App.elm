-- From http://www.elm-tutorial.org/040_effects/startapp_with_effects.html
module Main (..) where

import Effects exposing (Effects, Never)
import Html exposing (div, button, text, fromElement)
import Html.Events exposing (onClick)
import Time as Time
import Time exposing (..)
import SolarSystem as SolarSystem
import StartApp
import Task
import Debug as Debug
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
  let
    newModel = SolarSystem.update action model
  in
    (SolarSystem.update action model, Effects.none)

timeSignal : Signal Time.Time
timeSignal =
  Time.fps 10

tickSignal : Signal SolarSystem.Action
tickSignal =
  Signal.map (\_ -> SolarSystem.Tick) timeSignal


app : StartApp.App SolarSystem.Model
app =
  StartApp.start
    { init = init
    , inputs = [tickSignal]
    , update = update
    , view = view
    }

hitPlanets : Signal (List SolarSystem.Planet)
hitPlanets =
  Signal.map (\model -> model.planets) app.model
  |> Signal.map (List.filter (\planet -> planet.hit))
  |> Signal.filter (\ps -> not (List.isEmpty ps)) []

main : Signal.Signal Html.Html
main =
  app.html

logTee : a -> a
logTee x =
  Debug.log ("debug log" ++ (toString x))
  x

port audio : Signal Int
port audio =
  Signal.map random hitPlanets
  |> Signal.map logTee

random t =
  (1 + List.length (t)) * 100
