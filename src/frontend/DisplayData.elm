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
import FormatNumber exposing (formatFloat, formatInt)
import Table
import Chart


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
        , values = [ Value 0.123 123 "hello", Value 0 151 "world" ]
    }


tableConfig : String -> Table.Config Value Msg
tableConfig dimensionName =
    let
        -- Use a non-breakable space to separate between thousands
        locale =
            { decimals = 1, thousandSeparator = "\x202F", decimalSeparator = "." }

        dimensionColumn =
            Table.stringColumn dimensionName .value

        samplesColumn =
            Table.customColumn
                { name = "number of samples"
                , viewData = .samples >> formatInt locale
                , sorter = Table.decreasingOrIncreasingBy .samples
                }

        ageColumn =
            Table.customColumn
                { name = "average age"
                , viewData = .age >> formatFloat locale
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
    case model.dimensionName of
        Nothing ->
            text "Nothing selected"

        Just name ->
            viewWithName name model


viewWithName : String -> Model -> Html Msg
viewWithName name model =
    div [ class "results" ]
        [ Chart.pie (List.map pieData model.values)
            |> Chart.title name
            |> Chart.colors chartColors
            |> Chart.toHtml
        , Table.view
            (tableConfig name)
            model.tableState
            model.values
        ]


pieData : Value -> ( Float, String )
pieData { samples, value } =
    ( toFloat samples, value )


chartColors : List String
chartColors =
    [ "#001f3f"
    , "#0074D9"
    , "#7FDBFF"
    , "#39CCCC"
    , "#3D9970"
    , "#2ECC40"
    , "#01FF70"
    , "#FFDC00"
    , "#FF851B"
    , "#FF4136"
    , "#85144b"
    , "#F012BE"
    , "#B10DC9"
    , "#111111"
    ]
