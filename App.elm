-- From http://www.elm-tutorial.org/040_effects/startapp_with_effects.html
module Main (..) where

import Effects exposing (Effects, Never)
import Html exposing (div, button, text, fromElement)
import Html.Events exposing (onClick)
import Time
import Time exposing (..)
import SolarSystem
import StartApp
import Debug
import View exposing (..)


view : Signal.Address SolarSystem.Action -> SolarSystem.Model -> Html.Html
view address model =
  div []
    [
    button [ onClick address SolarSystem.RemoveLastPlanet ] [ text "-" ]
    , button [ onClick address SolarSystem.AddPlanet ] [ text "+" ]
    , button [ onClick address SolarSystem.Tick ] [ text "!" ]
    , fromElement (View.canvas model)
    , div [] [ text (toString model.planets) ]
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
    , inputs = [tickSignal]
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

getFrequency : SolarSystem.Planet -> Int
getFrequency planet =
  round (planet.radius)

port audio : Signal (List Int)
port audio =
  hitPlanets
  |> Signal.map (\ps -> List.map getFrequency ps )
  |> Signal.map (Debug.log "ping")
  -- |> Signal.filter True
