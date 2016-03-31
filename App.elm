import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp

import SolarSystem as SolarSystem

main =
  StartApp.start { model = SolarSystem.initialModel, view = view, update = SolarSystem.update }

view : Signal.Address SolarSystem.Action -> SolarSystem.Model -> Html.Html
view address model =
  div []
    [ button [ onClick address SolarSystem.Decrement ] [ text "-" ]
    , div [] [ text (toString model.count) ]
    , button [ onClick address SolarSystem.Increment ] [ text "+" ]
    ]
