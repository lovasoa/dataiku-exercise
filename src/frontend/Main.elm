module Main exposing (..)

import Html exposing (Html, h1, div, text)
import Html.Events exposing (onClick)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { appName : String }


model : Model
model =
    { appName = "US census" }



-- UPDATE


type alias Msg =
    ()


update : Msg -> Model -> Model
update msg model =
    case msg of
        () ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.appName ] ]
