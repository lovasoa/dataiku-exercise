module DisplayData
    exposing
        ( Model
        , Value
        , initialModel
        , Msg(SetDimension, SetValues)
        , update
        , view
        )

import Html
    exposing
        ( Html
        , div
        , text
        , strong
        , table
        , thead
        , tbody
        , tr
        , td
        , th
        )
import Html.Attributes exposing (..)


main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }



-- MODEL


type alias Value =
    { age : Float, samples : Int, value : String }


type alias Model =
    { dimensionName : String, values : List Value }


initialModel : Model
initialModel =
    { dimensionName = "", values = [] }



-- UPDATE


type Msg
    = SetDimension String
    | SetValues (List Value)


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetDimension name ->
            { model | dimensionName = name }

        SetValues values ->
            { model | values = values }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ table []
            [ thead []
                [ tr []
                    [ th []
                        [ text
                            (if model.dimensionName /= "" then
                                model.dimensionName
                             else
                                "Column name"
                            )
                        ]
                    , th [] [ text "number of samples" ]
                    , th [] [ text "mean age" ]
                    ]
                ]
            , tbody []
                (List.map viewValue model.values)
            ]
        , div []
            [ strong []
                [ model.values |> List.length |> toString |> text ]
            , text " results."
            ]
        ]


viewValue : Value -> Html Msg
viewValue v =
    tr []
        [ td [] [ text v.value ]
        , td [] [ text <| toString v.samples ]
        , td [] [ text <| toString v.age ]
        ]
