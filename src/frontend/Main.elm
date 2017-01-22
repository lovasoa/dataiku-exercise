module VisualizeCensus exposing (..)

{-|
# US census visualization web application
-}

import Html exposing (Html, h1, div, pre, text)
import Html.Attributes exposing (hidden)
import ChooseDimension
import GetDimensions
import DisplayData
import GetData


main =
    Html.program
        { init = init
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


init : ( Model, Cmd Msg )
init =
    { appName = "Visualize Census"
    , dimension = ChooseDimension.initialModel
    , data = DisplayData.initialModel
    , error = Nothing
    }
        ! [ GetDimensions.get ReceiveDimensions Error ]



-- UPDATE


type Msg
    = ChooseDimensionMsg ChooseDimension.Msg
    | DataMsg DisplayData.Msg
    | ReceiveDimensions ChooseDimension.Model
    | Error String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChooseDimensionMsg msg ->
            { model
                | dimension = ChooseDimension.update msg model.dimension
                , error = Nothing
            }
                ! case msg of
                    ChooseDimension.Choose (Just { id, value }) ->
                        [ GetData.get DataMsg Error id ]

                    _ ->
                        []

        DataMsg msg ->
            { model | data = DisplayData.update msg model.data } ! []

        ReceiveDimensions dimension ->
            { model | dimension = dimension } ! []

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
