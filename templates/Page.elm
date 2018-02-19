module Page exposing (..)
import QuestionName as Question {- insert correct Question here -}


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


update : PageMsg -> PageData -> (Answers, Cmd PageMsg)
update pageMsg pageData =
  case pageMsg of
    DrawPage ->
      ( { pageData | currentPage = True
                   , visited = True
        }
      , Cmd.none
      )

view : Bool -> Html SurveyMsg
view admin =
  div
    []
    if admin then
        [ drawAdminPanel
        , drawPageContent
        ]
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
