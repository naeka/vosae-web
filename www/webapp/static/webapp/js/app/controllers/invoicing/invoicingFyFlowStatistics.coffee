Vosae.InvoicingFyFlowStatisticsController = Em.ObjectController.extend Vosae.StatisticsMixin,
  pipeline: ->
    [
      "$match":
        "date":
          "$gte": @get('session.tenantSettings.invoicing.currentFyStartAt').format()
          "$lt": @get('session.tenantSettings.invoicing.currentFyStartAt').clone().add('years', 1).format()
    ,
      "$project":
        "amount": 1
        "account_type": 1
        "month_number":
          "$month": "$date"
    ,
      "$group":
        "_id":
          "month_number": "$month_number"
          "account_type": "$account_type"

        "amount":
          "$sum": "$amount"

        "count":
          "$sum": 1
    ]

  _object: Em.Object.extend
    content: []
    currentMonth: (new Date()).getMonth()

    fyInvoiced: (->
      ret =
        amount: 0
        count: 0
      for month in @get('content').filterProperty('_id.account_type', 'RECEIVABLE')
        ret.amount += month.amount
        ret.count += month.count
      ret
    ).property('content')

    currentMonthInvoiced: (->
      month = @get('content').filterProperty('_id.account_type', 'RECEIVABLE').findProperty('_id.month_number', @currentMonth + 1)
      amount: (if month then month.amount else 0)
      count: (if month then month.count else 0)
    ).property('content')

    fyPurchased: (->
      ret =
        amount: 0
        count: 0
      for month in @get('content').filterProperty('_id.account_type', 'PAYABLE')
        ret.amount += month.amount
        ret.count += month.count
      ret
    ).property('content')

    currentMonthPurchased: (->
      month = @get('content').filterProperty('_id.account_type', 'PAYABLE').findProperty('_id.month_number', @currentMonth + 1)
      amount: (if month then month.amount else 0)
      count: (if month then month.count else 0)
    ).property('content')

    currentMonthProfits: (->
      @get('currentMonthInvoiced.amount') - @get('currentMonthPurchased.amount')
    ).property('currentMonthInvoiced', 'currentMonthPurchased')
