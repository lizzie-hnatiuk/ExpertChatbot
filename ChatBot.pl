% Pronoun Reversal
% changes grammatical person of sentance (for response creation)
me_you(me, you).
me_you(i, you).
me_you(my, your).
me_you(mine, yours).
me_you(am, are).

% Input/Output
% takes an input string of user text
% returns a response string
main :-
  write('Expert ChatBot Sample'),
  % repeat forces code to endlessly repreat (until something termiates backtracking)
  repeat,
  write('➟ '), read_string(InputString),
  respond(InputString, ResponseString),
  write(ResponseString),
  % forces backtracking until user inputs 'quit'
  InputString == 'quit'.

%Core Pattern Matcher - Respond function
respond(InputString, ResponseString) :-
  string_to_list(InputString, InputWordList),
  swap_person(InputWordList, SwappedWordList),
  form_response(SwappedWordList, ResponseWordList),
  list_to_string(ResponseWordList, ResponseString),
  % ! turns off auto backtracking
  %- so we have one response per user input
  !.

  %String/List conversion
  %Split string into list of words sepearated by " "
  string_to_list(String, WordList) :-
    split_string(String, " ", "", WordList).
  %Condense list of words into single String in same order
  list_to_string([], "").
  list_to_string([Word], String) :-
    Word == String.
  list_to_string([Word|T], String) :-
    string_concat(Word, " ", WordWithSpace),
    list_to_string(T, TailString),
    string_concat(WordWithSpace, TailString, String).
