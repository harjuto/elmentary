-- From http://www.elm-tutorial.org/040_effects/startapp_with_effects.html
module Main (..) where

import Json.Decode as JD
import Effects exposing (Effects, Never)
import Html as H exposing (Html)
import Html.Events exposing (onClick, on)
import Html.Attributes exposing (id)
import Time
import Time exposing (..)
import Task
import KeyboardPiano
import SolarSystem
import Models exposing (Model, Planet)
import Notes
import Signal
import StartApp
import View exposing (..)
import Style exposing (..)

targetSelectedDecoder : JD.Decoder String
targetSelectedDecoder = JD.at ["target", "value"] JD.string

audioSoundIds : List String
audioSoundIds = ["piano", "saw", "shortSine", "longSine", "hihatOpen", "hihatClosed", "ghost", "piano", "drums"]

selects : List Html
selects =
  List.map (\sound -> (H.option [] [H.text sound])) audioSoundIds

view : Signal.Address SolarSystem.Action -> Model -> H.Html
view address model =
  H.div [ Style.container ]
    [
      H.div [ Style.canvas ] [H.fromElement (View.canvas model)]
    , H.div [ Style.controls ] [
        H.div [] [ H.text model.lastClick ]
      , H.button [ onClick address SolarSystem.ClearPlanets, id "reset" ] [ H.text "Reset" ]
      , H.select
        [
          id "sound-selector",
          on "change" targetSelectedDecoder (Signal.message address << SolarSystem.SoundSelected)
        ]
        (List.map (\sound -> (H.option [] [H.text sound])) audioSoundIds)
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
      , inputs = [tickSignal,
                  View.canvasSizeSignal,
                  View.actionSignal,
                  KeyboardPiano.actionSignal,
                  initialCanvasSize,
                  View.mousePositionOffsetSignal]
      , update = update
      , view = view
      }

sounds : Signal String
sounds = Signal.map (.sounds) app.model

hitPlanets : Signal (List Planet)
hitPlanets =
  Signal.map (.planets) app.model
    |> Signal.map (List.filter ( \planet -> planet.ticksSinceHit == 0))
    |> Signal.filter (\ps -> not (List.isEmpty ps)) []

main : Signal.Signal H.Html
main =
  app.html

getInstrument : String -> Planet -> String
getInstrument sounds planet =
  let
    getDrum planet =
      if planet.radius == Notes.c4 then "hihatOpen"
      else if planet.radius == Notes.d4 then "hihatClosed"
      else if planet.radius == Notes.e4 then "snare"
      else "bass" -- default
  in case sounds of
    "drums" -> getDrum planet
    x -> x -- default: pass straight as such

getSound : String -> Planet -> (Int, String)
getSound sounds planet =
  (round (planet.radius), (getInstrument sounds planet))

port audio : Signal (List (Int, String))
port audio =
  Signal.sampleOn hitPlanets sounds
  |> Signal.map2 (,) hitPlanets
  |> Signal.map (\(ps, sounds) -> List.map (getSound sounds) ps )
