module Main exposing (..)

import Html exposing (Html, h1, div, text)
import Html.Events exposing (onClick)
import ChooseDimension


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { appName : String
    , dimension : ChooseDimension.Model
    }


model : Model
model =
    { appName = "US census", dimension = ChooseDimension.initialModel }



-- UPDATE


type Msg
    = ChooseDimensionMsg ChooseDimension.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChooseDimensionMsg msg ->
            { model | dimension = ChooseDimension.update msg model.dimension }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.appName ]
        , Html.map ChooseDimensionMsg (ChooseDimension.view model.dimension)
        ]
