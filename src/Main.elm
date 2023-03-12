module Main exposing (..)

import Browser
import Html exposing (Html, button, div, form, h1, h2, h3, input, label, li, p, text, textarea, ul)
import Html.Attributes exposing (class)
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
    { notes : List (Id, Note)
    , currentNote : Note
    , nextId : Id
    }


init : Model
init =
    { notes = [(0, { title = "", body = "", tag = "" })]
    , currentNote = { title = "", body = "", tag = "" }
    , nextId = 1
    }

type Msg
    = UpdateBody Id String
    | UpdateTitle Id String
    | UpdateTag Id String
    | CreateNote
    | DeleteNote Id

-- Function to update the fields of a note given the id of the note we want to
-- update
updateNote : Id -> String -> String -> (Id, Note) -> (Id, Note)
updateNote id value content (noteId, note) =
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
        (noteId, note)
    

-- ction to compare the id of a note to the id of the note we want to update
isNote : Id -> (Id, Note) -> Bool
isNote id (noteId, note) =
    id == noteId  

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
            { model | notes = List.filter (not << isNote id) model.notes }

-- VIEW

-- View to render a list of notes 
viewNotes : List (Id, Note) -> Html Msg
viewNotes notes =
    ul [ ] 
        (List.map
            (\(id, note) ->
                li [ class "note p-4 rounded-lg shadow-md" ]
                    [ h1 [class "text-xl font-bold mb-2"] [ text note.title ]
                    , p [ class "text-gray-700" ] [ text note.body ]
                    , button [ onClick (DeleteNote id) ] [ text "Delete" ]
                ]
            )
            notes
        )

viewForm : Model -> Html Msg
viewForm model =
    form []
        [ label [class "block text-gray-700 font-bold mb-2"] [ text "Title" ]
        , input [ onInput (UpdateTitle model.nextId) ] []
        , label [ class "block text-gray-700 font-bold mb-2"] [ text "Body" ]
        , textarea [ onInput (UpdateBody model.nextId) ] []
        , button [ onClick CreateNote ] [ text "Create" ]
        ]

view : Model -> Html Msg
view model =
    div [ class "p-4" ]
        [ viewNotes model.notes        , viewForm model        ]

main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
