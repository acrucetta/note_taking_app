module Main exposing (..)

import Browser
import Color
import Element
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


-- MODEL


type alias Note =
    { title : String
    , body : String
    , tag : String
    }


type alias Id =
    Int


type alias Model =
    { notes : List ( Id, Note )
    , currentNote : Note
    , nextId : Id
    , selectedId : Maybe Id
    }


init : Model
init =
    { notes = [ ( 0, { title = "", body = "", tag = "" } ) ]
    , currentNote = { title = "", body = "", tag = "" }
    , nextId = 1
    , selectedId = Just 0
    }


type Msg
    = UpdateBody Id String
    | UpdateTitle Id String
    | UpdateTag Id String
    | CreateNote
    | DeleteNote Id
    | SelectNote Id
    | NoOp



-- Function to update the fields of a note given the id of the note we want to
-- update


updateNote : Id -> String -> String -> ( Id, Note ) -> ( Id, Note )
updateNote id value content ( noteId, note ) =
    if id == noteId then
        ( noteId
        , case value of
            "title" ->
                { note | title = content }

            "body" ->
                { note | body = content }

            "tag" ->
                { note | tag = content }

            _ ->
                note
        )

    else
        ( noteId, note )



-- ction to compare the id of a note to the id of the note we want to update

isNote : Maybe Id -> ( Id, Note ) -> Bool
isNote maybeId ( noteId, note ) =
    Just noteId == maybeId


update : Msg -> Model -> Model
update msg model =
    case msg of
        -- Update the current note with the given body
        UpdateBody id value ->
            { model
                | notes = List.map (updateNote id "body" value) model.notes
            }

        -- Update the current note with the given title
        UpdateTitle id value ->
            { model
                | notes = List.map (updateNote id "title" value) model.notes
            }

        -- Update the current note with the given tag
        UpdateTag id value ->
            { model
                | notes = List.map (updateNote id "tag" value) model.notes
            }

        -- Append a new note to the list of notes with the current id and
        -- increment the id
        CreateNote ->
            { model
                | notes = ( model.nextId, model.currentNote ) :: model.notes
                , nextId = model.nextId + 1
            }

        -- Delete the note with the given id
        DeleteNote id ->
            { model
                | notes = List.filter (not << isNote (Just id)) model.notes
            }

        SelectNote id ->
            { model | selectedId = Just id }

        NoOp ->
            model



-- VIEW

viewNoteListItem : ( Id, Note ) -> Bool -> Html Msg
viewNoteListItem ( id, note ) isActive =
    div
        [ classList [ ( "note-list-item", True ), ( "active", isActive ) ]
        , onClick (SelectNote id)
        ]
        [ h3 [] [ text note.title ]
        , p [] [ text (String.left 100 note.body) ]
        ]

viewSidebar : Model -> Html Msg
viewSidebar model =
    div [ class "sidebar" ]
        [ header []
            [ h1 [] [ text "Notes" ]
            , button [ onClick CreateNote ] [ text "Create Note" ]
            ]
        , div []
            [ List.map (\note -> viewNoteListItem note (Just (Tuple.first note) == model.selectedId)) model.notes
                |> List.reverse
                |> div []
            ]
        ]

viewNoteEditor : Model -> Html Msg
viewNoteEditor model =
    case List.head (List.filter (isNote model.selectedId) model.notes) of
        Just ( _, note ) ->
            div [ class "note-editor" ]
                [ input
                    [ type_ "text"
                    , class "title"
                    , value note.title
                    , onInput (\content -> Maybe.map (\id -> UpdateTitle id content) model.selectedId |> Maybe.withDefault NoOp)
                    , placeholder "Title"
                    ]
                    []
                , textarea
                    [ class "body"
                    , value note.body
                    , onInput (\content -> Maybe.map (\id -> UpdateBody id content) model.selectedId |> Maybe.withDefault NoOp)
                    , placeholder "Write your note here..."
                    ]
                    []
                ]

        Nothing ->
            div [ class "note-editor" ] []

view : Model -> Html Msg
view model =
    div []
        [ viewSidebar model
        , viewNoteEditor model
        ]

main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
