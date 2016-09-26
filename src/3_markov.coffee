Multiverse = require '@the-grid/multiversejson'
{PathSolver} = Multiverse.Harmonics

masterverse =
  Y_width:
    cols1:
      $class:['cols1']
      $cols: 1
    cols2:
      $class:['cols2']
      $cols: 2
    cols3:
      $class:['cols3']
      $cols: 3
    cols4:
      $class:['cols4']
      $cols: 4
    cols5:
      $class:['cols5']
      $cols: 5
    cols6:
      $class:['cols6']
      $cols: 6
    full:
      $class:['full']
      $cols: 12
  Y_color: [
    dark:
      $class:['dark']
    light:
      $class:['light']
  ]
  Y_post_type: [
    {$class:['post']}
    {$class:['repost']}
  ]
  Y_state: [
    {$class:['not-featured']}
    {$class:['featured']}
  ]

length = 10
offorderness = 4

pathAccumulationKeys = [ '$class' ]

harmonies = ($) ->
  $ 'markov',
    branchName: 'width'
    legend: ['cols1', 'cols2', 'cols3']
    transitions: [
      vector: [ 100, 100, 3]
    ]

#harmonies = ($) ->
#  $ 'or', ['cols1', 'cols2', 'dark']

composer = new Multiverse.Composer
  masterverse: masterverse
  length: length
  offorderness: offorderness
  harmonies: harmonies
  multiverseOptions: {pathAccumulationKeys}

solutions = composer.solve({max:1,log:1})
console.log 'Solutions', solutions

console.log 'Beat Matrix'
for solution in solutions
  actualMatrix = composer.matrix.ofSolution(solution,false)
  console.log composer.matrix.ofSolution(solution,true)

