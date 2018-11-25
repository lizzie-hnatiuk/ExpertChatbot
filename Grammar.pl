% *************** Grammar.pl contains the Relations for the ChatBot ***************
% *********************  pertaining to general grammar rules *********************

:- consult('ConversationOntology.pl').

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
% sentance(L0,L4) :-
%   noun_phrase(L0,L1),
%   noun_phrase(L1,L2),
%   verb(L2,L3),
%   pp(L3,L4).

% NounPhrase --> (Determiner) (Adjective) Noun (PrepositionalPhrase)
noun_phrase(L0,L4) :-
    opt_det(L0,L1),
    opt_adjectives(L1,L2),
    noun(L2,L3),
    opt_pp(L3,L4).

% VerbPhrase --> Verb (NounPhrase) (PrepositionalPhrase)
verb_phrase(L0,L3) :-
  verb(L0,L1),
  opt_noun_phrase(L1,L2),
  opt_pp(L2,L3).

% PrepositionalPhrase --> Preposition (NounPhrase)
pp(L0,L2) :-
  preposition(L0,L1),
  opt_noun_phrase(L1,L2).

% ************************** Helper Functions for Rules **************************

% Adjectives is a sequence of adjectives adjectives(L,L).
adjectives(L0,L2) :-
  adj(L0,L1),
  adjectives(L1,L2).
adjectives(L0,L1) :- adj(L0,L1).

% optional determiners, adjectives, prepositional phrases, noun phrases
%  are either nothing or themself
opt_det(L0,L1) :-
  det(L0,L1).
opt_det(L,L).

opt_adjectives(L0,L1) :-
    adjectives(L0,L1).
opt_adjectives(L,L).

opt_pp(L0,L1) :-
    pp(L0,L1).
opt_pp(L,L).

opt_noun_phrase(L0,L1) :-
    noun_phrase(L0,L1).
opt_noun_phrase(L,L).

% ************************ Using the Conversation Ontology ************************

% relation to access types of words words in our ontology
property(Word, Property, Value) :-
    word(Word, PropertyList),
    member(Property = Value, PropertyList).

% ************************ Dictionaries For Word Type ************************

det([StringWord | L], L) :-
  atom_string(Word, StringWord),
  property(Word, type, det).
det(L,L).

noun([StringWord | L], L) :-
  atom_string(Word, StringWord),
  property(Word, type, noun).

adj([StringWord | L],L) :-
  atom_string(Word, StringWord),
  property(Word, type, adj).

verb([StringWord | L],L) :-
  atom_string(Word, StringWord),
  property(Word, type, verb).

preposition([StringWord | L],L) :-
  atom_string(Word, StringWord),
  property(Word, type, prep).
