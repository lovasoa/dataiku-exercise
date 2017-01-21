module Main exposing (..)

{-|
# US census visualization web application
-}

import Html exposing (Html, h1, div, pre, text)
import Html.Attributes exposing (hidden)
import ChooseDimension
import DisplayData
import GetData


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
    , error : Maybe String
    }


initialModel : Model
initialModel =
    { appName = "US census"
    , dimension = ChooseDimension.initialModel
    , data = DisplayData.initialModel
    , error = Nothing
    }



-- UPDATE


type Msg
    = ChooseDimensionMsg ChooseDimension.Msg
    | DataMsg DisplayData.Msg
    | ReceiveData DisplayData.Model
    | Error String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChooseDimensionMsg msg ->
            let
                newDimension =
                    ChooseDimension.update msg model.dimension

                updated =
                    { model | dimension = newDimension, error = Nothing }
            in
                case msg of
                    ChooseDimension.Choose "" ->
                        updated ! []

                    ChooseDimension.Choose name ->
                        let
                            ( modelWithData, oldCmd ) =
                                update (DataMsg (DisplayData.SetDimension name)) updated
                        in
                            modelWithData ! [ GetData.get ReceiveData Error name, oldCmd ]

                    _ ->
                        updated ! []

        DataMsg msg ->
            { model | data = DisplayData.update msg model.data } ! []

        ReceiveData data ->
            { model | data = data } ! []

        Error err ->
            -- TODO
            { model | error = Just err } ! []



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text model.appName ]
        , pre [ hidden (model.error == Nothing) ] [ text <| Maybe.withDefault "" model.error ]
        , Html.map ChooseDimensionMsg (ChooseDimension.view model.dimension)
        , Html.map DataMsg (DisplayData.view model.data)
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
