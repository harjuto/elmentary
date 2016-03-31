import Html exposing (div, button, text, fromElement)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp
import SolarSystem as SolarSystem
import View exposing (..)

main =
  StartApp.start { model = SolarSystem.initialModel, view = view, update = SolarSystem.update }

view address model = fromElement View.renderWorld
