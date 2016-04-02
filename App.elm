-- From http://www.elm-tutorial.org/040_effects/startapp_with_effects.html
module Main (..) where

import Effects exposing (Effects, Never)
import Html as H exposing (Html)
import Html.Events exposing (onClick, on)
import Html.Attributes exposing (id)
import Time
import Time exposing (..)
import Task
import KeyboardPiano
import SolarSystem
import Models
import Config
import Notes
import Signal
import StartApp
import View exposing (..)
import Style exposing (..)

type Action
    = SolarSystemAction SolarSystem.Action
    | ConfigAction Config.Action
    | NoOp

type alias Model =
  { solarSystem : Models.Model
    , config : Config.Model
  }

view : Signal.Address Action -> Model -> H.Html
view address model =
  H.div [ Style.container ]
    [
      H.div [ Style.canvas ] [H.fromElement (View.canvas model.solarSystem)]
    , H.div [ Style.controls, id "controls" ] [
        H.p [] [ H.text "Press enter to go fullscreen." ]
      , H.button [ onClick address (SolarSystemAction SolarSystem.ClearPlanets), id "reset" ] [ H.text "Reset" ]
      , H.button [ onClick address (SolarSystemAction SolarSystem.LoadSong), id "load" ] [ H.text "Load Song" ]
      , Config.view (Signal.forwardTo address ConfigAction) model.config
    ]

    ]


-- startMailbox & sendInitialSignal for getting the inital window dimensions

startMailbox : Signal.Mailbox ()
startMailbox =
  Signal.mailbox ()

sendInitialSignal : Effects Action
sendInitialSignal =
    Signal.send startMailbox.address ()
        |> Task.map (always NoOp)
        |> Effects.task

init : (Model, Effects Action)
init =
  let
    model = { solarSystem = SolarSystem.initialModel, config = Config.initialModel}
  in
    ( model, sendInitialSignal )


update : Action ->  Model -> ( Model, Effects.Effects Action)
update action model =
  case action of
    SolarSystemAction act ->
      let
        solarModel = SolarSystem.update act model.solarSystem
      in
        (Model solarModel model.config, Effects.none)
    ConfigAction act ->
      let
        configModel = Config.update act model.config
      in
        (Model model.solarSystem configModel, Effects.none)
    NoOp -> (model, Effects.none)

timeSignal : Signal Time.Time
timeSignal =
  Time.fps 30

tickSignal : Signal Action
tickSignal =
  Signal.map (\_ -> SolarSystemAction SolarSystem.Tick) timeSignal


app : StartApp.App Model
app =
  let
    initialCanvasSize = View.initialCanvasSizeSignal startMailbox.signal
  in
    StartApp.start
      { init = init
      , inputs = [tickSignal,
                  (View.canvasSizeSignal |> Signal.map SolarSystemAction),
                  (View.actionSignal |> Signal.map SolarSystemAction),
                  (KeyboardPiano.actionSignal |> Signal.map SolarSystemAction),
                  (initialCanvasSize |> Signal.map SolarSystemAction),
                  (View.mousePositionOffsetSignal |> Signal.map SolarSystemAction)]
      , update = update
      , view = view
      }

sounds : Signal String
sounds =
  app.model
  |> Signal.map (.config)
  |> Signal.map (.sounds)

hitPlanets : Signal (List Models.Planet)
hitPlanets =
  app.model
  |> Signal.map (.solarSystem)
  |> Signal.map (.planets)
  |> Signal.map (List.filter ( \planet -> planet.ticksSinceHit == 0))
  |> Signal.filter (\ps -> not (List.isEmpty ps)) []

main : Signal.Signal H.Html
main =
  app.html

audioSoundIds : List String
audioSoundIds = ["piano", "drums", "bass", "saw", "shortSine", "longSine", "hihatOpen", "hihatClosed", "ghost", "piano", "snareLoud"]

getInstrument : String -> Models.Planet -> String
getInstrument sounds planet =
  let
    getDrum planet =
      if planet.radius == Notes.c4 then "hihatOpen"
      else if planet.radius == Notes.d4 then "hihatClosed"
      else if planet.radius == Notes.e4 then "snareLoud"
      else if planet.radius == Notes.f4 then "snare"
      else "piano" -- default
  in case sounds of
    "drums" -> getDrum planet
    x -> x -- default: pass straight as such

getSound : String -> Models.Planet -> (Int, String)
getSound sounds planet =
  (round (planet.radius), (getInstrument sounds planet))

port audio : Signal (List (Int, String))
port audio =
  Signal.sampleOn hitPlanets sounds
  |> Signal.map2 (,) hitPlanets
  |> Signal.map (\(ps, sounds) -> List.map (getSound sounds) ps )
