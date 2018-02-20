module Page exposing (..)

-- Elm Imports
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Extra as LE exposing ()

-- Question Build Imports
{- insert correct Question -}
import QuestionName as Question

-- Survey Build Imports
import SurveyMsgs

type alias PageData =
  { r |
    currentPage : False -- this shoudl be handled by routing really, this is just for now.
  , visited : False
  , questionTitle : String
  , questionText : String
  , quesitonAnswers : List String
  , questionButtonText : String
  }       -- use blueprint to construct and insert
type PageMsg = Quit | Answer   -- use blueprint to construct and insert
{- NB: sometimes the record answer msg will come from the page, sometimes from the
       question this can be decided from the blueprint/@pages hash
       Answer updating will always be done from the question page.
-}

drawPage : SurveyState -> Bool
drawPage currentState =
  True -- build logic from blueprint

view : Bool -> Html SurveyMsg
view admin =
  div
    []
    if admin then
        [ drawAdminPanel, drawPageContent ]
    else
        [ drawPageContent ]

drawAdminPanel : Html SurveyMsg
drawAdminPanel =
    div [] [] -- build from blueprint and insert

drawPageContent : PageData -> Html SurveyMsg
drawPageContent data =
    div
      []
      [ Quesion.view data ] -- build from blueprint and insert
