module View where
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)


import SolarSystem as SolarSystem

canvasSize : Int
canvasSize = 800

universeSize : Float
universeSize = 300

planetSize : Float
planetSize = 50

canvas : SolarSystem.Model -> Element
canvas model =
  collage canvasSize canvasSize
    (
      [ space, asteroidField ] ++ List.map planet model.planets
    )

space : Form
space =
  toForm (fittedImage canvasSize canvasSize "space.jpg")

planet : SolarSystem.Planet -> Form
planet planet =
  let
    image = if planet.hit then (fittedImage 50 50 "planethit.png") else (fittedImage 50 50 "planet.png")
  in
    toForm image
      |> move (cos planet.angle * (planet.radius * 50), sin -planet.angle * (planet.radius * 50))

asteroidField : Form
asteroidField =
  toForm (fittedImage (400) 100 "asteroidfield.png")
    |> moveX 200
asteroids : Path
asteroids =
  path [ (0, 0), (universeSize, 0)]

-- Colors
rockBrown : Color
rockBrown =
  rgba 204 102 0 1

spaceBlack : Color
spaceBlack =
  rgb 32 32 32

asteroidGray : Color
asteroidGray =
  Color.lightRed
