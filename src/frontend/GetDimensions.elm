module GetDimensions exposing (get)

import Http
import ChooseDimension exposing (Model)
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
        (Decode.succeed "")
        (Decode.field "data" (Decode.list decodeColumn))


decodeColumn : Decode.Decoder String
decodeColumn =
    Decode.field "name" Decode.string
