module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, input, text, textarea, ul, li)
import Html.Attributes exposing (class)
import Html.Events exposing (onInput, onClick)
import Json.Encode


-- MODEL
type alias Model =
    { notes : List String
    , currentNote : String
    }


init : Model
init =
    { notes = []
    , currentNote = ""}


type Msg
    = UpdateNote String
    | SaveNote


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateNote note ->
            { model | currentNote = note }

        SaveNote ->
            { model | notes = model.notes ++ [ model.currentNote ], currentNote = "" }

view : Model -> Html Msg
view model =
    div []
        [ header
        , textarea [ class "note-textarea", onInput UpdateNote ] [ text model.currentNote ]
        , button [ class "save-button", onClick SaveNote ] [ text "Save" ]
        , notesList model
        ]


header : Html msg
header =
    h1 [] [ text "My Notes" ]


notesList : Model -> Html msg
notesList model =
    ul [ class "notes-list" ] (List.map (\note -> li [] [ text note ]) model.notes)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


notesToJson : List String -> Json.Encode.Value
notesToJson notes =
    notes
        |> List.map Json.Encode.string
        |> Json.Encode.list
