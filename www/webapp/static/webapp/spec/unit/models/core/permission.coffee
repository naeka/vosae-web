store = null

describe 'Vosae.Permission', ->
  beforeEach ->
    store = Vosae.Store.create()

  afterEach ->
    store.destroy()