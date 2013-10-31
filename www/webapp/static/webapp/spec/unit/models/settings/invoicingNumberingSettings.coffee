store = null

describe 'Vosae.InvoicingNumberingSettings', ->
  beforeEach ->
    comp = getAdapterForTest(Vosae.InvoicingNumberingSettings)
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

  it 'preview computed property should return a preview for invoicing numbering', ->
    # Setup
    store.adapterForType(Vosae.InvoicingNumberingSettings).load store, Vosae.InvoicingNumberingSettings,
      id: 1
      date_format: "Ym"
      scheme: "DN"
      separator: "-"
    invoicingNumberingSettings = store.find Vosae.InvoicingNumberingSettings, 1

    # Test
    expect(invoicingNumberingSettings.get('preview')).toEqual(moment().format("YYYYMM") + "-" + "00000")

    # Setup
    invoicingNumberingSettings.set 'separator', ';'

    # Test
    expect(invoicingNumberingSettings.get('preview')).toEqual(moment().format("YYYYMM") + ";" + "00000")

    # Setup
    invoicingNumberingSettings.set 'dateFormat', 'Ymd'

    # Test
    expect(invoicingNumberingSettings.get('preview')).toEqual(moment().format("YYYYMMDD") + ";" + "00000")

    # Setup
    invoicingNumberingSettings.set 'scheme', 'N'

    # Test
    expect(invoicingNumberingSettings.get('preview')).toEqual "00000"

  it 'schemeIsNumber computed property should return true if scheme is number', ->
    # Setup
    store.adapterForType(Vosae.InvoicingNumberingSettings).load store, Vosae.InvoicingNumberingSettings,
      id: 1
      scheme: "DN"
    invoicingNumberingSettings = store.find Vosae.InvoicingNumberingSettings, 1

    # Test
    expect(invoicingNumberingSettings.get('schemeIsNumber')).toBeFalsy()

    # Setup
    invoicingNumberingSettings.set 'scheme', 'N'

    # Test
    expect(invoicingNumberingSettings.get('schemeIsNumber')).toBeTruthy()