import Html exposing (div, button, text, fromElement)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp
import View exposing (..)

main =
  StartApp.start { model = model, view = view, update = update }


model = 0

view address model = fromElement View.renderWorld

update action model = 0
