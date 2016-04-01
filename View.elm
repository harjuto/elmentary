module View where
import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Notes as Notes
import SolarSystem as SolarSystem

canvasSize : Int
canvasSize = 800

universeSize : Float
universeSize = 300

planetSize : Float
planetSize = 10

-- Fitting notes from c1 to c3 to the universe circle
radiusCoefficient : Float
radiusCoefficient = ((universeSize - 50) / 2) / Notes.c5

canvas : SolarSystem.Model -> Element
canvas model =
  collage canvasSize canvasSize
    (
      [ space, asteroidField ] ++ List.map planet model.planets
    )

space : Form
space =
  circle universeSize
    |> filled spaceBlack
    |> move(0,0)


planet : SolarSystem.Planet -> Form
planet planet =
  circle planetSize
    |> filled (if planet.hit then Color.red else rockBrown)
    |> move (cos planet.angle * (planet.radius * radiusCoefficient), sin -planet.angle * (planet.radius * radiusCoefficient))

asteroidField : Form
asteroidField =
  traced (solid asteroidGray) asteroids

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
