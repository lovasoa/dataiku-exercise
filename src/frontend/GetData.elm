module GetData exposing (get)

import Http
import DisplayData exposing (Model, Value)
import Json.Decode as Decode


base =
    "../backend/sample-data/"


type alias Error =
    Http.Error



-- Request a list of values to the server


get : (List Value -> msg) -> (String -> msg) -> String -> Cmd msg
get success fail name =
    let
        url =
            base ++ "data/" ++ (Http.encodeUri name)
    in
        Http.send (handleResult success fail) (Http.get url decodeData)



-- handle the HTTP result


handleResult : (List Value -> msg) -> (String -> msg) -> Result Http.Error (List Value) -> msg
handleResult success fail result =
    case result of
        Err e ->
            fail <| toString e

        Ok values ->
            success values



-- JSON decoders


decodeData : Decode.Decoder (List Value)
decodeData =
    Decode.at [ "data" ] (Decode.list decodeValue)


decodeValue : Decode.Decoder Value
decodeValue =
    Decode.map3 Value
        (Decode.field "age" Decode.float)
        (Decode.field "samples" Decode.int)
        (Decode.field "value" Decode.string)
