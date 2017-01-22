module GetDimensions exposing (get)

import Http
import ChooseDimension exposing (Model, Values, Value)
import Json.Decode as Decode


base =
    "/api/"


type alias Error =
    Http.Error


{-| Request a list of values to the server
-}
get : (Model -> msg) -> (String -> msg) -> Cmd msg
get success fail =
    let
        url =
            base ++ "columns"
    in
        Http.send (handleResult success fail) (Http.get url decodeData)


{-| handle the HTTP result
-}
handleResult : (Model -> msg) -> (String -> msg) -> Result Http.Error Model -> msg
handleResult success fail result =
    case result of
        Err e ->
            fail <| toString e

        Ok model ->
            success model



-- JSON decoders


decodeData : Decode.Decoder Model
decodeData =
    Decode.map2 Model
        (Decode.succeed Nothing)
        (Decode.field "data" (Decode.list decodeColumn))


decodeColumn : Decode.Decoder Value
decodeColumn =
    Decode.map2 Value
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
