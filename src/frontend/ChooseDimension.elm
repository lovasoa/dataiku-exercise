module ChooseDimension exposing (Model, initialModel, Msg(Choose, SetList), update, view)

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


type alias Model =
    { choosen : String, possible : List String }


initialModel : Model
initialModel =
    { possible = [], choosen = "" }



-- UPDATE


type Msg
    = Choose String
    | SetList (List String)


update : Msg -> Model -> Model
update msg model =
    case msg of
        Choose choosen ->
            { model | choosen = choosen }

        SetList list ->
            { model | possible = list }



-- VIEW


view : Model -> Html Msg
view model =
    label []
        [ text "Choose a variable to analyze: "
        , select [ onInput Choose ] (viewOptions model)
        ]


viewOptions : Model -> List (Html Msg)
viewOptions model =
    (option [ disabled True, selected (model.choosen == "") ] [ text "-- Select a value --" ])
        :: (List.map
                (\v -> option [ selected (v == model.choosen) ] [ text v ])
                model.possible
           )
