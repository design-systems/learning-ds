# Learning Design Systems

## Understanding The Composer

The Composer is the third (?) generation of DS. Privously we had Taylor and
Pipeline.
It's the entry point for DS and executes all other DS parts like
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

## Understanding ds-nj

- First we call the sites:solve gulp task for some mock
- For that we call the-composer passing mock's siteData
  and composerOptions
    the-mixer:
     compverseJson:
     	 mix:
     	 	 $Y_compositions: src/ds/index ... dsNickJones
- The result from the-composer is written on HTML file
- OK, so what the-composer does?
 - Run the-mixer on siteData
    theMixer = new TheMixer(siteData, options)
    mix = theMixer.getMix().mix
    return mix
  - OK, but what the-mixer does?
    # The contructor does:
    layoutSpectrum = siteData.config.layout_spectrum
    compverseJson = options['the-mixer'].compverseJson
    # And then getMix() does:
    compverse = new Multiverse(compverseJson, {
    	pathAccumulationKeys: ['$formality', '$formalityWeight', $name'],
    	branchPrefix: '$Y_'
    allPaths = compverse.getAllPaths()
    ...
    compverse.collapse( ... )
    # So it creates a compverse based on compositions and
    # some tricky mix (see spectrum-helper.js) of spectrums
    # (both layout and formality weights)
    # In the end it uses such spectrums to collapse/group paths
    # Paths are like solutions for some possible options?
  - OK, but what Multiverse and Multiverse.collapse() do?
    It seems to collpse only what is selected by branchPrefix, so
    given that we have $Y_ as branchPrefix, it only collapses those
    branches, and also given that pathAccumulation is $formality, ...
    it only collapses those keys/values... all other Y_ branches
    remain untouched (which are the majority of branches on the-mixer pass)

    So yeah, it seems this Multiverse for the-mixer is really simple.
    It only cares about formality and spectrum values, not anymore.

    It seems there's some extra complexity on spectrum-helper,
    maybe trying to force some spectrums/formalities, or
    decide based on various formality configs we have, but
    I prefer to see that as a black box for now and continue...
 - Add classifiers to siteData
    Well, there's no mix[data-classifiers], no items:classifiers
    nor site:classifiers on the-dagger, so it adds nothing
    to siteData...

    That's for now, it looks like the placeholder to add
    ML classifiers to items and sites based !!!
 - Maps siteData into Structs to easier/validated access
    In other words, run the-data-modeler on siteData...
 - Run the-curator on siteData, mix and options and return grid
    Uses the config from mix['the-curator']
    Tries to find a site type, uses index by default
    Add ui-components from mix['the-painters]['index']['ui-components']
    And other configs (it seems it's the same for all the-*: first builds the
    config, then run it, some solver generally).
    What the heck is DI??
    So by default runs
    theCurator = new TheCurator(config)
    return theCurator.curate()
   - OK, and what TheCurator.curate does?
    harmoniesComposer = new HarmoniesComposer
      harmonies: ...
      grid: ...
      items: ...
      uiComponents: ...
      siteData: ...
      dataClassification: ...
    matrixComposer = new MatrixComposer
      harmonies: harmoniesComposer.allHarmonies
      grid: ...
      uiComponents: ...
      pathAccumulationKeys: harmoniesComposer.pathAccumulationKeys
      uiComponentsMeta: harmoniesComposer.uiComponentsMeta
      seed: ...
      offorderness: ...
    curate = ->
      fdSolution = matrixComposer.solve(solvingOptions)
      mapsUICompsAndItemsToSections fdSolution
         fdMapper = new FDMapperGridCuration(fdMapperOptions)
         grid.section = fdMapper.map()
      return grid

    Uses a Matrix solver ??? to put components as sections on
    a grid. Like a real designer.

    And the Matrix solver (path solver)  itself uses data comming from 
    harmonies composer.
    - OK, and what HarmoniesComposer does?
    ??? black box for now
    - OK, and what MatrixComposer.solve does?
    ??? uses a path solver to find what sections/components to
    use based on restrictions on number of items for a section
    and other constraints

    Need to understand better how it does that...
    It seems lots of complexity goes here, one of the main
    parts of the-composer!
    - OK, there's also lots of FDMapper for grid and item, what they do?
    FDMapperItemsCuration adds uiComponent, the component chosen
    by renderverse for this section; and itemsToRender,
    the items that the component will need to render for the
    section

    FDMapperGridCuration does the same??? But for grid???

 - Run the-stylist on siteData, grid, mix and options and return imgfloUrls
    Groups lots of subparts...
       the-beautician
       the-colorist
       the-lensman
       the-style-solver
       the-typographer
    Defines styling of each section in the layout (previously
    solved grid).
    How ???

 - Run the-plumber on siteData, grid, mix and options and return html
     Generally depends on ds-*, but commonly gets the grid
     and siteData, and ImgfloUrls and renders React components
     into GOM elements which will dump HTML (finally!)
 - Return html and imgfloUrls to written to file (the html)
     Write the dumped HTML into a file

# Todo

- Understand the-curator better (matrix path solver, harmonies
solver)
- Understand each part of the-stylist better
- Understand how ds-nj's the-plumber runs
- How to plug classifiers to items / sites? the-tagger

# Glossary

- Harmonies
- Harmonic Matrixes
- Vertical x Horizontal constraints
- Inlets
- Branches
- MultiverseJSON
- Markov Chain
- Probability Vector
- FD Solver
- Constraints
- Constraints Solver
- The Mixer. Does the first high level choices based on formality levels
  and spectrums
- The Composer. Calls all other "agents" or parts of DS, one
  after another, in a flow of data until HTML is generated
- The Curator. One of the most complex parts of The Composer.
  Uses some FD solvers to choose which ui components to use,
  depending on how much items it needs to be rendered and so on,
  mapping these ui components to sections on a grid
- The Stylist
- The Plumber

# Ideas

- Keep updating harmonies (specially probability vectors of Markov chains) with
  new ones coming from (1) user redesigns and (2) global vectors for a same ds
  on all The Grid
  Or from some user preferences for content units (and, by consequence, its
  harmonies) while selecting them on a feedback loop with some ML model (neural
  network)

# Questions

Is branchPrefix (on Multiverse) used to choose between what
should be collapsed/solved on this level and what should not?
Like "all $Y_ branches should be solved now, and Y_ can be
solved later"?
Yes, exactly.

