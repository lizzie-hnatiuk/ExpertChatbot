% Pronoun Reversal
% knowledge base portion of program
% changes grammatical person of sentance (for response creation)
me_you(me, you).
me_you(i, you).
me_you(my, your).
me_you(mine, yours).
me_you(am, are).
me_you(im, youre).

% Input/Output
% takes an input string of user text
% returns a response string
main :-
  write("Expert ChatBot Sample"), nl,
  % repeat forces code to endlessly repreat (until something termiates backtracking)
  write("Ask me anything!"), nl,
  repeat,
  write("➟ "), nl,
  read_line_to_codes(user_input, CharCodeList),
  atom_codes(InputAtom, CharCodeList),
  atom_string(InputAtom, InputString),
  respond(InputString, ResponseString), nl,
  write(ResponseString), nl,
  % forces backtracking until user inputs 'quit'
  InputString == "quit".

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

%Using Pronoun Reversal to Create Response
%boundary condition: if list is empty, were done.
swap_person([], []).
%recursive condition:
%    - take first ward in list and call swap_word/2
%    - put replacement word in output list
%    - recursively call rest of input list
swap_person([X|Xs], [Y|Ys]) :-
  swap_word(X, Y),
  !, swap_person(Xs, Ys).

%looks at K.B. to see if word is mentioned in pronoun reversals
swap_word(X, Y) :- me_you(X, Y).
swap_word(X, Y) :- me_you(Y, X).
%if not in K.B., word is replaced with itself
swap_word(W,W).

%Forming the Resopnse
% for now, simply add question mark to end
form_response(In, Out) :-
  append(In, ["?"], Out).
