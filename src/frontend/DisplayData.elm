module DisplayData
    exposing
        ( Model
        , Value
        , initialModel
        , Msg(SetDimension, SetValues)
        , update
        , view
        )

import Html exposing (Html, div, text)
import Html.Attributes exposing (..)
import Table


main =
    Html.beginnerProgram
        { model = testModel
        , view = view
        , update = update
        }



-- MODEL


type alias Value =
    { age : Float, samples : Int, value : String }


type alias Model =
    { dimensionName : Maybe String
    , values : List Value
    , tableState : Table.State
    }


initialModel : Model
initialModel =
    { dimensionName = Nothing
    , values = []
    , tableState = Table.initialSort "number of samples"
    }


testModel : Model
testModel =
    { initialModel
        | dimensionName = Just "variable"
        , values = [ Value 0.123 123 "hello", Value 0 1 "world" ]
    }


tableConfig : String -> Table.Config Value Msg
tableConfig dimensionName =
    let
        dimensionColumn =
            Table.stringColumn dimensionName .value

        samplesColumn =
            Table.customColumn
                { name = "number of samples"
                , viewData = .samples >> toString
                , sorter = Table.decreasingOrIncreasingBy .samples
                }

        ageColumn =
            Table.customColumn
                { name = "average age"
                , viewData = .age >> (\x -> toFloat (round (x * 10)) / 10) >> toString
                , sorter = Table.increasingOrDecreasingBy .age
                }
    in
        Table.config
            { toId = .value
            , toMsg = SetTableState
            , columns = [ dimensionColumn, samplesColumn, ageColumn ]
            }



-- UPDATE


type Msg
    = SetDimension String
    | SetValues String (List Value)
    | SetTableState Table.State


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetDimension name ->
            { model | dimensionName = Just name }

        SetValues name values ->
            { model | values = values, dimensionName = Just name }

        SetTableState state ->
            { model | tableState = state }



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "results" ]
        [ case model.dimensionName of
            Nothing ->
                text "Nothing selected"

            Just name ->
                Table.view
                    (tableConfig name)
                    model.tableState
                    model.values
        ]
