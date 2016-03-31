module Audio where

import Time exposing (..)

port audio : Signal Int
port audio =
  Signal.map random (every second)
  |> Signal.map round

random t =
  sqrt t / 10000
