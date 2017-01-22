module ChooseDimension
    exposing
        ( Model
        , Values
        , Value
        , initialModel
        , Msg(Choose, SetList)
        , update
        , view
        )

import Html exposing (Html, label, select, option, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }



-- MODEL


type alias Value =
    { id : Int, value : String }


type alias Values =
    List Value


type alias Model =
    { choosen : Maybe Value, possible : Values }


initialModel : Model
initialModel =
    { possible = [], choosen = Nothing }



-- UPDATE


type Msg
    = Choose (Maybe Value)
    | SetList Values


update : Msg -> Model -> Model
update msg model =
    case msg of
        Choose choosen ->
            { model | choosen = choosen }

        SetList list ->
            { model | possible = list }



-- VIEW


{-| Finds a value from its string id
-}
getValue : Values -> String -> Maybe Value
getValue values str =
    String.toInt str
        |> Result.toMaybe
        |> Maybe.andThen
            (\id ->
                List.filter (((==) id) << .id) values
                    |> List.head
            )


view : Model -> Html Msg
view model =
    label []
        [ text "Choose a variable to analyze: "
        , select
            [ onInput (Choose << getValue model.possible) ]
            (viewOptions model)
        ]


viewOptions : Model -> List (Html Msg)
viewOptions model =
    (option
        [ disabled True, selected (model.choosen == Nothing) ]
        [ text "-- Select a value --" ]
    )
        :: (List.map (viewOption model) model.possible)


viewOption : Model -> Value -> Html Msg
viewOption model v =
    option
        [ selected (model.choosen == Just v), value <| toString v.id ]
        [ text v.value ]
