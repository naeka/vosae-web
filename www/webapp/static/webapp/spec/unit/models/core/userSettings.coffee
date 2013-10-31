store = null

describe 'Vosae.UserSettings', ->
  beforeEach ->
    store = Vosae.Store.create()

  afterEach ->
    store.destroy()