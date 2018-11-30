% ***** GeneralResponsePatterns.pl contains the Knowledge Base for the ChatBot *****
% **********************  pertaining to natural language flow **********************

:- consult('Dictionary.pl').

% ********************************Pronoun Reversal ********************************
% changes grammatical person of sentance (for response creation)

% Object Pronouns
% object: the NP sister to V, daughter of VP
me_you_p("me", "you").

% Subject Pronouns
% subject: the NP sister to VP, daughter of S
me_you_s("I", "you").
me_you_s("i", "you").

% Possessive Pronouns
% refer to  N or NP, can replace N or NP, shows possession
% eg: mine yours his hers its ours yours theirs...
me_you("mine", "yours").

% Possessive Adjectives
% noun determiners : my his her its your our their ...
me_you("my", "your").

% Pronoun Verbs
me_you("am", "are").

% Pronoun-Verb Conjunctions
me_you("im", "you're").
me_you("i'm", "you're").

% ******************General Response Rules for Converation Flow ******************
response( ["yes",_],
    [ ["why",?] ]).

response( ["no",_],
    [ ["why","not",?] ]).

response( [_, "your", "name", "is", X],
      [ ["nice","to", "meet", "you", X, "!"] ]).

response( [_,"you","like",X],
    [ ["how","can","you","like",X,?],
      ["is","it","strange","to","like",X,?],
      ["XXXX"] ]).

response( ["how","am","me",_],
    [ ["good,","thank","you","for","asking",":)"] ]).

response( [_,"how","am","me",_],
    [ ["good,","thank","you","for","asking",":)"] ]).

response( [_,"you","want","to",X],
          [ ["why","would","you","want","to",X,?],
            ["you","can","not",X,'.'],
            ["is","it","dangerous","to",X,?],
            ["XXXX"]]).

response( [_,"do","me","want","to",X],
          [ ["I", "would", "love","to",X,'!'],
            ["No,","thank","you",'.'],
            ["XXXX"] ]).

response( [X], [ [X,?] ]).

special_response( ["what","does",X,"mean"],
                  Definitions ) :-  alldefs(X, Definitions).

special_response( ["what","am","hyponyms","of",X],
                  Hyponyms ) :-  allhyps(X, Hyponyms).

special_response( ["what","am","antonyms","of",X],
                  Antonyms ) :-  allants(X, Antonyms).
