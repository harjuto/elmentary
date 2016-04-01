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
<<<<<<< HEAD
  toForm (fittedImage canvasSize canvasSize "/images/space.jpg")
=======
  toForm (fittedImage canvasSize canvasSize "img/space.jpg")
>>>>>>> 2d1cad82763437b9a1be57058b9eaeafc8533228

planet : SolarSystem.Planet -> Form
planet planet =
  let
<<<<<<< HEAD
    image = if planet.ticksSinceHit < 10 then (fittedImage planetSize planetSize "/images/planethit.png") else (fittedImage planetSize planetSize "/images/planet.png")
=======
    image = if planet.ticksSinceHit < 10 then (fittedImage 50 50 "img/planethit.png") else (fittedImage 50 50 "img/planet.png")
>>>>>>> 2d1cad82763437b9a1be57058b9eaeafc8533228
  in
    toForm image
      |> move (cos planet.angle * (planet.radius * radiusCoefficient), sin -planet.angle * (planet.radius * radiusCoefficient))


<<<<<<< HEAD
asteroidField : Signal.Address SolarSystem.Action -> Form
asteroidField address =
  toForm (fittedImage (400) 100 "/images/asteroidfield.png")
=======
asteroidField : Form
asteroidField =
  toForm (fittedImage (400) 100 "img/asteroidfield.png")
>>>>>>> 2d1cad82763437b9a1be57058b9eaeafc8533228
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
