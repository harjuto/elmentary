module View where
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import SolarSystem as SolarSystem


world : SolarSystem.Model -> Element

world model =
  collage 800 800
    (
      [ space ] ++ List.map drawPlanet model.planets
    )

space : Form
space =
  circle 300
    |> filled spaceBlack
    |> move (0,0)

drawPlanet : SolarSystem.Planet -> Form
drawPlanet planet =
  circle 20
    |> filled rockBrown
    |> move (10,10)

rockBrown : Color
rockBrown =
  rgba 204 102 0 1

spaceBlack : Color
spaceBlack =
  rgb 32 32 32
