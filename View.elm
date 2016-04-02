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

maxParallax : Int
maxParallax = 80

mousePositionOffsetSignal : Signal SolarSystem.Action
mousePositionOffsetSignal =
  Signal.map2 calculateOffset Mouse.position Window.dimensions
  |> Signal.map SolarSystem.ParallaxUpdate

calculateOffset : (Int, Int) -> (Int, Int) -> (Float, Float)
calculateOffset m w =
  let
    halfWidth = toFloat (fst w) / 2
    halfHeight = toFloat (snd w) / 2
    mouseX = toFloat (fst m)
    mouseY = toFloat (snd m)
    x = ((halfWidth - mouseX) / halfWidth) * toFloat maxParallax
    y = ((halfHeight - mouseY) / halfHeight) * toFloat maxParallax
  in
    (x, y)

universeSize : Float
universeSize = 400

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
    |> Signal.filter (\freq -> freq < Notes.c6) Notes.c4
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
      [ (space model.canvasSize model.parallax), asteroidField ] ++ List.map planet model.planets
    )

space : (Int, Int) -> (Float, Float) -> Form
space (width, height) (x, y) =
    toForm (fittedImage (width +  maxParallax*2) (height + maxParallax*2) "img/space2.jpg")
    |> move (x, -y)

planet : Planet -> Form
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
