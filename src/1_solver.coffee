Multiverse = require '@the-grid/multiversejson'
{PathSolver} = Multiverse.Harmonics

# Data model

tree =
  Y_:
    a:
      name: 'first'
      weight: 10
    b:
      name: 'second'
      weight: 5

pathAccumulationKeys = [ 'weight' ]
mv = new Multiverse tree, { pathAccumulationKeys }
console.log mv.count()
console.log mv.get(0)
console.log mv.getAll()

# Solver

solver = new PathSolver mv

solutions = solver.solve {log: 1, max: 99999}
console.log solutions


