module Note exposing (..)

import Json.Decode as Json exposing (Decoder)


-- MODEL


type alias Note =
    { title : String
    , body : String
    }



-- JSON ENCODING AND DECODING


encode : Note -> Json.Value
encode note =
    Json.object
        [ ( "title", Json.string note.title )
        , ( "body", Json.string note.body )
        ]


decode : Json.Decoder Note
decode =
    Json.map2 Note
        (Json.field "title" Json.string)
        (Json.field "body" Json.string)
