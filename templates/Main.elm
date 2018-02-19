module Main

include Html exposing (..)

type SurveyMsg = NextPage | Finish  -- build from blueprint and insert
type alias Answers = {}             -- build from blueprint and insert

init : (Answers, SurveyMsg)
init = ({}, Cmd.none)

update : SurveyMsg -> Answers -> (Answers, Cmd SurveyMsg)
update msg answers =
  case msg of
    NextPage ->
      (answers, Cmd.none)
    Finish ->
      (answers, Cmd.none)

view : Html SurveyMsg
view =
    div [] []                      -- build from blueprint and insert

program : Program Never Answers SurveyMsg
program =
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }
