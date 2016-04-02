module Models (..) where

-- MODELS
type alias Planet =
  {
    radius: Float, -- Radius from the center of the solar system
    angle: Float, -- Angle at the angular orbit
    speed: Float, -- Angular speed
    ticksSinceHit: Int,
    instrument: String -- What instrument to use. Alternatives in audio.js
  }

type alias Model =
  {
    planets: List Planet,
    lastClick: String,
    canvasSize: (Int, Int)
  }
