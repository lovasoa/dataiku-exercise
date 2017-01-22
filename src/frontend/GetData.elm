module GetData exposing (get)

import Http
import DisplayData exposing (Msg, Value)
import Json.Decode as Decode


base =
    "/api/"


type alias Error =
    Http.Error



-- Request a list of values to the server


get : (Msg -> msg) -> (String -> msg) -> Int -> Cmd msg
get success fail id =
    let
        url =
            base ++ "data/" ++ (Http.encodeUri (toString id))
    in
        Http.send (handleResult success fail) (Http.get url decodeData)



-- handle the HTTP result


handleResult : (Msg -> msg) -> (String -> msg) -> Result Error Msg -> msg
handleResult success fail result =
    case result of
        Err e ->
            fail <| toString e

        Ok model ->
            success model



-- JSON decoders


decodeData : Decode.Decoder Msg
decodeData =
    Decode.map2 DisplayData.SetValues
        (Decode.field "column" Decode.string)
        (Decode.field "data" (Decode.list decodeValue))


decodeValue : Decode.Decoder Value
decodeValue =
    Decode.map3 Value
        (Decode.field "age" Decode.float)
        (Decode.field "samples" Decode.int)
        (Decode.field "value" Decode.string)
