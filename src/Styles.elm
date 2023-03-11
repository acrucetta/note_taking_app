module Styles exposing (..)

import Css exposing (..)


noteTextarea : Style
noteTextarea =
    height (px 200)
        |> width (pct 100)
        |> border (px 2) solid (rgb 238 238 238) 
        |> borderRadius (px 4)
        |> padding (px 8)
        |> fontFamily [ "sans-serif" ]
        |> fontSize (px 16)


saveButton : Style
saveButton =
    border (px 1) solid (rgb 76 175 80)
        |> display block
        |> margin (px 8) auto
        |> backgroundColor (rgb 76 175 80)
        |> color (rgb 255 255 255)
        |> padding (px 8) (px 16)
        |> borderRadius (px 4)
        |> fontFamily [ "sans-serif" ]
        |> fontSize (px 16)


notesList : Style
notesList =
    listStyle none
        |> padding (px 0)
        |> margin (px 0)
        |> fontFamily [ "sans-serif" ]
        |> fontSize (px 16)


notesListItem : Style
notesListItem =
    borderBottom (px 1) solid (rgb 238 238 238)
        |> padding (px 8)
        |> display flex
        |> alignItems center
        |> justifyContent spaceBetween


container : Style
container =
    display flex
        |> flexDirection column
        |> alignItems center
        |> margin (px 16)


styles : List Style
styles =
    [ noteTextarea
    , saveButton
    , notesList
    , notesListItem
    , container
    ]

