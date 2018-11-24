% Knowledge Base portion of program -----------------------------------------------

% Pronoun Reversal
% changes grammatical person of sentance (for response creation)
me_you("me", "you").
me_you("i", "you").
me_you("my", "your").
me_you("mine", "yours").
me_you("am", "are").
me_you("im", "you're").
me_you("im", "you're").

%general response rules for converation flow
response( ["yes",_],
    [ ["why",?] ]).
response( ["no",_],
    [ ["why","not",?] ]).
response( [_,"you","like",X],
    [ ["how","can","you","like",X,?],
      ["is","it","strange","to","like",X,?] ]).
response( [_,"want","to",X],
          [ ["why","would","you","want","to",X,?],
            ["you","can","not",X,'.'],
            ["is","it","dangerous","to",X,?] ]).
response( [X],
          [ [X,?] ]).
%Rule portion of program ----------------------------------------------------------

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

%Forming the Response
% for now, simply add question mark to end
% remember input list has swapped pronouns!!!
form_response(In, Out) :-
  response(InputPattern, ResponsePatterns),
  match(InputPattern, In),
  %random_elem(ResponsePatterns, ResponsePattern),
  flatten(ResponsePatterns, Out).


%returns random answer from list of possible answers
random_elem(List, Elem) :-
  count(List, N),
  !,
  random(1, N, I),
  nth1(I, List, Elem).

%counts number of elements in a list
%count([], 0).
count([_|Tail], N) :-
  count(Tail, N1),
  N is N1 + 1.

%Matching Input with Response Rules
% boundary condtions:
%   - when input list is empty
match([], []).
%   - when only element left is a variable
%        - variable bound to whatever is left of input
match([Xs], IWs) :-
    var(Xs),
    !,
    Xs = IWs.
% recursive cases:
%    - next element in input is a variable
%        - call fill_var to gather words up
%          until next specific word is encountered
match([Xs,W|PWs], IWs) :-
    var(Xs),
    !,
    fill_var(Xs, W, IWs, IWsLeft),
    match([W|PWs], IWsLeft).
%    - next element is a specific word
%        - if matches user input, continue recursion
match([W|PWs], [W|IWs]) :-
    !,
    match(PWs, IWs).

%Walking Input List to Find Words
% 4 arguments:
%    - the output list of words
%         - returned to caller
%    - the next word in the input pattern
%         - causes recursion to stop when it’s found
%    - the user input list being walked
%         - looking for the stop word
%    - the remainder of the input list
%         - returned to caller for further processing
fill_var([], W, [W|IWs], [W|IWs]) :-
    !.
fill_var([X|Xs], W, [X|IWs], IWsLeft) :-
    fill_var(Xs, W, IWs, IWsLeft).
