module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json exposing (Decoder)
import Note exposing (Note)


-- MODEL


type alias Model =
    { notes : List Note
    , newNote : Note
    }


initialModel : Model
initialModel =
    { notes = []
    , newNote = { title = "", body = "" }
    }


-- MESSAGES


type Msg
    = AddNote
    | UpdateNoteTitle String
    | UpdateNoteBody String


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddNote ->
            let
                newModel =
                    { model | notes = model.notes ++ [ model.newNote ], newNote = { title = "", body = "" } }
            in
            ( newModel, Cmd.none )

        UpdateNoteTitle title ->
            let
                newNote =
                    { model.newNote | title = title }
                newModel =
                    { model | newNote = newNote }
            in
            ( newModel, Cmd.none )

        UpdateNoteBody body ->
            let
                newNote =
                    { model.newNote | body = body }
                newModel =
                    { model | newNote = newNote }
            in
            ( newModel, Cmd.none )


-- SUBSCRIPTIONS


port notes : (List Note -> msg) -> Sub msg


-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Note Taking App" ]
        , form [ onsubmit AddNote, autoComplete "off" ]
            [ label [] [ text "Title" ]
            , input [ type_ "text", required True, onInput (Json.map UpdateNoteTitle targetValue) ] []
            , label [] [ text "Body" ]
            , textarea [ required True, onInput (Json.map UpdateNoteBody targetValue) ] []
            , button [ type_ "submit" ] [ text "Add Note" ]
            ]
        , h2 [] [ text "Notes" ]
        , ul [] (List.map noteToListItem model.notes)
        ]


noteToListItem : Note -> Html msg
noteToListItem note =
    li [] [ text note.title, br [], text note.body ]


-- MAIN


main : Program () Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , update = update
        , view = view
        , subscriptions = notes
        }
