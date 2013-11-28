this.notEmpty = function(selector) {
  return function() {
    return $(selector).text().trim() !== '';
  };
};

this.hasText = function(selector, text) {
  return function() {
    return $(selector).text().trim() === text;
  };
};

this.appRendered = function() {
  return $('.ember-application').length;
};

var forEach, get, indexOf, manyArrayFlags, recordArrayFlags, set;

get = Ember.get;

set = Ember.set;

indexOf = Ember.EnumerableUtils.indexOf;

forEach = Ember.EnumerableUtils.forEach;

recordArrayFlags = ['isLoaded'];

manyArrayFlags = ['isLoaded'];

this.expectAjaxType = function(type) {
  return expect(ajaxType).toEqual(type);
};

this.expectAjaxURL = function(url) {
  var a;
  a = document.createElement('a');
  a.href = ajaxUrl;
  return expect(a.pathname).toEqual("/api/v1" + url);
};

this.expectAjaxData = function(hash) {
  return expect(JSON.parse(JSON.stringify(ajaxHash.data))).toEqual(JSON.parse(JSON.stringify(hash)));
};

this.stateEquals = function(entity, expectedState) {
  var actualState;
  actualState = Ember.get(entity, "currentState.stateName");
  actualState = actualState && actualState.replace(/^root\./, "");
  return expect(actualState).toEqual(expectedState);
};

this.statesEqual = function(entities, expectedState) {
  return forEach(entities, function(entity) {
    return stateEquals(entity, expectedState);
  });
};

this.enabledFlags = function(entity, expectedFlagArr, onlyCheckFlagArr) {
  var possibleFlags;
  possibleFlags = void 0;
  if (onlyCheckFlagArr) {
    possibleFlags = onlyCheckFlagArr;
  } else {
    possibleFlags = ["isLoading", "isLoaded", "isReloading", "isDirty", "isSaving", "isDeleted", "isError", "isNew", "isValid"];
  }
  return forEach(possibleFlags, function(flag) {
    var actualFlagValue, expectedFlagValue;
    expectedFlagValue = void 0;
    actualFlagValue = void 0;
    expectedFlagValue = indexOf(expectedFlagArr, flag) !== -1;
    actualFlagValue = entity.get(flag);
    return expect(actualFlagValue).toEqual(expectedFlagValue);
  });
};

this.enabledFlagsForArray = function(entities, expectedFlagArr, onlyCheckFlagArr) {
  return forEach(entities, function(entity) {
    return enabledFlags(entity, expectedFlagArr, onlyCheckFlagArr);
  });
};

this.after = function(time, func) {
  waits(time);
  return jasmine.getEnv().currentSpec.runs(func);
};

this.once = function(condition, func) {
  waitsFor(condition);
  return jasmine.getEnv().currentSpec.runs(func);
};

this.waitFor = waitsFor;

var store;

store = null;

describe('Vosae.Address', function() {
  beforeEach(function() {
    return store = Vosae.Store.create();
  });
  afterEach(function() {
    return store.destroy();
  });
  it('type property should be WORK when creating address', function() {
    var address;
    address = store.createRecord(Vosae.Address);
    return expect(address.get('type')).toEqual("WORK");
  });
  it('isEmpty computed property', function() {
    var address;
    address = store.createRecord(Vosae.Address);
    expect(address.isEmpty()).toEqual(true);
    address.set('streetAddress', 'SomeContent');
    return expect(address.isEmpty()).toEqual(false);
  });
  return it('dumpDatafrom method', function() {
    var address, newAddress;
    address = store.createRecord(Vosae.Address);
    address.setProperties({
      type: 'HOME',
      postofficeBox: 'postofficeBox',
      streetAddress: 'streetAddress',
      extendedAddress: 'extendedAddress',
      postalCode: 'postalCode',
      city: 'city',
      state: 'state',
      country: 'country'
    });
    newAddress = store.createRecord(Vosae.Address);
    newAddress.dumpDataFrom(address);
    expect(newAddress.get('type')).toEqual('HOME');
    expect(newAddress.get('postofficeBox')).toEqual('postofficeBox');
    expect(newAddress.get('streetAddress')).toEqual('streetAddress');
    expect(newAddress.get('extendedAddress')).toEqual('extendedAddress');
    expect(newAddress.get('postalCode')).toEqual('postalCode');
    expect(newAddress.get('city')).toEqual('city');
    expect(newAddress.get('state')).toEqual('state');
    return expect(newAddress.get('country')).toEqual('country');
  });
});

var store;

store = null;

describe('Vosae.Contact', function() {
  var hashContact;
  hashContact = {
    additional_names: null,
    addresses: [],
    birthday: void 0,
    civility: null,
    emails: [],
    firstname: null,
    gravatar_mail: null,
    name: null,
    note: null,
    phones: [],
    photo_source: null,
    photo_uri: null,
    "private": false,
    role: null,
    status: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Contact);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all contact makes a GET to /contact/', function() {
    var contact, contacts;
    contacts = store.find(Vosae.Contact);
    enabledFlags(contacts, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/contact/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashContact, {
          id: 1,
          firstname: "Tom",
          name: "Dale"
        })
      ]
    });
    contact = contacts.objectAt(0);
    statesEqual(contacts, 'loaded.saved');
    stateEquals(contact, 'loaded.saved');
    enabledFlagsForArray(contacts, ['isLoaded', 'isValid']);
    enabledFlags(contact, ['isLoaded', 'isValid']);
    return expect(contact).toEqual(store.find(Vosae.Contact, 1));
  });
  it('finding a contact by ID makes a GET to /contact/:id/', function() {
    var contact;
    contact = store.find(Vosae.Contact, 1);
    stateEquals(contact, 'loading');
    enabledFlags(contact, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/contact/1/");
    ajaxHash.success($.extend({}, hashContact, {
      id: 1,
      firstname: "Tom",
      name: "Dale",
      resource_uri: "/api/v1/contact/1/"
    }));
    stateEquals(contact, 'loaded.saved');
    enabledFlags(contact, ['isLoaded', 'isValid']);
    return expect(contact).toEqual(store.find(Vosae.Contact, 1));
  });
  it('finding contacts by query makes a GET to /contact/:query/', function() {
    var contacts, marion, tom;
    contacts = store.find(Vosae.Contact, {
      name: "Dale",
      page: 1
    });
    expect(contacts.get('length')).toEqual(0);
    enabledFlags(contacts, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/contact/");
    expectAjaxType("GET");
    expectAjaxData({
      name: "Dale",
      page: 1
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashContact, {
          id: 1,
          firstname: "Tom",
          name: "Dale"
        }), $.extend({}, hashContact, {
          id: 2,
          firstname: "Marion",
          name: "Dale"
        })
      ]
    });
    tom = contacts.objectAt(0);
    marion = contacts.objectAt(1);
    statesEqual([tom, marion], 'loaded.saved');
    enabledFlags(contacts, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([tom, marion], ['isLoaded'], recordArrayFlags);
    expect(contacts.get('length')).toEqual(2);
    expect(tom.get('firstname')).toEqual("Tom");
    expect(marion.get('firstname')).toEqual("Marion");
    expect(tom.get('id')).toEqual("1");
    return expect(marion.get('id')).toEqual("2");
  });
  it('creating a contact makes a POST to /contact/', function() {
    var contact;
    contact = store.createRecord(Vosae.Contact, {
      firstname: "Tom",
      name: "Dale"
    });
    stateEquals(contact, 'loaded.created.uncommitted');
    enabledFlags(contact, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    contact.get('transaction').commit();
    stateEquals(contact, 'loaded.created.inFlight');
    enabledFlags(contact, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/contact/");
    expectAjaxType("POST");
    expectAjaxData($.extend({}, hashContact, {
      firstname: "Tom",
      name: "Dale"
    }));
    ajaxHash.success($.extend({}, hashContact, {
      id: 1,
      firstname: "Tom",
      name: "Dale",
      resource_uri: "/api/v1/contact/1/"
    }));
    stateEquals(contact, 'loaded.saved');
    enabledFlags(contact, ['isLoaded', 'isValid']);
    return expect(contact).toEqual(store.find(Vosae.Contact, 1));
  });
  it('updating a contact makes a PUT to /contact/:id/', function() {
    var contact;
    store.load(Vosae.User, {
      id: 1
    });
    store.load(Vosae.Contact, {
      id: 1,
      firstname: "Tom",
      name: "Dale",
      creator: "/api/v1/user/1/",
      status: "ACTIVE",
      "private": false
    });
    contact = store.find(Vosae.Contact, 1);
    stateEquals(contact, 'loaded.saved');
    enabledFlags(contact, ['isLoaded', 'isValid']);
    contact.setProperties({
      firstname: "Yehuda",
      name: "Katz"
    });
    stateEquals(contact, 'loaded.updated.uncommitted');
    enabledFlags(contact, ['isLoaded', 'isDirty', 'isValid']);
    contact.get('transaction').commit();
    stateEquals(contact, 'loaded.updated.inFlight');
    enabledFlags(contact, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/contact/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, hashContact, {
      firstname: "Yehuda",
      name: "Katz",
      creator: "/api/v1/user/1/",
      status: "ACTIVE"
    }));
    ajaxHash.success($.extend({}, hashContact, {
      id: 1,
      firstname: "Yehuda",
      name: "Katz",
      creator: "/api/v1/user/1",
      status: "ACTIVE",
      "private": false
    }));
    stateEquals(contact, 'loaded.saved');
    enabledFlags(contact, ['isLoaded', 'isValid']);
    expect(contact).toEqual(store.find(Vosae.Contact, 1));
    return expect(contact.get('firstname')).toEqual('Yehuda');
  });
  it('deleting a contact makes a DELETE to /contact/:id/', function() {
    var contact;
    store.load(Vosae.Contact, {
      id: 1,
      firstname: "Tom",
      name: "Dale"
    });
    contact = store.find(Vosae.Contact, 1);
    stateEquals(contact, 'loaded.saved');
    enabledFlags(contact, ['isLoaded', 'isValid']);
    contact.deleteRecord();
    stateEquals(contact, 'deleted.uncommitted');
    enabledFlags(contact, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']);
    contact.get('transaction').commit();
    stateEquals(contact, 'deleted.inFlight');
    enabledFlags(contact, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']);
    expectAjaxURL("/contact/1/");
    expectAjaxType("DELETE");
    ajaxHash.success();
    stateEquals(contact, 'deleted.saved');
    return enabledFlags(contact, ['isLoaded', 'isDeleted', 'isValid']);
  });
  it('civility property should be null when creating contact', function() {
    var contact;
    contact = store.createRecord(Vosae.Contact);
    return expect(contact.get('civility')).toEqual(null);
  });
  it('fullName property should concat firstname and name', function() {
    var contact;
    store.load(Vosae.Contact, {
      id: 1
    });
    contact = store.find(Vosae.Contact, 1);
    expect(contact.get('fullName')).toEqual('');
    contact.set('firstname', 'Tom');
    expect(contact.get('fullName')).toEqual('Tom');
    contact.set('name', 'Dale');
    return expect(contact.get('fullName')).toEqual('Tom Dale');
  });
  return it('organization belongsTo relationship', function() {
    var contact;
    store.load(Vosae.Organization, {
      id: 1,
      corporate_name: "Emberjs"
    });
    store.load(Vosae.Contact, {
      id: 1,
      organization: "/api/v1/organization/1/"
    });
    contact = store.find(Vosae.Contact, 1);
    return expect(contact.get('organization.corporateName')).toEqual("Emberjs");
  });
});

var store;

store = null;

describe('Vosae.Email', function() {
  beforeEach(function() {
    return store = Vosae.Store.create();
  });
  afterEach(function() {
    return store.destroy();
  });
  it('type property should be WORK when creating email', function() {
    var email;
    email = store.createRecord(Vosae.Email);
    return expect(email.get('type')).toEqual('WORK');
  });
  return it('displayType computed property', function() {
    var email;
    email = store.createRecord(Vosae.Email);
    return expect(email.get('displayType')).toEqual('Work');
  });
});

var store;

store = null;

describe('Vosae.Entity', function() {
  beforeEach(function() {
    return store = Vosae.Store.create();
  });
  afterEach(function() {
    return store.destroy();
  });
  it('can add emails', function() {
    var email, email2, entity;
    store.load(Vosae.Entity, {
      id: 1
    });
    entity = store.find(Vosae.Entity, 1);
    email = entity.get('emails').createRecord(Vosae.Email);
    email2 = entity.get('emails').createRecord(Vosae.Email);
    expect(entity.get('emails.length')).toEqual(2);
    expect(entity.get('emails').objectAt(0)).toEqual(email);
    return expect(entity.get('emails').objectAt(1)).toEqual(email2);
  });
  it('can add phones', function() {
    var entity, phone, phone2;
    store.load(Vosae.Entity, {
      id: 1
    });
    entity = store.find(Vosae.Entity, 1);
    phone = entity.get('phones').createRecord(Vosae.Phone);
    phone2 = entity.get('phones').createRecord(Vosae.Phone);
    expect(entity.get('phones.length')).toEqual(2);
    expect(entity.get('phones').objectAt(0)).toEqual(phone);
    return expect(entity.get('phones').objectAt(1)).toEqual(phone2);
  });
  it('can add addresses', function() {
    var address, address2, entity;
    store.load(Vosae.Entity, {
      id: 1
    });
    entity = store.find(Vosae.Entity, 1);
    address = entity.get('addresses').createRecord(Vosae.Address);
    address2 = entity.get('addresses').createRecord(Vosae.Address);
    expect(entity.get('addresses.length')).toEqual(2);
    expect(entity.get('addresses').objectAt(0)).toEqual(address);
    return expect(entity.get('addresses').objectAt(1)).toEqual(address2);
  });
  it('can delete emails', function() {
    var email, email2, entity;
    store.load(Vosae.Entity, {
      id: 1
    });
    entity = store.find(Vosae.Entity, 1);
    email = entity.get('emails').createRecord(Vosae.Email);
    email2 = entity.get('emails').createRecord(Vosae.Email);
    expect(entity.get('emails.length')).toEqual(2);
    entity.get('emails').removeObject(email);
    entity.get('emails').removeObject(email2);
    return expect(entity.get('emails.length')).toEqual(0);
  });
  it('can delete phones', function() {
    var entity, phone, phone2;
    store.load(Vosae.Entity, {
      id: 1
    });
    entity = store.find(Vosae.Entity, 1);
    phone = entity.get('phones').createRecord(Vosae.Phone);
    phone2 = entity.get('phones').createRecord(Vosae.Phone);
    expect(entity.get('phones.length')).toEqual(2);
    entity.get('phones').removeObject(phone);
    entity.get('phones').removeObject(phone2);
    return expect(entity.get('phones.length')).toEqual(0);
  });
  it('can delete addresses', function() {
    var address, address2, entity;
    store.load(Vosae.Entity, {
      id: 1
    });
    entity = store.find(Vosae.Entity, 1);
    address = entity.get('addresses').createRecord(Vosae.Address);
    address2 = entity.get('addresses').createRecord(Vosae.Address);
    expect(entity.get('addresses.length')).toEqual(2);
    entity.get('addresses').removeObject(address);
    entity.get('addresses').removeObject(address2);
    return expect(entity.get('addresses.length')).toEqual(0);
  });
  return it('private property should be true when creating entity', function() {
    var entity;
    entity = store.createRecord(Vosae.Entity);
    return expect(entity.get('private')).toEqual(false);
  });
});

var store;

store = null;

describe('Vosae.Organization', function() {
  var hashOrganization;
  hashOrganization = {
    addresses: [],
    contacts: [],
    corporate_name: null,
    emails: [],
    gravatar_mail: null,
    note: null,
    phones: [],
    photo_source: null,
    photo_uri: null,
    "private": false,
    status: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Organization);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all organization makes a GET to /organization/', function() {
    var organization, organizations;
    organizations = store.find(Vosae.Organization);
    enabledFlags(organizations, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/organization/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashOrganization, {
          id: 1,
          corporateName: "Naeka"
        })
      ]
    });
    organization = organizations.objectAt(0);
    statesEqual(organizations, 'loaded.saved');
    stateEquals(organization, 'loaded.saved');
    enabledFlagsForArray(organizations, ['isLoaded', 'isValid']);
    enabledFlags(organization, ['isLoaded', 'isValid']);
    return expect(organization).toEqual(store.find(Vosae.Organization, 1));
  });
  it('finding a organization by ID makes a GET to /organization/:id/', function() {
    var organization;
    organization = store.find(Vosae.Organization, 1);
    stateEquals(organization, 'loading');
    enabledFlags(organization, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/organization/1/");
    ajaxHash.success($.extend({}, hashOrganization, {
      id: 1,
      corporateName: "Naeka",
      resource_uri: "/api/v1/organization/1/"
    }));
    stateEquals(organization, 'loaded.saved');
    enabledFlags(organization, ['isLoaded', 'isValid']);
    return expect(organization).toEqual(store.find(Vosae.Organization, 1));
  });
  it('finding organizations by query makes a GET to /organization/:query/', function() {
    var naeka, organizations;
    organizations = store.find(Vosae.Organization, {
      corporateName: "Naeka",
      page: 1
    });
    expect(organizations.get('length')).toEqual(0);
    enabledFlags(organizations, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/organization/");
    expectAjaxType("GET");
    expectAjaxData({
      corporateName: "Naeka",
      page: 1
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashOrganization, {
          id: 1,
          corporate_name: "Naeka"
        })
      ]
    });
    naeka = organizations.objectAt(0);
    statesEqual([naeka], 'loaded.saved');
    enabledFlags(organizations, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([naeka], ['isLoaded'], recordArrayFlags);
    expect(organizations.get('length')).toEqual(1);
    expect(naeka.get('corporateName')).toEqual("Naeka");
    return expect(naeka.get('id')).toEqual("1");
  });
  it('creating a organization makes a POST to /organization/', function() {
    var organization;
    organization = store.createRecord(Vosae.Organization, {
      corporateName: "Naeka"
    });
    stateEquals(organization, 'loaded.created.uncommitted');
    enabledFlags(organization, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    organization.get('transaction').commit();
    stateEquals(organization, 'loaded.created.inFlight');
    enabledFlags(organization, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/organization/");
    expectAjaxType("POST");
    expectAjaxData($.extend({}, hashOrganization, {
      corporate_name: "Naeka"
    }));
    ajaxHash.success($.extend({}, hashOrganization, {
      id: 1,
      corporateName: "Naeka",
      resource_uri: "/api/v1/organization/1/"
    }));
    stateEquals(organization, 'loaded.saved');
    enabledFlags(organization, ['isLoaded', 'isValid']);
    return expect(organization).toEqual(store.find(Vosae.Organization, 1));
  });
  it('updating a organization makes a PUT to /organization/:id/', function() {
    var organization;
    store.load(Vosae.User, {
      id: 1
    });
    store.load(Vosae.Organization, {
      id: 1,
      corporateName: "Naeka",
      creator: "/api/v1/user/1/",
      status: "ACTIVE",
      "private": false
    });
    organization = store.find(Vosae.Organization, 1);
    stateEquals(organization, 'loaded.saved');
    enabledFlags(organization, ['isLoaded', 'isValid']);
    organization.setProperties({
      corporateName: "NaekaCorp"
    });
    stateEquals(organization, 'loaded.updated.uncommitted');
    enabledFlags(organization, ['isLoaded', 'isDirty', 'isValid']);
    organization.get('transaction').commit();
    stateEquals(organization, 'loaded.updated.inFlight');
    enabledFlags(organization, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/organization/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, hashOrganization, {
      corporate_name: "NaekaCorp",
      creator: "/api/v1/user/1/",
      status: "ACTIVE"
    }));
    ajaxHash.success($.extend({}, hashOrganization, {
      id: 1,
      corporate_name: "NaekaCorp",
      creator: "/api/v1/user/1",
      status: "ACTIVE",
      "private": false
    }));
    stateEquals(organization, 'loaded.saved');
    enabledFlags(organization, ['isLoaded', 'isValid']);
    expect(organization).toEqual(store.find(Vosae.Organization, 1));
    return expect(organization.get('corporateName')).toEqual('NaekaCorp');
  });
  it('deleting a organization makes a DELETE to /organization/:id/', function() {
    var organization;
    store.load(Vosae.Organization, {
      id: 1,
      corporateName: "Naeka"
    });
    organization = store.find(Vosae.Organization, 1);
    stateEquals(organization, 'loaded.saved');
    enabledFlags(organization, ['isLoaded', 'isValid']);
    organization.deleteRecord();
    stateEquals(organization, 'deleted.uncommitted');
    enabledFlags(organization, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']);
    organization.get('transaction').commit();
    stateEquals(organization, 'deleted.inFlight');
    enabledFlags(organization, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']);
    expectAjaxURL("/organization/1/");
    expectAjaxType("DELETE");
    ajaxHash.success();
    stateEquals(organization, 'deleted.saved');
    return enabledFlags(organization, ['isLoaded', 'isDeleted', 'isValid']);
  });
  it('can add contacts', function() {
    var contact, contact2, organization;
    store.load(Vosae.Organization, {
      id: 1
    });
    organization = store.find(Vosae.Organization, 1);
    contact = organization.get('contacts').createRecord(Vosae.Contact);
    contact2 = organization.get('contacts').createRecord(Vosae.Contact);
    expect(organization.get('contacts.length')).toEqual(2);
    expect(organization.get('contacts').objectAt(0)).toEqual(contact);
    return expect(organization.get('contacts').objectAt(1)).toEqual(contact2);
  });
  return it('can delete contacts', function() {
    var contact, contact2, organization;
    store.load(Vosae.Organization, {
      id: 1
    });
    organization = store.find(Vosae.Organization, 1);
    contact = organization.get('contacts').createRecord(Vosae.Contact);
    contact2 = organization.get('contacts').createRecord(Vosae.Contact);
    expect(organization.get('contacts.length')).toEqual(2);
    organization.get('contacts').removeObject(contact);
    organization.get('contacts').removeObject(contact2);
    return expect(organization.get('contacts.length')).toEqual(0);
  });
});

var store;

store = null;

describe('Vosae.Phone', function() {
  beforeEach(function() {
    return store = Vosae.Store.create();
  });
  afterEach(function() {
    return store.destroy();
  });
  it('type property should be WORK when creating phone', function() {
    var phone;
    phone = store.createRecord(Vosae.Phone);
    return expect(phone.get('type')).toEqual("WORK");
  });
  it('typeIsWork computed property', function() {
    var phone;
    phone = store.createRecord(Vosae.Phone);
    expect(phone.get('typeIsWork')).toEqual(true);
    phone.set('type', 'SomethingShity');
    return expect(phone.get('typeIsWork')).toEqual(false);
  });
  it('typeIsHome computed property', function() {
    var phone;
    phone = store.createRecord(Vosae.Phone);
    phone.set('type', 'SomethingShity');
    expect(phone.get('typeIsHome')).toEqual(false);
    phone.set('type', 'HOME');
    return expect(phone.get('typeIsHome')).toEqual(true);
  });
  it('combinedType property', function() {
    var phone;
    phone = store.createRecord(Vosae.Phone);
    phone.set('type', 'WORK');
    expect(phone.get('combinedType')).toEqual('WORK');
    phone.set('subtype', 'CELL');
    return expect(phone.get('combinedType')).toEqual('WORK-CELL');
  });
  it('displayCombinedType', function() {
    var phone;
    phone = store.createRecord(Vosae.Phone);
    phone.set('type', 'WORK');
    expect(phone.get('displayCombinedType')).toEqual('Work');
    phone.set('subtype', 'CELL');
    expect(phone.get('displayCombinedType')).toEqual('Work cell');
    phone.set('type', null);
    expect(phone.get('displayCombinedType')).toEqual('');
    phone.set('subtype', null);
    expect(phone.get('displayCombinedType')).toEqual('');
    phone.set('type', 'SomethingShity');
    return expect(phone.get('displayCombinedType')).toEqual('');
  });
  return it('combined type changed', function() {
    var phone;
    phone = store.createRecord(Vosae.Phone);
    phone.combinedTypeChanged('HOME-FAX');
    expect(phone.get('type')).toEqual('HOME');
    return expect(phone.get('subtype')).toEqual('FAX');
  });
});

var store;

store = null;

describe('Vosae.Tenant', function() {
  var hashTenant;
  hashTenant = {
    billing_address: null,
    email: null,
    fax: null,
    name: null,
    phone: null,
    postal_address: null,
    registration_info: null,
    report_settings: null,
    slug: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Tenant);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all tenants makes a GET to /tenant/', function() {
    var tenant, tenants;
    tenants = store.find(Vosae.Tenant);
    enabledFlags(tenants, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/tenant/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashTenant, {
          id: 1,
          name: "Naeka"
        })
      ]
    });
    tenant = tenants.objectAt(0);
    statesEqual(tenants, 'loaded.saved');
    stateEquals(tenant, 'loaded.saved');
    enabledFlagsForArray(tenants, ['isLoaded', 'isValid']);
    enabledFlags(tenant, ['isLoaded', 'isValid']);
    return expect(tenant).toEqual(store.find(Vosae.Tenant, 1));
  });
  it('finding a tenant by ID makes a GET to /tenant/:id/', function() {
    var tenant;
    tenant = store.find(Vosae.Tenant, 1);
    stateEquals(tenant, 'loading');
    enabledFlags(tenant, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/tenant/1/");
    ajaxHash.success($.extend({}, hashTenant, {
      id: 1,
      name: "Naeka",
      resource_uri: "/api/v1/tenant/1/"
    }));
    stateEquals(tenant, 'loaded.saved');
    enabledFlags(tenant, ['isLoaded', 'isValid']);
    return expect(tenant).toEqual(store.find(Vosae.Tenant, 1));
  });
  it('finding tenants by query makes a GET to /tenant/:query/', function() {
    var naeka, tenants, vosae;
    tenants = store.find(Vosae.Tenant, {
      page: 1
    });
    expect(tenants.get('length')).toEqual(0);
    enabledFlags(tenants, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/tenant/");
    expectAjaxType("GET");
    expectAjaxData({
      page: 1
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashTenant, {
          id: 1,
          name: "Naeka"
        }), $.extend({}, hashTenant, {
          id: 2,
          name: "Vosae"
        })
      ]
    });
    naeka = tenants.objectAt(0);
    vosae = tenants.objectAt(1);
    statesEqual([naeka, vosae], 'loaded.saved');
    enabledFlags(tenants, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([naeka, vosae], ['isLoaded'], recordArrayFlags);
    expect(tenants.get('length')).toEqual(2);
    expect(naeka.get('name')).toEqual("Naeka");
    expect(vosae.get('name')).toEqual("Vosae");
    expect(naeka.get('id')).toEqual("1");
    return expect(vosae.get('id')).toEqual("2");
  });
  it('creating a tenant makes a POST to /tenant/', function() {
    var controller, eur, tenant, usd;
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1,
      symbol: "EUR",
      resource_uri: "/api/v1/currency/1/"
    });
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 2,
      symbol: "USD",
      resource_uri: "/api/v1/currency/2/"
    });
    eur = store.find(Vosae.Currency, 1);
    usd = store.find(Vosae.Currency, 2);
    tenant = store.createRecord(Vosae.Tenant, {
      name: "Naeka"
    });
    controller = Vosae.lookup('controller:tenants.add');
    controller.setProperties({
      supportedCurrencies: [eur, usd],
      defaultCurrency: eur
    });
    stateEquals(tenant, 'loaded.created.uncommitted');
    enabledFlags(tenant, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    tenant.get('transaction').commit();
    stateEquals(tenant, 'loaded.created.inFlight');
    enabledFlags(tenant, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/tenant/");
    expectAjaxType("POST");
    expectAjaxData($.extend({}, hashTenant, {
      name: "Naeka",
      supported_currencies: ['/api/v1/currency/1/', '/api/v1/currency/2/'],
      default_currency: '/api/v1/currency/1/'
    }));
    ajaxHash.success($.extend({}, hashTenant, {
      id: 1,
      name: "Naeka"
    }));
    stateEquals(tenant, 'loaded.saved');
    enabledFlags(tenant, ['isLoaded', 'isValid']);
    return expect(tenant).toEqual(store.find(Vosae.Tenant, 1));
  });
  it('updating a tenant makes a PUT to /tenant/:id/', function() {
    var tenant;
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      name: "Naeka"
    });
    tenant = store.find(Vosae.Tenant, 1);
    stateEquals(tenant, 'loaded.saved');
    enabledFlags(tenant, ['isLoaded', 'isValid']);
    tenant.setProperties({
      name: "Vosae"
    });
    stateEquals(tenant, 'loaded.updated.uncommitted');
    enabledFlags(tenant, ['isLoaded', 'isDirty', 'isValid']);
    tenant.get('transaction').commit();
    stateEquals(tenant, 'loaded.updated.inFlight');
    enabledFlags(tenant, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/tenant/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, hashTenant, {
      name: "Vosae"
    }));
    ajaxHash.success($.extend({}, hashTenant, {
      id: 1,
      name: "Vosae"
    }));
    stateEquals(tenant, 'loaded.saved');
    enabledFlags(tenant, ['isLoaded', 'isValid']);
    expect(tenant).toEqual(store.find(Vosae.Tenant, 1));
    return expect(tenant.get('name')).toEqual('Vosae');
  });
  it('registrationInfo belongsTo relationship', function() {
    var tenant;
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      registration_info: {
        business_entity: "SARL",
        share_capital: "1200.00",
        vat_number: null,
        siret: null,
        rcs_number: null,
        resource_type: "fr_registration_info"
      }
    });
    tenant = store.find(Vosae.Tenant, 1);
    return expect(tenant.get('registrationInfo.businessEntity')).toEqual("SARL");
  });
  it('reportSettings belongsTo relationship', function() {
    var tenant;
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      report_settings: {
        font_name: "arial",
        font_size: 15,
        base_color: "#CCC",
        force_bw: true,
        language: "fr"
      }
    });
    tenant = store.find(Vosae.Tenant, 1);
    return expect(tenant.get('reportSettings.fontName')).toEqual("arial");
  });
  it('postalAddress belongsTo relationship', function() {
    var tenant;
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      postal_address: {
        postoffice_box: "",
        street_address: "streetAddress",
        extended_address: "",
        postal_code: "",
        city: "",
        state: "",
        country: ""
      }
    });
    tenant = store.find(Vosae.Tenant, 1);
    return expect(tenant.get('postalAddress.streetAddress')).toEqual("streetAddress");
  });
  it('billingAddress belongsTo relationship', function() {
    var tenant;
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      billing_address: {
        postoffice_box: "",
        street_address: "streetAddress",
        extended_address: "",
        postal_code: "",
        city: "",
        state: "",
        country: ""
      }
    });
    tenant = store.find(Vosae.Tenant, 1);
    return expect(tenant.get('billingAddress.streetAddress')).toEqual("streetAddress");
  });
  it('svgLogo belongsTo relationship', function() {
    var file, tenant;
    store.adapterForType(Vosae.File).load(store, Vosae.File, {
      id: 1
    });
    file = store.find(Vosae.File, 1);
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      svg_logo: '/api/v1/file/1/'
    });
    tenant = store.find(Vosae.Tenant, 1);
    return expect(tenant.get('svgLogo')).toEqual(file);
  });
  it('imgLogo belongsTo relationship', function() {
    var file, tenant;
    store.adapterForType(Vosae.File).load(store, Vosae.File, {
      id: 1
    });
    file = store.find(Vosae.File, 1);
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      img_logo: '/api/v1/file/1/'
    });
    tenant = store.find(Vosae.Tenant, 1);
    return expect(tenant.get('imgLogo')).toEqual(file);
  });
  return it('terms belongsTo relationship', function() {
    var file, tenant;
    store.adapterForType(Vosae.File).load(store, Vosae.File, {
      id: 1
    });
    file = store.find(Vosae.File, 1);
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      terms: '/api/v1/file/1/'
    });
    tenant = store.find(Vosae.Tenant, 1);
    return expect(tenant.get('terms')).toEqual(file);
  });
});

var store;

store = null;

describe('Vosae.File', function() {
  var hashFile;
  hashFile = {
    name: null,
    size: null,
    sha1_checksum: null,
    download_link: null,
    stream_link: null,
    ttl: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.File);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all file makes a GET to /file/', function() {
    var file, files;
    files = store.find(Vosae.File);
    enabledFlags(files, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/file/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashFile, {
          id: 1,
          name: "myFile.txt"
        })
      ]
    });
    file = files.objectAt(0);
    statesEqual(files, 'loaded.saved');
    stateEquals(file, 'loaded.saved');
    enabledFlagsForArray(files, ['isLoaded', 'isValid']);
    enabledFlags(file, ['isLoaded', 'isValid']);
    return expect(file).toEqual(store.find(Vosae.File, 1));
  });
  it('finding a file by ID makes a GET to /file/:id/', function() {
    var file;
    file = store.find(Vosae.File, 1);
    stateEquals(file, 'loading');
    enabledFlags(file, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/file/1/");
    ajaxHash.success($.extend({}, hashFile, {
      id: 1,
      name: "myFile.txt",
      resource_uri: "/api/v1/file/1/"
    }));
    stateEquals(file, 'loaded.saved');
    enabledFlags(file, ['isLoaded', 'isValid']);
    return expect(file).toEqual(store.find(Vosae.File, 1));
  });
  it('finding files by query makes a GET to /file/:query/', function() {
    var file1, file2, files;
    files = store.find(Vosae.File, {
      page: 1
    });
    expect(files.get('length')).toEqual(0);
    enabledFlags(files, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/file/");
    expectAjaxType("GET");
    expectAjaxData({
      page: 1
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashFile, {
          id: 1,
          name: "myFile1.txt"
        }), $.extend({}, hashFile, {
          id: 2,
          name: "myFile2.txt"
        })
      ]
    });
    file1 = files.objectAt(0);
    file2 = files.objectAt(1);
    statesEqual([file1, file2], 'loaded.saved');
    enabledFlags(files, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([file1, file2], ['isLoaded'], recordArrayFlags);
    expect(files.get('length')).toEqual(2);
    expect(file1.get('name')).toEqual("myFile1.txt");
    expect(file2.get('name')).toEqual("myFile2.txt");
    expect(file1.get('id')).toEqual("1");
    return expect(file2.get('id')).toEqual("2");
  });
  it('creating a file makes a POST to /file/', function() {
    var file;
    file = store.createRecord(Vosae.File, {
      name: "myFile.txt"
    });
    stateEquals(file, 'loaded.created.uncommitted');
    enabledFlags(file, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    file.get('transaction').commit();
    stateEquals(file, 'loaded.created.inFlight');
    enabledFlags(file, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/file/");
    expectAjaxType("POST");
    expectAjaxData($.extend({}, hashFile, {
      name: "myFile.txt"
    }));
    ajaxHash.success($.extend({}, hashFile, {
      id: 1,
      name: "myFile.txt",
      resource_uri: "/api/v1/file/1/"
    }));
    stateEquals(file, 'loaded.saved');
    enabledFlags(file, ['isLoaded', 'isValid']);
    return expect(file).toEqual(store.find(Vosae.File, 1));
  });
  it('updating a file makes a PUT to /file/:id/', function() {
    var file;
    store.adapterForType(Vosae.File).load(store, Vosae.File, {
      id: 1,
      name: "myFile.txt"
    });
    file = store.find(Vosae.File, 1);
    stateEquals(file, 'loaded.saved');
    enabledFlags(file, ['isLoaded', 'isValid']);
    file.setProperties({
      name: "export.txt"
    });
    stateEquals(file, 'loaded.updated.uncommitted');
    enabledFlags(file, ['isLoaded', 'isDirty', 'isValid']);
    file.get('transaction').commit();
    stateEquals(file, 'loaded.updated.inFlight');
    enabledFlags(file, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/file/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, hashFile, {
      name: "export.txt"
    }));
    ajaxHash.success($.extend({}, hashFile, {
      id: 1,
      name: "export.txt"
    }));
    stateEquals(file, 'loaded.saved');
    enabledFlags(file, ['isLoaded', 'isValid']);
    expect(file).toEqual(store.find(Vosae.File, 1));
    return expect(file.get('name')).toEqual('export.txt');
  });
  it('deleting a file makes a DELETE to /file/:id/', function() {
    var file;
    store.adapterForType(Vosae.File).load(store, Vosae.File, {
      id: 1,
      name: "myFile.txt"
    });
    file = store.find(Vosae.File, 1);
    stateEquals(file, 'loaded.saved');
    enabledFlags(file, ['isLoaded', 'isValid']);
    file.deleteRecord();
    stateEquals(file, 'deleted.uncommitted');
    enabledFlags(file, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']);
    file.get('transaction').commit();
    stateEquals(file, 'deleted.inFlight');
    enabledFlags(file, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']);
    expectAjaxURL("/file/1/");
    expectAjaxType("DELETE");
    ajaxHash.success();
    stateEquals(file, 'deleted.saved');
    return enabledFlags(file, ['isLoaded', 'isDeleted', 'isValid']);
  });
  return it('issuer belongsTo relationship', function() {
    var file, user;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1
    });
    user = store.find(Vosae.User, 1);
    store.adapterForType(Vosae.File).load(store, Vosae.File, {
      id: 1,
      issuer: "/api/v1/user/1/"
    });
    file = store.find(Vosae.File, 1);
    return expect(file.get('issuer')).toEqual(user);
  });
});

var store;

store = null;

describe('Vosae.Group', function() {
  var hashGroup;
  hashGroup = {
    name: null,
    permissions: []
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Group);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all group makes a GET to /group/', function() {
    var group, groups;
    groups = store.find(Vosae.Group);
    enabledFlags(groups, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/group/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashGroup, {
          id: 1,
          name: "Administrators"
        })
      ]
    });
    group = groups.objectAt(0);
    statesEqual(groups, 'loaded.saved');
    stateEquals(group, 'loaded.saved');
    enabledFlagsForArray(groups, ['isLoaded', 'isValid']);
    enabledFlags(group, ['isLoaded', 'isValid']);
    return expect(group).toEqual(store.find(Vosae.Group, 1));
  });
  it('finding a group by ID makes a GET to /group/:id/', function() {
    var group;
    group = store.find(Vosae.Group, 1);
    stateEquals(group, 'loading');
    enabledFlags(group, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/group/1/");
    ajaxHash.success($.extend({}, hashGroup, {
      id: 1,
      name: "Administrators",
      resource_uri: "/api/v1/group/1/"
    }));
    stateEquals(group, 'loaded.saved');
    enabledFlags(group, ['isLoaded', 'isValid']);
    return expect(group).toEqual(store.find(Vosae.Group, 1));
  });
  it('finding groups by query makes a GET to /group/:query/', function() {
    var administrators, groups, users;
    groups = store.find(Vosae.Group, {
      page: 1
    });
    expect(groups.get('length')).toEqual(0);
    enabledFlags(groups, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/group/");
    expectAjaxType("GET");
    expectAjaxData({
      page: 1
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashGroup, {
          id: 1,
          name: "Administrators"
        }), $.extend({}, hashGroup, {
          id: 2,
          name: "Users"
        })
      ]
    });
    administrators = groups.objectAt(0);
    users = groups.objectAt(1);
    statesEqual([administrators, users], 'loaded.saved');
    enabledFlags(groups, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([administrators, users], ['isLoaded'], recordArrayFlags);
    expect(groups.get('length')).toEqual(2);
    expect(administrators.get('name')).toEqual("Administrators");
    expect(users.get('name')).toEqual("Users");
    expect(administrators.get('id')).toEqual("1");
    return expect(users.get('id')).toEqual("2");
  });
  it('creating a group makes a POST to /group/', function() {
    var group;
    group = store.createRecord(Vosae.Group, {
      name: "Administrators"
    });
    stateEquals(group, 'loaded.created.uncommitted');
    enabledFlags(group, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    group.get('transaction').commit();
    stateEquals(group, 'loaded.created.inFlight');
    enabledFlags(group, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/group/");
    expectAjaxType("POST");
    expectAjaxData($.extend({}, hashGroup, {
      name: "Administrators"
    }));
    ajaxHash.success($.extend({}, hashGroup, {
      id: 1,
      name: "Administrators",
      created_by: "/api/v1/user/1/",
      resource_uri: "/api/v1/group/1/"
    }));
    stateEquals(group, 'loaded.saved');
    enabledFlags(group, ['isLoaded', 'isValid']);
    return expect(group).toEqual(store.find(Vosae.Group, 1));
  });
  it('updating a group makes a PUT to /group/:id/', function() {
    var group;
    store.adapterForType(Vosae.Group).load(store, Vosae.Group, {
      id: 1,
      name: "Administrators"
    });
    group = store.find(Vosae.Group, 1);
    stateEquals(group, 'loaded.saved');
    enabledFlags(group, ['isLoaded', 'isValid']);
    group.setProperties({
      name: "Secretaries"
    });
    stateEquals(group, 'loaded.updated.uncommitted');
    enabledFlags(group, ['isLoaded', 'isDirty', 'isValid']);
    group.get('transaction').commit();
    stateEquals(group, 'loaded.updated.inFlight');
    enabledFlags(group, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/group/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, hashGroup, {
      name: "Secretaries"
    }));
    ajaxHash.success($.extend({}, hashGroup, {
      id: 1,
      name: "Secretaries"
    }));
    stateEquals(group, 'loaded.saved');
    enabledFlags(group, ['isLoaded', 'isValid']);
    expect(group).toEqual(store.find(Vosae.Group, 1));
    return expect(group.get('name')).toEqual('Secretaries');
  });
  it('deleting a group makes a DELETE to /group/:id/', function() {
    var group;
    store.adapterForType(Vosae.Group).load(store, Vosae.Group, {
      id: 1,
      name: "Administrators"
    });
    group = store.find(Vosae.Group, 1);
    stateEquals(group, 'loaded.saved');
    enabledFlags(group, ['isLoaded', 'isValid']);
    group.deleteRecord();
    stateEquals(group, 'deleted.uncommitted');
    enabledFlags(group, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']);
    group.get('transaction').commit();
    stateEquals(group, 'deleted.inFlight');
    enabledFlags(group, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']);
    expectAjaxURL("/group/1/");
    expectAjaxType("DELETE");
    ajaxHash.success();
    stateEquals(group, 'deleted.saved');
    return enabledFlags(group, ['isLoaded', 'isDeleted', 'isValid']);
  });
  it('createdBy belongsTo relationship', function() {
    var group, user;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1
    });
    user = store.find(Vosae.User, 1);
    store.adapterForType(Vosae.Group).load(store, Vosae.Group, {
      id: 1,
      created_by: '/api/v1/user/1/'
    });
    group = store.find(Vosae.Group, 1);
    return expect(group.get('createdBy')).toEqual(user);
  });
  return it('loadPermissionsFromGroup() method should load and set permissions from another group', function() {
    var group1, group2;
    store.adapterForType(Vosae.Group).load(store, Vosae.Group, {
      id: 1,
      permissions: ['can_edit_organization']
    });
    store.adapterForType(Vosae.Group).load(store, Vosae.Group, {
      id: 2,
      permissions: []
    });
    group1 = store.find(Vosae.Group, 1);
    group2 = store.find(Vosae.Group, 2);
    group2.loadPermissionsFromGroup(group1);
    return expect(group2.get('permissions')).toEqual(['can_edit_organization']);
  });
});

var store;

store = null;

describe('Vosae.Notification', function() {
  var hashNotification;
  hashNotification = {
    read: false,
    sent_at: void 0
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Notification);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all notification makes a GET to /notification/', function() {
    var notification, notifications;
    notifications = store.find(Vosae.Notification);
    enabledFlags(notifications, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/notification/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashNotification, {
          id: 1,
          read: false
        })
      ]
    });
    notification = notifications.objectAt(0);
    statesEqual(notifications, 'loaded.saved');
    stateEquals(notification, 'loaded.saved');
    enabledFlagsForArray(notifications, ['isLoaded', 'isValid']);
    enabledFlags(notification, ['isLoaded', 'isValid']);
    return expect(notification).toEqual(store.find(Vosae.Notification, 1));
  });
  it('finding a notification by ID makes a GET to /notification/:id/', function() {
    var notification;
    notification = store.find(Vosae.Notification, 1);
    ajaxHash.success($.extend, {}, hashNotification, {
      id: 1,
      read: false
    });
    expectAjaxType("GET");
    expectAjaxURL("/notification/1/");
    return expect(notification).toEqual(store.find(Vosae.Notification, 1));
  });
  it('marking a notification as read makes a PUT to /notification/:id/mark_as_read/', function() {
    var notification;
    store.load(Vosae.Notification, {
      id: 1,
      read: false
    });
    notification = store.find(Vosae.Notification, 1);
    notification.markAsRead();
    expectAjaxType("PUT");
    expectAjaxURL("/notification/1/mark_as_read/");
    expect(notification).toEqual(store.find(Vosae.Notification, 1));
    return expect(notification.get('read')).toEqual(true);
  });
  it('polymorph contact_saved_ne', function() {
    var contact, notification;
    store.load(Vosae.Contact, {
      id: 1
    });
    contact = store.find(Vosae.Contact, 1);
    notification = store.find(Vosae.ContactSavedNE, 1);
    ajaxHash.success($.extend({}, hashNotification, {
      id: 1,
      resource_type: "contact_saved_ne",
      contact_name: "Tom Dale",
      contact: "/api/v1/contact/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/notification/1/");
    expect(notification.get('module')).toEqual("contact");
    expect(notification.get('contactName')).toEqual("Tom Dale");
    return expect(notification.get('contact')).toEqual(contact);
  });
  it('polymorph organization_saved_ne', function() {
    var notification, organization;
    store.load(Vosae.Organization, {
      id: 1
    });
    organization = store.find(Vosae.Organization, 1);
    notification = store.find(Vosae.OrganizationSavedNE, 1);
    ajaxHash.success($.extend({}, hashNotification, {
      id: 1,
      resource_type: "organization_saved_ne",
      organization_name: "Naeka",
      organization: "/api/v1/organization/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/notification/1/");
    expect(notification.get('module')).toEqual("contact");
    expect(notification.get('organizationName')).toEqual("Naeka");
    return expect(notification.get('organization')).toEqual(organization);
  });
  it('polymorph quotation_saved_ne', function() {
    var notification, quotation;
    store.load(Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    notification = store.find(Vosae.QuotationSavedNE, 1);
    ajaxHash.success($.extend({}, hashNotification, {
      id: 1,
      resource_type: "quotation_saved_ne",
      customer_display: "Vosae",
      quotation_reference: "QUOTATION 2013_12_04_001",
      quotation: "/api/v1/quotation/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/notification/1/");
    expect(notification.get('module')).toEqual("invoicing");
    expect(notification.get('customerDisplay')).toEqual("Vosae");
    expect(notification.get('quotationReference')).toEqual("QUOTATION 2013_12_04_001");
    return expect(notification.get('quotation')).toEqual(quotation);
  });
  it('polymorph invoice_saved_ne', function() {
    var invoice, notification;
    store.load(Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    notification = store.find(Vosae.InvoiceSavedNE, 1);
    ajaxHash.success($.extend({}, hashNotification, {
      id: 1,
      resource_type: "invoice_saved_ne",
      customer_display: "Vosae",
      invoice_reference: "INVOICE 2013_12_04_001",
      invoice: "/api/v1/invoice/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/notification/1/");
    expect(notification.get('module')).toEqual("invoicing");
    expect(notification.get('customerDisplay')).toEqual("Vosae");
    expect(notification.get('invoiceReference')).toEqual("INVOICE 2013_12_04_001");
    return expect(notification.get('invoice')).toEqual(invoice);
  });
  it('polymorph down_payment_invoice_saved_ne', function() {
    var downPaymentInvoice, notification;
    store.load(Vosae.DownPaymentInvoice, {
      id: 1
    });
    downPaymentInvoice = store.find(Vosae.DownPaymentInvoice, 1);
    notification = store.find(Vosae.DownPaymentInvoiceSavedNE, 1);
    ajaxHash.success($.extend({}, hashNotification, {
      id: 1,
      resource_type: "down_payment_invoice_saved_ne",
      customer_display: "Vosae",
      down_payment_invoice_reference: "DOWNPAYMENTINVOICE 2013_12_04_001",
      down_payment_invoice: "/api/v1/down_payment_invoice/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/notification/1/");
    expect(notification.get('module')).toEqual("invoicing");
    expect(notification.get('customerDisplay')).toEqual("Vosae");
    expect(notification.get('downPaymentInvoiceReference')).toEqual("DOWNPAYMENTINVOICE 2013_12_04_001");
    return expect(notification.get('downPaymentInvoice')).toEqual(downPaymentInvoice);
  });
  return it('polymorph credit_note_saved_ne', function() {
    var creditNote, notification;
    store.load(Vosae.CreditNote, {
      id: 1
    });
    creditNote = store.find(Vosae.CreditNote, 1);
    notification = store.find(Vosae.CreditNoteSavedNE, 1);
    ajaxHash.success($.extend({}, hashNotification, {
      id: 1,
      resource_type: "credit_note_saved_ne",
      customer_display: "Vosae",
      credit_note_reference: "CREDITNOTE 2013_12_04_001",
      credit_note: "/api/v1/credit_note/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/notification/1/");
    expect(notification.get('module')).toEqual("invoicing");
    expect(notification.get('customerDisplay')).toEqual("Vosae");
    expect(notification.get('creditNoteReference')).toEqual("CREDITNOTE 2013_12_04_001");
    return expect(notification.get('creditNote')).toEqual(creditNote);
  });
});

var store;

store = null;

describe('Vosae.Permission', function() {
  beforeEach(function() {
    return store = Vosae.Store.create();
  });
  return afterEach(function() {
    return store.destroy();
  });
});

var store;

store = null;

describe('Vosae.RegistrationInfo', function() {
  var hashRegistrationInfo;
  hashRegistrationInfo = {
    business_entity: null,
    share_capital: null
  };
  beforeEach(function() {
    return store = Vosae.Store.create();
  });
  afterEach(function() {
    return store.destroy();
  });
  it('registrationInfoFor() method should return the right model according to the country code', function() {
    var registrationInfo;
    registrationInfo = Vosae.RegistrationInfo.createRecord();
    expect(registrationInfo.registrationInfoFor('BE')).toEqual(Vosae.BeRegistrationInfo);
    expect(registrationInfo.registrationInfoFor('CH')).toEqual(Vosae.ChRegistrationInfo);
    expect(registrationInfo.registrationInfoFor('FR')).toEqual(Vosae.FrRegistrationInfo);
    expect(registrationInfo.registrationInfoFor('GB')).toEqual(Vosae.GbRegistrationInfo);
    expect(registrationInfo.registrationInfoFor('LU')).toEqual(Vosae.LuRegistrationInfo);
    return expect(registrationInfo.registrationInfoFor('US')).toEqual(Vosae.UsRegistrationInfo);
  });
  it('polymorph be_registration_info', function() {
    var tenant;
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      registration_info: {
        business_entity: "SARL",
        share_capital: "1200,00",
        resource_type: "be_registration_info",
        vat_number: "30303030"
      }
    });
    tenant = store.find(Vosae.Tenant, 1);
    expect(tenant.get('registrationInfo.countryCode')).toEqual('BE');
    expect(tenant.get('registrationInfo.businessEntity')).toEqual("SARL");
    expect(tenant.get('registrationInfo.shareCapital')).toEqual("1200,00");
    return expect(tenant.get('registrationInfo.vatNumber')).toEqual("30303030");
  });
  it('polymorph ch_registration_info', function() {
    var tenant;
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      registration_info: {
        business_entity: "SARL",
        share_capital: "1200,00",
        resource_type: "ch_registration_info",
        vat_number: "30303030"
      }
    });
    tenant = store.find(Vosae.Tenant, 1);
    expect(tenant.get('registrationInfo.countryCode')).toEqual('CH');
    expect(tenant.get('registrationInfo.businessEntity')).toEqual("SARL");
    expect(tenant.get('registrationInfo.shareCapital')).toEqual("1200,00");
    return expect(tenant.get('registrationInfo.vatNumber')).toEqual("30303030");
  });
  it('polymorph fr_registration_info', function() {
    var tenant;
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      registration_info: {
        business_entity: "SARL",
        share_capital: "1200,00",
        resource_type: "fr_registration_info",
        vat_number: "30303030",
        siret: "12345",
        rcs_number: "6780"
      }
    });
    tenant = store.find(Vosae.Tenant, 1);
    expect(tenant.get('registrationInfo.countryCode')).toEqual('FR');
    expect(tenant.get('registrationInfo.businessEntity')).toEqual("SARL");
    expect(tenant.get('registrationInfo.shareCapital')).toEqual("1200,00");
    expect(tenant.get('registrationInfo.vatNumber')).toEqual("30303030");
    expect(tenant.get('registrationInfo.siret')).toEqual("12345");
    return expect(tenant.get('registrationInfo.rcsNumber')).toEqual("6780");
  });
  it('polymorph gb_registration_info', function() {
    var tenant;
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      registration_info: {
        business_entity: "SARL",
        share_capital: "1200,00",
        resource_type: "gb_registration_info",
        vat_number: "30303030"
      }
    });
    tenant = store.find(Vosae.Tenant, 1);
    expect(tenant.get('registrationInfo.countryCode')).toEqual('GB');
    expect(tenant.get('registrationInfo.businessEntity')).toEqual("SARL");
    expect(tenant.get('registrationInfo.shareCapital')).toEqual("1200,00");
    return expect(tenant.get('registrationInfo.vatNumber')).toEqual("30303030");
  });
  it('polymorph lu_registration_info', function() {
    var tenant;
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      registration_info: {
        business_entity: "SARL",
        share_capital: "1200,00",
        resource_type: "lu_registration_info",
        vat_number: "30303030"
      }
    });
    tenant = store.find(Vosae.Tenant, 1);
    expect(tenant.get('registrationInfo.countryCode')).toEqual('LU');
    expect(tenant.get('registrationInfo.businessEntity')).toEqual("SARL");
    expect(tenant.get('registrationInfo.shareCapital')).toEqual("1200,00");
    return expect(tenant.get('registrationInfo.vatNumber')).toEqual("30303030");
  });
  return it('polymorph us_registration_info', function() {
    var tenant;
    store.adapterForType(Vosae.Tenant).load(store, Vosae.Tenant, {
      id: 1,
      registration_info: {
        business_entity: "SARL",
        share_capital: "1200,00",
        resource_type: "us_registration_info"
      }
    });
    tenant = store.find(Vosae.Tenant, 1);
    expect(tenant.get('registrationInfo.countryCode')).toEqual('US');
    expect(tenant.get('registrationInfo.businessEntity')).toEqual("SARL");
    return expect(tenant.get('registrationInfo.shareCapital')).toEqual("1200,00");
  });
});

var store;

store = null;

describe('Vosae.ReportSettings', function() {
  var hashReportSettings;
  hashReportSettings = {
    fontName: null,
    fontSize: null,
    baseColor: null,
    forceBw: null,
    language: null
  };
  beforeEach(function() {
    return store = Vosae.Store.create();
  });
  afterEach(function() {
    return store.destroy();
  });
  it('defaultLanguage computed property should return the language object according to the country code', function() {
    var reportSettings;
    store.adapterForType(Vosae.ReportSettings).load(store, Vosae.ReportSettings, {
      id: 1,
      language: "fr"
    });
    reportSettings = store.find(Vosae.ReportSettings, 1);
    return expect(reportSettings.get('defaultLanguage')).toEqual(Vosae.languages.findProperty('code', 'fr'));
  });
  return it('otherLanguages computed property should return an array of language object different than the default language ', function() {
    var otherLanguages, reportSettings;
    store.adapterForType(Vosae.ReportSettings).load(store, Vosae.ReportSettings, {
      id: 1,
      language: "fr"
    });
    reportSettings = store.find(Vosae.ReportSettings, 1);
    otherLanguages = Vosae.languages.filter(function(language) {
      if (language.get('code') !== "fr") {
        return language;
      }
    });
    return expect(reportSettings.get('otherLanguages')).toEqual(otherLanguages);
  });
});

var store;

store = null;

describe('Vosae.Timeline', function() {
  var hashTimelineEntry;
  hashTimelineEntry = {
    datetime: void 0,
    created: false,
    module: null,
    issuer_name: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Timeline);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all timeline entries makes a GET to /timeline/', function() {
    var timelineEntries, timelineEntry;
    timelineEntries = store.find(Vosae.Timeline);
    enabledFlags(timelineEntries, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/timeline/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashTimelineEntry, {
          id: 1,
          created: false
        })
      ]
    });
    timelineEntry = timelineEntries.objectAt(0);
    statesEqual(timelineEntries, 'loaded.saved');
    stateEquals(timelineEntry, 'loaded.saved');
    enabledFlagsForArray(timelineEntries, ['isLoaded', 'isValid']);
    enabledFlags(timelineEntry, ['isLoaded', 'isValid']);
    return expect(timelineEntry).toEqual(store.find(Vosae.Timeline, 1));
  });
  it('finding a timeline entry by ID makes a GET to /timeline/:id/', function() {
    var timelineEntry;
    timelineEntry = store.find(Vosae.Timeline, 1);
    ajaxHash.success($.extend, {}, hashTimelineEntry, {
      id: 1,
      created: false
    });
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    return expect(timelineEntry).toEqual(store.find(Vosae.Timeline, 1));
  });
  it('polymorph contact_saved_te', function() {
    var contact, timelineEntry;
    store.load(Vosae.Contact, {
      id: 1
    });
    contact = store.find(Vosae.Contact, 1);
    timelineEntry = store.find(Vosae.ContactSavedTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      created: false,
      resource_type: "contact_saved_te",
      contact_name: "Tom Dale",
      contact: "/api/v1/contact/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('contactName')).toEqual("Tom Dale");
    return expect(timelineEntry.get('contact')).toEqual(contact);
  });
  it('polymorph organization_saved_te', function() {
    var organization, timelineEntry;
    store.load(Vosae.Organization, {
      id: 1
    });
    organization = store.find(Vosae.Organization, 1);
    timelineEntry = store.find(Vosae.OrganizationSavedTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      resource_type: "organization_saved_te",
      organization_name: "Naeka",
      organization: "/api/v1/organization/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('organizationName')).toEqual("Naeka");
    return expect(timelineEntry.get('organization')).toEqual(organization);
  });
  it('polymorph quotation_saved_te', function() {
    var quotation, timelineEntry;
    store.load(Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    timelineEntry = store.find(Vosae.QuotationSavedTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      customer_display: "Naeka",
      quotation_reference: "QUOTATION 2013_12_04_001",
      quotation: "/api/v1/quotation/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('customerDisplay')).toEqual("Naeka");
    expect(timelineEntry.get('quotationReference')).toEqual("QUOTATION 2013_12_04_001");
    return expect(timelineEntry.get('quotation')).toEqual(quotation);
  });
  it('polymorph invoice_saved_te', function() {
    var invoice, timelineEntry;
    store.load(Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    timelineEntry = store.find(Vosae.InvoiceSavedTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      customer_display: "Naeka",
      invoice_reference: "INVOICE 2013_12_04_001",
      invoice: "/api/v1/invoice/1/",
      invoice_has_temporary_reference: true
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('customerDisplay')).toEqual("Naeka");
    expect(timelineEntry.get('invoiceReference')).toEqual("INVOICE 2013_12_04_001");
    expect(timelineEntry.get('invoiceHasTemporaryReference')).toEqual(true);
    return expect(timelineEntry.get('invoice')).toEqual(invoice);
  });
  it('polymorph down_payment_invoice_saved_te', function() {
    var downPaymentInvoice, timelineEntry;
    store.load(Vosae.DownPaymentInvoice, {
      id: 1
    });
    downPaymentInvoice = store.find(Vosae.DownPaymentInvoice, 1);
    timelineEntry = store.find(Vosae.DownPaymentInvoiceSavedTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      customer_display: "Naeka",
      down_payment_invoice_reference: "DOWNPAYMENTINVOICE 2013_12_04_001",
      down_payment_invoice: "/api/v1/down_payment_invoice/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('customerDisplay')).toEqual("Naeka");
    expect(timelineEntry.get('downPaymentInvoiceReference')).toEqual("DOWNPAYMENTINVOICE 2013_12_04_001");
    return expect(timelineEntry.get('downPaymentInvoice')).toEqual(downPaymentInvoice);
  });
  it('polymorph credit_note_saved_te', function() {
    var creditNote, timelineEntry;
    store.load(Vosae.CreditNote, {
      id: 1
    });
    creditNote = store.find(Vosae.CreditNote, 1);
    timelineEntry = store.find(Vosae.CreditNoteSavedTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      customer_display: "Naeka",
      credit_note_reference: "CREDITNOTE 2013_12_04_001",
      credit_note: "/api/v1/credit_note/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('customerDisplay')).toEqual("Naeka");
    expect(timelineEntry.get('creditNoteReference')).toEqual("CREDITNOTE 2013_12_04_001");
    return expect(timelineEntry.get('creditNote')).toEqual(creditNote);
  });
  it('polymorph quotation_changed_state_te', function() {
    var quotation, timelineEntry;
    store.load(Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    timelineEntry = store.find(Vosae.QuotationChangedStateTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      previous_state: "DRAFT",
      new_state: "AWAITING_APPROVAL",
      quotation_reference: "QUOTATION 2013_12_04_001",
      quotation: "/api/v1/quotation/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('previousState')).toEqual("DRAFT");
    expect(timelineEntry.get('newState')).toEqual("AWAITING_APPROVAL");
    expect(timelineEntry.get('quotationReference')).toEqual("QUOTATION 2013_12_04_001");
    return expect(timelineEntry.get('quotation')).toEqual(quotation);
  });
  it('polymorph invoice_changed_state_te', function() {
    var invoice, timelineEntry;
    store.load(Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    timelineEntry = store.find(Vosae.InvoiceChangedStateTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      previous_state: "DRAFT",
      new_state: "REGISTERED",
      invoice_reference: "INVOICE 2013_12_04_001",
      invoice: "/api/v1/invoice/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('previousState')).toEqual("DRAFT");
    expect(timelineEntry.get('newState')).toEqual("REGISTERED");
    expect(timelineEntry.get('invoiceReference')).toEqual("INVOICE 2013_12_04_001");
    return expect(timelineEntry.get('invoice')).toEqual(invoice);
  });
  it('polymorph down_payment_invoice_changed_state_te', function() {
    var downPaymentInvoice, timelineEntry;
    store.load(Vosae.DownPaymentInvoice, {
      id: 1
    });
    downPaymentInvoice = store.find(Vosae.DownPaymentInvoice, 1);
    timelineEntry = store.find(Vosae.DownPaymentInvoiceChangedStateTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      previous_state: "DRAFT",
      new_state: "REGISTERED",
      down_payment_invoice_reference: "DOWNPAYMENTINVOICE 2013_12_04_001",
      down_payment_invoice: "/api/v1/down_payment_invoice/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('previousState')).toEqual("DRAFT");
    expect(timelineEntry.get('newState')).toEqual("REGISTERED");
    expect(timelineEntry.get('downPaymentInvoiceReference')).toEqual("DOWNPAYMENTINVOICE 2013_12_04_001");
    return expect(timelineEntry.get('downPaymentInvoice')).toEqual(downPaymentInvoice);
  });
  it('polymorph credit_note_changed_state_te', function() {
    var creditNote, timelineEntry;
    store.load(Vosae.CreditNote, {
      id: 1
    });
    creditNote = store.find(Vosae.CreditNote, 1);
    timelineEntry = store.find(Vosae.CreditNoteChangedStateTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      previous_state: "DRAFT",
      new_state: "REGISTERED",
      credit_note_reference: "CREDITNOTE 2013_12_04_001",
      credit_note: "/api/v1/credit_note/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('previousState')).toEqual("DRAFT");
    expect(timelineEntry.get('newState')).toEqual("REGISTERED");
    expect(timelineEntry.get('creditNoteReference')).toEqual("CREDITNOTE 2013_12_04_001");
    return expect(timelineEntry.get('creditNote')).toEqual(creditNote);
  });
  it('polymorph quotation_make_invoice_te', function() {
    var invoice, quotation, timelineEntry;
    store.load(Vosae.Quotation, {
      id: 1
    });
    store.load(Vosae.Invoice, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    invoice = store.find(Vosae.Invoice, 1);
    timelineEntry = store.find(Vosae.QuotationMakeInvoiceTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      customer_display: "Vosae",
      quotation_reference: "QUOTATION 2013_12_04_001",
      quotation: "/api/v1/quotation/1/",
      invoice_reference: "INVOICE 2013_12_04_001",
      invoice_has_temporary_reference: true,
      invoice: "/api/v1/invoice/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('customerDisplay')).toEqual("Vosae");
    expect(timelineEntry.get('quotationReference')).toEqual("QUOTATION 2013_12_04_001");
    expect(timelineEntry.get('quotation')).toEqual(quotation);
    expect(timelineEntry.get('invoiceReference')).toEqual("INVOICE 2013_12_04_001");
    expect(timelineEntry.get('invoiceHasTemporaryReference')).toEqual(true);
    return expect(timelineEntry.get('invoice')).toEqual(invoice);
  });
  it('polymorph quotation_make_down_payment_invoice_te', function() {
    var downPaymentInvoice, quotation, timelineEntry;
    store.load(Vosae.Quotation, {
      id: 1
    });
    store.load(Vosae.DownPaymentInvoice, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    downPaymentInvoice = store.find(Vosae.DownPaymentInvoice, 1);
    timelineEntry = store.find(Vosae.QuotationMakeDownPaymentInvoiceTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      quotation_reference: "QUOTATION 2013_12_04_001",
      quotation: "/api/v1/quotation/1/",
      down_payment_invoice: "/api/v1/down_payment_invoice/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('quotationReference')).toEqual("QUOTATION 2013_12_04_001");
    expect(timelineEntry.get('quotation')).toEqual(quotation);
    return expect(timelineEntry.get('downPaymentInvoice')).toEqual(downPaymentInvoice);
  });
  it('polymorph invoice_cancelled_te', function() {
    var creditNote, invoice, timelineEntry;
    store.load(Vosae.Invoice, {
      id: 1
    });
    store.load(Vosae.CreditNote, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    creditNote = store.find(Vosae.CreditNote, 1);
    timelineEntry = store.find(Vosae.InvoiceCancelledTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      invoice_reference: "INVOICE 2013_12_04_001",
      invoice: "/api/v1/invoice/1/",
      credit_note: "/api/v1/credit_note/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('invoiceReference')).toEqual("INVOICE 2013_12_04_001");
    expect(timelineEntry.get('invoice')).toEqual(invoice);
    return expect(timelineEntry.get('creditNote')).toEqual(creditNote);
  });
  return it('polymorph down_payment_invoice_cancelled_te', function() {
    var creditNote, downPaymentInvoice, timelineEntry;
    store.load(Vosae.DownPaymentInvoice, {
      id: 1
    });
    store.load(Vosae.CreditNote, {
      id: 1
    });
    downPaymentInvoice = store.find(Vosae.DownPaymentInvoice, 1);
    creditNote = store.find(Vosae.CreditNote, 1);
    timelineEntry = store.find(Vosae.DownPaymentInvoiceCancelledTE, 1);
    ajaxHash.success($.extend({}, hashTimelineEntry, {
      id: 1,
      down_payment_invoice_reference: "DOWNPAYMENTINVOICE 2013_12_04_001",
      down_payment_invoice: "/api/v1/down_payment_invoice/1/",
      credit_note: "/api/v1/credit_note/1/"
    }));
    expectAjaxType("GET");
    expectAjaxURL("/timeline/1/");
    expect(timelineEntry.get('downPaymentInvoiceReference')).toEqual("DOWNPAYMENTINVOICE 2013_12_04_001");
    expect(timelineEntry.get('downPaymentInvoice')).toEqual(downPaymentInvoice);
    return expect(timelineEntry.get('creditNote')).toEqual(creditNote);
  });
});

var store;

store = null;

describe('Vosae.User', function() {
  var hashUser;
  hashUser = {
    email: null,
    full_name: null,
    groups: [],
    permissions: [],
    photo_uri: null,
    settings: null,
    specific_permissions: {},
    status: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.User);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all user makes a GET to /user/', function() {
    var user, users;
    users = store.find(Vosae.User);
    enabledFlags(users, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/user/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashUser, {
          id: 1,
          full_name: "Tom Dale",
          email: "tom.dale@vosae.com"
        })
      ]
    });
    user = users.objectAt(0);
    statesEqual(users, 'loaded.saved');
    stateEquals(user, 'loaded.saved');
    enabledFlagsForArray(users, ['isLoaded', 'isValid']);
    enabledFlags(user, ['isLoaded', 'isValid']);
    return expect(user).toEqual(store.find(Vosae.User, 1));
  });
  it('finding a user by ID makes a GET to /user/:id/', function() {
    var user;
    user = store.find(Vosae.User, 1);
    stateEquals(user, 'loading');
    enabledFlags(user, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/user/1/");
    ajaxHash.success($.extend({}, hashUser, {
      id: 1,
      full_name: "Tom Dale",
      email: "tom.dale@vosae.com",
      resource_uri: "/api/v1/user/1/"
    }));
    stateEquals(user, 'loaded.saved');
    enabledFlags(user, ['isLoaded', 'isValid']);
    return expect(user).toEqual(store.find(Vosae.User, 1));
  });
  it('finding users by query makes a GET to /user/:query/', function() {
    var tom, users, yehuda;
    users = store.find(Vosae.User, {
      page: 1
    });
    expect(users.get('length')).toEqual(0);
    enabledFlags(users, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/user/");
    expectAjaxType("GET");
    expectAjaxData({
      page: 1
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashUser, {
          id: 1,
          full_name: "Tom Dale",
          email: "tom.dale@vosae.com"
        }), $.extend({}, hashUser, {
          id: 2,
          full_name: "Yehuda Katz",
          email: "yehuda.katz@vosae.com"
        })
      ]
    });
    tom = users.objectAt(0);
    yehuda = users.objectAt(1);
    statesEqual([tom, yehuda], 'loaded.saved');
    enabledFlags(users, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([tom, yehuda], ['isLoaded'], recordArrayFlags);
    expect(users.get('length')).toEqual(2);
    expect(tom.get('fullName')).toEqual("Tom Dale");
    expect(yehuda.get('fullName')).toEqual("Yehuda Katz");
    expect(tom.get('id')).toEqual("1");
    return expect(yehuda.get('id')).toEqual("2");
  });
  it('creating a user makes a POST to /user/', function() {
    var user;
    user = store.createRecord(Vosae.User, {
      fullName: "Tom Dale",
      email: "tom.dale@vosae.com"
    });
    stateEquals(user, 'loaded.created.uncommitted');
    enabledFlags(user, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    user.get('transaction').commit();
    stateEquals(user, 'loaded.created.inFlight');
    enabledFlags(user, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/user/");
    expectAjaxType("POST");
    expectAjaxData($.extend({}, hashUser, {
      full_name: "Tom Dale",
      email: "tom.dale@vosae.com"
    }));
    ajaxHash.success($.extend({}, hashUser, {
      id: 1,
      full_name: "Tom Dale",
      email: "tom.dale@vosae.com",
      resource_uri: "/api/v1/user/1/"
    }));
    stateEquals(user, 'loaded.saved');
    enabledFlags(user, ['isLoaded', 'isValid']);
    return expect(user).toEqual(store.find(Vosae.User, 1));
  });
  it('updating a user makes a PUT to /user/:id/', function() {
    var user;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1,
      fullName: "Tom Dale",
      email: "tom.dale@vosae.com"
    });
    user = store.find(Vosae.User, 1);
    stateEquals(user, 'loaded.saved');
    enabledFlags(user, ['isLoaded', 'isValid']);
    user.setProperties({
      fullName: "Yehuda Katz",
      email: "yehuda.katz@vosae.com"
    });
    stateEquals(user, 'loaded.updated.uncommitted');
    enabledFlags(user, ['isLoaded', 'isDirty', 'isValid']);
    user.get('transaction').commit();
    stateEquals(user, 'loaded.updated.inFlight');
    enabledFlags(user, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/user/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, hashUser, {
      full_name: "Yehuda Katz",
      email: "yehuda.katz@vosae.com"
    }));
    ajaxHash.success($.extend({}, hashUser, {
      id: 1,
      full_name: "Yehuda Katz",
      email: "yehuda.katz@vosae.com"
    }));
    stateEquals(user, 'loaded.saved');
    enabledFlags(user, ['isLoaded', 'isValid']);
    expect(user).toEqual(store.find(Vosae.User, 1));
    return expect(user.get('fullName')).toEqual('Yehuda Katz');
  });
  it('deleting a user makes a DELETE to /user/:id/', function() {
    var user;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1,
      fullName: "Tom Dale"
    });
    user = store.find(Vosae.User, 1);
    stateEquals(user, 'loaded.saved');
    enabledFlags(user, ['isLoaded', 'isValid']);
    user.deleteRecord();
    stateEquals(user, 'deleted.uncommitted');
    enabledFlags(user, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']);
    user.get('transaction').commit();
    stateEquals(user, 'deleted.inFlight');
    enabledFlags(user, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']);
    expectAjaxURL("/user/1/");
    expectAjaxType("DELETE");
    ajaxHash.success();
    stateEquals(user, 'deleted.saved');
    return enabledFlags(user, ['isLoaded', 'isDeleted', 'isValid']);
  });
  it('groups hasMany relationship', function() {
    var group, user;
    store.adapterForType(Vosae.Group).load(store, Vosae.Group, {
      id: 1,
      name: 'Administrators'
    });
    group = store.find(Vosae.Group, 1);
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1,
      groups: ['/api/v1/group/1/']
    });
    user = store.find(Vosae.User, 1);
    return expect(user.get('groups').objectAt(0)).toEqual(group);
  });
  it('specificPermissions hasMany relationship', function() {
    var user;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1,
      specific_permissions: {
        'can_edit_contact': true
      }
    });
    user = store.find(Vosae.User, 1);
    expect(user.get('specificPermissions').objectAt(0).get('name')).toEqual('can_edit_contact');
    return expect(user.get('specificPermissions').objectAt(0).get('value')).toEqual(true);
  });
  it('settings belongsTo relationship', function() {
    var user;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1,
      settings: {
        language_code: "fr"
      }
    });
    user = store.find(Vosae.User, 1);
    return expect(user.get('settings.languageCode')).toEqual('fr');
  });
  it('permissions property should be empty when creating user', function() {
    var user;
    user = store.createRecord(Vosae.User);
    return expect(user.get('permissions')).toEqual([]);
  });
  it('permissionsContains() method should return false if user hasnt perm', function() {
    var user;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1,
      permissions: ['can_edit_contact']
    });
    user = store.find(Vosae.User, 1);
    expect(user.permissionsContains('can_edit_contact')).toEqual(true);
    return expect(user.permissionsContains('can_edit_organization')).toEqual(false);
  });
  it('specificPermissionsContains() method should return false if user hasnt perm', function() {
    var specificPerm, specificPerm2, user;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1,
      specific_permissions: {
        'can_edit_contact': true
      }
    });
    user = store.find(Vosae.User, 1);
    specificPerm = user.specificPermissionsContains('can_edit_contact');
    specificPerm2 = user.specificPermissionsContains('can_edit_organization');
    expect(specificPerm.get('name')).toEqual('can_edit_contact');
    expect(specificPerm.get('value')).toEqual(true);
    return expect(specificPerm2).toEqual(false);
  });
  it('mergeGroupsPermissions() should merge groups permissions into user permissions', function() {
    var group1, group2, user;
    store.adapterForType(Vosae.Group).load(store, Vosae.Group, {
      id: 1,
      permissions: ['can_edit_contact', 'can_add_quotation']
    });
    store.adapterForType(Vosae.Group).load(store, Vosae.Group, {
      id: 2,
      permissions: ['can_edit_organization', 'can_edit_contact']
    });
    group1 = store.find(Vosae.Group, 1);
    group2 = store.find(Vosae.Group, 2);
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1,
      groups: ['/api/v1/group/1/', '/api/v1/group/2/']
    });
    user = store.find(Vosae.User, 1);
    user.mergeGroupsPermissions();
    expect(user.get('permissions').get('length')).toEqual(3);
    expect(user.permissionsContains('can_edit_contact')).toEqual(true);
    expect(user.permissionsContains('can_edit_organization')).toEqual(true);
    return expect(user.permissionsContains('can_add_quotation')).toEqual(true);
  });
  it('getStatus computed property should return user\'s status', function() {
    var user;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1,
      status: 'ACTIVE'
    });
    user = store.find(Vosae.User, 1);
    expect(user.get('getStatus')).toEqual('Active');
    user.set('status', 'SOMETHINGWRONG');
    return expect(user.get('getStatus')).toEqual('Unknown');
  });
  return it('getFullName computed property should return user\'s full name', function() {
    var user;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1,
      full_name: 'Tom Dale'
    });
    user = store.find(Vosae.User, 1);
    expect(user.get('getFullName')).toEqual('Tom Dale');
    user.set('fullName', '');
    return expect(user.get('getFullName')).toEqual('To define');
  });
});

var store;

store = null;

describe('Vosae.UserSettings', function() {
  beforeEach(function() {
    return store = Vosae.Store.create();
  });
  return afterEach(function() {
    return store.destroy();
  });
});

var store;

store = null;

describe('Vosae.CreditNote', function() {
  var hashCreditNote;
  hashCreditNote = {
    account_type: null,
    amount: null,
    attachments: [],
    current_revision: null,
    notes: [],
    reference: null,
    state: null,
    total: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.CreditNote);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all creditNote makes a GET to /credit_note/', function() {
    var creditNote, creditNotes;
    creditNotes = store.find(Vosae.CreditNote);
    enabledFlags(creditNotes, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/credit_note/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashCreditNote, {
          id: 1
        })
      ]
    });
    creditNote = creditNotes.objectAt(0);
    statesEqual(creditNotes, 'loaded.saved');
    stateEquals(creditNote, 'loaded.saved');
    enabledFlagsForArray(creditNotes, ['isLoaded', 'isValid']);
    enabledFlags(creditNote, ['isLoaded', 'isValid']);
    return expect(creditNote).toEqual(store.find(Vosae.CreditNote, 1));
  });
  it('finding a creditNote by ID makes a GET to /credit_note/:id/', function() {
    var creditNote;
    creditNote = store.find(Vosae.CreditNote, 1);
    stateEquals(creditNote, 'loading');
    enabledFlags(creditNote, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/credit_note/1/");
    ajaxHash.success($.extend({}, hashCreditNote, {
      id: 1,
      resource_uri: "/api/v1/credit_note/1/"
    }));
    stateEquals(creditNote, 'loaded.saved');
    enabledFlags(creditNote, ['isLoaded', 'isValid']);
    return expect(creditNote).toEqual(store.find(Vosae.CreditNote, 1));
  });
  it('finding creditNotes by query makes a GET to /credit_note/:query/', function() {
    var creditNote1, creditNote2, creditNotes;
    creditNotes = store.find(Vosae.CreditNote, {
      state: "DRAFT"
    });
    expect(creditNotes.get('length')).toEqual(0);
    enabledFlags(creditNotes, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/credit_note/");
    expectAjaxType("GET");
    expectAjaxData({
      state: "DRAFT"
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashCreditNote, {
          id: 1,
          state: "DRAFT"
        }), $.extend({}, hashCreditNote, {
          id: 2,
          state: "DRAFT"
        })
      ]
    });
    creditNote1 = creditNotes.objectAt(0);
    creditNote2 = creditNotes.objectAt(1);
    statesEqual([creditNote1, creditNote2], 'loaded.saved');
    enabledFlags(creditNotes, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([creditNote1, creditNote2], ['isLoaded'], recordArrayFlags);
    expect(creditNotes.get('length')).toEqual(2);
    expect(creditNote1.get('state')).toEqual("DRAFT");
    expect(creditNote2.get('state')).toEqual("DRAFT");
    expect(creditNote1.get('id')).toEqual("1");
    return expect(creditNote2.get('id')).toEqual("2");
  });
  it('relatedColor property should return green', function() {
    var creditNote;
    store.adapterForType(Vosae.CreditNote).load(store, Vosae.CreditNote, {
      id: 1
    });
    creditNote = store.find(Vosae.CreditNote, 1);
    return expect(creditNote.get('relatedColor')).toEqual("green");
  });
  it('isInvoice property should return false', function() {
    var creditNote;
    store.adapterForType(Vosae.CreditNote).load(store, Vosae.CreditNote, {
      id: 1
    });
    creditNote = store.find(Vosae.CreditNote, 1);
    return expect(creditNote.get('isInvoice')).toBeFalsy();
  });
  it('isQuotation property should return false', function() {
    var creditNote;
    store.adapterForType(Vosae.CreditNote).load(store, Vosae.CreditNote, {
      id: 1
    });
    creditNote = store.find(Vosae.CreditNote, 1);
    return expect(creditNote.get('isQuotation')).toBeFalsy();
  });
  it('isCreditNote property should return true', function() {
    var creditNote;
    store.adapterForType(Vosae.CreditNote).load(store, Vosae.CreditNote, {
      id: 1
    });
    creditNote = store.find(Vosae.CreditNote, 1);
    return expect(creditNote.get('isCreditNote')).toBeTruthy;
  });
  it('isPurchaseOrder property should return true', function() {
    var creditNote;
    store.adapterForType(Vosae.CreditNote).load(store, Vosae.CreditNote, {
      id: 1
    });
    creditNote = store.find(Vosae.CreditNote, 1);
    return expect(creditNote.get('isPurchaseOrder')).toBeTruthy;
  });
  it('group belongsTo relationship', function() {
    var creditNote, invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    store.adapterForType(Vosae.CreditNote).load(store, Vosae.CreditNote, {
      id: 1,
      related_invoice: "/api/v1/invoice/1/"
    });
    creditNote = store.find(Vosae.CreditNote, 1);
    return expect(creditNote.get('relatedInvoice')).toEqual(invoice);
  });
  it('relatedInvoice belongsTo relationship', function() {
    var creditNote, invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    store.adapterForType(Vosae.CreditNote).load(store, Vosae.CreditNote, {
      id: 1,
      related_invoice: "/api/v1/invoice/1/"
    });
    creditNote = store.find(Vosae.CreditNote, 1);
    return expect(creditNote.get('relatedInvoice')).toEqual(invoice);
  });
  return it('relatedDownPaymentInvoice belongsTo relationship', function() {
    var creditNote, downPaymentInvoice;
    store.adapterForType(Vosae.DownPaymentInvoice).load(store, Vosae.DownPaymentInvoice, {
      id: 1
    });
    downPaymentInvoice = store.find(Vosae.DownPaymentInvoice, 1);
    store.adapterForType(Vosae.CreditNote).load(store, Vosae.CreditNote, {
      id: 1,
      related_down_payment_invoice: "/api/v1/down_payment_invoice/1/"
    });
    creditNote = store.find(Vosae.CreditNote, 1);
    return expect(creditNote.get('relatedDownPaymentInvoice')).toEqual(downPaymentInvoice);
  });
});

var store;

store = null;

describe('Vosae.Currency', function() {
  var hashCurrency;
  hashCurrency = {
    symbol: null,
    rates: [],
    resource_uri: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Currency);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all currency makes a GET to /currency/', function() {
    var currencies, currency;
    currencies = store.find(Vosae.Currency);
    enabledFlags(currencies, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/currency/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashCurrency, {
          id: 1,
          symbol: "EUR"
        })
      ]
    });
    currency = currencies.objectAt(0);
    statesEqual(currencies, 'loaded.saved');
    stateEquals(currency, 'loaded.saved');
    enabledFlagsForArray(currencies, ['isLoaded', 'isValid']);
    enabledFlags(currency, ['isLoaded', 'isValid']);
    return expect(currency).toEqual(store.find(Vosae.Currency, 1));
  });
  it('finding a currency by ID makes a GET to /currency/:id/', function() {
    var currency;
    currency = store.find(Vosae.Currency, 1);
    stateEquals(currency, 'loading');
    enabledFlags(currency, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/currency/1/");
    ajaxHash.success($.extend({}, hashCurrency, {
      id: 1,
      symbol: "EUR",
      rates: [],
      resource_uri: "/api/v1/currency/1/"
    }));
    stateEquals(currency, 'loaded.saved');
    enabledFlags(currency, ['isLoaded', 'isValid']);
    return expect(currency).toEqual(store.find(Vosae.Currency, 1));
  });
  it('finding currencies by query makes a GET to /currency/:query/', function() {
    var currencies, eur, usd;
    currencies = store.find(Vosae.Currency, {
      page: 1
    });
    expect(currencies.get('length')).toEqual(0);
    enabledFlags(currencies, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/currency/");
    expectAjaxType("GET");
    expectAjaxData({
      page: 1
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashCurrency, {
          id: 1,
          symbol: "EUR",
          resource_uri: "/api/v1/currency/1/"
        }), $.extend({}, hashCurrency, {
          id: 2,
          symbol: "USD",
          resource_uri: "/api/v1/currency/2/"
        })
      ]
    });
    eur = currencies.objectAt(0);
    usd = currencies.objectAt(1);
    statesEqual([eur, usd], 'loaded.saved');
    enabledFlags(currencies, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([eur, usd], ['isLoaded'], recordArrayFlags);
    expect(currencies.get('length')).toEqual(2);
    expect(eur.get('symbol')).toEqual("EUR");
    expect(usd.get('symbol')).toEqual("USD");
    expect(eur.get('id')).toEqual("1");
    return expect(usd.get('id')).toEqual("2");
  });
  it('description property should return the currency\'s description', function() {
    var currency;
    store.load(Vosae.Currency, {
      id: 1,
      symbol: "SOMETHINGSHITTY"
    });
    currency = store.find(Vosae.Currency, 1);
    expect(currency.get('description')).toEqual('');
    currency.set('symbol', 'EUR');
    return expect(currency.get('description')).toEqual('Euro');
  });
  it('displaySign property should return the currency\'s sign', function() {
    var currency;
    store.load(Vosae.Currency, {
      id: 1,
      symbol: ""
    });
    currency = store.find(Vosae.Currency, 1);
    expect(currency.get('displaySign')).toEqual('');
    currency.set('symbol', 'EUR');
    return expect(currency.get('displaySign')).toEqual('€');
  });
  it('displaySignWithSymbol property should return the currency\'s sign with symbol', function() {
    var currency;
    store.load(Vosae.Currency, {
      id: 1,
      symbol: ""
    });
    currency = store.find(Vosae.Currency, 1);
    expect(currency.get('displaySignWithSymbol')).toEqual('');
    currency.set('symbol', 'EUR');
    return expect(currency.get('displaySignWithSymbol')).toEqual('€ - EUR');
  });
  it('exchangeRateFor() should return the exchangeRate associated to the specified symbol', function() {
    var currency, rateUSD;
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1,
      symbol: "EUR",
      rates: [
        {
          currency_to: "USD",
          datetime: "2013-07-23T12:01:00+00:00",
          rate: "1.32"
        }, {
          currency_to: "JPY",
          datetime: "2013-07-23T12:01:00+00:00",
          rate: "0.3"
        }
      ]
    });
    currency = store.find(Vosae.Currency, 1);
    rateUSD = currency.get('rates').objectAt(0);
    return expect(currency.exchangeRateFor('USD')).toEqual(rateUSD);
  });
  it('toCurrency() method should convert an amount from a currency to another, based on the rates', function() {
    var currency;
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1,
      symbol: "EUR",
      rates: [
        {
          currency_to: "USD",
          datetime: "2013-07-23T12:01:00+00:00",
          rate: "1.32"
        }
      ]
    });
    currency = store.find(Vosae.Currency, 1);
    return expect(currency.toCurrency('USD', 10).round(2)).toEqual(13.2);
  });
  return it('fromCurrency() method should convert an amount from a currency to another, based on the rates', function() {
    var currency;
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1,
      symbol: "EUR",
      rates: [
        {
          currency_to: "USD",
          datetime: "2013-07-23T12:01:00+00:00",
          rate: "1.32"
        }
      ]
    });
    currency = store.find(Vosae.Currency, 1);
    return expect(currency.fromCurrency('USD', 132)).toEqual(100);
  });
});

var store;

store = null;

describe('Vosae.Invoice', function() {
  var expectedPostData, hashInvoice;
  hashInvoice = {
    account_type: null,
    amount: null,
    attachments: [],
    balance: null,
    current_revision: null,
    has_temporary_reference: true,
    notes: [],
    paid: null,
    payments: [],
    reference: null,
    state: null,
    total: null
  };
  expectedPostData = {
    "state": null,
    "paid": null,
    "balance": null,
    "has_temporary_reference": true,
    "reference": null,
    "account_type": "RECEIVABLE",
    "total": null,
    "amount": null,
    "payments": [],
    "notes": [],
    "attachments": [],
    "current_revision": {
      "invoicing_date": "2013-07-26",
      "custom_payment_conditions": null,
      "revision": null,
      "state": null,
      "sender": "Tom Dale",
      "customer_reference": null,
      "taxes_application": null,
      "line_items": [
        {
          "reference": "Siteweb",
          "description": "My site web",
          "item_id": "1",
          "quantity": 1,
          "unit_price": 100,
          "tax": "/api/v1/tax/1/"
        }
      ],
      "pdf": null,
      "organization": "/api/v1/organization/1/",
      "contact": "/api/v1/contact/1/",
      "sender_address": {
        "type": "WORK",
        "postoffice_box": "a",
        "street_address": "b",
        "extended_address": "c",
        "postal_code": "d",
        "city": "e",
        "state": "f",
        "country": "g"
      },
      "billing_address": {
        "type": "WORK",
        "postoffice_box": "aa",
        "street_address": "bb",
        "extended_address": "cc",
        "postal_code": "dd",
        "city": "ee",
        "state": "ff",
        "country": "gg"
      },
      "delivery_address": {
        "type": "WORK",
        "postoffice_box": "aaa",
        "street_address": "bbb",
        "extended_address": "ccc",
        "postal_code": "ddd",
        "city": "eee",
        "state": "fff",
        "country": "ggg"
      },
      "currency": {
        "symbol": "EUR",
        "resource_uri": null,
        "rates": [
          {
            "currency_to": "GBP",
            "rate": 0.86
          }, {
            "currency_to": "USD",
            "rate": 1.33
          }
        ]
      }
    }
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Invoice);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all invoice makes a GET to /invoice/', function() {
    var invoice, invoices;
    invoices = store.find(Vosae.Invoice);
    enabledFlags(invoices, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/invoice/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashInvoice, {
          id: 1
        })
      ]
    });
    invoice = invoices.objectAt(0);
    statesEqual(invoices, 'loaded.saved');
    stateEquals(invoice, 'loaded.saved');
    enabledFlagsForArray(invoices, ['isLoaded', 'isValid']);
    enabledFlags(invoice, ['isLoaded', 'isValid']);
    return expect(invoice).toEqual(store.find(Vosae.Invoice, 1));
  });
  it('finding a invoice by ID makes a GET to /invoice/:id/', function() {
    var invoice;
    invoice = store.find(Vosae.Invoice, 1);
    stateEquals(invoice, 'loading');
    enabledFlags(invoice, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/invoice/1/");
    ajaxHash.success($.extend({}, hashInvoice, {
      id: 1,
      resource_uri: "/api/v1/invoice/1/"
    }));
    stateEquals(invoice, 'loaded.saved');
    enabledFlags(invoice, ['isLoaded', 'isValid']);
    return expect(invoice).toEqual(store.find(Vosae.Invoice, 1));
  });
  it('finding invoices by query makes a GET to /invoice/:query/', function() {
    var invoice1, invoice2, invoices;
    invoices = store.find(Vosae.Invoice, {
      state: "DRAFT"
    });
    expect(invoices.get('length')).toEqual(0);
    enabledFlags(invoices, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/invoice/");
    expectAjaxType("GET");
    expectAjaxData({
      state: "DRAFT"
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashInvoice, {
          id: 1,
          state: "DRAFT"
        }), $.extend({}, hashInvoice, {
          id: 2,
          state: "DRAFT"
        })
      ]
    });
    invoice1 = invoices.objectAt(0);
    invoice2 = invoices.objectAt(1);
    statesEqual([invoice1, invoice2], 'loaded.saved');
    enabledFlags(invoices, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([invoice1, invoice2], ['isLoaded'], recordArrayFlags);
    expect(invoices.get('length')).toEqual(2);
    expect(invoice1.get('state')).toEqual("DRAFT");
    expect(invoice2.get('state')).toEqual("DRAFT");
    expect(invoice1.get('id')).toEqual("1");
    return expect(invoice2.get('id')).toEqual("2");
  });
  it('creating a invoice makes a POST to /invoice/', function() {
    var billingAddress, contact, currency, currentRevision, deliveryAddress, invoice, lineItem, organization, rate1, rate2, senderAddress, tax, unusedTransaction;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1
    });
    store.adapterForType(Vosae.Organization).load(store, Vosae.Organization, {
      id: 1
    });
    store.adapterForType(Vosae.Contact).load(store, Vosae.Contact, {
      id: 1
    });
    tax = store.find(Vosae.Tax, 1);
    contact = store.find(Vosae.Contact, 1);
    organization = store.find(Vosae.Organization, 1);
    unusedTransaction = store.transaction();
    currentRevision = unusedTransaction.createRecord(Vosae.InvoiceRevision);
    currency = unusedTransaction.createRecord(Vosae.Currency);
    billingAddress = unusedTransaction.createRecord(Vosae.Address);
    deliveryAddress = unusedTransaction.createRecord(Vosae.Address);
    senderAddress = unusedTransaction.createRecord(Vosae.Address);
    rate1 = unusedTransaction.createRecord(Vosae.ExchangeRate);
    rate2 = unusedTransaction.createRecord(Vosae.ExchangeRate);
    rate1.setProperties({
      "currencyTo": "GBP",
      "rate": 0.86
    });
    rate2.setProperties({
      "currencyTo": "USD",
      "rate": 1.33
    });
    currency.get('rates').addObject(rate1);
    currency.get('rates').addObject(rate2);
    currency.setProperties({
      "symbol": "EUR"
    });
    senderAddress.setProperties({
      "postofficeBox": "a",
      "streetAddress": "b",
      "extendedAddress": "c",
      "postalCode": "d",
      "city": "e",
      "state": "f",
      "country": "g"
    });
    billingAddress.setProperties({
      "postofficeBox": "aa",
      "streetAddress": "bb",
      "extendedAddress": "cc",
      "postalCode": "dd",
      "city": "ee",
      "state": "ff",
      "country": "gg"
    });
    deliveryAddress.setProperties({
      "postofficeBox": "aaa",
      "streetAddress": "bbb",
      "extendedAddress": "ccc",
      "postalCode": "ddd",
      "city": "eee",
      "state": "fff",
      "country": "ggg"
    });
    lineItem = currentRevision.get('lineItems').createRecord();
    lineItem.setProperties({
      "ref": "Siteweb",
      "description": "My site web",
      "itemId": "1",
      "quantity": 1,
      "unitPrice": 100,
      "tax": tax
    });
    currentRevision.setProperties({
      'invoicingDate': new Date(2013, 6, 26),
      'sender': "Tom Dale",
      'currency': currency,
      'organization': organization,
      'contact': contact,
      'billingAddress': billingAddress,
      'deliveryAddress': deliveryAddress,
      'senderAddress': senderAddress
    });
    invoice = store.createRecord(Vosae.Invoice, {});
    invoice.setProperties({
      "accountType": "RECEIVABLE",
      "currentRevision": currentRevision
    });
    stateEquals(invoice, 'loaded.created.uncommitted');
    enabledFlags(invoice, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    invoice.get('transaction').commit();
    stateEquals(invoice, 'loaded.created.inFlight');
    enabledFlags(invoice, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/invoice/");
    expectAjaxType("POST");
    expectAjaxData(expectedPostData);
    ajaxHash.success($.extend({}, expectedPostData, {
      id: 1,
      state: "DRAFT",
      resource_uri: "/api/v1/invoice/1/"
    }));
    stateEquals(invoice, 'loaded.saved');
    enabledFlags(invoice, ['isLoaded', 'isValid']);
    return expect(invoice).toEqual(store.find(Vosae.Invoice, 1));
  });
  it('updating a invoice makes a PUT to /invoice/:id/', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, $.extend({}, expectedPostData, {
      id: 1,
      state: "DRAFT"
    }));
    invoice = store.find(Vosae.Invoice, 1);
    stateEquals(invoice, 'loaded.saved');
    enabledFlags(invoice, ['isLoaded', 'isValid']);
    invoice.setProperties({
      state: "REGISTERED"
    });
    stateEquals(invoice, 'loaded.updated.uncommitted');
    enabledFlags(invoice, ['isLoaded', 'isDirty', 'isValid']);
    invoice.get('transaction').commit();
    stateEquals(invoice, 'loaded.updated.inFlight');
    enabledFlags(invoice, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/invoice/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, expectedPostData, {
      state: "REGISTERED"
    }));
    ajaxHash.success($.extend({}, expectedPostData, {
      id: 1,
      state: "REGISTERED"
    }));
    stateEquals(invoice, 'loaded.saved');
    enabledFlags(invoice, ['isLoaded', 'isValid']);
    expect(invoice).toEqual(store.find(Vosae.Invoice, 1));
    return expect(invoice.get('state')).toEqual('REGISTERED');
  });
  it('deleting an invoice makes a DELETE to /invoice/:id/', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      state: "DRAFT"
    });
    invoice = store.find(Vosae.Invoice, 1);
    stateEquals(invoice, 'loaded.saved');
    enabledFlags(invoice, ['isLoaded', 'isValid']);
    invoice.deleteRecord();
    stateEquals(invoice, 'deleted.uncommitted');
    enabledFlags(invoice, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']);
    invoice.get('transaction').commit();
    stateEquals(invoice, 'deleted.inFlight');
    enabledFlags(invoice, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']);
    expectAjaxURL("/invoice/1/");
    expectAjaxType("DELETE");
    ajaxHash.success();
    stateEquals(invoice, 'deleted.saved');
    return enabledFlags(invoice, ['isLoaded', 'isDeleted', 'isValid']);
  });
  it('notes hasMany relationship', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      notes: [
        {
          note: "My note"
        }
      ]
    });
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('notes.firstObject.note')).toEqual("My note");
  });
  it('can add note', function() {
    var invoice, note, note2;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    note = invoice.get('notes').createRecord();
    note2 = invoice.get('notes').createRecord();
    expect(invoice.get('notes.length')).toEqual(2);
    expect(invoice.get('notes').objectAt(0)).toEqual(note);
    return expect(invoice.get('notes').objectAt(1)).toEqual(note2);
  });
  it('can delete note', function() {
    var invoice, note, note2;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    note = invoice.get('notes').createRecord();
    note2 = invoice.get('notes').createRecord();
    expect(invoice.get('notes.length')).toEqual(2);
    invoice.get('notes').removeObject(note);
    invoice.get('notes').removeObject(note2);
    return expect(invoice.get('notes.length')).toEqual(0);
  });
  it('attachments hasMany relationship', function() {
    var file, invoice;
    store.adapterForType(Vosae.File).load(store, Vosae.File, {
      id: 1
    });
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      attachments: ["/api/v1/file/1/"]
    });
    file = store.find(Vosae.File, 1);
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('attachments.firstObject')).toEqual(file);
  });
  it('can add attachment', function() {
    var attachment, attachment2, invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    attachment = invoice.get('attachments').createRecord();
    attachment2 = invoice.get('attachments').createRecord();
    expect(invoice.get('attachments.length')).toEqual(2);
    expect(invoice.get('attachments').objectAt(0)).toEqual(attachment);
    return expect(invoice.get('attachments').objectAt(1)).toEqual(attachment2);
  });
  it('can delete attachment', function() {
    var attachment, attachment2, invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    attachment = invoice.get('attachments').createRecord();
    attachment2 = invoice.get('attachments').createRecord();
    expect(invoice.get('attachments.length')).toEqual(2);
    invoice.get('attachments').removeObject(attachment);
    invoice.get('attachments').removeObject(attachment2);
    return expect(invoice.get('attachments.length')).toEqual(0);
  });
  it('payments hasMany relationship', function() {
    var invoice, payment;
    store.adapterForType(Vosae.Payment).load(store, Vosae.Payment, {
      id: 1
    });
    payment = store.find(Vosae.Payment, 1);
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      payments: ["/api/v1/payment/1/"]
    });
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('payments.firstObject')).toEqual(payment);
  });
  it('can add payment', function() {
    var invoice, payment, payment2;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    payment = invoice.get('payments').createRecord();
    payment2 = invoice.get('payments').createRecord();
    expect(invoice.get('payments.length')).toEqual(2);
    expect(invoice.get('payments').objectAt(0)).toEqual(payment);
    return expect(invoice.get('payments').objectAt(1)).toEqual(payment2);
  });
  it('can delete payment', function() {
    var invoice, payment, payment2;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    payment = invoice.get('payments').createRecord();
    payment2 = invoice.get('payments').createRecord();
    expect(invoice.get('payments.length')).toEqual(2);
    invoice.get('payments').removeObject(payment);
    invoice.get('payments').removeObject(payment2);
    return expect(invoice.get('payments.length')).toEqual(0);
  });
  it('issuer belongsTo relationship', function() {
    var invoice, issuer;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1
    });
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      issuer: "/api/v1/user/1/"
    });
    issuer = store.find(Vosae.User, 1);
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('issuer')).toEqual(issuer);
  });
  it('organization belongsTo relationship', function() {
    var invoice, organization;
    store.adapterForType(Vosae.Organization).load(store, Vosae.Organization, {
      id: 1
    });
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      organization: "/api/v1/organization/1/"
    });
    organization = store.find(Vosae.Organization, 1);
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('organization')).toEqual(organization);
  });
  it('contact belongsTo relationship', function() {
    var contact, invoice;
    store.adapterForType(Vosae.Contact).load(store, Vosae.Contact, {
      id: 1
    });
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      contact: "/api/v1/contact/1/"
    });
    contact = store.find(Vosae.Contact, 1);
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('contact')).toEqual(contact);
  });
  it('invoiceRevision belongsTo relationship', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      current_revision: {
        state: "DRAFT"
      }
    });
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('currentRevision.state')).toEqual("DRAFT");
  });
  it('relatedQuotation belongsTo relationship', function() {
    var invoice, quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      related_quotation: "/api/v1/quotation/1/"
    });
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('relatedQuotation')).toEqual(quotation);
  });
  it('relatedPurchaseOrder belongsTo relationship', function() {
    var invoice, purchaseOrder;
    store.adapterForType(Vosae.PurchaseOrder).load(store, Vosae.PurchaseOrder, {
      id: 1
    });
    purchaseOrder = store.find(Vosae.PurchaseOrder, 1);
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      related_purchase_order: "/api/v1/purchaseOrder/1/"
    });
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('relatedPurchaseOrder')).toEqual(purchaseOrder);
  });
  it('isUpdatingState property should be false by default', function() {
    var invoice;
    invoice = store.createRecord(Vosae.Invoice, {});
    return expect(invoice.get('isUpdatingState')).toEqual(false);
  });
  it('isGeneratingPdfState property should be false by default', function() {
    var invoice;
    invoice = store.createRecord(Vosae.Invoice, {});
    return expect(invoice.get('isGeneratingPdfState')).toEqual(false);
  });
  it('relatedColor property should return green', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('relatedColor')).toEqual("green");
  });
  it('isInvoice property should return false', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('isInvoice')).toBeTruthy();
  });
  it('isQuotation property should return false', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('isQuotation')).toBeFalsy();
  });
  it('isCreditNote property should return true', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('isCreditNote')).toBeFalsy();
  });
  it('isPurchaseOrder property should return true', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    return expect(invoice.get('isPurchaseOrder')).toBeFalsy();
  });
  it('displayState property should return the acutal state formated', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    return Vosae.invoiceStatesChoices.forEach(function(state) {
      invoice.set('state', state.get('value'));
      return expect(invoice.get('displayState')).toBeTruthy();
    });
  });
  it('canAddPayment property should return true if payment could be added to the invoice', function() {
    var invoice, payment;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      state: "REGISTERED"
    });
    invoice = store.find(Vosae.Invoice, 1);
    expect(invoice.get('canAddPayment')).toEqual(false);
    invoice.set('balance', 0);
    expect(invoice.get('canAddPayment')).toEqual(false);
    invoice.set('balance', 1000);
    expect(invoice.get('canAddPayment')).toEqual(true);
    payment = invoice.get('payments').createRecord();
    return expect(invoice.get('canAddPayment')).toEqual(false);
  });
  it('isPayableOrPaid property return true if invoice is payable or paid', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    expect(invoice.get('isPayableOrPaid')).toEqual(false);
    return Vosae.invoiceStatesChoices.forEach(function(state) {
      invoice.set('state', state.get('value'));
      if (["REGISTERED", "OVERDUE", "PART_PAID", "PAID"].contains(state.get('value'))) {
        return expect(invoice.get('isPayableOrPaid')).toBeTruthy();
      } else {
        return expect(invoice.get('isPayableOrPaid')).toBeFalsy();
      }
    });
  });
  it('availableStates return an array with the available states based on the current state', function() {
    var availableStates, invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    availableStates = invoice.get('availableStates');
    expect(availableStates).toEqual([]);
    invoice.set("state", "DRAFT");
    availableStates = invoice.get('availableStates');
    expect(availableStates.get('length')).toEqual(1);
    expect(availableStates.getEach('value')).toContain("REGISTERED");
    invoice.set("state", "REGISTERED");
    availableStates = invoice.get('availableStates');
    expect(availableStates.get('length')).toEqual(1);
    expect(availableStates.getEach('value')).toContain("CANCELLED");
    invoice.set("state", "OVERDUE");
    availableStates = invoice.get('availableStates');
    expect(availableStates.get('length')).toEqual(1);
    expect(availableStates.getEach('value')).toContain("CANCELLED");
    invoice.set("state", "PART_PAID");
    availableStates = invoice.get('availableStates');
    expect(availableStates.get('length')).toEqual(1);
    expect(availableStates.getEach('value')).toContain("CANCELLED");
    invoice.set("state", "PAID");
    availableStates = invoice.get('availableStates');
    expect(availableStates.get('length')).toEqual(1);
    return expect(availableStates.getEach('value')).toContain("CANCELLED");
  });
  it('isModifiable property return true if invoice can be edited', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    expect(invoice.get('isModifiable')).toBeFalsy();
    return Vosae.invoiceStatesChoices.forEach(function(state) {
      invoice.set('state', state.get('value'));
      if (state.get('value') === 'DRAFT') {
        return expect(invoice.get('isModifiable')).toBeTruthy();
      } else {
        return expect(invoice.get('isModifiable')).toBeFalsy();
      }
    });
  });
  it('isDeletable property return true if invoice can be deleted', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    expect(invoice.get('isModifiable')).toBeFalsy();
    expect(invoice.get('isDeletable')).toBeFalsy();
    invoice.set('state', 'DRAFT');
    expect(invoice.get('isModifiable')).toBeTruthy();
    return expect(invoice.get('isDeletable')).toBeTruthy();
  });
  it('isCancelable property return true if invoice is in a cancelable state', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    expect(invoice.get('isCancelable')).toBeFalsy();
    return Vosae.invoiceStatesChoices.forEach(function(state) {
      invoice.set('state', state.get('value'));
      if (["REGISTERED", "OVERDUE", "PART_PAID", "PAID"].contains(state.get('value'))) {
        return expect(invoice.get('isCancelable')).toBeTruthy();
      } else {
        return expect(invoice.get('isCancelable')).toBeFalsy();
      }
    });
  });
  it('isPayable property return true if invoice is in a payable state', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    expect(invoice.get('isPayable')).toBeFalsy();
    return Vosae.invoiceStatesChoices.forEach(function(state) {
      invoice.set('state', state.get('value'));
      if (["REGISTERED", "OVERDUE", "PART_PAID"].contains(state.get('value'))) {
        return expect(invoice.get('isPayable')).toBeTruthy();
      } else {
        return expect(invoice.get('isPayable')).toBeFalsy();
      }
    });
  });
  it('isPaid property return true if invoice is paid', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    expect(invoice.get('isPaid')).toBeFalsy();
    return Vosae.invoiceStatesChoices.forEach(function(state) {
      invoice.set('state', state.get('value'));
      if (state.get('value') === 'PAID') {
        return expect(invoice.get('isPaid')).toBeTruthy();
      } else {
        return expect(invoice.get('isPaid')).toBeFalsy();
      }
    });
  });
  it('isDraft property return true if invoice is draft', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    expect(invoice.get('isDraft')).toBeFalsy();
    return Vosae.invoiceStatesChoices.forEach(function(state) {
      invoice.set('state', state.get('value'));
      if (state.get('value') === 'DRAFT') {
        return expect(invoice.get('isDraft')).toBeTruthy();
      } else {
        return expect(invoice.get('isDraft')).toBeFalsy();
      }
    });
  });
  it('isCancelled property return true if invoice has been cancelled', function() {
    var invoice;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    expect(invoice.get('isCancelled')).toBeFalsy();
    return Vosae.invoiceStatesChoices.forEach(function(state) {
      invoice.set('state', state.get('value'));
      if (state.get('value') === 'CANCELLED') {
        return expect(invoice.get('isCancelled')).toBeTruthy();
      } else {
        return expect(invoice.get('isCancelled')).toBeFalsy();
      }
    });
  });
  it('isInvoicable property return true if invoice is invoicable', function() {
    var invoice;
    store.adapterForType(Vosae.Contact).load(store, Vosae.Contact, {
      id: 1
    });
    store.adapterForType(Vosae.Organization).load(store, Vosae.Organization, {
      id: 1
    });
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1
    });
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    invoice = store.find(Vosae.Invoice, 1);
    invoice.setProperties({
      'state': 'DRAFT',
      'contact': store.find(Vosae.Contact, 1),
      'organization': store.find(Vosae.Organization, 1),
      'currentRevision': store.find(Vosae.InvoiceRevision, 1),
      'currentRevision.invoicingDate': new Date(),
      'currentRevision.dueDate': new Date(),
      'currentRevision.customPaymentConditions': 'CASH'
    });
    invoice.get('currentRevision.lineItems').createRecord();
    expect(invoice.get('isInvoicable')).toBeTruthy();
    invoice.set('state', 'REGISTERED');
    expect(invoice.get('isInvoicable')).toBeFalsy();
    invoice.set('state', 'DRAFT');
    invoice.set('contact', null);
    expect(invoice.get('isInvoicable')).toBeTruthy();
    invoice.set('organization', null);
    expect(invoice.get('isInvoicable')).toBeFalsy();
    invoice.set('contact', store.find(Vosae.Contact, 1));
    invoice.set('organization', store.find(Vosae.Organization, 1));
    invoice.set('currentRevision.invoicingDate', null);
    expect(invoice.get('isInvoicable')).toBeFalsy();
    invoice.set('currentRevision.invoicingDate', new Date());
    expect(invoice.get('isInvoicable')).toBeTruthy();
    invoice.set('currentRevision.dueDate', null);
    expect(invoice.get('isInvoicable')).toBeTruthy();
    invoice.set('currentRevision.customPaymentConditions', null);
    expect(invoice.get('isInvoicable')).toBeFalsy();
    invoice.set('currentRevision.dueDate', new Date());
    invoice.set('currentRevision.customPaymentConditions', 'CASH');
    expect(invoice.get('isInvoicable')).toBeTruthy();
    invoice.get('currentRevision.lineItems').removeObject(invoice.get('currentRevision.lineItems').objectAt(0));
    return expect(invoice.get('isInvoicable')).toBeFalsy();
  });
  return it('invoiceCancel() method should cancel the Invoice', function() {
    var controller, invoice;
    store.adapterForType(Vosae.CreditNote).load(store, Vosae.CreditNote, {
      id: 1
    });
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      state: 'REGISTERED'
    });
    invoice = store.find(Vosae.Invoice, 1);
    controller = Vosae.lookup("controller:invoice.edit");
    controller.transitionToRoute = function() {};
    invoice.invoiceCancel(controller);
    expect(invoice.get('isCancelling')).toEqual(true);
    expectAjaxURL("/invoice/1/cancel/");
    expectAjaxType("PUT");
    ajaxHash.success({
      credit_note_uri: "/api/v1/credit_note/1/"
    });
    expectAjaxType("GET");
    expectAjaxURL("/invoice/1/");
    ajaxHash.success({
      state: "CANCELLED"
    });
    return expect(invoice.get('isCancelling')).toEqual(false);
  });
});

var store;

store = null;

describe('Vosae.InvoiceBaseGroup', function() {
  beforeEach(function() {
    return store = Vosae.Store.create();
  });
  afterEach(function() {
    return store.destroy();
  });
  it('quotation belongsTo relationship', function() {
    var invoiceBaseGroup, quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1,
      quotation: "/api/v1/quotation/1/"
    });
    quotation = store.find(Vosae.Quotation, 1);
    invoiceBaseGroup = store.find(Vosae.InvoiceBaseGroup, 1);
    return expect(invoiceBaseGroup.get('quotation')).toEqual(quotation);
  });
  it('purchaseOrder belongsTo relationship', function() {
    var invoiceBaseGroup, purchaseOrder;
    store.adapterForType(Vosae.PurchaseOrder).load(store, Vosae.PurchaseOrder, {
      id: 1
    });
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1,
      purchase_order: "/api/v1/purcharse_order/1/"
    });
    purchaseOrder = store.find(Vosae.PurchaseOrder, 1);
    invoiceBaseGroup = store.find(Vosae.InvoiceBaseGroup, 1);
    return expect(invoiceBaseGroup.get('purchaseOrder')).toEqual(purchaseOrder);
  });
  it('downPaymentInvoices hasMany relationship', function() {
    var downPaymentInvoice, invoiceBaseGroup;
    store.adapterForType(Vosae.DownPaymentInvoice).load(store, Vosae.DownPaymentInvoice, {
      id: 1
    });
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1,
      down_payment_invoices: ["/api/v1/down_payment_invoice/1/"]
    });
    invoiceBaseGroup = store.find(Vosae.InvoiceBaseGroup, 1);
    downPaymentInvoice = store.find(Vosae.DownPaymentInvoice, 1);
    return expect(invoiceBaseGroup.get('downPaymentInvoices.firstObject')).toEqual(downPaymentInvoice);
  });
  it('can add downPaymentInvoices', function() {
    var downPayment, downPayment2, invoiceBaseGroup;
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1
    });
    invoiceBaseGroup = store.find(Vosae.InvoiceBaseGroup, 1);
    downPayment = invoiceBaseGroup.get('downPaymentInvoices').createRecord();
    downPayment2 = invoiceBaseGroup.get('downPaymentInvoices').createRecord();
    expect(invoiceBaseGroup.get('downPaymentInvoices.length')).toEqual(2);
    expect(invoiceBaseGroup.get('downPaymentInvoices').objectAt(0)).toEqual(downPayment);
    return expect(invoiceBaseGroup.get('downPaymentInvoices').objectAt(1)).toEqual(downPayment2);
  });
  it('can delete downPaymentInvoices', function() {
    var downPayment, downPayment2, invoiceBaseGroup;
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1
    });
    invoiceBaseGroup = store.find(Vosae.InvoiceBaseGroup, 1);
    downPayment = invoiceBaseGroup.get('downPaymentInvoices').createRecord();
    downPayment2 = invoiceBaseGroup.get('downPaymentInvoices').createRecord();
    expect(invoiceBaseGroup.get('downPaymentInvoices.length')).toEqual(2);
    invoiceBaseGroup.get('downPaymentInvoices').removeObject(downPayment);
    invoiceBaseGroup.get('downPaymentInvoices').removeObject(downPayment2);
    return expect(invoiceBaseGroup.get('downPaymentInvoices.length')).toEqual(0);
  });
  it('invoice belongsTo relationship', function() {
    var invoice, invoiceBaseGroup;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1,
      invoice: "/api/v1/invoice/1/"
    });
    invoice = store.find(Vosae.Invoice, 1);
    invoiceBaseGroup = store.find(Vosae.InvoiceBaseGroup, 1);
    return expect(invoiceBaseGroup.get('invoice')).toEqual(invoice);
  });
  it('invoicesCancelled hasMany relationship', function() {
    var invoiceBaseGroup, invoiceCancelled;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1,
      invoices_cancelled: ["/api/v1/invoice/1/"]
    });
    invoiceBaseGroup = store.find(Vosae.InvoiceBaseGroup, 1);
    invoiceCancelled = store.find(Vosae.Invoice, 1);
    return expect(invoiceBaseGroup.get('invoicesCancelled.firstObject')).toEqual(invoiceCancelled);
  });
  it('can add invoicesCancelled', function() {
    var invoiceBaseGroup, invoiceCancelled, invoiceCancelled2;
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1
    });
    invoiceBaseGroup = store.find(Vosae.InvoiceBaseGroup, 1);
    invoiceCancelled = invoiceBaseGroup.get('invoicesCancelled').createRecord();
    invoiceCancelled2 = invoiceBaseGroup.get('invoicesCancelled').createRecord();
    expect(invoiceBaseGroup.get('invoicesCancelled.length')).toEqual(2);
    expect(invoiceBaseGroup.get('invoicesCancelled').objectAt(0)).toEqual(invoiceCancelled);
    return expect(invoiceBaseGroup.get('invoicesCancelled').objectAt(1)).toEqual(invoiceCancelled2);
  });
  it('can delete invoicesCancelled', function() {
    var invoiceBaseGroup, invoiceCancelled, invoiceCancelled2;
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1
    });
    invoiceBaseGroup = store.find(Vosae.InvoiceBaseGroup, 1);
    invoiceCancelled = invoiceBaseGroup.get('invoicesCancelled').createRecord();
    invoiceCancelled2 = invoiceBaseGroup.get('invoicesCancelled').createRecord();
    expect(invoiceBaseGroup.get('invoicesCancelled.length')).toEqual(2);
    invoiceBaseGroup.get('invoicesCancelled').removeObject(invoiceCancelled);
    invoiceBaseGroup.get('invoicesCancelled').removeObject(invoiceCancelled2);
    return expect(invoiceBaseGroup.get('invoicesCancelled.length')).toEqual(0);
  });
  it('creditNotes hasMany relationship', function() {
    var creditNote, invoiceBaseGroup;
    store.adapterForType(Vosae.CreditNote).load(store, Vosae.CreditNote, {
      id: 1
    });
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1,
      credit_notes: ["/api/v1/credit_note/1/"]
    });
    invoiceBaseGroup = store.find(Vosae.InvoiceBaseGroup, 1);
    creditNote = store.find(Vosae.CreditNote, 1);
    return expect(invoiceBaseGroup.get('creditNotes.firstObject')).toEqual(creditNote);
  });
  it('can add creditNotes', function() {
    var creditNote, creditNote2, invoiceBaseGroup;
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1
    });
    invoiceBaseGroup = store.find(Vosae.InvoiceBaseGroup, 1);
    creditNote = invoiceBaseGroup.get('creditNotes').createRecord();
    creditNote2 = invoiceBaseGroup.get('creditNotes').createRecord();
    expect(invoiceBaseGroup.get('creditNotes.length')).toEqual(2);
    expect(invoiceBaseGroup.get('creditNotes').objectAt(0)).toEqual(creditNote);
    return expect(invoiceBaseGroup.get('creditNotes').objectAt(1)).toEqual(creditNote2);
  });
  return it('can delete creditNotes', function() {
    var creditNote, creditNote2, invoiceBaseGroup;
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1
    });
    invoiceBaseGroup = store.find(Vosae.InvoiceBaseGroup, 1);
    creditNote = invoiceBaseGroup.get('creditNotes').createRecord();
    creditNote2 = invoiceBaseGroup.get('creditNotes').createRecord();
    expect(invoiceBaseGroup.get('creditNotes.length')).toEqual(2);
    invoiceBaseGroup.get('creditNotes').removeObject(creditNote);
    invoiceBaseGroup.get('creditNotes').removeObject(creditNote2);
    return expect(invoiceBaseGroup.get('creditNotes.length')).toEqual(0);
  });
});

var store;

store = null;

describe('Vosae.InvoiceRevision', function() {
  beforeEach(function() {
    return store = Vosae.Store.create();
  });
  afterEach(function() {
    return store.destroy();
  });
  it('lineItems hasMany relationship', function() {
    var book, invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      lineItems: [
        {
          ref: "Book"
        }
      ]
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    book = invoiceRevision.get('lineItems').objectAt(0);
    return expect(invoiceRevision.get('lineItems.firstObject')).toEqual(book);
  });
  it('can add lineItem', function() {
    var invoiceRevision, lineItem, lineItem2;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    lineItem = invoiceRevision.get('lineItems').createRecord(Vosae.LineItem);
    lineItem2 = invoiceRevision.get('lineItems').createRecord(Vosae.LineItem);
    expect(invoiceRevision.get('lineItems.length')).toEqual(2);
    expect(invoiceRevision.get('lineItems').objectAt(0)).toEqual(lineItem);
    return expect(invoiceRevision.get('lineItems').objectAt(1)).toEqual(lineItem2);
  });
  it('can delete lineItem', function() {
    var invoiceRevision, lineItem, lineItem2;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    lineItem = invoiceRevision.get('lineItems').createRecord(Vosae.LineItem);
    lineItem2 = invoiceRevision.get('lineItems').createRecord(Vosae.LineItem);
    expect(invoiceRevision.get('lineItems.length')).toEqual(2);
    invoiceRevision.get('lineItems').removeObject(lineItem);
    invoiceRevision.get('lineItems').removeObject(lineItem2);
    return expect(invoiceRevision.get('lineItems.length')).toEqual(0);
  });
  it('pdf belongsTo relationship', function() {
    var file, invoiceRevision;
    store.adapterForType(Vosae.File).load(store, Vosae.File, {
      id: 1
    });
    file = store.find(Vosae.File, 1);
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      pdf: {
        fr: "/api/v1/file/1/"
      }
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision.get('pdf.fr')).toEqual(file);
  });
  it('organization belongsTo relationship', function() {
    var invoiceRevision, organization;
    store.adapterForType(Vosae.Organization).load(store, Vosae.Organization, {
      id: 1
    });
    organization = store.find(Vosae.Organization, 1);
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      organization: "/api/v1/organization/1/"
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision.get('organization')).toEqual(organization);
  });
  it('contact belongsTo relationship', function() {
    var contact, invoiceRevision;
    store.adapterForType(Vosae.Contact).load(store, Vosae.Contact, {
      id: 1
    });
    contact = store.find(Vosae.Contact, 1);
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      contact: "/api/v1/contact/1/"
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision.get('contact')).toEqual(contact);
  });
  it('issuer belongsTo relationship', function() {
    var invoiceRevision, issuer;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1
    });
    issuer = store.find(Vosae.User, 1);
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      issuer: "/api/v1/issuer/1/"
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision.get('issuer')).toEqual(issuer);
  });
  it('currency belongsTo relationship', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      currency: {
        symbol: "EUR"
      }
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision.get('currency.symbol')).toEqual("EUR");
  });
  it('senderAddress belongsTo relationship', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      sender_address: {
        country: "France"
      }
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision.get('senderAddress.country')).toEqual("France");
  });
  it('billingAddress belongsTo relationship', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      billing_address: {
        country: "France"
      }
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision.get('billingAddress.country')).toEqual("France");
  });
  it('deliveryAddress belongsTo relationship', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      delivery_address: {
        country: "France"
      }
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision.get('deliveryAddress.country')).toEqual("France");
  });
  it('displayQuotationDate property should format the quotationDate', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      quotation_date: "2013-07-17T14:51:37+02:00"
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    expect(invoiceRevision.get('displayQuotationDate')).toEqual("July 17 2013");
    invoiceRevision.set('quotationDate', null);
    return expect(invoiceRevision.get('displayQuotationDate')).toEqual("undefined");
  });
  it('displayQuotationValidity property should format the quotationValidity', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      quotation_validity: "2013-07-17T14:51:37+02:00"
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    expect(invoiceRevision.get('displayQuotationValidity')).toEqual("July 17 2013");
    invoiceRevision.set('quotationValidity', null);
    return expect(invoiceRevision.get('displayQuotationValidity')).toEqual("undefined");
  });
  it('displayInvoicingDate property should format the invoicingDate', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      invoicing_date: "2013-07-17T14:51:37+02:00"
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    expect(invoiceRevision.get('displayInvoicingDate')).toEqual("July 17 2013");
    invoiceRevision.set('invoicingDate', null);
    return expect(invoiceRevision.get('displayInvoicingDate')).toEqual("undefined");
  });
  it('displayCreditNoteEmissionDate property should format the creditNoteEmissionDate', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      credit_note_emission_date: "2013-07-17T14:51:37+02:00"
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    expect(invoiceRevision.get('displayCreditNoteEmissionDate')).toEqual("July 17 2013");
    invoiceRevision.set('creditNoteEmissionDate', null);
    return expect(invoiceRevision.get('displayCreditNoteEmissionDate')).toEqual("undefined");
  });
  it('displayDueDate property should format the dueDate', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    expect(invoiceRevision.get('displayDueDate')).toEqual("undefined");
    invoiceRevision.set('customPaymentConditions', "30 days");
    expect(invoiceRevision.get('displayDueDate')).toEqual("variable");
    invoiceRevision.set('dueDate', new Date(2013, 6, 17));
    expect(invoiceRevision.get('displayDueDate')).toEqual("variable (July 17 2013)");
    invoiceRevision.set('customPaymentConditions', null);
    return expect(invoiceRevision.get('displayDueDate')).toEqual("July 17 2013");
  });
  it('total property should add the total of each lineItems', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      line_items: [
        {
          unit_price: 10.46,
          quantity: 2
        }, {
          unit_price: 5.30,
          quantity: 10
        }
      ]
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision.get('total')).toEqual(73.92);
  });
  it('totalVAT property should add the total with taxes of each lineItems', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1,
      rate: 0.10
    });
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 2,
      rate: 0.20
    });
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      line_items: [
        {
          unit_price: 10.46,
          quantity: 2,
          tax: "/api/v1/tax/1/"
        }, {
          unit_price: 5.30,
          quantity: 10,
          tax: "/api/v1/tax/2/"
        }
      ]
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision.get('totalVAT')).toEqual(86.612);
  });
  it('displayTotal property should format and round the total', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      line_items: [
        {
          unit_price: 10.46,
          quantity: 2
        }, {
          unit_price: 5.30,
          quantity: 10
        }
      ]
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision.get('displayTotal')).toEqual("73.92");
  });
  it('dispayTotalVAT property should format and round the totalVAT', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1,
      rate: 0.10
    });
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 2,
      rate: 0.20
    });
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      line_items: [
        {
          unit_price: 10.46,
          quantity: 2,
          tax: "/api/v1/tax/1/"
        }, {
          unit_price: 5.30,
          quantity: 10,
          tax: "/api/v1/tax/2/"
        }
      ]
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision.get('displayTotalVAT')).toEqual("86.61");
  });
  it('taxes property should return a dict with total amount for each taxes', function() {
    var invoiceRevision, taxes;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1,
      rate: 0.10
    });
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 2,
      rate: 0.20
    });
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      line_items: [
        {
          unit_price: 10,
          quantity: 1,
          tax: "/api/v1/tax/1/"
        }, {
          unit_price: 4,
          quantity: 2,
          tax: "/api/v1/tax/1/"
        }, {
          unit_price: 5,
          quantity: 3,
          tax: "/api/v1/tax/2/"
        }
      ]
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    taxes = invoiceRevision.get('taxes');
    expect(taxes.objectAt(0).total).toEqual(1.8);
    expect(taxes.objectAt(0).tax).toEqual(store.find(Vosae.Tax, 1));
    expect(taxes.objectAt(1).total).toEqual(3);
    return expect(taxes.objectAt(1).tax).toEqual(store.find(Vosae.Tax, 2));
  });
  it('_getLineItemsReferences() method should return an array of itemID related to the lineItems', function() {
    var invoiceRevision;
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      line_items: [
        {
          item_id: "1"
        }, {
          item_id: "2"
        }, {
          item_id: "3"
        }, {
          item_id: "1"
        }
      ]
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    return expect(invoiceRevision._getLineItemsReferences()).toEqual(["1", "2", "3"]);
  });
  it('_userOverrodeUnitPrice() method should return true if orginial unit price has been overrode', function() {
    var invoiceCurrency, invoiceRevision, item, itemCurrency, lineItem;
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1,
      symbol: "EUR"
    });
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 1,
      unit_price: 10,
      currency: "/api/v1/currency/1/"
    });
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      currency: {
        symbol: "EUR",
        rates: [
          {
            currency_to: "EUR",
            rate: "1.00"
          }, {
            currency_to: "USD",
            rate: "2.00"
          }
        ]
      },
      line_items: [
        {
          item_id: "1",
          unit_price: 10
        }
      ]
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    lineItem = invoiceRevision.get('lineItems').objectAt(0);
    invoiceCurrency = invoiceRevision.get('currency');
    item = store.find(Vosae.Item, 1);
    itemCurrency = item.get('currency');
    expect(invoiceRevision._userOverrodeUnitPrice(lineItem, item, invoiceCurrency)).toEqual(false);
    lineItem.set('unitPrice', 20);
    expect(invoiceRevision._userOverrodeUnitPrice(lineItem, item, invoiceCurrency)).toEqual(true);
    itemCurrency.set('symbol', 'USD');
    lineItem.set('unitPrice', 5);
    expect(invoiceRevision._userOverrodeUnitPrice(lineItem, item, invoiceCurrency)).toEqual(false);
    lineItem.set('unitPrice', 10);
    return expect(invoiceRevision._userOverrodeUnitPrice(lineItem, item, invoiceCurrency)).toEqual(true);
  });
  it('_convertLineItemsPrice() method should return true if orginial unit price has been overrode', function() {
    var currentCurrency, invoiceRevision, lineItems, newCurrency;
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1,
      symbol: "EUR",
      rates: [
        {
          currency_to: "EUR",
          rate: "1.00"
        }, {
          currency_to: "USD",
          rate: "2.00"
        }
      ]
    });
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 2,
      symbol: "USD",
      rates: [
        {
          currency_to: "EUR",
          rate: "0.50"
        }, {
          currency_to: "USD",
          rate: "1.00"
        }
      ]
    });
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 1,
      unit_price: 10,
      currency: "/api/v1/currency/1/"
    });
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 2,
      unit_price: 8,
      currency: "/api/v1/currency/1/"
    });
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 3,
      unit_price: 57,
      currency: "/api/v1/currency/2/"
    });
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      currency: {
        symbol: "EUR",
        rates: [
          {
            currency_to: "EUR",
            rate: "1.00"
          }, {
            currency_to: "USD",
            rate: "2.00"
          }
        ]
      },
      line_items: [
        {
          item_id: "1",
          unit_price: 10
        }, {
          item_id: "2",
          unit_price: 4
        }, {
          item_id: "3",
          unit_price: 91
        }, {
          item_id: "3",
          unit_price: 28.50
        }
      ]
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    currentCurrency = invoiceRevision.get('currency');
    newCurrency = store.find(Vosae.Currency, 2);
    invoiceRevision._convertLineItemsPrice(currentCurrency, newCurrency);
    lineItems = invoiceRevision.get('lineItems');
    expect(lineItems.objectAt(0).get('unitPrice')).toEqual(20);
    expect(lineItems.objectAt(1).get('unitPrice')).toEqual(8);
    expect(lineItems.objectAt(2).get('unitPrice')).toEqual(182);
    expect(lineItems.objectAt(3).get('unitPrice')).toEqual(57);
    expect(invoiceRevision.get('currency.symbol')).toEqual("USD");
    expect(invoiceRevision.get('currency.rates').toArray()).toEqual(newCurrency.get('rates').toArray());
    currentCurrency = invoiceRevision.get('currency');
    newCurrency = store.find(Vosae.Currency, 1);
    invoiceRevision._convertLineItemsPrice(currentCurrency, newCurrency);
    lineItems = invoiceRevision.get('lineItems');
    expect(lineItems.objectAt(0).get('unitPrice')).toEqual(10);
    expect(lineItems.objectAt(1).get('unitPrice')).toEqual(4);
    expect(lineItems.objectAt(2).get('unitPrice')).toEqual(91);
    expect(lineItems.objectAt(3).get('unitPrice')).toEqual(28.50);
    expect(invoiceRevision.get('currency.symbol')).toEqual("EUR");
    return expect(invoiceRevision.get('currency.rates').toArray()).toEqual(newCurrency.get('rates').toArray());
  });
  return it('updateWithCurrency() method should update the invoiceRevision with the new currency', function() {
    var invoiceRevision, item1, item2, newCurrency;
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1,
      symbol: "EUR",
      rates: [
        {
          currency_to: "EUR",
          rate: "1.00"
        }, {
          currency_to: "USD",
          rate: "2.00"
        }
      ]
    });
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 2,
      symbol: "USD",
      rates: [
        {
          currency_to: "EUR",
          rate: "0.50"
        }, {
          currency_to: "USD",
          rate: "1.00"
        }
      ]
    });
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 1,
      unit_price: 10,
      currency: "/api/v1/currency/1/"
    });
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 2,
      unit_price: 57,
      currency: "/api/v1/currency/2/"
    });
    item1 = store.find(Vosae.Item, 1);
    item2 = store.find(Vosae.Item, 2);
    store.adapterForType(Vosae.InvoiceRevision).load(store, Vosae.InvoiceRevision, {
      id: 1,
      currency: {
        symbol: "EUR",
        rates: [
          {
            currency_to: "EUR",
            rate: "1.00"
          }, {
            currency_to: "USD",
            rate: "2.00"
          }
        ]
      },
      line_items: [
        {
          item_id: "1",
          unit_price: 10
        }, {
          item_id: "2",
          unit_price: 91
        }
      ]
    });
    invoiceRevision = store.find(Vosae.InvoiceRevision, 1);
    newCurrency = store.find(Vosae.Currency, 2);
    invoiceRevision.updateWithCurrency(newCurrency);
    waitsFor(function() {
      return invoiceRevision.get('currency.symbol') === "USD";
    }, "", 750);
    return runs(function() {
      var lineItems;
      lineItems = invoiceRevision.get('lineItems');
      expect(lineItems.objectAt(0).get('unitPrice')).toEqual(20);
      expect(lineItems.objectAt(1).get('unitPrice')).toEqual(182);
      expect(invoiceRevision.get('currency.rates').toArray()).toEqual(newCurrency.get('rates').toArray());
      invoiceRevision.set('lineItems.content', []);
      newCurrency = store.find(Vosae.Currency, 1);
      invoiceRevision.updateWithCurrency(newCurrency);
      expect(invoiceRevision.get('currency.symbol')).toEqual("EUR");
      return expect(invoiceRevision.get('currency.rates').toArray()).toEqual(newCurrency.get('rates').toArray());
    });
  });
});

var store;

store = null;

describe('Vosae.Item', function() {
  var hashItem;
  hashItem = {
    reference: null,
    description: null,
    unit_price: null,
    type: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Item);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all item makes a GET to /item/', function() {
    var item, items;
    items = store.find(Vosae.Item);
    enabledFlags(items, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/item/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashItem, {
          id: 1,
          ref: "siteweb",
          unit_price: 1000.64
        })
      ]
    });
    item = items.objectAt(0);
    statesEqual(items, 'loaded.saved');
    stateEquals(item, 'loaded.saved');
    enabledFlagsForArray(items, ['isLoaded', 'isValid']);
    enabledFlags(item, ['isLoaded', 'isValid']);
    return expect(item).toEqual(store.find(Vosae.Item, 1));
  });
  it('finding a item by ID makes a GET to /item/:id/', function() {
    var item;
    item = store.find(Vosae.Item, 1);
    stateEquals(item, 'loading');
    enabledFlags(item, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/item/1/");
    ajaxHash.success($.extend({}, hashItem, {
      id: 1,
      ref: "siteweb",
      unit_price: 1000,
      resource_uri: "/api/v1/item/1/"
    }));
    stateEquals(item, 'loaded.saved');
    enabledFlags(item, ['isLoaded', 'isValid']);
    return expect(item).toEqual(store.find(Vosae.Item, 1));
  });
  it('finding items by query makes a GET to /item/:query/', function() {
    var book, items, pen;
    items = store.find(Vosae.Item, {
      page: 1
    });
    expect(items.get('length')).toEqual(0);
    enabledFlags(items, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/item/");
    expectAjaxType("GET");
    expectAjaxData({
      page: 1
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashItem, {
          id: 1,
          reference: "Pen",
          price: 8.34
        }), $.extend({}, hashItem, {
          id: 2,
          reference: "Book",
          price: 34.10
        })
      ]
    });
    pen = items.objectAt(0);
    book = items.objectAt(1);
    statesEqual([pen, book], 'loaded.saved');
    enabledFlags(items, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([pen, book], ['isLoaded'], recordArrayFlags);
    expect(items.get('length')).toEqual(2);
    expect(pen.get('ref')).toEqual("Pen");
    expect(book.get('ref')).toEqual("Book");
    expect(pen.get('id')).toEqual("1");
    return expect(book.get('id')).toEqual("2");
  });
  it('creating a item makes a POST to /item/', function() {
    var item;
    item = store.createRecord(Vosae.Item, {
      ref: "Book",
      unitPrice: 9.45
    });
    stateEquals(item, 'loaded.created.uncommitted');
    enabledFlags(item, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    item.get('transaction').commit();
    stateEquals(item, 'loaded.created.inFlight');
    enabledFlags(item, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/item/");
    expectAjaxType("POST");
    expectAjaxData($.extend({}, hashItem, {
      reference: "Book",
      unit_price: 9.45
    }));
    ajaxHash.success($.extend({}, hashItem, {
      id: 1,
      reference: "Book",
      unit_price: 9.45,
      resource_uri: "/api/v1/item/1/"
    }));
    stateEquals(item, 'loaded.saved');
    enabledFlags(item, ['isLoaded', 'isValid']);
    return expect(item).toEqual(store.find(Vosae.Item, 1));
  });
  it('updating an item makes a PUT to /item/:id/', function() {
    var item;
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 1,
      reference: "Book",
      unit_price: 24.53,
      type: "PRODUCT"
    });
    item = store.find(Vosae.Item, 1);
    stateEquals(item, 'loaded.saved');
    enabledFlags(item, ['isLoaded', 'isValid']);
    item.setProperties({
      unitPrice: 15.00
    });
    stateEquals(item, 'loaded.updated.uncommitted');
    enabledFlags(item, ['isLoaded', 'isDirty', 'isValid']);
    item.get('transaction').commit();
    stateEquals(item, 'loaded.updated.inFlight');
    enabledFlags(item, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/item/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, hashItem, {
      reference: "Book",
      unit_price: 15.00,
      type: "PRODUCT"
    }));
    ajaxHash.success($.extend({}, hashItem, {
      id: 1,
      reference: "Book",
      unit_price: 15.00,
      type: "PRODUCT"
    }));
    stateEquals(item, 'loaded.saved');
    enabledFlags(item, ['isLoaded', 'isValid']);
    expect(item).toEqual(store.find(Vosae.Item, 1));
    return expect(item.get('unitPrice')).toEqual(15.00);
  });
  it('deleting a item makes a DELETE to /item/:id/', function() {
    var item;
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 1,
      ref: "Book",
      unit_price: 15.00
    });
    item = store.find(Vosae.Item, 1);
    stateEquals(item, 'loaded.saved');
    enabledFlags(item, ['isLoaded', 'isValid']);
    item.deleteRecord();
    stateEquals(item, 'deleted.uncommitted');
    enabledFlags(item, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']);
    item.get('transaction').commit();
    stateEquals(item, 'deleted.inFlight');
    enabledFlags(item, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']);
    expectAjaxURL("/item/1/");
    expectAjaxType("DELETE");
    ajaxHash.success();
    stateEquals(item, 'deleted.saved');
    return enabledFlags(item, ['isLoaded', 'isDeleted', 'isValid']);
  });
  it('tax belongsTo relationship', function() {
    var item, tax;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1
    });
    tax = store.find(Vosae.Tax, 1);
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 1,
      tax: "/api/v1/tax/1/"
    });
    item = store.find(Vosae.Item, 1);
    return expect(item.get('tax')).toEqual(tax);
  });
  it('currency belongsTo relationship', function() {
    var currency, item;
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1
    });
    currency = store.find(Vosae.Currency, 1);
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 1,
      currency: "/api/v1/currency/1/"
    });
    item = store.find(Vosae.Item, 1);
    return expect(item.get('currency')).toEqual(currency);
  });
  it('displayUnitPrice property should round and format unit price', function() {
    var item;
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 1
    });
    item = store.find(Vosae.Item, 1);
    expect(item.get('displayUnitPrice')).toEqual(void 0);
    item.set('unitPrice', 15.46);
    expect(item.get('displayUnitPrice')).toEqual("15.46");
    item.set('unitPrice', 15.460564545);
    return expect(item.get('displayUnitPrice')).toEqual("15.46");
  });
  it('displayType property should return the item type', function() {
    var item;
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 1,
      type: "PRODUCT"
    });
    item = store.find(Vosae.Item, 1);
    expect(item.get('displayType')).toEqual("Product");
    item.set('type', "SERVICE");
    return expect(item.get('displayType')).toEqual("Service");
  });
  return it('isEmpty() method should return true if item is empty', function() {
    var item;
    store.adapterForType(Vosae.Item).load(store, Vosae.Item, {
      id: 1
    });
    item = store.find(Vosae.Item, 1);
    expect(item.isEmpty()).toEqual(true);
    item.setProperties({
      ref: "Book",
      description: "A great book about cooking",
      unit_price: 15.35
    });
    return expect(item.isEmpty()).toEqual(false);
  });
});

var store;

store = null;

describe('Vosae.LineItem', function() {
  beforeEach(function() {
    return store = Vosae.Store.create();
  });
  afterEach(function() {
    return store.destroy();
  });
  it('tax belongsTo relationship', function() {
    var lineItem, tax;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1
    });
    tax = store.find(Vosae.Tax, 1);
    store.adapterForType(Vosae.LineItem).load(store, Vosae.LineItem, {
      id: 1,
      tax: "/api/v1/tax/1/"
    });
    lineItem = store.find(Vosae.LineItem, 1);
    return expect(lineItem.get('tax')).toEqual(tax);
  });
  it('shouldDisableField property should return true if lineItem hasn\'t reference', function() {
    var lineItem;
    store.adapterForType(Vosae.LineItem).load(store, Vosae.LineItem, {
      id: 1
    });
    lineItem = store.find(Vosae.LineItem, 1);
    expect(lineItem.get('shouldDisableField')).toEqual(true);
    lineItem.set('ref', 'book194');
    return expect(lineItem.get('shouldDisableField')).toEqual(false);
  });
  it('total property should return unit price multiplied by the quantity', function() {
    var lineItem;
    store.adapterForType(Vosae.LineItem).load(store, Vosae.LineItem, {
      id: 1
    });
    lineItem = store.find(Vosae.LineItem, 1);
    expect(lineItem.get('total')).toEqual(0);
    lineItem.set('unitPrice', 10);
    expect(lineItem.get('total')).toEqual(0);
    lineItem.set('quantity', 5);
    return expect(lineItem.get('total')).toEqual(50);
  });
  it('totalVAT property should return unit price multiplied by the quantity multiplied by the tax', function() {
    var lineItem;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1,
      rate: 0.196
    });
    store.adapterForType(Vosae.LineItem).load(store, Vosae.LineItem, {
      id: 1,
      tax: "/api/v1/tax/1/"
    });
    lineItem = store.find(Vosae.LineItem, 1);
    expect(lineItem.get('totalVAT')).toEqual(0);
    lineItem.set('unitPrice', 10.2);
    expect(lineItem.get('totalVAT')).toEqual(0);
    lineItem.set('quantity', 5);
    return expect(lineItem.get('totalVAT')).toEqual(60.996);
  });
  it('displayTotal property should return the total formated and rounded', function() {
    var lineItem;
    store.adapterForType(Vosae.LineItem).load(store, Vosae.LineItem, {
      id: 1
    });
    lineItem = store.find(Vosae.LineItem, 1);
    expect(lineItem.get('displayTotal')).toEqual("0.00");
    lineItem.setProperties({
      unitPrice: 10.03434,
      quantity: 5
    });
    return expect(lineItem.get('displayTotal')).toEqual("50.17");
  });
  it('displayTotalVAT property should return the totalVAT formated and rounded', function() {
    var lineItem;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1,
      rate: 0.196
    });
    store.adapterForType(Vosae.LineItem).load(store, Vosae.LineItem, {
      id: 1,
      tax: "/api/v1/tax/1/"
    });
    lineItem = store.find(Vosae.LineItem, 1);
    expect(lineItem.get('displayTotalVAT')).toEqual("0.00");
    lineItem.setProperties({
      unitPrice: 10.2,
      quantity: 5
    });
    return expect(lineItem.get('displayTotalVAT')).toEqual("61.00");
  });
  it('displayUnitPrice property should return the unit price formated and rounded', function() {
    var lineItem;
    store.adapterForType(Vosae.LineItem).load(store, Vosae.LineItem, {
      id: 1
    });
    lineItem = store.find(Vosae.LineItem, 1);
    expect(lineItem.get('displayUnitPrice')).toEqual("0.00");
    lineItem.setProperties({
      unitPrice: 1000000.050
    });
    return expect(lineItem.get('displayUnitPrice')).toEqual("1,000,000.05");
  });
  it('displayQuantity property should return the quantity formated and rounded', function() {
    var lineItem;
    store.adapterForType(Vosae.LineItem).load(store, Vosae.LineItem, {
      id: 1
    });
    lineItem = store.find(Vosae.LineItem, 1);
    expect(lineItem.get('displayQuantity')).toEqual("0.00");
    lineItem.setProperties({
      quantity: 10000.567
    });
    return expect(lineItem.get('displayQuantity')).toEqual("10,000.57");
  });
  it('VAT() method should return a dict with the vat amount total and the tax object', function() {
    var lineItem, tax;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1,
      rate: 0.10
    });
    tax = store.find(Vosae.Tax, 1);
    store.adapterForType(Vosae.LineItem).load(store, Vosae.LineItem, {
      id: 1,
      tax: "/api/v1/tax/1/"
    });
    lineItem = store.find(Vosae.LineItem, 1);
    expect(lineItem.VAT()).toEqual(null);
    lineItem.setProperties({
      quantity: 10
    });
    expect(lineItem.VAT()).toEqual(null);
    lineItem.setProperties({
      unitPrice: 50
    });
    return expect(lineItem.VAT()).toEqual({
      total: 50,
      tax: tax
    });
  });
  return it('isEmpty() method should return true if lineItem is empty', function() {
    var lineItem;
    store.adapterForType(Vosae.LineItem).load(store, Vosae.LineItem, {
      id: 1
    });
    lineItem = store.find(Vosae.LineItem, 1);
    expect(lineItem.isEmpty()).toEqual(true);
    lineItem.setProperties({
      ref: "Book",
      description: "A great book about cooking",
      unit_price: 15.35
    });
    return expect(lineItem.isEmpty()).toEqual(false);
  });
});

var store;

store = null;

describe('Vosae.Payment', function() {
  var expectedPostData;
  expectedPostData = {
    amount: 1000,
    type: "CASH",
    date: "2013-08-10",
    currency: "/api/v1/currency/1/",
    related_to: "/api/v1/invoice/1/",
    note: "bah"
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Payment);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding a payment by ID makes a GET to /payment/:id/', function() {
    var payment;
    payment = store.find(Vosae.Payment, 1);
    stateEquals(payment, 'loading');
    enabledFlags(payment, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/payment/1/");
    ajaxHash.success({
      id: 1,
      resource_uri: "/api/v1/payment/1/"
    });
    stateEquals(payment, 'loaded.saved');
    enabledFlags(payment, ['isLoaded', 'isValid']);
    return expect(payment).toEqual(store.find(Vosae.Payment, 1));
  });
  it('creating a payment makes a POST to /payment/', function() {
    var payment;
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1
    });
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    payment = store.createRecord(Vosae.Payment, {});
    payment.setProperties({
      'amount': 1000,
      'type': 'CASH',
      'date': new Date(2013, 7, 10),
      'currency': store.find(Vosae.Currency, 1),
      'relatedTo': store.find(Vosae.Invoice, 1),
      'note': 'bah'
    });
    stateEquals(payment, 'loaded.created.uncommitted');
    enabledFlags(payment, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    payment.get('transaction').commit();
    stateEquals(payment, 'loaded.created.inFlight');
    enabledFlags(payment, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/payment/");
    expectAjaxType("POST");
    expectAjaxData(expectedPostData);
    ajaxHash.success($.extend({}, expectedPostData, {
      id: 1,
      resource_uri: "/api/v1/payment/1/"
    }));
    stateEquals(payment, 'loaded.saved');
    enabledFlags(payment, ['isLoaded', 'isValid']);
    return expect(payment).toEqual(store.find(Vosae.Payment, 1));
  });
  it('displayDate property should return the date formated', function() {
    var payment;
    store.adapterForType(Vosae.Payment).load(store, Vosae.Payment, {
      id: 1
    });
    payment = store.find(Vosae.Payment, 1);
    expect(payment.get('displayDate')).toEqual("undefined");
    payment.set("date", new Date(2013, 7, 10));
    return expect(payment.get('displayDate')).toEqual("August 10 2013");
  });
  it('displayAmount property should return the amount formated', function() {
    var payment;
    store.adapterForType(Vosae.Payment).load(store, Vosae.Payment, {
      id: 1
    });
    payment = store.find(Vosae.Payment, 1);
    expect(payment.get('displayAmount')).toEqual("");
    payment.set("amount", 1000);
    return expect(payment.get('displayAmount')).toEqual("1,000.00");
  });
  it('displayType property should return the type formated', function() {
    var payment;
    store.adapterForType(Vosae.Payment).load(store, Vosae.Payment, {
      id: 1
    });
    payment = store.find(Vosae.Payment, 1);
    expect(payment.get('displayType')).toEqual("undefined");
    return Vosae.paymentTypes.forEach(function(type) {
      payment.set('type', type.get('value'));
      return expect(payment.get('displayType')).toEqual(type.get('label'));
    });
  });
  it('displayNote property should return the note or -', function() {
    var payment;
    store.adapterForType(Vosae.Payment).load(store, Vosae.Payment, {
      id: 1
    });
    payment = store.find(Vosae.Payment, 1);
    expect(payment.get('displayNote')).toEqual("-");
    payment.set("note", "my note");
    return expect(payment.get('displayNote')).toEqual("my note");
  });
  it('amountMax property should return the amount maximum for the payment', function() {
    var currency, payment;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      balance: 1000,
      current_revision: {
        currency: {
          symbol: "EUR",
          rates: [
            {
              currency_to: "USD",
              rate: "2"
            }, {
              currency_to: "EUR",
              rate: "1"
            }
          ]
        }
      }
    });
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1,
      symbol: "USD"
    });
    currency = store.find(Vosae.Currency, 1);
    store.adapterForType(Vosae.Payment).load(store, Vosae.Payment, {
      id: 1,
      currency: "/api/v1/currency/1/",
      related_to: "/api/v1/invoice/1/"
    });
    payment = store.find(Vosae.Payment, 1);
    expect(payment.get('amountMax')).toEqual(2000.00);
    payment.get('currency').set("symbol", "EUR");
    return expect(payment.get('amountMax')).toEqual(1000.00);
  });
  return it('updateWithCurrency() method shold convert the amount according to the new currency', function() {
    var eur, payment, usd;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1,
      balance: 1000,
      current_revision: {
        currency: {
          symbol: "EUR",
          rates: [
            {
              currency_to: "USD",
              rate: "2"
            }, {
              currency_to: "EUR",
              rate: "1"
            }
          ]
        }
      }
    });
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1,
      symbol: "USD"
    });
    usd = store.find(Vosae.Currency, 1);
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 2,
      symbol: "EUR"
    });
    eur = store.find(Vosae.Currency, 2);
    store.adapterForType(Vosae.Payment).load(store, Vosae.Payment, {
      id: 1,
      currency: "/api/v1/currency/1/",
      related_to: "/api/v1/invoice/1/",
      amount: 2000
    });
    payment = store.find(Vosae.Payment, 1);
    payment.updateWithCurrency(eur);
    expect(payment.get('amount')).toEqual(1000.00);
    payment.updateWithCurrency(usd);
    return expect(payment.get('amount')).toEqual(2000.00);
  });
});

var store;

store = null;

describe('Vosae.Quotation', function() {
  var expectedPostData, hashQuotation;
  hashQuotation = {
    account_type: null,
    amount: null,
    attachments: [],
    current_revision: null,
    notes: [],
    reference: null,
    state: null,
    total: null
  };
  expectedPostData = {
    "state": null,
    "reference": null,
    "account_type": "RECEIVABLE",
    "total": null,
    "amount": null,
    "notes": [],
    "attachments": [],
    "current_revision": {
      "quotation_date": "2013-07-26",
      "quotation_validity": "2013-07-28",
      "custom_payment_conditions": null,
      "revision": null,
      "state": null,
      "sender": "Tom Dale",
      "customer_reference": null,
      "taxes_application": null,
      "line_items": [
        {
          "reference": "Siteweb",
          "description": "My site web",
          "item_id": "1",
          "quantity": 1,
          "unit_price": 100,
          "tax": "/api/v1/tax/1/"
        }
      ],
      "pdf": null,
      "organization": "/api/v1/organization/1/",
      "contact": "/api/v1/contact/1/",
      "sender_address": {
        "type": "WORK",
        "postoffice_box": "a",
        "street_address": "b",
        "extended_address": "c",
        "postal_code": "d",
        "city": "e",
        "state": "f",
        "country": "g"
      },
      "billing_address": {
        "type": "WORK",
        "postoffice_box": "aa",
        "street_address": "bb",
        "extended_address": "cc",
        "postal_code": "dd",
        "city": "ee",
        "state": "ff",
        "country": "gg"
      },
      "delivery_address": {
        "type": "WORK",
        "postoffice_box": "aaa",
        "street_address": "bbb",
        "extended_address": "ccc",
        "postal_code": "ddd",
        "city": "eee",
        "state": "fff",
        "country": "ggg"
      },
      "currency": {
        "symbol": "EUR",
        "resource_uri": null,
        "rates": [
          {
            "currency_to": "GBP",
            "rate": 0.86
          }, {
            "currency_to": "USD",
            "rate": 1.33
          }
        ]
      }
    }
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Quotation);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all quotation makes a GET to /quotation/', function() {
    var quotation, quotations;
    quotations = store.find(Vosae.Quotation);
    enabledFlags(quotations, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/quotation/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashQuotation, {
          id: 1
        })
      ]
    });
    quotation = quotations.objectAt(0);
    statesEqual(quotations, 'loaded.saved');
    stateEquals(quotation, 'loaded.saved');
    enabledFlagsForArray(quotations, ['isLoaded', 'isValid']);
    enabledFlags(quotation, ['isLoaded', 'isValid']);
    return expect(quotation).toEqual(store.find(Vosae.Quotation, 1));
  });
  it('finding a quotation by ID makes a GET to /quotation/:id/', function() {
    var quotation;
    quotation = store.find(Vosae.Quotation, 1);
    stateEquals(quotation, 'loading');
    enabledFlags(quotation, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/quotation/1/");
    ajaxHash.success($.extend({}, hashQuotation, {
      id: 1,
      resource_uri: "/api/v1/quotation/1/"
    }));
    stateEquals(quotation, 'loaded.saved');
    enabledFlags(quotation, ['isLoaded', 'isValid']);
    return expect(quotation).toEqual(store.find(Vosae.Quotation, 1));
  });
  it('finding quotations by query makes a GET to /quotation/:query/', function() {
    var quotation1, quotation2, quotations;
    quotations = store.find(Vosae.Quotation, {
      state: "DRAFT"
    });
    expect(quotations.get('length')).toEqual(0);
    enabledFlags(quotations, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/quotation/");
    expectAjaxType("GET");
    expectAjaxData({
      state: "DRAFT"
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashQuotation, {
          id: 1,
          state: "DRAFT"
        }), $.extend({}, hashQuotation, {
          id: 2,
          state: "DRAFT"
        })
      ]
    });
    quotation1 = quotations.objectAt(0);
    quotation2 = quotations.objectAt(1);
    statesEqual([quotation1, quotation2], 'loaded.saved');
    enabledFlags(quotations, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([quotation1, quotation2], ['isLoaded'], recordArrayFlags);
    expect(quotations.get('length')).toEqual(2);
    expect(quotation1.get('state')).toEqual("DRAFT");
    expect(quotation2.get('state')).toEqual("DRAFT");
    expect(quotation1.get('id')).toEqual("1");
    return expect(quotation2.get('id')).toEqual("2");
  });
  it('creating a quotation makes a POST to /quotation/', function() {
    var billingAddress, contact, currency, currentRevision, deliveryAddress, lineItem, organization, quotation, rate1, rate2, senderAddress, tax, unusedTransaction;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1
    });
    store.adapterForType(Vosae.Organization).load(store, Vosae.Organization, {
      id: 1
    });
    store.adapterForType(Vosae.Contact).load(store, Vosae.Contact, {
      id: 1
    });
    tax = store.find(Vosae.Tax, 1);
    contact = store.find(Vosae.Contact, 1);
    organization = store.find(Vosae.Organization, 1);
    unusedTransaction = store.transaction();
    currentRevision = unusedTransaction.createRecord(Vosae.InvoiceRevision);
    currency = unusedTransaction.createRecord(Vosae.Currency);
    billingAddress = unusedTransaction.createRecord(Vosae.Address);
    deliveryAddress = unusedTransaction.createRecord(Vosae.Address);
    senderAddress = unusedTransaction.createRecord(Vosae.Address);
    rate1 = unusedTransaction.createRecord(Vosae.ExchangeRate);
    rate2 = unusedTransaction.createRecord(Vosae.ExchangeRate);
    rate1.setProperties({
      "currencyTo": "GBP",
      "rate": 0.86
    });
    rate2.setProperties({
      "currencyTo": "USD",
      "rate": 1.33
    });
    currency.get('rates').addObject(rate1);
    currency.get('rates').addObject(rate2);
    currency.setProperties({
      "symbol": "EUR"
    });
    senderAddress.setProperties({
      "postofficeBox": "a",
      "streetAddress": "b",
      "extendedAddress": "c",
      "postalCode": "d",
      "city": "e",
      "state": "f",
      "country": "g"
    });
    billingAddress.setProperties({
      "postofficeBox": "aa",
      "streetAddress": "bb",
      "extendedAddress": "cc",
      "postalCode": "dd",
      "city": "ee",
      "state": "ff",
      "country": "gg"
    });
    deliveryAddress.setProperties({
      "postofficeBox": "aaa",
      "streetAddress": "bbb",
      "extendedAddress": "ccc",
      "postalCode": "ddd",
      "city": "eee",
      "state": "fff",
      "country": "ggg"
    });
    lineItem = currentRevision.get('lineItems').createRecord();
    lineItem.setProperties({
      "ref": "Siteweb",
      "description": "My site web",
      "itemId": "1",
      "quantity": 1,
      "unitPrice": 100,
      "tax": tax
    });
    currentRevision.setProperties({
      'quotationDate': new Date(2013, 6, 26),
      'quotationValidity': new Date(2013, 6, 28),
      'sender': "Tom Dale",
      'currency': currency,
      'organization': organization,
      'contact': contact,
      'billingAddress': billingAddress,
      'deliveryAddress': deliveryAddress,
      'senderAddress': senderAddress
    });
    quotation = store.createRecord(Vosae.Quotation, {});
    quotation.setProperties({
      "accountType": "RECEIVABLE",
      "currentRevision": currentRevision
    });
    stateEquals(quotation, 'loaded.created.uncommitted');
    enabledFlags(quotation, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    quotation.get('transaction').commit();
    stateEquals(quotation, 'loaded.created.inFlight');
    enabledFlags(quotation, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/quotation/");
    expectAjaxType("POST");
    expectAjaxData(expectedPostData);
    ajaxHash.success($.extend({}, expectedPostData, {
      id: 1,
      state: "DRAFT",
      resource_uri: "/api/v1/quotation/1/"
    }));
    stateEquals(quotation, 'loaded.saved');
    enabledFlags(quotation, ['isLoaded', 'isValid']);
    return expect(quotation).toEqual(store.find(Vosae.Quotation, 1));
  });
  it('updating a quotation makes a PUT to /quotation/:id/', function() {
    var quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, $.extend({}, expectedPostData, {
      id: 1,
      state: "DRAFT"
    }));
    quotation = store.find(Vosae.Quotation, 1);
    stateEquals(quotation, 'loaded.saved');
    enabledFlags(quotation, ['isLoaded', 'isValid']);
    quotation.setProperties({
      state: "REGISTERED"
    });
    stateEquals(quotation, 'loaded.updated.uncommitted');
    enabledFlags(quotation, ['isLoaded', 'isDirty', 'isValid']);
    quotation.get('transaction').commit();
    stateEquals(quotation, 'loaded.updated.inFlight');
    enabledFlags(quotation, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/quotation/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, expectedPostData, {
      state: "REGISTERED"
    }));
    ajaxHash.success($.extend({}, expectedPostData, {
      id: 1,
      state: "REGISTERED"
    }));
    stateEquals(quotation, 'loaded.saved');
    enabledFlags(quotation, ['isLoaded', 'isValid']);
    expect(quotation).toEqual(store.find(Vosae.Quotation, 1));
    return expect(quotation.get('state')).toEqual('REGISTERED');
  });
  it('deleting a quotation makes a DELETE to /quotation/:id/', function() {
    var quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1,
      state: "DRAFT"
    });
    quotation = store.find(Vosae.Quotation, 1);
    stateEquals(quotation, 'loaded.saved');
    enabledFlags(quotation, ['isLoaded', 'isValid']);
    quotation.deleteRecord();
    stateEquals(quotation, 'deleted.uncommitted');
    enabledFlags(quotation, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']);
    quotation.get('transaction').commit();
    stateEquals(quotation, 'deleted.inFlight');
    enabledFlags(quotation, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']);
    expectAjaxURL("/quotation/1/");
    expectAjaxType("DELETE");
    ajaxHash.success();
    stateEquals(quotation, 'deleted.saved');
    return enabledFlags(quotation, ['isLoaded', 'isDeleted', 'isValid']);
  });
  it('notes hasMany relationship', function() {
    var quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1,
      notes: [
        {
          note: "My note"
        }
      ]
    });
    quotation = store.find(Vosae.Quotation, 1);
    return expect(quotation.get('notes.firstObject.note')).toEqual("My note");
  });
  it('can add note', function() {
    var note, note2, quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    note = quotation.get('notes').createRecord();
    note2 = quotation.get('notes').createRecord();
    expect(quotation.get('notes.length')).toEqual(2);
    expect(quotation.get('notes').objectAt(0)).toEqual(note);
    return expect(quotation.get('notes').objectAt(1)).toEqual(note2);
  });
  it('can delete note', function() {
    var note, note2, quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    note = quotation.get('notes').createRecord();
    note2 = quotation.get('notes').createRecord();
    expect(quotation.get('notes.length')).toEqual(2);
    quotation.get('notes').removeObject(note);
    quotation.get('notes').removeObject(note2);
    return expect(quotation.get('notes.length')).toEqual(0);
  });
  it('attachments hasMany relationship', function() {
    var file, quotation;
    store.adapterForType(Vosae.File).load(store, Vosae.File, {
      id: 1
    });
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1,
      attachments: ["/api/v1/file/1/"]
    });
    file = store.find(Vosae.File, 1);
    quotation = store.find(Vosae.Quotation, 1);
    return expect(quotation.get('attachments.firstObject')).toEqual(file);
  });
  it('can add attachment', function() {
    var attachment, attachment2, quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    attachment = quotation.get('attachments').createRecord();
    attachment2 = quotation.get('attachments').createRecord();
    expect(quotation.get('attachments.length')).toEqual(2);
    expect(quotation.get('attachments').objectAt(0)).toEqual(attachment);
    return expect(quotation.get('attachments').objectAt(1)).toEqual(attachment2);
  });
  it('can delete attachment', function() {
    var attachment, attachment2, quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    attachment = quotation.get('attachments').createRecord();
    attachment2 = quotation.get('attachments').createRecord();
    expect(quotation.get('attachments.length')).toEqual(2);
    quotation.get('attachments').removeObject(attachment);
    quotation.get('attachments').removeObject(attachment2);
    return expect(quotation.get('attachments.length')).toEqual(0);
  });
  it('issuer belongsTo relationship', function() {
    var issuer, quotation;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1
    });
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1,
      issuer: "/api/v1/user/1/"
    });
    issuer = store.find(Vosae.User, 1);
    quotation = store.find(Vosae.Quotation, 1);
    return expect(quotation.get('issuer')).toEqual(issuer);
  });
  it('organization belongsTo relationship', function() {
    var organization, quotation;
    store.adapterForType(Vosae.Organization).load(store, Vosae.Organization, {
      id: 1
    });
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1,
      organization: "/api/v1/organization/1/"
    });
    organization = store.find(Vosae.Organization, 1);
    quotation = store.find(Vosae.Quotation, 1);
    return expect(quotation.get('organization')).toEqual(organization);
  });
  it('contact belongsTo relationship', function() {
    var contact, quotation;
    store.adapterForType(Vosae.Contact).load(store, Vosae.Contact, {
      id: 1
    });
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1,
      contact: "/api/v1/contact/1/"
    });
    contact = store.find(Vosae.Contact, 1);
    quotation = store.find(Vosae.Quotation, 1);
    return expect(quotation.get('contact')).toEqual(contact);
  });
  it('invoiceRevision belongsTo relationship', function() {
    var quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1,
      current_revision: {
        state: "DRAFT"
      }
    });
    quotation = store.find(Vosae.Quotation, 1);
    return expect(quotation.get('currentRevision.state')).toEqual("DRAFT");
  });
  it('isUpdatingState property should be false by default', function() {
    var quotation;
    quotation = store.createRecord(Vosae.Quotation, {});
    return expect(quotation.get('isUpdatingState')).toEqual(false);
  });
  it('isGeneratingPdfState property should be false by default', function() {
    var quotation;
    quotation = store.createRecord(Vosae.Quotation, {});
    return expect(quotation.get('isGeneratingPdfState')).toEqual(false);
  });
  it('relatedColor property should return orange', function() {
    var quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    return expect(quotation.get('relatedColor')).toEqual("orange");
  });
  it('isInvoice property should return false', function() {
    var quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    return expect(quotation.get('isInvoice')).toBeFalsy();
  });
  it('isQuotation property should return false', function() {
    var quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    return expect(quotation.get('isQuotation')).toBeTruthy();
  });
  it('isCreditNote property should return true', function() {
    var quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    return expect(quotation.get('isCreditNote')).toBeFalsy();
  });
  it('isPurchaseOrder property should return true', function() {
    var quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    return expect(quotation.get('isPurchaseOrder')).toBeFalsy();
  });
  it('displayState property should return the acutal state formated', function() {
    var quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    return Vosae.quotationStatesChoices.forEach(function(state) {
      quotation.set('state', state.get('value'));
      return expect(quotation.get('displayState')).toBeTruthy();
    });
  });
  it('availableStates return an array with the available states based on the current state', function() {
    var availableStates, quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    availableStates = quotation.get('availableStates');
    expect(availableStates).toEqual([]);
    quotation.set("state", "DRAFT");
    availableStates = quotation.get('availableStates');
    expect(availableStates.get('length')).toEqual(3);
    expect(availableStates.getEach('label')).toContain("Awaiting approval");
    expect(availableStates.getEach('label')).toContain("Approved");
    expect(availableStates.getEach('label')).toContain("Refused");
    quotation.set("state", "AWAITING_APPROVAL");
    availableStates = quotation.get('availableStates');
    expect(availableStates.get('length')).toEqual(2);
    expect(availableStates.getEach('label')).toContain("Approved");
    expect(availableStates.getEach('label')).toContain("Refused");
    quotation.set("state", "EXPIRED");
    availableStates = quotation.get('availableStates');
    expect(availableStates.get('length')).toEqual(3);
    expect(availableStates.getEach('label')).toContain("Awaiting approval");
    expect(availableStates.getEach('label')).toContain("Approved");
    expect(availableStates.getEach('label')).toContain("Refused");
    quotation.set("state", "REFUSED");
    availableStates = quotation.get('availableStates');
    expect(availableStates.get('length')).toEqual(2);
    expect(availableStates.getEach('label')).toContain("Awaiting approval");
    return expect(availableStates.getEach('label')).toContain("Approved");
  });
  it('isInvoiceable property return true if quotation can be transform to an invoice', function() {
    var quotation;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    quotation.set("group", store.find(Vosae.InvoiceBaseGroup, 1));
    expect(quotation.get('isInvoiceable')).toEqual(true);
    quotation.set("group.relatedInvoice", store.find(Vosae.Invoice, 1));
    return expect(quotation.get('isInvoiceable')).toEqual(false);
  });
  it('isModifiable property return true if quotation can be edited', function() {
    var quotation;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    store.adapterForType(Vosae.InvoiceBaseGroup).load(store, Vosae.InvoiceBaseGroup, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    quotation.set("group", store.find(Vosae.InvoiceBaseGroup, 1));
    expect(quotation.get('isModifiable')).toEqual(true);
    quotation.set("group.relatedInvoice", store.find(Vosae.Invoice, 1));
    return expect(quotation.get('isModifiable')).toEqual(false);
  });
  it('isDeletable property return true if quotation can be deleted', function() {
    var quotation;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    quotation.set("group", store.find(Vosae.InvoiceBaseGroup, 1));
    expect(quotation.get('isDeletable')).toEqual(true);
    quotation.set("group.relatedInvoice", store.find(Vosae.Invoice, 1));
    expect(quotation.get('isDeletable')).toEqual(false);
    quotation.set("group.relatedInvoice", null);
    quotation.get("group.downPaymentInvoices").createRecord();
    expect(quotation.get('isDeletable')).toEqual(false);
    quotation.setProperties({
      "group.downPaymentInvoices.content": [],
      "id": null
    });
    return expect(quotation.get('isDeletable')).toEqual(false);
  });
  it('isIssuable property return true if quotation could be sent', function() {
    var quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    expect(quotation.get('isIssuable')).toEqual(false);
    quotation.set("state", "DRAFT");
    expect(quotation.get('isIssuable')).toEqual(false);
    quotation.set("state", "EXPIRED");
    expect(quotation.get('isIssuable')).toEqual(true);
    quotation.set("state", "AWAITING_APPROVAL");
    expect(quotation.get('isIssuable')).toEqual(true);
    quotation.set("state", "REFUSED");
    expect(quotation.get('isIssuable')).toEqual(true);
    quotation.set("state", "APPROVED");
    expect(quotation.get('isIssuable')).toEqual(true);
    quotation.set("state", "INVOICED");
    return expect(quotation.get('isIssuable')).toEqual(true);
  });
  it('isInvoiced property return true if quotation is invoiced', function() {
    var quotation;
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    expect(quotation.get('isInvoiced')).toEqual(false);
    quotation.set("state", "DRAFT");
    expect(quotation.get('isInvoiced')).toEqual(false);
    quotation.set("state", "EXPIRED");
    expect(quotation.get('isInvoiced')).toEqual(false);
    quotation.set("state", "AWAITING_APPROVAL");
    expect(quotation.get('isInvoiced')).toEqual(false);
    quotation.set("state", "REFUSED");
    expect(quotation.get('isInvoiced')).toEqual(false);
    quotation.set("state", "APPROVED");
    expect(quotation.get('isInvoiced')).toEqual(false);
    quotation.set("state", "INVOICED");
    return expect(quotation.get('isInvoiced')).toEqual(true);
  });
  return it('makeInvoice() method should make an Invoice based on the quotation', function() {
    var controller, quotation;
    store.adapterForType(Vosae.Invoice).load(store, Vosae.Invoice, {
      id: 1
    });
    store.adapterForType(Vosae.Quotation).load(store, Vosae.Quotation, {
      id: 1
    });
    quotation = store.find(Vosae.Quotation, 1);
    controller = Vosae.lookup("controller:quotation.edit");
    controller.transitionToRoute = function() {};
    quotation.makeInvoice(controller);
    expect(quotation.get('isMakingInvoice')).toEqual(true);
    expectAjaxURL("/quotation/1/make_invoice/");
    expectAjaxType("PUT");
    ajaxHash.success({
      invoice_uri: "/api/v1/invoice/1/"
    });
    expectAjaxType("GET");
    expectAjaxURL("/quotation/1/");
    ajaxHash.success({
      state: "INVOICED"
    });
    return expect(quotation.get('isMakingInvoice')).toEqual(false);
  });
});

var store;

store = null;

describe('Vosae.Tax', function() {
  var hashTax;
  hashTax = {
    name: null,
    rate: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Tax);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all tax makes a GET to /tax/', function() {
    var tax, taxes;
    taxes = store.find(Vosae.Tax);
    enabledFlags(taxes, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/tax/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashTax, {
          id: 1,
          name: "TVA",
          rate: 0.196
        })
      ]
    });
    tax = taxes.objectAt(0);
    statesEqual(taxes, 'loaded.saved');
    stateEquals(tax, 'loaded.saved');
    enabledFlagsForArray(taxes, ['isLoaded', 'isValid']);
    enabledFlags(tax, ['isLoaded', 'isValid']);
    return expect(tax).toEqual(store.find(Vosae.Tax, 1));
  });
  it('finding a tax by ID makes a GET to /tax/:id/', function() {
    var tax;
    tax = store.find(Vosae.Tax, 1);
    stateEquals(tax, 'loading');
    enabledFlags(tax, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/tax/1/");
    ajaxHash.success($.extend({}, hashTax, {
      id: 1,
      name: "TVA",
      rate: 0.196,
      resource_uri: "/api/v1/tax/1/"
    }));
    stateEquals(tax, 'loaded.saved');
    enabledFlags(tax, ['isLoaded', 'isValid']);
    return expect(tax).toEqual(store.find(Vosae.Tax, 1));
  });
  it('finding taxes by query makes a GET to /tax/:query/', function() {
    var taxes, tva, tva2;
    taxes = store.find(Vosae.Tax, {
      page: 1
    });
    expect(taxes.get('length')).toEqual(0);
    enabledFlags(taxes, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/tax/");
    expectAjaxType("GET");
    expectAjaxData({
      page: 1
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashTax, {
          id: 1,
          name: "TVA",
          rate: 0.196
        }), $.extend({}, hashTax, {
          id: 2,
          name: "TVA2",
          rate: 0.055
        })
      ]
    });
    tva = taxes.objectAt(0);
    tva2 = taxes.objectAt(1);
    statesEqual([tva, tva2], 'loaded.saved');
    enabledFlags(taxes, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([tva, tva2], ['isLoaded'], recordArrayFlags);
    expect(taxes.get('length')).toEqual(2);
    expect(tva.get('name')).toEqual("TVA");
    expect(tva2.get('name')).toEqual("TVA2");
    expect(tva.get('id')).toEqual("1");
    return expect(tva2.get('id')).toEqual("2");
  });
  it('creating a tax makes a POST to /tax/', function() {
    var tax;
    tax = store.createRecord(Vosae.Tax, {
      name: "TVA",
      rate: 0.196
    });
    stateEquals(tax, 'loaded.created.uncommitted');
    enabledFlags(tax, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    tax.get('transaction').commit();
    stateEquals(tax, 'loaded.created.inFlight');
    enabledFlags(tax, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/tax/");
    expectAjaxType("POST");
    expectAjaxData($.extend({}, hashTax, {
      name: "TVA",
      rate: 0.196
    }));
    ajaxHash.success($.extend({}, hashTax, {
      id: 1,
      name: "TVA",
      rate: 0.196,
      resource_uri: "/api/v1/tax/1/"
    }));
    stateEquals(tax, 'loaded.saved');
    enabledFlags(tax, ['isLoaded', 'isValid']);
    return expect(tax).toEqual(store.find(Vosae.Tax, 1));
  });
  it('updating an tax makes a PUT to /tax/:id/', function() {
    var tax;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1,
      name: "TVA",
      rate: 0.196
    });
    tax = store.find(Vosae.Tax, 1);
    stateEquals(tax, 'loaded.saved');
    enabledFlags(tax, ['isLoaded', 'isValid']);
    tax.setProperties({
      rate: 0.055
    });
    stateEquals(tax, 'loaded.updated.uncommitted');
    enabledFlags(tax, ['isLoaded', 'isDirty', 'isValid']);
    tax.get('transaction').commit();
    stateEquals(tax, 'loaded.updated.inFlight');
    enabledFlags(tax, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/tax/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, hashTax, {
      name: "TVA",
      rate: 0.055
    }));
    ajaxHash.success($.extend({}, hashTax, {
      id: 1,
      name: "TVA",
      rate: 0.055
    }));
    stateEquals(tax, 'loaded.saved');
    enabledFlags(tax, ['isLoaded', 'isValid']);
    expect(tax).toEqual(store.find(Vosae.Tax, 1));
    return expect(tax.get('rate')).toEqual(0.055);
  });
  it('deleting a tax makes a DELETE to /tax/:id/', function() {
    var tax;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1,
      name: "TVA",
      rate: 0.196
    });
    tax = store.find(Vosae.Tax, 1);
    stateEquals(tax, 'loaded.saved');
    enabledFlags(tax, ['isLoaded', 'isValid']);
    tax.deleteRecord();
    stateEquals(tax, 'deleted.uncommitted');
    enabledFlags(tax, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']);
    tax.get('transaction').commit();
    stateEquals(tax, 'deleted.inFlight');
    enabledFlags(tax, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']);
    expectAjaxURL("/tax/1/");
    expectAjaxType("DELETE");
    ajaxHash.success();
    stateEquals(tax, 'deleted.saved');
    return enabledFlags(tax, ['isLoaded', 'isDeleted', 'isValid']);
  });
  it('displayTax property should contact tax name and rate', function() {
    var tax;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1,
      name: "TVA",
      rate: 0.196
    });
    tax = store.find(Vosae.Tax, 1);
    return expect(tax.get('displayTax')).toEqual("TVA 19.60%");
  });
  return it('displayRate property should format the tax rate', function() {
    var tax;
    store.adapterForType(Vosae.Tax).load(store, Vosae.Tax, {
      id: 1,
      name: "TVA",
      rate: 0.196
    });
    tax = store.find(Vosae.Tax, 1);
    return expect(tax.get('displayRate')).toEqual("19.60%");
  });
});

var store;

store = null;

describe('Vosae.Attendee', function() {
  var hashAttendee;
  hashAttendee = {
    email: null,
    display_name: null,
    organizer: null,
    photo_uri: null,
    optional: null,
    response_status: null,
    comment: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.Attendee);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding a attendee by ID makes a GET to /attendee/:id/', function() {
    var attendee;
    attendee = store.find(Vosae.Attendee, 1);
    ajaxHash.success($.extend, {}, hashAttendee, {
      id: 1
    });
    expectAjaxType("GET");
    expectAjaxURL("/attendee/1/");
    return expect(attendee).toEqual(store.find(Vosae.Attendee, 1));
  });
  return it('vosaeUser belongsTo relationship', function() {
    var attendee, user;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1
    });
    store.adapterForType(Vosae.Attendee).load(store, Vosae.Attendee, {
      id: 1,
      vosae_user: "/api/v1/user/1/"
    });
    user = store.find(Vosae.User, 1);
    attendee = store.find(Vosae.Attendee, 1);
    return expect(attendee.get('vosaeUser')).toEqual(user);
  });
});

var store;

store = null;

describe('Vosae.VosaeCalendar', function() {
  var hashVosaeCalendar;
  hashVosaeCalendar = {
    summary: null,
    description: null,
    location: null,
    timezone: null,
    acl: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.VosaeCalendar);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all vosaeCalendar makes a GET to /vosae_calendar/', function() {
    var vosaeCalendar, vosaeCalendars;
    vosaeCalendars = store.find(Vosae.VosaeCalendar);
    enabledFlags(vosaeCalendars, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/vosae_calendar/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashVosaeCalendar, {
          id: 1,
          summary: "My vosaeCalendar"
        })
      ]
    });
    vosaeCalendar = vosaeCalendars.objectAt(0);
    statesEqual(vosaeCalendars, 'loaded.saved');
    stateEquals(vosaeCalendar, 'loaded.saved');
    enabledFlagsForArray(vosaeCalendars, ['isLoaded', 'isValid']);
    enabledFlags(vosaeCalendar, ['isLoaded', 'isValid']);
    return expect(vosaeCalendar).toEqual(store.find(Vosae.VosaeCalendar, 1));
  });
  it('finding a vosaeCalendar by ID makes a GET to /vosae_calendar/:id/', function() {
    var vosaeCalendar;
    vosaeCalendar = store.find(Vosae.VosaeCalendar, 1);
    stateEquals(vosaeCalendar, 'loading');
    enabledFlags(vosaeCalendar, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/vosae_calendar/1/");
    ajaxHash.success($.extend({}, hashVosaeCalendar, {
      id: 1,
      summary: "My vosaeCalendar"
    }));
    stateEquals(vosaeCalendar, 'loaded.saved');
    enabledFlags(vosaeCalendar, ['isLoaded', 'isValid']);
    return expect(vosaeCalendar).toEqual(store.find(Vosae.VosaeCalendar, 1));
  });
  it('finding vosaeCalendars by query makes a GET to /vosae_calendar/:query/', function() {
    var vosaeCalendar1, vosaeCalendar2, vosaeCalendars;
    vosaeCalendars = store.find(Vosae.VosaeCalendar, {
      page: 1
    });
    expect(vosaeCalendars.get('length')).toEqual(0);
    enabledFlags(vosaeCalendars, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/vosae_calendar/");
    expectAjaxType("GET");
    expectAjaxData({
      page: 1
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashVosaeCalendar, {
          id: 1,
          summary: "My vosaeCalendar 1"
        }), $.extend({}, hashVosaeCalendar, {
          id: 2,
          summary: "My vosaeCalendar 2"
        })
      ]
    });
    vosaeCalendar1 = vosaeCalendars.objectAt(0);
    vosaeCalendar2 = vosaeCalendars.objectAt(1);
    statesEqual([vosaeCalendar1, vosaeCalendar2], 'loaded.saved');
    enabledFlags(vosaeCalendars, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([vosaeCalendar1, vosaeCalendar2], ['isLoaded'], recordArrayFlags);
    expect(vosaeCalendars.get('length')).toEqual(2);
    expect(vosaeCalendar1.get('summary')).toEqual("My vosaeCalendar 1");
    expect(vosaeCalendar2.get('summary')).toEqual("My vosaeCalendar 2");
    expect(vosaeCalendar1.get('id')).toEqual("1");
    return expect(vosaeCalendar2.get('id')).toEqual("2");
  });
  it('creating a vosaeCalendar makes a POST to /vosae_calendar/', function() {
    var vosaeCalendar;
    vosaeCalendar = store.createRecord(Vosae.VosaeCalendar, {
      summary: "My vosaeCalendar"
    });
    stateEquals(vosaeCalendar, 'loaded.created.uncommitted');
    enabledFlags(vosaeCalendar, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    vosaeCalendar.get('transaction').commit();
    stateEquals(vosaeCalendar, 'loaded.created.inFlight');
    enabledFlags(vosaeCalendar, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/vosae_calendar/");
    expectAjaxType("POST");
    expectAjaxData($.extend({}, hashVosaeCalendar, {
      summary: "My vosaeCalendar"
    }));
    ajaxHash.success($.extend({}, hashVosaeCalendar, {
      id: 1,
      summary: "My vosaeCalendar",
      resource_uri: "/api/v1/vosae_calendar/1/"
    }));
    stateEquals(vosaeCalendar, 'loaded.saved');
    enabledFlags(vosaeCalendar, ['isLoaded', 'isValid']);
    return expect(vosaeCalendar).toEqual(store.find(Vosae.VosaeCalendar, 1));
  });
  it('updating a vosaeCalendar makes a PUT to /vosae_calendar/:id/', function() {
    var vosaeCalendar;
    store.load(Vosae.VosaeCalendar, {
      id: 1,
      summary: "My vosaeCalendar"
    });
    vosaeCalendar = store.find(Vosae.VosaeCalendar, 1);
    stateEquals(vosaeCalendar, 'loaded.saved');
    enabledFlags(vosaeCalendar, ['isLoaded', 'isValid']);
    vosaeCalendar.setProperties({
      summary: "My vosaeCalendar edited"
    });
    stateEquals(vosaeCalendar, 'loaded.updated.uncommitted');
    enabledFlags(vosaeCalendar, ['isLoaded', 'isDirty', 'isValid']);
    vosaeCalendar.get('transaction').commit();
    stateEquals(vosaeCalendar, 'loaded.updated.inFlight');
    enabledFlags(vosaeCalendar, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/vosae_calendar/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, hashVosaeCalendar, {
      summary: "My vosaeCalendar edited"
    }));
    ajaxHash.success($.extend({}, hashVosaeCalendar, {
      id: 1,
      summary: "My vosaeCalendar edited"
    }));
    stateEquals(vosaeCalendar, 'loaded.saved');
    enabledFlags(vosaeCalendar, ['isLoaded', 'isValid']);
    expect(vosaeCalendar).toEqual(store.find(Vosae.VosaeCalendar, 1));
    return expect(vosaeCalendar.get('summary')).toEqual('My vosaeCalendar edited');
  });
  it('deleting a vosaeCalendar makes a DELETE to /vosae_calendar/:id/', function() {
    var vosaeCalendar;
    store.load(Vosae.VosaeCalendar, {
      id: 1
    });
    vosaeCalendar = store.find(Vosae.VosaeCalendar, 1);
    stateEquals(vosaeCalendar, 'loaded.saved');
    enabledFlags(vosaeCalendar, ['isLoaded', 'isValid']);
    vosaeCalendar.deleteRecord();
    stateEquals(vosaeCalendar, 'deleted.uncommitted');
    enabledFlags(vosaeCalendar, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']);
    vosaeCalendar.get('transaction').commit();
    stateEquals(vosaeCalendar, 'deleted.inFlight');
    enabledFlags(vosaeCalendar, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']);
    expectAjaxURL("/vosae_calendar/1/");
    expectAjaxType("DELETE");
    ajaxHash.success();
    stateEquals(vosaeCalendar, 'deleted.saved');
    return enabledFlags(vosaeCalendar, ['isLoaded', 'isDeleted', 'isValid']);
  });
  return it('acl embedded belongsTo relationship', function() {
    var vosaeCalendar;
    store.adapterForType(Vosae.VosaeCalendar).load(store, Vosae.VosaeCalendar, {
      id: 1,
      acl: {
        rules: [
          {
            role: "OWNER"
          }
        ]
      }
    });
    vosaeCalendar = store.find(Vosae.VosaeCalendar, 1);
    return expect(vosaeCalendar.get('acl.rules.firstObject.role')).toEqual("OWNER");
  });
});

var store;

store = null;

describe('Vosae.CalendarAcl', function() {
  var hashCalendarAcl;
  hashCalendarAcl = {
    rules: []
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.CalendarAcl);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  return it('vosaeUser hasMany relationship', function() {
    var calendarAcl, calendarAclRule;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1
    });
    store.adapterForType(Vosae.CalendarAcl).load(store, Vosae.CalendarAcl, {
      id: 1,
      rules: [
        {
          principal: "/api/v1/user/1/",
          role: "NONE"
        }
      ]
    });
    calendarAcl = store.find(Vosae.CalendarAcl, 1);
    calendarAclRule = calendarAcl.get('rules').objectAt(0);
    return expect(calendarAcl.get('rules.firstObject')).toEqual(calendarAclRule);
  });
});

var store;

store = null;

describe('Vosae.CalendarAclRule', function() {
  var hashCalendarAclRule;
  hashCalendarAclRule = {
    rules: []
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.CalendarAclRule);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('principal belongsTo relationship', function() {
    var calendarAclRule, user;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1
    });
    store.adapterForType(Vosae.CalendarAclRule).load(store, Vosae.CalendarAclRule, {
      id: 1,
      principal: "/api/v1/user/1/",
      role: "NONE"
    });
    user = store.find(Vosae.User, 1);
    calendarAclRule = store.find(Vosae.CalendarAclRule, 1);
    return expect(calendarAclRule.get('principal')).toEqual(user);
  });
  return it('displayRole property should return and format the role', function() {
    var calendarAclRule;
    store.adapterForType(Vosae.CalendarAclRule).load(store, Vosae.CalendarAclRule, {
      id: 1
    });
    calendarAclRule = store.find(Vosae.CalendarAclRule, 1);
    expect(calendarAclRule.get('displayRole')).toEqual('');
    return Vosae.calendarAclRuleRoles.forEach(function(role) {
      calendarAclRule.set('role', role.get('value'));
      return expect(calendarAclRule.get('displayRole')).toEqual(role.get('displayName'));
    });
  });
});

var store;

store = null;

describe('Vosae.CalendarList', function() {
  var hashCalendarList;
  hashCalendarList = {
    summary: null,
    description: null,
    location: null,
    timezone: null,
    summary_override: null,
    color: null,
    selected: true,
    is_own: true,
    reminders: []
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.CalendarList);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all calendarList makes a GET to /calendar_list/', function() {
    var calendarList, calendarLists;
    calendarLists = store.find(Vosae.CalendarList);
    enabledFlags(calendarLists, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/calendar_list/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashCalendarList, {
          id: 1,
          summary: "My calendarList"
        })
      ]
    });
    calendarList = calendarLists.objectAt(0);
    statesEqual(calendarLists, 'loaded.saved');
    stateEquals(calendarList, 'loaded.saved');
    enabledFlagsForArray(calendarLists, ['isLoaded', 'isValid']);
    enabledFlags(calendarList, ['isLoaded', 'isValid']);
    return expect(calendarList).toEqual(store.find(Vosae.CalendarList, 1));
  });
  it('finding a calendarList by ID makes a GET to /calendar_list/:id/', function() {
    var calendarList;
    calendarList = store.find(Vosae.CalendarList, 1);
    stateEquals(calendarList, 'loading');
    enabledFlags(calendarList, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/calendar_list/1/");
    ajaxHash.success($.extend({}, hashCalendarList, {
      id: 1,
      summary: "My calendarList"
    }));
    stateEquals(calendarList, 'loaded.saved');
    enabledFlags(calendarList, ['isLoaded', 'isValid']);
    return expect(calendarList).toEqual(store.find(Vosae.CalendarList, 1));
  });
  it('finding calendarLists by query makes a GET to /calendar_list/:query/', function() {
    var calendarList1, calendarList2, calendarLists;
    calendarLists = store.find(Vosae.CalendarList, {
      page: 1
    });
    expect(calendarLists.get('length')).toEqual(0);
    enabledFlags(calendarLists, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/calendar_list/");
    expectAjaxType("GET");
    expectAjaxData({
      page: 1
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashCalendarList, {
          id: 1,
          summary: "My calendarList 1"
        }), $.extend({}, hashCalendarList, {
          id: 2,
          summary: "My calendarList 2"
        })
      ]
    });
    calendarList1 = calendarLists.objectAt(0);
    calendarList2 = calendarLists.objectAt(1);
    statesEqual([calendarList1, calendarList2], 'loaded.saved');
    enabledFlags(calendarLists, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([calendarList1, calendarList2], ['isLoaded'], recordArrayFlags);
    expect(calendarLists.get('length')).toEqual(2);
    expect(calendarList1.get('summary')).toEqual("My calendarList 1");
    expect(calendarList2.get('summary')).toEqual("My calendarList 2");
    expect(calendarList1.get('id')).toEqual("1");
    return expect(calendarList2.get('id')).toEqual("2");
  });
  it('creating a calendarList makes a POST to /calendar_list/', function() {
    var calendarList;
    calendarList = store.createRecord(Vosae.CalendarList, {
      summary: "My calendarList"
    });
    stateEquals(calendarList, 'loaded.created.uncommitted');
    enabledFlags(calendarList, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    calendarList.get('transaction').commit();
    stateEquals(calendarList, 'loaded.created.inFlight');
    enabledFlags(calendarList, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/calendar_list/");
    expectAjaxType("POST");
    expectAjaxData($.extend({}, hashCalendarList, {
      summary: "My calendarList"
    }));
    ajaxHash.success($.extend({}, hashCalendarList, {
      id: 1,
      summary: "My calendarList",
      resource_uri: "/api/v1/calendar_list/1/"
    }));
    stateEquals(calendarList, 'loaded.saved');
    enabledFlags(calendarList, ['isLoaded', 'isValid']);
    return expect(calendarList).toEqual(store.find(Vosae.CalendarList, 1));
  });
  it('updating a calendarList makes a PUT to /calendar_list/:id/', function() {
    var calendarList;
    store.load(Vosae.CalendarList, {
      id: 1,
      summary: "My calendarList"
    });
    calendarList = store.find(Vosae.CalendarList, 1);
    stateEquals(calendarList, 'loaded.saved');
    enabledFlags(calendarList, ['isLoaded', 'isValid']);
    calendarList.setProperties({
      summary: "My calendarList edited",
      isOwn: true,
      selected: true
    });
    stateEquals(calendarList, 'loaded.updated.uncommitted');
    enabledFlags(calendarList, ['isLoaded', 'isDirty', 'isValid']);
    calendarList.get('transaction').commit();
    stateEquals(calendarList, 'loaded.updated.inFlight');
    enabledFlags(calendarList, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/calendar_list/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, hashCalendarList, {
      summary: "My calendarList edited"
    }));
    ajaxHash.success($.extend({}, hashCalendarList, {
      id: 1,
      summary: "My calendarList edited"
    }));
    stateEquals(calendarList, 'loaded.saved');
    enabledFlags(calendarList, ['isLoaded', 'isValid']);
    expect(calendarList).toEqual(store.find(Vosae.CalendarList, 1));
    return expect(calendarList.get('summary')).toEqual('My calendarList edited');
  });
  it('deleting a calendarList makes a DELETE to /calendar_list/:id/', function() {
    var calendarList;
    store.load(Vosae.CalendarList, {
      id: 1
    });
    calendarList = store.find(Vosae.CalendarList, 1);
    stateEquals(calendarList, 'loaded.saved');
    enabledFlags(calendarList, ['isLoaded', 'isValid']);
    calendarList.deleteRecord();
    stateEquals(calendarList, 'deleted.uncommitted');
    enabledFlags(calendarList, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']);
    calendarList.get('transaction').commit();
    stateEquals(calendarList, 'deleted.inFlight');
    enabledFlags(calendarList, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']);
    expectAjaxURL("/calendar_list/1/");
    expectAjaxType("DELETE");
    ajaxHash.success();
    stateEquals(calendarList, 'deleted.saved');
    return enabledFlags(calendarList, ['isLoaded', 'isDeleted', 'isValid']);
  });
  it('selected property should be equal to true by default', function() {
    var calendarList;
    calendarList = store.createRecord(Vosae.CalendarList, {});
    return expect(calendarList.get('selected')).toEqual(true);
  });
  it('isOwn property should be equal to true by default', function() {
    var calendarList;
    calendarList = store.createRecord(Vosae.CalendarList, {});
    return expect(calendarList.get('isOwn')).toEqual(true);
  });
  it('calendar belongsTo relationship', function() {
    var calendarList, vosaeCalendar;
    store.adapterForType(Vosae.VosaeCalendar).load(store, Vosae.VosaeCalendar, {
      id: 1
    });
    store.adapterForType(Vosae.CalendarList).load(store, Vosae.CalendarList, {
      id: 1,
      calendar: "/api/v1/vosae_calendar/1/"
    });
    vosaeCalendar = store.find(Vosae.VosaeCalendar, 1);
    calendarList = store.find(Vosae.CalendarList, 1);
    return expect(calendarList.get('calendar')).toEqual(vosaeCalendar);
  });
  it('displayName computed property return summaryOverride or summary', function() {
    var calendarList;
    store.adapterForType(Vosae.CalendarList).load(store, Vosae.CalendarList, {
      id: 1,
      calendar: "/api/v1/vosae_calendar/1/"
    });
    calendarList = store.find(Vosae.CalendarList, 1);
    expect(calendarList.get('displayName')).toBeFalsy();
    calendarList.set('summary', 'My summary');
    expect(calendarList.get('displayName')).toEqual('My summary');
    calendarList.set('summaryOverride', 'My summary override');
    return expect(calendarList.get('displayName')).toEqual('My summary override');
  });
  it('displayColor computed property should return the color fomarted', function() {
    var calendarList;
    store.adapterForType(Vosae.CalendarList).load(store, Vosae.CalendarList, {
      id: 1,
      calendar: "/api/v1/vosae_calendar/1/"
    });
    calendarList = store.find(Vosae.CalendarList, 1);
    expect(calendarList.get('displayColor')).toEqual('');
    return Vosae.calendarListColors.forEach(function(color) {
      calendarList.set('color', color.get('value'));
      return expect(calendarList.get('displayColor')).toEqual(color.get('displayName'));
    });
  });
  it('displayTimezone computed property should return the timezone fomarted', function() {
    var calendarList;
    store.adapterForType(Vosae.CalendarList).load(store, Vosae.CalendarList, {
      id: 1,
      calendar: "/api/v1/vosae_calendar/1/"
    });
    calendarList = store.find(Vosae.CalendarList, 1);
    expect(calendarList.get('displayTimezone')).toEqual('');
    return Vosae.timezones.forEach(function(timezone) {
      calendarList.set('timezone', timezone.get('value'));
      return expect(calendarList.get('displayTimezone')).toEqual(timezone.get('displayName'));
    });
  });
  return it('textColor property should return an hex color according to color', function() {
    var calendarList;
    store.adapterForType(Vosae.CalendarList).load(store, Vosae.CalendarList, {
      id: 1,
      calendar: "/api/v1/vosae_calendar/1/"
    });
    calendarList = store.find(Vosae.CalendarList, 1);
    expect(calendarList.get('textColor')).toEqual("#333");
    calendarList.set('color', '#000');
    expect(calendarList.get('textColor')).toEqual("#FEFEFE");
    calendarList.set('color', '#FFF');
    return expect(calendarList.get('textColor')).toEqual("#333");
  });
});

var store;

store = null;

describe('Vosae.VosaeEvent', function() {
  var hashEvent;
  hashEvent = {
    attendees: [],
    color: null,
    description: null,
    end: null,
    instance_id: null,
    location: null,
    original_start: null,
    recurrence: null,
    reminders: null,
    start: null,
    status: null,
    summary: null,
    transparency: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.VosaeEvent);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding all vosaeEvent makes a GET to /vosae_event/', function() {
    var vosaeEvent, vosaeEvents;
    vosaeEvents = store.find(Vosae.VosaeEvent);
    enabledFlags(vosaeEvents, ['isLoaded', 'isValid'], recordArrayFlags);
    expectAjaxURL("/vosae_event/");
    expectAjaxType("GET");
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashEvent, {
          id: 1,
          summary: "My vosaeEvent"
        })
      ]
    });
    vosaeEvent = vosaeEvents.objectAt(0);
    statesEqual(vosaeEvents, 'loaded.saved');
    stateEquals(vosaeEvent, 'loaded.saved');
    enabledFlagsForArray(vosaeEvents, ['isLoaded', 'isValid']);
    enabledFlags(vosaeEvent, ['isLoaded', 'isValid']);
    return expect(vosaeEvent).toEqual(store.find(Vosae.VosaeEvent, 1));
  });
  it('finding a vosaeEvent by ID makes a GET to /vosae_event/:id/', function() {
    var vosaeEvent;
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    stateEquals(vosaeEvent, 'loading');
    enabledFlags(vosaeEvent, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/vosae_event/1/");
    ajaxHash.success($.extend({}, hashEvent, {
      id: 1,
      summary: "My vosaeEvent"
    }));
    stateEquals(vosaeEvent, 'loaded.saved');
    enabledFlags(vosaeEvent, ['isLoaded', 'isValid']);
    return expect(vosaeEvent).toEqual(store.find(Vosae.VosaeEvent, 1));
  });
  it('finding vosaeEvents by query makes a GET to /vosae_event/:query/', function() {
    var vosaeEvent1, vosaeEvent2, vosaeEvents;
    vosaeEvents = store.find(Vosae.VosaeEvent, {
      page: 1
    });
    expect(vosaeEvents.get('length')).toEqual(0);
    enabledFlags(vosaeEvents, ['isLoading'], recordArrayFlags);
    expectAjaxURL("/vosae_event/");
    expectAjaxType("GET");
    expectAjaxData({
      page: 1
    });
    ajaxHash.success({
      meta: {},
      objects: [
        $.extend({}, hashEvent, {
          id: 1,
          summary: "My vosaeEvent 1"
        }), $.extend({}, hashEvent, {
          id: 2,
          summary: "My vosaeEvent 2"
        })
      ]
    });
    vosaeEvent1 = vosaeEvents.objectAt(0);
    vosaeEvent2 = vosaeEvents.objectAt(1);
    statesEqual([vosaeEvent1, vosaeEvent2], 'loaded.saved');
    enabledFlags(vosaeEvents, ['isLoaded'], recordArrayFlags);
    enabledFlagsForArray([vosaeEvent1, vosaeEvent2], ['isLoaded'], recordArrayFlags);
    expect(vosaeEvents.get('length')).toEqual(2);
    expect(vosaeEvent1.get('summary')).toEqual("My vosaeEvent 1");
    expect(vosaeEvent2.get('summary')).toEqual("My vosaeEvent 2");
    expect(vosaeEvent1.get('id')).toEqual("1");
    return expect(vosaeEvent2.get('id')).toEqual("2");
  });
  it('creating a vosaeEvent makes a POST to /vosae_event/', function() {
    var vosaeEvent;
    vosaeEvent = store.createRecord(Vosae.VosaeEvent, {
      summary: "My vosaeEvent"
    });
    stateEquals(vosaeEvent, 'loaded.created.uncommitted');
    enabledFlags(vosaeEvent, ['isLoaded', 'isDirty', 'isNew', 'isValid']);
    vosaeEvent.get('transaction').commit();
    stateEquals(vosaeEvent, 'loaded.created.inFlight');
    enabledFlags(vosaeEvent, ['isLoaded', 'isDirty', 'isNew', 'isValid', 'isSaving']);
    expectAjaxURL("/vosae_event/");
    expectAjaxType("POST");
    expectAjaxData($.extend({}, hashEvent, {
      summary: "My vosaeEvent"
    }));
    ajaxHash.success($.extend({}, hashEvent, {
      id: 1,
      summary: "My vosaeEvent",
      resource_uri: "/api/v1/vosae_event/1/"
    }));
    stateEquals(vosaeEvent, 'loaded.saved');
    enabledFlags(vosaeEvent, ['isLoaded', 'isValid']);
    return expect(vosaeEvent).toEqual(store.find(Vosae.VosaeEvent, 1));
  });
  it('updating a vosaeEvent makes a PUT to /vosae_event/:id/', function() {
    var vosaeEvent;
    store.load(Vosae.VosaeEvent, {
      id: 1,
      summary: "My vosaeEvent"
    });
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    stateEquals(vosaeEvent, 'loaded.saved');
    enabledFlags(vosaeEvent, ['isLoaded', 'isValid']);
    vosaeEvent.setProperties({
      summary: "My vosaeEvent edited"
    });
    stateEquals(vosaeEvent, 'loaded.updated.uncommitted');
    enabledFlags(vosaeEvent, ['isLoaded', 'isDirty', 'isValid']);
    vosaeEvent.get('transaction').commit();
    stateEquals(vosaeEvent, 'loaded.updated.inFlight');
    enabledFlags(vosaeEvent, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/vosae_event/1/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, hashEvent, {
      summary: "My vosaeEvent edited"
    }));
    ajaxHash.success($.extend({}, hashEvent, {
      id: 1,
      summary: "My vosaeEvent edited"
    }));
    stateEquals(vosaeEvent, 'loaded.saved');
    enabledFlags(vosaeEvent, ['isLoaded', 'isValid']);
    expect(vosaeEvent).toEqual(store.find(Vosae.VosaeEvent, 1));
    return expect(vosaeEvent.get('summary')).toEqual('My vosaeEvent edited');
  });
  it('deleting a vosaeEvent makes a DELETE to /vosae_event/:id/', function() {
    var vosaeEvent;
    store.load(Vosae.VosaeEvent, {
      id: 1
    });
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    stateEquals(vosaeEvent, 'loaded.saved');
    enabledFlags(vosaeEvent, ['isLoaded', 'isValid']);
    vosaeEvent.deleteRecord();
    stateEquals(vosaeEvent, 'deleted.uncommitted');
    enabledFlags(vosaeEvent, ['isLoaded', 'isDirty', 'isDeleted', 'isValid']);
    vosaeEvent.get('transaction').commit();
    stateEquals(vosaeEvent, 'deleted.inFlight');
    enabledFlags(vosaeEvent, ['isLoaded', 'isDirty', 'isSaving', 'isDeleted', 'isValid']);
    expectAjaxURL("/vosae_event/1/");
    expectAjaxType("DELETE");
    ajaxHash.success();
    stateEquals(vosaeEvent, 'deleted.saved');
    return enabledFlags(vosaeEvent, ['isLoaded', 'isDeleted', 'isValid']);
  });
  it('start embedded belongsTo relationship', function() {
    var vosaeEvent;
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1,
      start: {
        timezone: "UTC"
      }
    });
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    return expect(vosaeEvent.get('start.timezone')).toEqual("UTC");
  });
  it('end embedded belongsTo relationship', function() {
    var vosaeEvent;
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1,
      end: {
        timezone: "UTC"
      }
    });
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    return expect(vosaeEvent.get('end.timezone')).toEqual("UTC");
  });
  it('originalStart embedded belongsTo relationship', function() {
    var vosaeEvent;
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1,
      original_start: {
        timezone: "UTC"
      }
    });
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    return expect(vosaeEvent.get('originalStart.timezone')).toEqual("UTC");
  });
  it('calendar belongsTo relationship', function() {
    var calendar, vosaeEvent;
    store.adapterForType(Vosae.VosaeCalendar).load(store, Vosae.VosaeCalendar, {
      id: 1
    });
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1,
      calendar: "/api/v1/vosae_calendar/1/"
    });
    calendar = store.find(Vosae.VosaeCalendar, 1);
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    return expect(vosaeEvent.get('calendar')).toEqual(calendar);
  });
  it('calendarList belongsTo relationship', function() {
    var calendarList, vosaeEvent;
    store.adapterForType(Vosae.CalendarList).load(store, Vosae.CalendarList, {
      id: 1
    });
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1,
      calendar_list: "/api/v1/calendar_list/1/"
    });
    calendarList = store.find(Vosae.CalendarList, 1);
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    return expect(vosaeEvent.get('calendarList')).toEqual(calendarList);
  });
  it('creator belongsTo relationship', function() {
    var creator, vosaeEvent;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1
    });
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1,
      creator: "/api/v1/user/1/"
    });
    creator = store.find(Vosae.User, 1);
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    return expect(vosaeEvent.get('creator')).toEqual(creator);
  });
  it('organizer belongsTo relationship', function() {
    var organizer, vosaeEvent;
    store.adapterForType(Vosae.User).load(store, Vosae.User, {
      id: 1
    });
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1,
      organizer: "/api/v1/user/1/"
    });
    organizer = store.find(Vosae.User, 1);
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    return expect(vosaeEvent.get('organizer')).toEqual(organizer);
  });
  it('attendees embedded hasMany relationship', function() {
    var vosaeEvent;
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1,
      attendees: [
        {
          email: "test@vosae.com"
        }
      ]
    });
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    return expect(vosaeEvent.get('attendees.firstObject.email')).toEqual("test@vosae.com");
  });
  it('reminders embedded belongsTo relationship', function() {
    var vosaeEvent;
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1,
      reminders: {
        use_default: true
      }
    });
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    return expect(vosaeEvent.get('reminders.useDefault')).toEqual(true);
  });
  it('allDay property getter/setter', function() {
    var vosaeEvent;
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1
    });
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    expect(vosaeEvent.get('allDay')).toBeFalsy();
    vosaeEvent.set('start', store.createRecord(Vosae.EventDateTime, {}));
    vosaeEvent.set('start.date', new Date(2013, 7, 9));
    expect(vosaeEvent.get('allDay')).toBeFalsy();
    vosaeEvent.set('end', store.createRecord(Vosae.EventDateTime, {}));
    vosaeEvent.set('end.date', new Date(2013, 7, 9));
    expect(vosaeEvent.get('allDay')).toBeTruthy();
    vosaeEvent.set('allDay', true);
    expect(vosaeEvent.get('start.date')).toEqual(new Date(2013, 7, 9));
    expect(vosaeEvent.get('start.datetime')).toEqual(null);
    expect(vosaeEvent.get('end.date')).toEqual(new Date(2013, 7, 9));
    expect(vosaeEvent.get('end.datetime')).toEqual(null);
    vosaeEvent.set('start.date', null);
    vosaeEvent.set('start.datetime', new Date(2013, 7, 9));
    vosaeEvent.set('end.date', null);
    vosaeEvent.set('end.datetime', new Date(2013, 7, 9));
    vosaeEvent.set('allDay', true);
    expect(vosaeEvent.get('start.date')).toEqual(new Date(2013, 7, 9));
    expect(vosaeEvent.get('start.datetime')).toEqual(null);
    expect(vosaeEvent.get('end.date')).toEqual(new Date(2013, 7, 9));
    expect(vosaeEvent.get('end.datetime')).toEqual(null);
    vosaeEvent.set('start.date', new Date(2013, 7, 9));
    vosaeEvent.set('start.datetime', null);
    vosaeEvent.set('end.date', new Date(2013, 7, 9));
    vosaeEvent.set('end.datetime', null);
    vosaeEvent.set('allDay', false);
    expect(vosaeEvent.get('start.date')).toEqual(null);
    expect(vosaeEvent.get('start.datetime')).toEqual(new Date(2013, 7, 9));
    expect(vosaeEvent.get('end.date')).toEqual(null);
    expect(vosaeEvent.get('end.datetime')).toEqual(new Date(2013, 7, 9));
    vosaeEvent.set('start.date', new Date(2013, 7, 9));
    vosaeEvent.set('start.datetime', null);
    vosaeEvent.set('end.date', new Date(2013, 7, 9));
    vosaeEvent.set('end.datetime', null);
    vosaeEvent.set('allDay', false);
    expect(vosaeEvent.get('start.date')).toEqual(null);
    expect(vosaeEvent.get('start.datetime')).toEqual(new Date(2013, 7, 9));
    expect(vosaeEvent.get('end.date')).toEqual(null);
    return expect(vosaeEvent.get('end.datetime')).toEqual(new Date(2013, 7, 9));
  });
  it('displayDate should return and format start and end dates', function() {
    var vosaeEvent;
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1
    });
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    expect(vosaeEvent.get('displayDate')).toBeFalsy();
    vosaeEvent.set('start', store.createRecord(Vosae.EventDateTime, {}));
    vosaeEvent.set('start.date', new Date(2013, 7, 9));
    vosaeEvent.set('end', store.createRecord(Vosae.EventDateTime, {}));
    vosaeEvent.set('end.date', new Date(2013, 7, 10));
    return expect(vosaeEvent.get('displayDate')).toEqual('August Friday 9 - Saturday 10');
  });
  it('textColor property should return an hex color according to color', function() {
    var vosaeEvent;
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1
    });
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    expect(vosaeEvent.get('textColor')).toEqual("#333");
    vosaeEvent.set('color', '#000');
    expect(vosaeEvent.get('textColor')).toEqual("#FEFEFE");
    vosaeEvent.set('color', '#FFF');
    return expect(vosaeEvent.get('textColor')).toEqual("#333");
  });
  return it('getFullCalendarEvent() method should return a dict with event properties', function() {
    var vosaeEvent;
    store.adapterForType(Vosae.VosaeEvent).load(store, Vosae.VosaeEvent, {
      id: 1,
      summary: 'My title'
    });
    vosaeEvent = store.find(Vosae.VosaeEvent, 1);
    vosaeEvent.set('start', store.createRecord(Vosae.EventDateTime));
    vosaeEvent.set('start.date', new Date(2013, 7, 9));
    vosaeEvent.set('end', store.createRecord(Vosae.EventDateTime));
    vosaeEvent.set('end.date', new Date(2013, 7, 10));
    expect(vosaeEvent.getFullCalendarEvent()).toEqual({
      id: "1",
      title: 'My title',
      start: vosaeEvent.get('start.date'),
      end: vosaeEvent.get('end.date'),
      allDay: true
    });
    vosaeEvent.set('color', '#FFF');
    return expect(vosaeEvent.getFullCalendarEvent()).toEqual({
      id: "1",
      title: 'My title',
      start: vosaeEvent.get('start.date'),
      end: vosaeEvent.get('end.date'),
      allDay: true,
      color: "#FFF",
      textColor: "#333"
    });
  });
});

var store;

store = null;

describe('Vosae.EventDateTime', function() {
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.EventDateTime);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('allDay property getter/setter', function() {
    var date, datetime, eventDateTime;
    store.adapterForType(Vosae.EventDateTime).load(store, Vosae.EventDateTime, {
      id: 1
    });
    eventDateTime = store.find(Vosae.EventDateTime, 1);
    expect(eventDateTime.get('allDay')).toBeFalsy();
    eventDateTime.set('date', new Date(2013, 7, 9));
    expect(eventDateTime.get('allDay')).toBeTruthy();
    date = eventDateTime.get('date');
    eventDateTime.set('allDay', false);
    expect(eventDateTime.get('date')).toEqual(null);
    expect(eventDateTime.get('datetime')).toEqual(date);
    datetime = eventDateTime.get('datetime');
    eventDateTime.set('allDay', true);
    expect(eventDateTime.get('datetime')).toEqual(null);
    return expect(eventDateTime.get('date')).toEqual(moment(datetime).startOf('day').toDate());
  });
  it('dateOrDatetime property getter/setter', function() {
    var date, eventDateTime, expectedValue;
    store.adapterForType(Vosae.EventDateTime).load(store, Vosae.EventDateTime, {
      id: 1
    });
    eventDateTime = store.find(Vosae.EventDateTime, 1);
    expect(eventDateTime.get('dateOrDatetime')).toEqual(void 0);
    eventDateTime.set('date', new Date(2013, 7, 9));
    expect(eventDateTime.get('dateOrDatetime')).toEqual(eventDateTime.get('date'));
    eventDateTime.set('date', null);
    eventDateTime.set('datetime', new Date(2013, 7, 9));
    expect(eventDateTime.get('dateOrDatetime')).toEqual(eventDateTime.get('datetime'));
    date = new Date(2013, 7, 9);
    eventDateTime.set('dateOrDatetime', date);
    expect(eventDateTime.get('date')).toEqual(null);
    expect(eventDateTime.get('datetime')).toEqual(date);
    eventDateTime.set('datetime', null);
    eventDateTime.set('date', new Date(2013, 7, 9));
    date = new Date(2013, 7, 10);
    expectedValue = moment(date).startOf('day').toDate();
    eventDateTime.set('dateOrDatetime', date);
    expect(eventDateTime.get('date')).toEqual(expectedValue);
    return expect(eventDateTime.get('datetime')).toEqual(null);
  });
  it('onlyDate property getter/setter', function() {
    var dateTime, eventDateTime, expectedDateTime;
    store.adapterForType(Vosae.EventDateTime).load(store, Vosae.EventDateTime, {
      id: 1
    });
    eventDateTime = store.find(Vosae.EventDateTime, 1);
    expect((function() {
      return eventDateTime.get('onlyDate');
    })).toThrow(new Error("The onlyDate property must only be used to set the date"));
    dateTime = new Date(2013, 7, 9, 1, 1, 1);
    eventDateTime.set('dateOrDatetime', dateTime);
    eventDateTime.set('onlyDate', new Date(2013, 8, 10));
    expectedDateTime = new Date(2013, 8, 10, 1, 1, 1);
    return expect(eventDateTime.get('dateOrDatetime')).toEqual(expectedDateTime);
  });
  return it('onlyTime property getter/setter', function() {
    var date, eventDateTime, expectedDateTime;
    store.adapterForType(Vosae.EventDateTime).load(store, Vosae.EventDateTime, {
      id: 1
    });
    eventDateTime = store.find(Vosae.EventDateTime, 1);
    expect((function() {
      return eventDateTime.get('onlyTime');
    })).toThrow(new Error("The onlyTime property must only be used to set the time"));
    date = new Date(2013, 7, 9);
    eventDateTime.set('dateOrDatetime', date);
    eventDateTime.set('onlyTime', new Date(2013, 8, 10, 5, 5));
    expectedDateTime = new Date(2013, 7, 9, 5, 5);
    return expect(eventDateTime.get('dateOrDatetime')).toEqual(expectedDateTime);
  });
});

var store;

store = null;

describe('Vosae.ReminderEntry', function() {
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.ReminderEntry);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('minutes property should be equal to 10 by default', function() {
    var reminderEntry;
    reminderEntry = store.createRecord(Vosae.ReminderEntry, {});
    return expect(reminderEntry.get('minutes')).toEqual(10);
  });
  it('isPopup computed property should return true if reminder is a popup', function() {
    var reminderEntry;
    store.adapterForType(Vosae.ReminderEntry).load(store, Vosae.ReminderEntry, {
      id: 1
    });
    reminderEntry = store.find(Vosae.ReminderEntry, 1);
    expect(reminderEntry.get('isPopup')).toBeFalsy();
    reminderEntry.set('method', 'SOMETHINGSHITY');
    expect(reminderEntry.get('isPopup')).toBeFalsy();
    reminderEntry.set('method', 'POPUP');
    return expect(reminderEntry.get('isPopup')).toBeTruthy();
  });
  it('isEmail computed property should return true if reminder is an email', function() {
    var reminderEntry;
    store.adapterForType(Vosae.ReminderEntry).load(store, Vosae.ReminderEntry, {
      id: 1
    });
    reminderEntry = store.find(Vosae.ReminderEntry, 1);
    expect(reminderEntry.get('isEmail')).toBeFalsy();
    reminderEntry.set('method', 'SOMETHINGSHITY');
    expect(reminderEntry.get('isEmail')).toBeFalsy();
    reminderEntry.set('method', 'EMAIL');
    return expect(reminderEntry.get('isEmail')).toBeTruthy();
  });
  return it('displayMethod property should return and format the method', function() {
    var reminderEntry;
    store.adapterForType(Vosae.ReminderEntry).load(store, Vosae.ReminderEntry, {
      id: 1
    });
    reminderEntry = store.find(Vosae.ReminderEntry, 1);
    expect(reminderEntry.get('displayMethod')).toEqual('');
    return Vosae.reminderEntries.forEach(function(method) {
      reminderEntry.set('method', method.get('value'));
      return expect(reminderEntry.get('displayMethod')).toEqual(method.get('displayName'));
    });
  });
});

var store;

store = null;

describe('Vosae.ReminderSettings', function() {
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.ReminderSettings);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  return it('overrides hasMany relationship', function() {
    var reminderEntry, reminderSettings;
    store.adapterForType(Vosae.ReminderSettings).load(store, Vosae.ReminderSettings, {
      id: 1,
      overrides: [
        {
          method: "POPUP",
          minutes: 10
        }
      ]
    });
    reminderSettings = store.find(Vosae.ReminderSettings, 1);
    reminderEntry = reminderSettings.get('overrides').objectAt(0);
    return expect(reminderSettings.get('overrides.firstObject')).toEqual(reminderEntry);
  });
});

var store;

store = null;

describe('Vosae.TenantSettings', function() {
  var hashTenantSettings;
  hashTenantSettings = {
    core: null,
    invoicing: null
  };
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.TenantSettings);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('finding a tenant settings by ID makes a GET to /tenant_settings/:id/', function() {
    var tenantSettings;
    tenantSettings = store.find(Vosae.TenantSettings, 1);
    stateEquals(tenantSettings, 'loading');
    enabledFlags(tenantSettings, ['isLoading', 'isValid']);
    expectAjaxType("GET");
    expectAjaxURL("/tenant_settings/");
    ajaxHash.success($.extend({}, hashTenantSettings, {
      id: 1
    }));
    stateEquals(tenantSettings, 'loaded.saved');
    enabledFlags(tenantSettings, ['isLoaded', 'isValid']);
    return expect(tenantSettings).toEqual(store.find(Vosae.TenantSettings, 1));
  });
  it('updating a tenantSettings makes a PUT to /tenant_settings/', function() {
    var tenantSettings;
    store.adapterForType(Vosae.TenantSettings).load(store, Vosae.TenantSettings, {
      id: 1,
      invoicing: {
        payment_conditions: "CASH"
      }
    });
    tenantSettings = store.find(Vosae.TenantSettings, 1);
    stateEquals(tenantSettings, 'loaded.saved');
    enabledFlags(tenantSettings, ['isLoaded', 'isValid']);
    tenantSettings.set('invoicing', null);
    stateEquals(tenantSettings, 'loaded.updated.uncommitted');
    enabledFlags(tenantSettings, ['isLoaded', 'isDirty', 'isValid']);
    tenantSettings.get('transaction').commit();
    stateEquals(tenantSettings, 'loaded.updated.inFlight');
    enabledFlags(tenantSettings, ['isLoaded', 'isDirty', 'isSaving', 'isValid']);
    expectAjaxURL("/tenant_settings/");
    expectAjaxType("PUT");
    expectAjaxData($.extend({}, hashTenantSettings, {
      invoicing: null
    }));
    ajaxHash.success($.extend({}, hashTenantSettings, {
      id: 1
    }));
    stateEquals(tenantSettings, 'loaded.saved');
    enabledFlags(tenantSettings, ['isLoaded', 'isValid']);
    return expect(tenantSettings).toEqual(store.find(Vosae.TenantSettings, 1));
  });
  return it('invoicing belongsTo embedded relationship', function() {
    var tenantSettings;
    store.adapterForType(Vosae.TenantSettings).load(store, Vosae.TenantSettings, {
      id: 1,
      invoicing: {
        payment_conditions: "CASH"
      }
    });
    tenantSettings = store.find(Vosae.TenantSettings, 1);
    return expect(tenantSettings.get('invoicing.paymentConditions')).toEqual('CASH');
  });
});

var store;

store = null;

describe('Vosae.InvoicingNumberingSettings', function() {
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.InvoicingNumberingSettings);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('preview computed property should return a preview for invoicing numbering', function() {
    var invoicingNumberingSettings;
    store.adapterForType(Vosae.InvoicingNumberingSettings).load(store, Vosae.InvoicingNumberingSettings, {
      id: 1,
      date_format: "Ym",
      scheme: "DN",
      separator: "-"
    });
    invoicingNumberingSettings = store.find(Vosae.InvoicingNumberingSettings, 1);
    expect(invoicingNumberingSettings.get('preview')).toEqual(moment().format("YYYYMM") + "-" + "00000");
    invoicingNumberingSettings.set('separator', ';');
    expect(invoicingNumberingSettings.get('preview')).toEqual(moment().format("YYYYMM") + ";" + "00000");
    invoicingNumberingSettings.set('dateFormat', 'Ymd');
    expect(invoicingNumberingSettings.get('preview')).toEqual(moment().format("YYYYMMDD") + ";" + "00000");
    invoicingNumberingSettings.set('scheme', 'N');
    return expect(invoicingNumberingSettings.get('preview')).toEqual("00000");
  });
  return it('schemeIsNumber computed property should return true if scheme is number', function() {
    var invoicingNumberingSettings;
    store.adapterForType(Vosae.InvoicingNumberingSettings).load(store, Vosae.InvoicingNumberingSettings, {
      id: 1,
      scheme: "DN"
    });
    invoicingNumberingSettings = store.find(Vosae.InvoicingNumberingSettings, 1);
    expect(invoicingNumberingSettings.get('schemeIsNumber')).toBeFalsy();
    invoicingNumberingSettings.set('scheme', 'N');
    return expect(invoicingNumberingSettings.get('schemeIsNumber')).toBeTruthy();
  });
});

var store;

store = null;

describe('Vosae.InvoicingSettings', function() {
  beforeEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = getAdapterForTest(Vosae.InvoicingSettings);
    ajaxUrl = comp[0];
    ajaxType = comp[1];
    ajaxHash = comp[2];
    return store = comp[3];
  });
  afterEach(function() {
    var ajaxHash, ajaxType, ajaxUrl, comp;
    comp = void 0;
    ajaxUrl = void 0;
    ajaxType = void 0;
    ajaxHash = void 0;
    return store.destroy();
  });
  it('supportedCurrencies hasMany relationship', function() {
    var currency, invoicingSettings;
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1
    });
    store.adapterForType(Vosae.InvoicingSettings).load(store, Vosae.InvoicingSettings, {
      id: 1,
      supported_currencies: ["/api/v1/currency/1/"]
    });
    currency = store.find(Vosae.Currency, 1);
    invoicingSettings = store.find(Vosae.InvoicingSettings, 1);
    return expect(invoicingSettings.get('supportedCurrencies.firstObject')).toEqual(currency);
  });
  it('defaultCurrency belongsTo relationship', function() {
    var currency, invoicingSettings;
    store.adapterForType(Vosae.Currency).load(store, Vosae.Currency, {
      id: 1
    });
    store.adapterForType(Vosae.InvoicingSettings).load(store, Vosae.InvoicingSettings, {
      id: 1,
      default_currency: "/api/v1/currency/1/"
    });
    currency = store.find(Vosae.Currency, 1);
    invoicingSettings = store.find(Vosae.InvoicingSettings, 1);
    return expect(invoicingSettings.get('defaultCurrency')).toEqual(currency);
  });
  return it('numbering belongsTo embedded relationship', function() {
    var invoicingSettings;
    store.adapterForType(Vosae.InvoicingSettings).load(store, Vosae.InvoicingSettings, {
      id: 1,
      numbering: {
        separator: ";"
      }
    });
    invoicingSettings = store.find(Vosae.InvoicingSettings, 1);
    return expect(invoicingSettings.get('numbering.separator')).toEqual(";");
  });
});

var serializer;

serializer = null;

describe('Vosae.InvoiceBaseSerializer', function() {
  beforeEach(function() {
    return serializer = Vosae.InvoiceBaseSerializer.create();
  });
  afterEach(function() {
    return serializer.destroy();
  });
  return it('transformRelatedToRelationship method should update the json', function() {
    var data, json;
    data = {
      related_to: '/api/v1/down_payment_invoice/1'
    };
    json = serializer.transformRelatedToRelationship(data);
    expect(json['related_down_payment_invoice']).toEqual(data['related_to']);
    return expect(json.hasOwnProperty('related_to')).toEqual(false);
  });
});

describe('Accounting.js', function() {
  it('formatNumber()', function() {
    expect(accounting.formatNumber(0)).toEqual("0");
    expect(accounting.formatNumber(0.222222, {
      precision: 2
    })).toEqual("0.22");
    expect(accounting.formatNumber(0.456, {
      precision: 2
    })).toEqual("0.46");
    expect(accounting.formatNumber(1, {
      precision: 2
    })).toEqual("1.00");
    expect(accounting.formatNumber(10, {
      precision: 2
    })).toEqual("10.00");
    expect(accounting.formatNumber(100, {
      precision: 2
    })).toEqual("100.00");
    expect(accounting.formatNumber(1000, {
      precision: 2
    })).toEqual("1,000.00");
    expect(accounting.formatNumber(10000, {
      precision: 2
    })).toEqual("10,000.00");
    expect(accounting.formatNumber(100000, {
      precision: 2
    })).toEqual("100,000.00");
    return expect(accounting.formatNumber(1000000, {
      precision: 2
    })).toEqual("1,000,000.00");
  });
  return it('formatMoney()', function() {
    expect(accounting.formatMoney(0)).toEqual("0.00");
    expect(accounting.formatMoney(0.222222, {
      symbol: "$"
    })).toEqual("$0.22");
    expect(accounting.formatMoney(0.456, {
      symbol: "$"
    })).toEqual("$0.46");
    expect(accounting.formatMoney(1, {
      symbol: "$"
    })).toEqual("$1.00");
    expect(accounting.formatMoney(10, {
      symbol: "$"
    })).toEqual("$10.00");
    expect(accounting.formatMoney(100, {
      symbol: "$"
    })).toEqual("$100.00");
    expect(accounting.formatMoney(1000, {
      symbol: "$"
    })).toEqual("$1,000.00");
    expect(accounting.formatMoney(10000, {
      symbol: "$"
    })).toEqual("$10,000.00");
    expect(accounting.formatMoney(100000, {
      symbol: "$"
    })).toEqual("$100,000.00");
    return expect(accounting.formatMoney(1000000, {
      symbol: "$"
    })).toEqual("$1,000,000.00");
  });
});
