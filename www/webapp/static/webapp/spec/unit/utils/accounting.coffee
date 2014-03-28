# describe 'Accounting.js', ->

#   it 'formatNumber()', ->
#     # Test
#     expect(accounting.formatNumber(0)).toEqual "0"
#     expect(accounting.formatNumber(0.222222, precision: 2)).toEqual "0.22"
#     expect(accounting.formatNumber(0.456, precision: 2)).toEqual "0.46"
#     expect(accounting.formatNumber(1, precision: 2)).toEqual "1.00"
#     expect(accounting.formatNumber(10, precision: 2)).toEqual "10.00"
#     expect(accounting.formatNumber(100, precision: 2)).toEqual "100.00"
#     expect(accounting.formatNumber(1000, precision: 2)).toEqual "1,000.00"
#     expect(accounting.formatNumber(10000, precision: 2)).toEqual "10,000.00"
#     expect(accounting.formatNumber(100000, precision: 2)).toEqual "100,000.00"
#     expect(accounting.formatNumber(1000000, precision: 2)).toEqual "1,000,000.00"

#   it 'formatMoney()', ->
#     # Test
#     expect(accounting.formatMoney(0)).toEqual "0.00"
#     expect(accounting.formatMoney(0.222222, symbol: "$")).toEqual "$0.22"
#     expect(accounting.formatMoney(0.456, symbol: "$")).toEqual "$0.46"
#     expect(accounting.formatMoney(1, symbol: "$")).toEqual "$1.00"
#     expect(accounting.formatMoney(10, symbol: "$")).toEqual "$10.00"
#     expect(accounting.formatMoney(100, symbol: "$")).toEqual "$100.00"
#     expect(accounting.formatMoney(1000, symbol: "$")).toEqual "$1,000.00"
#     expect(accounting.formatMoney(10000, symbol: "$")).toEqual "$10,000.00"
#     expect(accounting.formatMoney(100000, symbol: "$")).toEqual "$100,000.00"
#     expect(accounting.formatMoney(1000000, symbol: "$")).toEqual "$1,000,000.00"