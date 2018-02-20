module Question exposing (..)

-- Elm Imports
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Extra as LE exposing ()

-- Page Build Imports
import PageMsgs

-- SUrvey Build Imports
import SurveyMsgs


type QuestionMsg = Answer1 String -- build from blueprint and insert
type alias QuestionData =
  { r |
    questionTitle : String
  , questionText : String
  , quesitonAnswers : List String
  , questionButtonText : String
  }

questionMsgs : List QuestionMsg -- build from blueprint and insert
questionMsgs = [ Answer1 ]


view : QuestionData -> Html QuestionMsg
view ({questionTitle questionText questionAnswers questionButtonText} as data) =
    div
      [ class "question" ]
      [ header questionTitle
      , question quesitonText
      , div
          [ class "kind-of-answer" ]
          [ callAnswer stringArgument listStringArgument ] -- insert based on question type
      , button
          [ onClick NextPageMessage ]
          [ buttonText ]
      ]


callAnswer = List.map answer answers
callAnswer = List.map answer <| LE.zip questionMsgs answers


answer : (QuestionMsg, (String, String)) -> Html SurveyMsg
answer (message (answer, code)) =
  div [] [] -- build based on question type in blueprint
