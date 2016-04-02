-- From http://www.elm-tutorial.org/040_effects/startapp_with_effects.html
module Main (..) where

import Effects exposing (Effects, Never)
import Html as H exposing (Html)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id)
import Time
import Time exposing (..)
import Task
import KeyboardPiano
import KeyboardGuitar
import SolarSystem
import Models exposing (Model, Planet)
import StartApp
import View exposing (..)
import Style exposing (..)


view : Signal.Address SolarSystem.Action -> Model -> H.Html

view address model =
  H.div [ Style.container ]
    [
      H.div [ Style.canvas ] [H.fromElement (View.canvas model)]
    , H.div [ Style.controls ] [
        H.div [] [ H.text model.lastClick ]
      , H.button [ onClick address SolarSystem.ClearPlanets, id "reset" ] [ H.text "Reset" ]
    ]

    ]


-- startMailbox & sendInitialSignal for getting the inital window dimensions

startMailbox : Signal.Mailbox ()
startMailbox =
  Signal.mailbox ()

sendInitialSignal : Effects SolarSystem.Action
sendInitialSignal =
    Signal.send startMailbox.address ()
        |> Task.map (always SolarSystem.NoOp)
        |> Effects.task

init : ( Model, Effects SolarSystem.Action )
init =
  (  SolarSystem.initialModel, sendInitialSignal )


update : SolarSystem.Action ->  Model -> ( Model, Effects.Effects SolarSystem.Action )
update action model =
    (SolarSystem.update action model, Effects.none)

timeSignal : Signal Time.Time
timeSignal =
  Time.fps 30

tickSignal : Signal SolarSystem.Action
tickSignal =
  Signal.map (\_ -> SolarSystem.Tick) timeSignal


app : StartApp.App Model
app =
  let
    initialCanvasSize = View.initialCanvasSizeSignal startMailbox.signal
  in
    StartApp.start
      { init = init
      , inputs = [tickSignal, View.canvasSizeSignal, View.actionSignal, KeyboardGuitar.actionSignal, initialCanvasSize]
      , update = update
      , view = view
      }

hitPlanets : Signal (List Planet)
hitPlanets =
  Signal.map (.planets) app.model
    |> Signal.map (List.filter ( \planet -> planet.ticksSinceHit == 0))
    |> Signal.filter (\ps -> not (List.isEmpty ps)) []

main : Signal.Signal H.Html
main =
  app.html

getSound : Planet -> (Int, String)
getSound planet =
  (round (planet.radius), planet.instrument)

port audio : Signal (List (Int, String))
port audio =
  hitPlanets
  |> Signal.map (\ps -> List.map getSound ps )
