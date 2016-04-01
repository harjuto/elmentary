module View where
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Notes as Notes
import SolarSystem as SolarSystem
import Signal
import Mouse

canvasSize : Int
canvasSize = 800

universeSize : Float
universeSize = 300

planetSize : Int
planetSize = 30

-- Fitting notes from c1 to c3 to the universe circle
radiusCoefficient : Float
radiusCoefficient = ((universeSize - 10) / 2) / Notes.c4

canvas : SolarSystem.Model -> Element
canvas model =
  collage canvasSize canvasSize
    (
      [ space, asteroidField ] ++ List.map planet model.planets
    )

space : Form
space =
  toForm (fittedImage canvasSize canvasSize "img/space.jpg")

planet : SolarSystem.Planet -> Form
planet planet =
  let
    image = if planet.ticksSinceHit < 10 then (fittedImage 50 50 "img/planethit.png") else (fittedImage 50 50 "img/planet.png")

  in
    toForm image
      |> move (cos planet.angle * (planet.radius * radiusCoefficient), sin -planet.angle * (planet.radius * radiusCoefficient))

asteroidField : Form
asteroidField =
  toForm (fittedImage (400) 100 "img/asteroidfield.png")
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
