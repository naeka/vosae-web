Vosae.emailTypeChoice = [
  Ember.Object.create
    name: gettext "Work"
    value: "WORK"
  Ember.Object.create
    name: gettext "Home"
    value: "HOME"
]

Vosae.phoneCombinedTypes = [
  Ember.Object.create
    name: gettext "Work"
    value: "WORK"
    type: "WORK"
    subtype: null
  Ember.Object.create
    name: gettext "Home"
    value: "HOME"
    type: "HOME"
    subtype: null
  Ember.Object.create
    name: gettext "Work cell"
    value: "WORK-CELL"
    type: "WORK"
    subtype: "CELL"
  Ember.Object.create
    name: gettext "Home cell"
    value: "HOME-CELL"
    type: "HOME"
    subtype: "CELL"
  Ember.Object.create
    name: gettext "Work fax"
    value: "WORK-FAX"
    type: "WORK"
    subtype: "FAX"
  Ember.Object.create
    name: gettext "Home fax"
    value: "HOME-FAX"
    type: "HOME"
    subtype: "FAX"
]

Vosae.addressTypeChoice = [
  Ember.Object.create
    name: gettext "Work"
    value: "WORK"
  Ember.Object.create
    name: gettext "Home"
    value: "HOME"
  Ember.Object.create
    name: gettext "Delivery"
    value: "DELIVERY"
  Ember.Object.create
    name: gettext "Billing"
    value: "BILLING"
  Ember.Object.create
    name: gettext "Other"
    value: "OTHER"
]

Vosae.contactCivilityChoice = [
  Ember.Object.create
    name: gettext "Mr"
    value: "Mr."
  Ember.Object.create
    name: gettext "Mrs"
    value: "Mrs."
  Ember.Object.create
    name: gettext "Miss"
    value: "Miss"
]