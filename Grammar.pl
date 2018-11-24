% *************** Grammar.pl contains the Relations for the ChatBot ***************
% *********************  pertaining to general grammar rules *********************

% ************************** Genrative Rules for Syntax **************************
%   * S —> NP VP
%   * NP —> (DET) (ADJ) N (PP)
%   * VP —> V (NP) (PP)
%   * PP —> P (NP)
%   * note: in brackets = optional
%   * topicalization: S —> VP_NP NP VP_V (VP_PP)

% Sentance --> NounPhrase + VerbPhrase
sentence(L0,L2) :-
  noun_phrase(L0,L1),
  verb_phrase(L1,L2).

% topicalization: optional movement NP after verb in VP to front of sentance
sentance(L0,L4) :-
  noun_phrase(L0,L1),
  noun_phrase(L1,L2),
  verb(L2,L3),
  pp(L3,L4).

% NounPhrase --> (Determiner) (Adjective) Noun (PrepositionalPhrase)
noun_phrase(L0,L4) :-
    det(L0,L1),
    adjectives(L1,L2),
    noun(L2,L3),
    pp(L3,L4).

% VerbPhrase --> Verb (NounPhrase) (PrepositionalPhrase)
verb_phrase(L0,L3) :-
  verb(L0,L1),
  noun_phrase(L1,L2),
  pp(L2,L3).

% PrepositionalPhrase --> Preposition (NounPhrase)
pp(L0,L2) :-
  preposition(L0,L1),
  noun_phrase(L1,L2).
