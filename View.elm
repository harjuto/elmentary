module View where
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Notes
import SolarSystem
import Mouse
import Window

-- canvasWidth : Int
-- canvasWidth =
--   Window.width
--   |>
--
-- canvasHeight : Int
-- canvasHeight =
--   Window.height

canvasWidth : Int
canvasWidth = 1600

canvasHeight : Int
canvasHeight = 800

universeSize : Float
universeSize = 300

planetSize : Int
planetSize = 30

-- Fitting notes from c1 to c3 to the universe circle
radiusCoefficient : Float
radiusCoefficient = ((universeSize - 10) / 2) / Notes.c4

clickSignal : Signal (Int, Int)
clickSignal =
  Signal.sampleOn Mouse.clicks Mouse.position

relativeClickSignal : Signal (Int, Int)
relativeClickSignal =
  Signal.map (\(x,y) -> (x - canvasWidth // 2, y - canvasHeight // 2)) clickSignal

actionSignal : Signal SolarSystem.Action
actionSignal =
  Signal.map coordinatesToFreq relativeClickSignal
    |> Signal.map SolarSystem.ClickAddPlanet

coordinatesToFreq : (Int, Int) -> Float
coordinatesToFreq (x, y) =
  let
    radius = sqrt ( (toFloat x) ^ 2 + (toFloat y) ^ 2)
  in
    radius / radiusCoefficient

canvas : SolarSystem.Model -> Element
canvas model =
  collage canvasWidth canvasHeight
    (
      [ space, asteroidField ] ++ List.map planet model.planets
    )

space : Form
space =
  toForm (fittedImage canvasWidth canvasHeight "img/space.jpg")

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
