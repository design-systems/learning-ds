# Learning Design Systems

## Understanding The Composer

The Composer is the third (?) generation of DS. Privously we had Taylor and
Pipeline.
It's the entry point for DS and executes all other DS participants like
the-mixer, the-curator, the-stylist and so on.

- the-mixer: takes site data (coming from APIs) and add some configurations,
  for now just adds `$Y_compositions` and sets a DS name. All the "solvable"
  parts are _nullified_, why?

- add classifiers on `item.dsClassifier` ?

- the-data-modeler: converts site data into Structs, easier to access

- the-curator: finally uses a solver! :-) uses multiverse compositions
  (harmonies + patterns) to decide which ui components to include on
  the resultant grid. Uses MatrixSolver. UI components are all React.
  For instance, a markov chain having possible UI components and 
  probabilities vectors can be used to specify which UI components should
  be choosen (probabilities vectors == harmonies)

- the-stylist: outputs a list of imgflo urls selected by the-lensman which uses
  multiverse and possible imgflo image filters

- the-plumber: gets the site data, the grid and the mix and outputs html

In the end, the-composer outputs html and a list of imgflo urls to be
consumed/rendered somewhere.

## Understanding Multiverse

Multiverse is a data model and also a collection of FD solvers.

Data model is known as MultiverseJSON, and it's a smart way to define a tree
structure. Each property can have a static value or a sub-stree or array of
possible values, called a _branch_ and symbolized by `Y_`.
It's also easy to specify constraint rules to be applied to those branches
to select between them on a possible walk of the solver.

We have a bunch of solvers like FD.

When we combine MultiverseJSON data of possible values and Multiverse Solvers
to decide between those values, we end up with magically generated stuff like
any pattern from music notes to components/blocks of a generated web site.

There's also a compact way to visualize possible generated content, called
Harmonic Matrixes. Each row is a row/property we want to choose from and each
column is a configuration choosen of those rows. For instance, if we have a
music composition, each row would be an instrument and each column would be 1
for an instrument playing or 0 for silence.

Harmonies are a mix of constraint operations and vectors ??

Constraint operations are operations we can apply on rows/columns of the matrix
or something like Markov chains (i.e. options and probabilities to choose
between them).

## Understanding Markov chains

Markov chains are just finite state machines but with probabilities on state
transitions. Given that, its memory is really limited: only knows about current
state and the next possible one. So it is really good predictor/generator of
sequences (e.g. music notes in a phrase, words in a poetry, HTML blocks in a
page).

# Ideas

- Keep updating harmonies (specially probability vectors of Markov chains) with
  new ones coming from (1) user redesigns and (2) global vectors for a same ds
  on all The Grid
