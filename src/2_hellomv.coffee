Multiverse = require '@the-grid/multiversejson'

# Multiverse Composer + Markov Constraints

masterverse =
  Y_width:
    rectangle:
      $class: [ 'rectangle' ]
      $size: 100
    circle:
      $class: [ 'circle' ]
      $size: 55
  Y_color:
    red:
      $class: [ 'red' ]
    blue:
      $class: [ 'blue' ]

harmonies = ($) ->
  $ 'markov',
    branchName: 'width'
    legend: [ 'rectangle' ]
    transitions: [
      vector: [ 1 ]
    ]

matrix =
  rectangle: [1, 1]

pathAccumulationKeys = [ '$class' ]

verses = [
  $item_index: 0
  title: "Item 0"
,
  $item_index: 1
  title: "Item 1"
]

composer = new Multiverse.Composer
  verses: verses
  length: 2
  offorderness: 4
  masterverse: masterverse
  harmonies: harmonies
  multiverseOptions: {pathAccumulationKeys}

solutions = composer.solve {max: 1, log: 1}
console.log composer.matrix.ofSolution(solutions, true)
