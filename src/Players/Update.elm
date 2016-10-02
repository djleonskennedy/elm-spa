module Players.Update exposing (..)
import Players.Messages exposing (Msg(..))
import Players.Commands exposing (save)
import Players.Models exposing (Player, PlayerId)
import Navigation



update: Msg -> List Player -> ( List Player, Cmd Msg )
update msg players =
    case msg of
        FetchAllDone newPlayers ->
            ( newPlayers, Cmd.none )

        FetchAllFail error ->
            ( players, Cmd.none )

        ShowPlayers ->
            ( players, Navigation.newUrl "#players" )

        ShowPlayer id ->
            ( players, Navigation.newUrl ("#player/" ++ (toString id)) )

        ChangeLevel id howMuch ->
            ( players, changeLevelCommands id howMuch players |> Cmd.batch )

        SaveSuccess updatedPlayer ->
            ( updatePlayer updatedPlayer players, Cmd.none )

        SaveFail error ->
            ( players, Cmd.none )



updatePlayer : Player -> List Player -> List Player
updatePlayer updatedPlayer =
    let
        select existingPlayer =
            if existingPlayer.id == updatedPlayer.id then
                updatedPlayer
            else
                existingPlayer
    in
        List.map select



changeLevelCommands : PlayerId -> Int -> List Player -> List (Cmd Msg)
changeLevelCommands playerId howMuch =
    let
        cmdForPlayer existingPlayer =
            if existingPlayer.id == playerId then
                save { existingPlayer | level = existingPlayer.level + howMuch }
            else
                Cmd.none
    in
        List.map cmdForPlayer