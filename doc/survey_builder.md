# SurveyBuilder

## Description
FAAS implementation of an environment for constructing surveys.


## Operational Flow
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
### QuestionName::Msgs
- UpdateAnswer1 String
- UpdateAnswer2 String
- ... ...
- UpdateAnswerN String

NB: a Maximum number of answers is necc. Multiple choice questions with less than
    the max are acceptable to the compiler, adding

### QuestionName::view(s)
```elm
questionSection : String -> String -> String -> List String
heading : String -> Html Msg
question : String -> Html Msg
answers : List String -> Html Msg
answer : String -> Html Msg
```

- answer may be any function which takes user input and generates
  (QuestionName::Msg = UpdateAnswerN String)

### QuestionName::formatAnswer : String -> Encode.Value
- takes a string input representing the question answer and encodes it as a JSON::Value

## PageId.elm


## ToDo

## Environment
