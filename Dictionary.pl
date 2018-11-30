:- consult('wn_g.pl'). % Glossary from WordNet RDF/OWL Files: https://www.w3.org/2006/03/wn/wn20/
:- consult('wn_s.pl'). % Dictionary from WordNet RDF/OWL Files: https://www.w3.org/2006/03/wn/wn20/
:- consult('wn_hyp.pl'). % Hyponyms from WordNet RDF/OWL Files: https://www.w3.org/2006/03/wn/wn20/
:- consult('wn_ant.pl'). % Antonyms from WordNet RDF/OWL Files: https://www.w3.org/2006/03/wn/wn20/



% s(ID, X, word, type, Y, Z)
% consults distionary in wn_s.pl to categorize type of input words:
%   - NOUN n
%   - VERB v
%   - ADJECTIVE a
%   - ADJECTIVE SATELLITE s
%   - ADVERB r
analyze_syntax(Sentance, Subject, Predicate) :-
  member(Verb, Sentance),
  atom_string(V, Verb), %convert string to atom
  s(_,_,V,v,_,_), %find the verb
  split_list(Sentance, Verb, Subject, Predicate).

%splits word list around the verb
split_list([], _, [], []).
split_list(In, Split, S, [Split|P]) :- append(S,[Split|P],In), !.

%gets Definition for a specified word (String) from wn_g.pl glossary
define(String, Definition) :-
  atom_string(Word, String),
  s(ID, _, Word,_,_,_),
  g(ID, Def),
  atom_string(Def, Definition).

alldefs(String, DefList) :-
  findall(Def, define(String, Def), DefList).

hyponym(String, Hyponym) :-
  atom_string(Word, String),
  s(ID, _, Word,_,_,_),
  hyp(ID, HypID),
  s(HypID, _, Hyp,_,_,_),
  atom_string(Hyp, Hyponym).

allhyps(String, HypList) :-
  findall(Hyp, hyponym(String, Hyp), HypList).

antonym(String, Antonym) :-
  atom_string(Word, String),
  s(ID, _, Word,_,_,_),
  ant(ID, _, AntID, _),
  s(AntID, _, Ant,_,_,_),
  atom_string(Ant, Antonym).

allants(String, AntList) :-
    findall(Ant, antonym(String, Ant), AntList).
