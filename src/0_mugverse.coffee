Multiverse = require '@the-grid/multiversejson'

mugs =
  xmas:
    color:
      Y_:
        1:
          red:
            name: 'red'
            formality: 1000
        2:
          gold:
            name: 'gold'
            formality: 10
        3:
          silver:
            name: 'silver'
            formality: 2
  easter:
    color:
      Y_:
        1:
          white:
            name: 'white'
            formality: 200
        2:
          blue:
            name: 'blue'
            formality: 3
  american:
    color:
      Y_:
        1:
          blue:
            name: 'blue'
            formality: 50
        2:
          red:
            name: 'red'
            formality: 50

pathAccumulationKeys = [ 'formality' ]
sort = (a, b) ->
  return a._data.formality - b._data.formality

mugverse = new Multiverse mugs, { pathAccumulationKeys, sort }

console.log JSON.stringify(mugverse.collapse(0), null, 2)

console.log mugverse.getAllPaths()
