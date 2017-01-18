module Main exposing (..)

import Html exposing (Html, h1, div, text)
import Html.Events exposing (onClick)
import ChooseDimension
import DisplayData


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
    , data : DisplayData.Model
    }


model : Model
model =
    { appName = "US census"
    , dimension = ChooseDimension.initialModel
    , data = DisplayData.initialModel
    }



-- UPDATE


type Msg
    = ChooseDimensionMsg ChooseDimension.Msg
    | DataMsg DisplayData.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChooseDimensionMsg msg ->
            { model | dimension = ChooseDimension.update msg model.dimension }

        DataMsg msg ->
            { model | data = DisplayData.update msg model.data }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.appName ]
        , Html.map ChooseDimensionMsg (ChooseDimension.view model.dimension)
        , Html.map DataMsg (DisplayData.view model.data)
        ]
