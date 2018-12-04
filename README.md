![](https://placehold.it/950x95/393a66/c7c9ff?text=Generalized+'Expert'+Chatbot)

![](https://placehold.it/950x60/c7c9ff/393a66?text=What+is+the+Problem?)
The problem at hand is to examine the benefits and drawbacks of using logic programing (specifically, SWI Prolog) in creating a chatbot (namely, a program to which a user may make statements using natural language, and receive a response in natural language). Specifically,  we will be assessing the characteristics of prolog optimized for search, flexible pattern matching, databases, parsing, first order logic, and controlled natural language.

![](https://placehold.it/950x60/c7c9ff/393a66?text=What+is+the+Something+Extra?)
The chatbot is ‘intelligent’ in the sense that it can recognize abstract patterns and respond appropriately within multiple different domains. The chatbot uses function symbols to abstract linguistic patterns and construct linguistic individuals, and will use separate databases for specific <i>ontologies</i><sup>[1](#Notes)</sup>. The ontologies are usable by the function symbols to support specific applications for the chatbot. For example, an ontology could be created to represent an expert system that warns people about what foods they can and cannot eat based on allergies<sup>[iii](#References)</sup>.  Without the ontology, the knowledge would all be stored in the linguistic rules specified by function symbols. With the ontology, the rules become simple general purpose rules and the knowledge is stored in the ontology. The current state of the chatbot makes use of some of the ontologies defined in <i>WordNet</i><sup>[ii](#References)</sup>, an electronic lexical database started at Princeton University. More ontologies may be easily added by following the example of the use of the WordNet components (wn_s.pl, wn_g.pl, wn_ant.pl, wn_hyp.pl) in Dictionary.pl (for searching the ontologies) and the special_response declarations in GeneralResponsePatterns.pl (for using the search functions to create chatbot responses).

![](https://placehold.it/950x60/c7c9ff/393a66?text=Interesting+Functionality)
* The chatbot is able to respond to any natural language query containing a specific word or sequence of words with a single specified response, or a random selection from a list of possible specified responses.
  * eg: The response to a query containing the phrase "how are you" is "good, thank you for asking :)"
  * eg: The response to a query containing the phrase "I want to X" is one of:
    * "why would you want to X?"
    * "you can not X."
    * "is it dangerous to X?"
  * New <i>natural language response patterns</i><sup>[2](#Notes)</sup> may be easily specified in GeneralResponsePatterns.pl
* The chatbot is able to respond to special natural language queries with specialized information.
  * Current <i>special response patterns</i><sup>[3](#Notes)</sup>:
    * The chatbot is able to give a list of possible definitions (as a numbered list) for any word X when asked: "what does X mean?"
    * The chatbot is able to provide a list of possible <i>antonyms</i><sup>[4](#Notes)</sup>(as a numbered list) for any word X when asked: "what are antonyms of X?"
    * The chatbot is able to provide a list of possible <i>hyponyms</i><sup>[5](#Notes)</sup> (as a numbered list) for any word X when asked: "what are hyponyms of X?"
  * New special response patterns may be easily specified in GeneralResponsePatterns.pl
* If there are no response patterns specified for a given query, the chatbot simply reverses the pronouns and adds a question mark on the end
  * eg: The response the the query "I think you are nice" (which has no specified natural language or special response patterns) is "you think I am nice?"
* The chatbot makes use of the conversion of the WordNet Schema(a lexical database for the English language) to RDF/OWL<sup>[i](#References)</sup> ontologies.
* Grammar rules are abstracted such that the chatbot is able to understand conversations in any language (whose syntax is similar to english in the sense that a sentence is a noun phrase followed by a verb phrase, etc.) through simply changing the language of the words in the response pattern & synset ontology (GeneralResponsePatterns.pl & wn_s.pl).

![](https://placehold.it/950x60/c7c9ff/393a66?text=What+Did+We+Learn+From+Doing+This?)
#### Benefits of Using SWI Prolog for This Task
* The atom data type is very helpful for working with strings, numbers, input/output, and database queries.
* built-in functions for splitting and concatenating strings and lists very helpful for linguistic deconstruction of syntax and morphology of natural language
* Quick, accurate search of large databases.
* Automatic backtracking feature allows for linguistic structures to be deconstructed repeatedly until one of the specified frameworks works - this is essential for natural language processing, as natural language has a variety of different general sentence, phrase, and word structures which all achieve the same goal.
  * eg: two different ways an english sentence may be constructed are:
    * A Noun (Subject) Phrase followed by a Verb (Object) Phrase
      * <i>the ugly man said "get off my lawn, kids!"</i>
    * An Object Noun Phrase followed by a Subject Noun Phrase followed by a Verb
      * <i>"get off my lawn, kids!" the ugly man said</i>
* Built in debugger 'trace' allows for real-time debugging of input/output.
#### Drawbacks of Using SWI Prolog for This Task   
* Operations on elements of lists require lots of code.
* Use of if-then-else can be very ugly.
* Automatic backtracking feature makes debug log extremely long.
#### General Problems Encountered
* The way people can automatically deconstruct sentences and understand differences between subject and object pronouns is very complex.

![](https://placehold.it/950x60/c7c9ff/393a66?text=Link+to+UBC+Wiki)
https://wiki.ubc.ca/Generalized_'Expert'_Chatbot_CPSC312

<a href='#Notes' id='Notes' class='anchor' aria-hidden='true'></a>
![](https://placehold.it/950x60/c7c9ff/393a66?text=Notes)
1) Ontology:  a representation, formal naming, and definition of the categories, properties, and relations between the concepts, data, and entities that substantiate one, many, or all domains.
2) Natural language response pattern: use pattern matching to provide responses to common colloquial phrases (i.e. those often used in conversational speech).
3) Special response pattern: use functions over ontologies to specialized obtain information.
4) Antonym: a word of opposite meaning.
   * eg: <i>happy</i> is an antonym of <i>sad</i>.</li>
5) Hyponym: a word of more specific meaning than a general term (i.e. a word whose meaning is included in the meaning of another word) .
   * eg: <i>spoon</i> is a hyponym of <i>cutlery</i>.</li>


#### Authors
Elizabeth Hnatiuk, Fengyi Bian & Jia Bin Wang

#### Course Section
CPSC 312 101

#### Date of Project Completion
November 2018

<a href='#References' id='References' class='anchor' aria-hidden='true'></a>
![](https://placehold.it/950x60/c7c9ff/393a66?text=References)
i) Assem, M.V., Gangemi, A. & Schreiber, G. (Eds). (2006)  RDF/OWL Representation of WordNet. <i>W3C Working Draft (19)</i>. Retrieved from: http://www.w3.org/TR/2006/WD-wordnet-rdf-20060619/.

ii) Fellbaum, C. (1998) WordNet: An Electronic Lexical Database. <i>Princeton University</i>. Retrieved from: http://wordnet.princeton.edu/.

iii) Merritt, D. (2003) AI - The art and science of making computers do interesting things that are not in their nature. <i>Dr. Dobb's AI Expert Newsletter (11)</i>. Retrieved from: https://trilug.org/pipermail/dev/2003-September/000368.html.
