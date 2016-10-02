module View exposing (view)

import Html exposing (Html, div, text)
import Html.App
import Models exposing (..)
import Messages exposing (Msg(..))
import Players.List
import Players.Edit
import Players.Models exposing (PlayerId)
import Routing exposing (Route(..))



view: Model -> Html Msg
view model =
    div []
        [ page model ]



page : Model -> Html Msg
page model =
    case (Debug.log "msg" model.route) of
        PlayersRoute ->
            Html.App.map PlayersMsg (Players.List.view model.players)

        PlayerRoute id ->
            playerEditPage model id

        NotFoundRoute ->
            notFoundView



playerEditPage: Model -> PlayerId -> Html Msg
playerEditPage model playerId =
    let
        maybePlayer =
            model.players
                |> List.filter (\player -> player.id == playerId)
                |> List.head
    in
        case maybePlayer of
            Just player ->
                Html.App.map PlayersMsg (Players.Edit.view player)
            Nothing ->
                notFoundView



notFoundView: Html Msg
notFoundView =
    div []
        [ text "Not Found"
        ]
