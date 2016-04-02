module Config (..) where

import Json.Decode as JD
import Html as H exposing (Html)
import Html.Events exposing (onClick, on)
import Html.Attributes exposing (id)

-- MODEL

type Action =
  SoundSelected String

type alias Model =
  {
    sounds: String
  }


initialModel : Model
initialModel =
  { sounds = "piano" }

audioSoundIds : List String
audioSoundIds = ["piano", "saw", "shortSine", "longSine", "hihatOpen", "hihatClosed", "ghost", "piano", "snareLoud", "drums"]

-- VIEW

targetSelectedDecoder : JD.Decoder String
targetSelectedDecoder = JD.at ["target", "value"] JD.string

selects : List Html
selects =
  List.map (\sound -> (H.option [] [H.text sound])) audioSoundIds

view : Signal.Address Action -> Model -> H.Html
view address model =
  H.select
    [
      id "sound-selector",
      on "change" targetSelectedDecoder (Signal.message address << SoundSelected)
    ]
    (List.map (\sound -> (H.option [] [H.text sound])) audioSoundIds)

-- UPDATE

update : Action -> Model -> Model
update action model =
  case action of
    SoundSelected s ->
        { model | sounds = (Debug.log "sound selected" s)}
