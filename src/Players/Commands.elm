module Players.Commands exposing (..)

import Http
import Task
import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=), int, string, Decoder, object3, list)
import Players.Models exposing (PlayerId, Player)
import Players.Messages exposing (..)

-- GET DATA

fetchAll : Cmd Msg
fetchAll =
    Task.perform FetchAllFail FetchAllDone
        <| Http.get collectionDecoder fetchUrl

fetchUrl: String
fetchUrl =
    "http://localhost:4000/players"

collectionDecoder: Decoder (List Player)
collectionDecoder =
    list playerDecoder

playerDecoder: Decoder Player
playerDecoder =
    object3 Player
        ( "id" := int )
        ( "name" := string )
        ( "level" := int )

-- SAVE DATA

saveUrl : PlayerId -> String
saveUrl playerId =
    "http://localhost:4000/players/" ++ (toString playerId)


saveTask : Player -> Task.Task Http.Error Player
saveTask player =
    let
        body =
            playerEncoded player
                |> Encode.encode 0
                |> Http.string

        config =
            { verb = "PATCH"
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = saveUrl player.id
            , body = body
            }
    in
        Http.send Http.defaultSettings config
            |> Http.fromJson playerDecoder


save : Player -> Cmd Msg
save player =
    saveTask player
        |> Task.perform SaveFail SaveSuccess


playerEncoded : Player -> Encode.Value
playerEncoded player =
    let
        list =
            [ ( "id", Encode.int player.id )
            , ( "name", Encode.string player.name )
            , ( "level", Encode.int player.level )
            ]
    in
        list
            |> Encode.object