# SurveyBuilder

## Description
FAAS implementation of an environment for constructing surveys.

## Developer Guidance
- Must use TDD as described below
  - Do not write any code without a spec
  - Write a minimal spec for the _top level_ functionality
  - Only write code to pass that spec
  - Write a spec that defines the _next level lower_ of functionality
- Code should be readable
  - No single/double/triple char var names
  - Keep func/var names as short as possible to describe the function
    - The more specialised the function, the longer the name
  - Short functions are happy functions, except Elm `update`s
  - Comments are encouraged but should not replace code readability



## Program Flow
#### Overall Operational Flow
- A blueprint is read in and a hash is generated from the structure.
  - This \@pages hash (which may be nested) contains a symbol or a string at
    each of its leaves.
  - \@pages[:page_id][...][:leaf_symbol] is a direction to insert a code from a
    JS/Elm template into a file.

  - For each page in \@pages (defined in a blueprint)
    - A complete PageId.elm is built from PageTemplate.elm
      - A QuestionName.elm template is used to generate the question portion
        - Text is inserted into QuestionName::view(s)
      - PageId::update is updated to handle QuestionName::Msgs to update answers dictionary
      - PageId::Msgs is updated to carry QuestionName::Msgs
      - Text is inserted into PageId::view(s)

    - Router.elm is updated to handle this page
    - Answers in Models.elm is updated
    - Main::answersJson is updated to handle answer formatting
    - PageId.elm is included in Main.elm
    - Main.elm::update is updated to handle PageId::Msgs
      - PageId::Msg = NextPage|Finish|FilterOut|Answers
      - Updating Answers Model
      - Performing sample filtering logic
- Main.elm is compiled

#### bootstrapping data loader (SurveyBuildMachine)
- One time operation on deploy
- Each template is loaded into a cog
- A survey cog is loaded with the template cogs

#### Blueprint -> JSON
- Use online docs for DSL to produce template JSON for each product.
- Trim branches off template JSON using the order data
  - Find form of order to restrict the template JSON
  - Eventually would like to simply generate the JSON from the order and blueprint instead of trimming so we can modularise survey purchase and generation.

#### JSON -> data loader
- Pages are loaded sequentially to maintain the build order. (ie/ this is not a parallel or concurrent algorithm)
**Construct a few page and question cogs and revisit this part**


## SurveyBuildMachine
#### Input JSON
```javascript
  {
    'page_0': {
      'question_type': 'QuestionName',
      'header': 'some title string',
      'question': {
        'title': 'some title string',
        'text': 'actual question',
        'answers': [
          'answer_0': 'answer 0',
          ...,
          'answer_n': 'answer n'
        ]
      },
      'showLogic': {
        'answer_a': 'condition',
        'answer_b': 'condition'
      }
    },
    'page_1': {
      ...
    },
    ...,
    'page_n': {
      ...
    }
  }
```


## Main.elm

### Main::answersJson : List String -> JSON::Encode::Value
```Elm
  Encode.object
    [ ('answer_1', 1st_QuestionName_PageId::formatAnswer),
      ...,
      ('answer_n', Nth_QuestionName_PageId::formatAnswer)
    ]
```


## QuestionName.Elm
#### QuestionName::Msgs
- UpdateAnswer1 String
- UpdateAnswer2 String
- ... ...
- UpdateAnswerN String

NB: a Maximum number of answers is necc. Multiple choice questions with less than
    the max are acceptable to the compiler, adding

#### QuestionName::view(s)
```elm
questionSection : String -> String -> String -> List String
heading : String -> Html Msg
question : String -> Html Msg
answers : List String -> Html Msg
answer : String -> Html Msg
```

- answer may be any function which takes user input and generates
  (QuestionName::Msg = UpdateAnswerN String)

#### QuestionName::formatAnswer : String -> Encode.Value
- takes a string input representing the question answer and encodes it as a JSON::Value

## PageId.elm
#### PageId.drawPage
- Logic Function governing whether page is drawn or skipped
- Should this always exist?
  - return true if page is drawn or if there is no logic to decide this
  - returns false only if logic exists


## Overall Ideas

#### Message passing chain
- QuestionAnswerMsg String -> Survey.update
  - via some `onEvent`
  - Survey must know about QuestionMsgs
- PageNavigationMsg -> Survey.update
  - via `onClick`
  - Survey must know about PageMsgs

#### Imports
- Survey has Messages, Views, Update, State Model
  - imports PageMsgs, QuestionMsgs, PageLogic, PageViews
- Page has Messages, Views, and Logic functions (for display_if etc)
  - imports QuestionViews, SurveyState
  - How to deal with skipped pages?
- Question has Messages, Views, SurveyState

#### SurveyStateModel.elm
- Built via bluprint JSON
- Contains both state and JSON encoding function for the state

#### ApiRequestPipe
- Pipe out JSON to JS land and ajax that shit to the server.
- How many API calls needed?
  - Only one for MVP, to submit.
  - Can catch window closing/reloading respondents with onUnload event?


## ToDo

## Environment
