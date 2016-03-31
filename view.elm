module View where
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)



renderWorld : Element
renderWorld =
  collage 800 800
    [ circle 300
        |> filled clearGrey
        |> move (-10,0)
    ]








clearGrey : Color
clearGrey =
  rgba 111 111 111 0.6
