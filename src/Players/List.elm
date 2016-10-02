module Players.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Players.Messages exposing (..)
import Players.Models exposing (Player)


view: List Player -> Html Msg
view players =
    div []
        [ nav players
        , list players
        ]

nav : List Player -> Html Msg
nav players =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Players" ] ]

list: List Player -> Html Msg
list players =
    div [ class "p2" ]
        [ table []
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , th [] [ text "Name" ]
                    , th [] [ text "level" ]
                    , th [] [ text "Actions" ]
                    ]
                ]
            , tbody [] (List.map playerRow players)
            ]
        ]

playerRow: Player -> Html Msg
playerRow player =
    let
        {id, name, level} = player
    in
        tr []
            [ td [] [ text (toString id) ]
            , td [] [ text name ]
            , td [] [ text (toString level) ]
            , td []
                [ editBtn player ]
            ]

editBtn : Player -> Html Msg
editBtn player =
    button
        [ class "btn regular"
        , onClick (ShowPlayer player.id)
        ]
        [ i [ class "fa fa-pencil mr1" ] [], text "Edit" ]