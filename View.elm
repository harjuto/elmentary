module View where
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Notes
import SolarSystem
import Models exposing (Model, Planet)
import Mouse
import Window

canvasSizeSignal : Signal SolarSystem.Action
canvasSizeSignal =
  Window.dimensions
  |> Signal.map (\x -> Debug.log "size: " x )
  |> Signal.map SolarSystem.CanvasSizeUpdate

initialCanvasSizeSignal: Signal x -> Signal SolarSystem.Action
initialCanvasSizeSignal startSignal =
  Signal.sampleOn startSignal canvasSizeSignal

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
  Signal.map2 (\(x,y) (w,h) -> (x - w // 2, y - h // 2)) clickSignal Window.dimensions

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

canvas : Model -> Element
canvas model =
  collage (fst model.canvasSize) (snd model.canvasSize)
    (
      [ (space model.canvasSize), (asteroidField model.canvasSize) ] ++ List.map planet model.planets
    )

space : (Int, Int) -> Form
space (width, height) =
  toForm (fittedImage width height "img/space2.jpg")

planet : Planet -> Form
planet planet =
  let
    image = if planet.ticksSinceHit < 10 then (fittedImage 50 50 "img/planethit.png") else (fittedImage 50 50 "img/planet.png")

  in
    toForm image
      |> move (cos planet.angle * (planet.radius * radiusCoefficient), sin -planet.angle * (planet.radius * radiusCoefficient))

asteroidField : (Int, Int) -> Form
asteroidField (width, height) =
  toForm (fittedImage (round (toFloat width / 2)) 100 "img/asteroidfield.png")
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
