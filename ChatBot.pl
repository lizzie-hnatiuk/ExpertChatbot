% *************** ChatBot.pl contains the Relations for the ChatBot ***************
% ************  pertaining to input deconstruction & output formation ************

:- consult('GeneralResponsePatterns.pl').
:- consult('Dictionary.pl'). % Dictionary from WordNet RDF/OWL Files: https://www.w3.org/2006/03/wn/wn20/

% *Input/Output*
% takes an input string of user text
% writes the response string
main :-
  write("Expert ChatBot Sample - type something -> "), nl, nl,
  % repeat forces code to endlessly repreat (until something termiates backtracking)
  repeat,
  read_line_to_codes(user_input, CharCodeList),
  atom_codes(InputAtom, CharCodeList),
  atom_string(InputAtom, InputString),
  respond(InputString, ResponseString), nl,
  write("（っ＾▿＾） "),
  split_string(ResponseString, "~", "", StringList),
  writeall(StringList), nl, nl,
  % forces backtracking until user inputs 'quit'
  InputString == "quit".

writeall([]).
writeall([H|T]) :- writeln(H), writeall(T).

% *Core Pattern Matcher - Respond function*
respond(InputString, ResponseString) :-
  string_to_list(InputString, InputWordList),
  analyze_syntax(InputWordList, Subject, Predicate)
  ->(
    swap_subject(Subject, SwappedSubject),
    swap_predicate(Predicate, SwappedPredicate),
    append(SwappedSubject, SwappedPredicate, SwappedWordList),
    form_response(SwappedWordList, ResponseWordList),
    list_to_string(ResponseWordList, ResponseString),
    !
    )
  ; (
    string_to_list(InputString, InputWordList),
    form_response(InputWordList, ResponseWordList),
    list_to_string(ResponseWordList, ResponseString),
    !
    ).

% *String/List conversion*
%Split string into list of words sepearated by " ", remove ?s
string_to_list(String, WordList) :-
  split_string(String, " ", "?", WordList).
%Condense list of words into single String in same order
list_to_string([], "").
list_to_string([Word], String) :-
  Word == String.
list_to_string([Word|T], String) :-
  string_concat(Word, " ", WordWithSpace),
  list_to_string(T, TailString),
  string_concat(WordWithSpace, TailString, String).

% *Using Pronoun Reversal to Create Response*
%swaps subject pronouns and other pronouns
swap_subject([], []).
swap_subject([S|Ss], [SS|SSs]) :-
  swap_word(S, SS), not(S==SS),
  !, swap_subject(Ss,SSs).
swap_subject([S|Ss], [SS|SSs]) :-
  swap_word_s(S, SS),
  !, swap_subject(Ss,SSs).

%swaps object pronouns and other pronouns
swap_predicate([], []).
swap_predicate([P|Ps], [SP|SPs]) :-
  swap_word(P, SP), not(P==SP),
  !, swap_predicate(Ps,SPs).
swap_predicate([P|Ps], [SP|SPs]) :-
  swap_word_p(P, SP),
  !, swap_predicate(Ps,SPs).

%looks at K.B. to see if word is mentioned in pronoun reversals
swap_word(X, Y) :- me_you(X, Y).
swap_word(X, Y) :- me_you(Y, X).
%if not in K.B., word is replaced with itself
swap_word(W,W).
% specialized pronoun swapping for object & subject pronouns (when to use "me" vs "I")
swap_word_p(X, Y) :- me_you_p(X, Y).
swap_word_p(X, Y) :- me_you_p(Y, X).
swap_word_p(W,W).
swap_word_s(X, Y) :- me_you_s(X, Y).
swap_word_s(X, Y) :- me_you_s(Y, X).
swap_word_s(W,W).

% *Forming the Response*
% remember input list has swapped pronouns!!!
form_response(In, Out) :-
  special_response(In, ResponsePatterns) %for definition queries
  -> (
     add_nums(ResponsePatterns, 1, NumPatterns), %adds numbers to each response
     flatten(NumPatterns, Out)
     )
  ;  (
     response(InputPattern, ResponsePatterns), %for all other response patterns
     match(InputPattern, In),
     random_elem(ResponsePatterns, ResponsePattern),
     flatten(ResponsePattern, Out)
     ).

add_nums([], _, []).
add_nums([S|Ss], N, [Numbered|UnNumbered]) :-
  atom_number(AN, N),
  atom_string(AS, S),
  atom_concat('~', AN, Splitter),
  atom_concat(Splitter, ' . ', Num),
  atom_concat(Num, AS, NumS),
  %atom_concat(NumS, '\nl', NumLn),
  atom_string(NumS, Numbered),
  N1 is N+1,
  add_nums(Ss, N1, UnNumbered).

%returns random answer from list of possible answers
random_elem(List, Elem) :-
  count(List, N),
  N>1 -> random(1, N, I),nth1(I, List, Elem) ; head(List, Elem).

head([H|_], H).

%counts number of elements in a list
count([], 0).
count([_|Tail], N) :-
  count(Tail, N1),
  N is N1 + 1.

% *Matching Input with Response Rules*
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

% *Walking Input List to Find Key Words*
% key words = those specified in response functions in GeneralResponsePatterns.pl
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
