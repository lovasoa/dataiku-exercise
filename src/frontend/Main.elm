module Main exposing (..)

import Html exposing (Html, h1, div, text)
import Html.Events exposing (onClick)
import ChooseDimension
import DisplayData


main =
    Html.program
        { init = initialModel ! []
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { appName : String
    , dimension : ChooseDimension.Model
    , data : DisplayData.Model
    }


initialModel : Model
initialModel =
    { appName = "US census"
    , dimension = ChooseDimension.initialModel
    , data = DisplayData.initialModel
    }



-- UPDATE


type Msg
    = ChooseDimensionMsg ChooseDimension.Msg
    | DataMsg DisplayData.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChooseDimensionMsg msg ->
            let
                newDimension =
                    ChooseDimension.update msg model.dimension

                updated =
                    { model | dimension = newDimension }
            in
                case msg of
                    ChooseDimension.Choose name ->
                        update
                            (DataMsg (DisplayData.SetDimension name))
                            updated

                    _ ->
                        updated ! []

        DataMsg msg ->
            { model | data = DisplayData.update msg model.data } ! []



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.appName ]
        , Html.map ChooseDimensionMsg (ChooseDimension.view model.dimension)
        , Html.map DataMsg (DisplayData.view model.data)
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
