module Audio where

import Time exposing (..)

port audio : Signal Float
port audio = (every second)
