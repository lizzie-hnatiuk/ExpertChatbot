% ***** GeneralResponsePatterns.pl contains the Knowledge Base for the ChatBot *****
% **********************  pertaining to natural language flow **********************

% ********************************Pronoun Reversal ********************************
% changes grammatical person of sentance (for response creation)

% Possessive Adjectives
% noun determiners : my his her its your our their ...
me_you("my", "your").

% Possessive Pronouns
% refer to  N or NP, can replace N or NP, shows possession
% eg: mine yours his hers its ours yours theirs...
me_you("mine", "yours").

% Subject Pronouns
% subject: the NP sister to VP, daughter of S
me_you("i", "you").

% Object Pronouns
% object: the NP sister to V, daughter of VP
me_you("me", "you").

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
      ["is","it","strange","to","like",X,?] ]).

response( [_,"want","to",X],
          [ ["why","would","you","want","to",X,?],
            ["you","can","not",X,'.'],
            ["is","it","dangerous","to",X,?] ]).

response( [X], [ [X,?] ]).
