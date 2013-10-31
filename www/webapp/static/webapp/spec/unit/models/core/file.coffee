store = null

describe 'Vosae.File', ->
  hashFile =
    name: null
    size: null
    sha1_checksum: null
    download_link: null
    stream_link: null
    ttl: null

  beforeEach ->
    comp = getAdapterForTest(Vosae.File)
    ajaxUrl = comp[0]
    ajaxType = comp[1]
    ajaxHash = comp[2]
    store = comp[3]

  afterEach ->
    comp = undefined
    ajaxUrl = undefined
    ajaxType = undefined
    ajaxHash = undefined
    store.destroy()

  it 'finding all file makes a GET to /file/', ->
    # Setup
    files = store.find Vosae.File

    # Test
    enabledFlags files, ['isLoaded', 'isValid'], recordArrayFlags
    expectAjaxURL "/file/"
    expectAjaxType "GET"

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [$.extend({}, hashFile, {id: 1, name: "myFile.txt"})]
    )
    file = files.objectAt(0)

    # Test
    statesEqual files, 'loaded.saved'
    stateEquals file, 'loaded.saved'
    enabledFlagsForArray files, ['isLoaded', 'isValid']
    enabledFlags file, ['isLoaded', 'isValid']
    expect(file).toEqual store.find(Vosae.File, 1)

  it 'finding a file by ID makes a GET to /file/:id/', ->
    # Setup
    file = store.find Vosae.File, 1

    # Test
    stateEquals file, 'loading'
    enabledFlags file, ['isLoading', 'isValid']
    expectAjaxType "GET"
    expectAjaxURL "/file/1/"

    # Setup
    ajaxHash.success($.extend {}, hashFile,
      id: 1
      name: "myFile.txt"
      resource_uri: "/api/v1/file/1/"
    )

    # Test
    stateEquals file, 'loaded.saved'
    enabledFlags file, ['isLoaded', 'isValid']
    expect(file).toEqual store.find(Vosae.File, 1)

  it 'finding files by query makes a GET to /file/:query/', ->
    # Setup
    files = store.find Vosae.File, {page: 1}

    # Test
    expect(files.get('length')).toEqual 0
    enabledFlags files, ['isLoading'], recordArrayFlags
    expectAjaxURL "/file/"
    expectAjaxType "GET"
    expectAjaxData({page: 1 })

    # Setup
    ajaxHash.success(
      meta: {}
      objects: [
        $.extend({}, hashFile, {id: 1, name: "myFile1.txt"})
        $.extend({}, hashFile, {id: 2, name: "myFile2.txt"})
      ]
    )
    file1 = files.objectAt 0
    file2 = files.objectAt 1

    # Test
    statesEqual [file1, file2], 'loaded.saved'
    enabledFlags files, ['isLoaded'], recordArrayFlags
    enabledFlagsForArray [file1, file2], ['isLoaded'], recordArrayFlags
    expect(files.get('length')).toEqual 2
    expect(file1.get('name')).toEqual "myFile1.txt"
    expect(file2.get('name')).toEqual "myFile2.txt"
    expect(file1.get('id')).toEqual "1"
    expect(file2.get('id')).toEqual "2"

  it 'creating a file makes a POST to /file/', ->
    # Setup
    file = store.createRecord Vosae.File, {name: "myFile.txt"}

    # Test
    stateEquals file, 'loaded.created.uncommitted'
    enabledFlags file, ['isLoaded', 'isDirty', 'isNew', 'isValid']

    # Setup
    file.get('transaction').commit()

    # Test
    stateEquals file, 'loaded.created.inFlight'
    enabledFlags file, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']
    expectAjaxURL "/file/"
    expectAjaxType "POST"
    expectAjaxData($.extend {}, hashFile, {name: "myFile.txt"})

    # Setup
    ajaxHash.success($.extend {}, hashFile,
      id: 1
      name: "myFile.txt"
      resource_uri: "/api/v1/file/1/"
    )

    # Test
    stateEquals file, 'loaded.saved'
    enabledFlags file, ['isLoaded', 'isValid']
    expect(file).toEqual store.find(Vosae.File, 1)

  it 'updating a file makes a PUT to /file/:id/', ->
    # Setup
    # store.load Vosae.Group, {id: 1, name: "Administrators"}
    store.adapterForType(Vosae.File).load store, Vosae.File, {id: 1, name: "myFile.txt"}
    file = store.find Vosae.File, 1

    # Test
    stateEquals file, 'loaded.saved' 
    enabledFlags file, ['isLoaded', 'isValid']

    # Setup
    file.setProperties {name: "export.txt"}

    # Test
    stateEquals file, 'loaded.updated.uncommitted'
    enabledFlags file, ['isLoaded', 'isDirty', 'isValid']

    # Setup
    file.get('transaction').commit()

    # Test
    stateEquals file, 'loaded.updated.inFlight'
    enabledFlags file, ['isLoaded', 'isDirty', 'isSaving', 'isValid']
    expectAjaxURL "/file/1/"
    expectAjaxType "PUT"
    expectAjaxData($.extend {}, hashFile,
      name: "export.txt"
    )

    # Setup
    ajaxHash.success($.extend {}, hashFile,
      id: 1
      name: "export.txt"
    )

    # Test
    stateEquals file, 'loaded.saved'
    enabledFlags file, ['isLoaded', 'isValid']
    expect(file).toEqual store.find(Vosae.File, 1)
    expect(file.get('name')).toEqual 'export.txt'

  it 'deleting a file makes a DELETE to /file/:id/', ->
    # Setup
    store.adapterForType(Vosae.File).load store, Vosae.File, {id: 1, name: "myFile.txt"}
    file = store.find Vosae.File, 1

    # Test
    stateEquals file, 'loaded.saved' 
    enabledFlags file, ['isLoaded', 'isValid']

    # Setup
    file.deleteRecord()

    # Test
    stateEquals file, 'deleted.uncommitted'
    enabledFlags file, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']

    # Setup
    file.get('transaction').commit()

    # Test
    stateEquals file, 'deleted.inFlight'
    enabledFlags file, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']
    expectAjaxURL "/file/1/"
    expectAjaxType "DELETE"

    # Setup
    ajaxHash.success()

    # Test
    stateEquals file, 'deleted.saved'
    enabledFlags file, ['isLoaded', 'isDeleted', 'isValid']

  it 'issuer belongsTo relationship', ->
    # Setup
    store.adapterForType(Vosae.User).load store, Vosae.User, {id: 1}
    user = store.find Vosae.User, 1
    store.adapterForType(Vosae.File).load store, Vosae.File, {id: 1, issuer: "/api/v1/user/1/"}
    file = store.find Vosae.File, 1

    # Test
    expect(file.get('issuer')).toEqual user
