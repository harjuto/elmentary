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
radiusCoefficient = ((universeSize - 50) / 2) / Notes.c5

canvas : Signal.Address SolarSystem.Action -> SolarSystem.Model -> Element
canvas address model =
  collage canvasSize canvasSize
    (
      [ space, asteroidField address ] ++ List.map planet model.planets
    )

space : Form
space =
  toForm (fittedImage canvasSize canvasSize "/images/space.jpg")

planet : SolarSystem.Planet -> Form
planet planet =
  let
    image = if planet.ticksSinceHit < 10 then (fittedImage planetSize planetSize "/images/planethit.png") else (fittedImage planetSize planetSize "/images/planet.png")
  in
    toForm image
      |> move (cos planet.angle * (planet.radius * radiusCoefficient), sin -planet.angle * (planet.radius * radiusCoefficient))


asteroidField : Signal.Address SolarSystem.Action -> Form
asteroidField address =
  toForm (fittedImage (400) 100 "/images/asteroidfield.png")
    |> moveX 200
    |> clickable Signal.message address Mouse.position 

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
