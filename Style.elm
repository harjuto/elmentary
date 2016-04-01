module Style where
import Html exposing (..)
import Html.Attributes exposing (..)

container : Attribute
container =
  style[
    ("color", "white"),
    ("display", "flex")
  ]

canvas : Attribute
canvas =
  style[

  ]

controls : Attribute
controls =
  style[
    ("padding", "10px")
      ]
