module GetData exposing (get)

import Http
import DisplayData exposing (Model, Value)
import Json.Decode as Decode


base =
    "../backend/sample-data/"


type alias Error =
    Http.Error



-- Request a list of values to the server


get : (Model -> msg) -> (String -> msg) -> String -> Cmd msg
get success fail name =
    let
        url =
            base ++ "data/" ++ (Http.encodeUri name)
    in
        Http.send (handleResult success fail) (Http.get url decodeData)



-- handle the HTTP result


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
        (Decode.field "column" Decode.string)
        (Decode.field "data" (Decode.list decodeValue))


decodeValue : Decode.Decoder Value
decodeValue =
    Decode.map3 Value
        (Decode.field "age" Decode.float)
        (Decode.field "samples" Decode.int)
        (Decode.field "value" Decode.string)
