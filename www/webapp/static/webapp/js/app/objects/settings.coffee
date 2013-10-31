Vosae.invoicingSchemes = [
  Ember.Object.create
    label: gettext("Date, Number")
    value: "DN"
  Ember.Object.create
    label: gettext("Number")
    value: "N"
]

Vosae.invoicingDateFormats = [
  Ember.Object.create
    value: "Ymd"
    label: "YYYYMMDD"
  Ember.Object.create
    value: "dmY"
    label: "DDMMYYYY"
  Ember.Object.create
    value: "ymd"
    label: "YYMMDD"
  Ember.Object.create
    value: "dmy"
    label: "DDMMYY"
  Ember.Object.create
    value: "Ym"
    label: "YYYYMM"
  Ember.Object.create
    value: "mY"
    label: "MMYYYY"
  Ember.Object.create
    value: "ym"
    label: "YYMM"
  Ember.Object.create
    value: "my"
    label: "MMYY"
  Ember.Object.create
    value: "Y"
    label: "YYYY"
  Ember.Object.create
    value: "y"
    label: "YY"
] 

Vosae.invoicingDateStrftimeFormats = [
  Ember.Object.create
    value: "Ymd"
    label: "%Y%m%d"
  Ember.Object.create
    value: "dmY"
    label: "%d%m%Y"
  Ember.Object.create
    value: "ymd"
    label: "%y%m%d"
  Ember.Object.create
    value: "dmy"
    label: "%d%m%y"
  Ember.Object.create
    value: "Ym"
    label: "%Y%m"
  Ember.Object.create
    value: "mY"
    label: "%m%Y"
  Ember.Object.create
    value: "ym"
    label: "%y%m"
  Ember.Object.create
    value: "my"
    label: "%m%y"
  Ember.Object.create
    value: "Y"
    label: "%Y"
  Ember.Object.create
    value: "y"
    label: "%y"
]

Vosae.invoicingSeparators = [
  Ember.Object.create
    value: ""
    label: gettext("No separator")
  Ember.Object.create
    value: "-"
    label: gettext("- (dash)")
  Ember.Object.create
    value: "_"
    label: gettext("_ (underscore)")
  Ember.Object.create
    value: "."
    label: gettext(". (dot)")
  Ember.Object.create
    value: ":"
    label: gettext(": (colon)")
  Ember.Object.create
    value: "::"
    label: gettext(":: (bi-colon)")
  Ember.Object.create
    value: "/"
    label: gettext("/ (slash)")
  Ember.Object.create
    value: "#"
    label: gettext("# (sharp)")
]