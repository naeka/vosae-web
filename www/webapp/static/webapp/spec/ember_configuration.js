(function (){
  window.Ember = window.Ember || {};

  Ember.config = {};
  Ember.testing = true;
  Ember.LOG_VERSION = false;

  window.ENV = { TESTING: true, LOG_VERSION: false };

  var extendPrototypes = QUnit.urlParams.extendprototypes;
  ENV['EXTEND_PROTOTYPES'] = !!extendPrototypes;

  window.async = function(callback, timeout) {
    stop();

    timeout = setTimeout(function() {
      start();
      ok(false, "Timeout was reached");
    }, timeout || 200);

    return function() {
      clearTimeout(timeout);

      start();

      var args = arguments;
      return Ember.run(function() {
        return callback.apply(this, args);
      });
    };
  };

  window.asyncEqual = function(a, b, message) {
    Ember.RSVP.all([ Ember.RSVP.resolve(a), Ember.RSVP.resolve(b) ]).then(async(function(array) {
      /*globals QUnit*/
      QUnit.push(array[0] === array[1], array[0], array[1], message);
    }));
  };

  window.invokeAsync = function(callback, timeout) {
    timeout = timeout || 1;

    setTimeout(async(callback, timeout+100), timeout);
  };

  window.setupStore = function(options) {
    var env = {};
    options = options || {};

    var container = env.container = new Ember.Container();

    var adapter = env.adapter = (options.adapter || Vosae.ApplicationAdapter);
    delete options.adapter;

    container.register('model:file', Vosae.File);
    container.register('model:localizedFile', Vosae.LocalizedFile);
    container.register('model:group', Vosae.Group);
    container.register('model:notification', Vosae.Notification);
    container.register('model:contactSavedNE', Vosae.ContactSavedNE);
    container.register('model:organizationSavedNE', Vosae.OrganizationSavedNE);
    container.register('model:quotationSavedNE', Vosae.QuotationSavedNE);
    container.register('model:invoiceSavedNE', Vosae.InvoiceSavedNE);
    container.register('model:downPaymentInvoiceSavedNE', Vosae.DownPaymentInvoiceSavedNE);
    container.register('model:creditNoteSavedNE', Vosae.CreditNoteSavedNE);
    container.register('model:eventReminderNE', Vosae.EventReminderNE);
    container.register('model:specificPermission', Vosae.SpecificPermission);
    container.register('model:registrationInfo', Vosae.RegistrationInfo);
    container.register('model:beRegistrationInfo', Vosae.BeRegistrationInfo);
    container.register('model:chRegistrationInfo', Vosae.ChRegistrationInfo);
    container.register('model:frRegistrationInfo', Vosae.FrRegistrationInfo);
    container.register('model:gbRegistrationInfo', Vosae.GbRegistrationInfo);
    container.register('model:luRegistrationInfo', Vosae.LuRegistrationInfo);
    container.register('model:usRegistrationInfo', Vosae.UsRegistrationInfo);
    container.register('model:reportSettings', Vosae.ReportSettings);
    container.register('model:timeline', Vosae.Timeline);
    container.register('model:contactSavedTE', Vosae.ContactSavedTE);
    container.register('model:organizationSavedTE', Vosae.OrganizationSavedTE);
    container.register('model:quotationSavedTE', Vosae.QuotationSavedTE);
    container.register('model:invoiceSavedTE', Vosae.InvoiceSavedTE);
    container.register('model:downPaymentInvoiceSavedTE', Vosae.DownPaymentInvoiceSavedTE);
    container.register('model:creditNoteSavedTE', Vosae.CreditNoteSavedTE);
    container.register('model:quotationChangedStateTE', Vosae.QuotationChangedStateTE);
    container.register('model:invoiceChangedStateTE', Vosae.InvoiceChangedStateTE);
    container.register('model:downPaymentInvoiceChangedStateTE', Vosae.DownPaymentInvoiceChangedStateTE);
    container.register('model:creditNoteChangedStateTE', Vosae.CreditNoteChangedStateTE);
    container.register('model:quotationAddedAttachmentTE', Vosae.QuotationAddedAttachmentTE);
    container.register('model:invoiceAddedAttachmentTE', Vosae.InvoiceAddedAttachmentTE);
    container.register('model:downPaymentInvoiceAddedAttachmentTE', Vosae.DownPaymentInvoiceAddedAttachmentTE);
    container.register('model:creditNoteAddedAttachmentTE', Vosae.CreditNoteAddedAttachmentTE);
    container.register('model:quotationMakeInvoiceTE', Vosae.QuotationMakeInvoiceTE);
    container.register('model:quotationMakeDownPaymentInvoiceTE', Vosae.QuotationMakeDownPaymentInvoiceTE);
    container.register('model:invoiceCancelledTE', Vosae.InvoiceCancelledTE);
    container.register('model:downPaymentInvoiceCancelledTE', Vosae.DownPaymentInvoiceCancelledTE);
    container.register('model:user', Vosae.User);
    container.register('model:userSettings', Vosae.UserSettings);
    container.register('model:tenant', Vosae.Tenant);
    container.register('model:apiKey', Vosae.ApiKey);
    container.register('model:tenantSettings', Vosae.TenantSettings);
    container.register('model:storageQuotasSettings', Vosae.StorageQuotasSettings);
    container.register('model:coreSettings', Vosae.CoreSettings);
    container.register('model:invoicingSettings', Vosae.InvoicingSettings);
    container.register('model:invoicingNumberingSettings', Vosae.InvoicingNumberingSettings);
    container.register('model:vosaeEmail', Vosae.VosaeEmail);
    container.register('model:vosaePhone', Vosae.VosaePhone);
    container.register('model:vosaeAddress', Vosae.VosaeAddress);
    container.register('model:entity', Vosae.Entity);
    container.register('model:organization', Vosae.Organization);
    container.register('model:contact', Vosae.Contact);
    container.register('model:contactGroup', Vosae.ContactGroup);
    container.register('model:currency', Vosae.Currency);
    container.register('model:snapshotCurrency', Vosae.SnapshotCurrency);
    container.register('model:exchangeRate', Vosae.ExchangeRate);
    container.register('model:tax', Vosae.Tax);
    container.register('model:invoiceNote', Vosae.InvoiceNote);
    container.register('model:payment', Vosae.Payment);
    container.register('model:invoiceRevision', Vosae.InvoiceRevision);
    container.register('model:quotationRevision', Vosae.QuotationRevision);
    container.register('model:purchaseOrderRevision', Vosae.PurchaseOrderRevision);
    container.register('model:invoiceRevision', Vosae.InvoiceRevision);
    container.register('model:creditNoteRevision', Vosae.CreditNoteRevision);
    container.register('model:lineItem', Vosae.LineItem);
    container.register('model:item', Vosae.Item);
    container.register('model:invoiceBase', Vosae.InvoiceBase);
    container.register('model:quotation', Vosae.Quotation);
    container.register('model:invoice', Vosae.Invoice);
    container.register('model:downPaymentInvoice', Vosae.DownPaymentInvoice);
    container.register('model:creditNote', Vosae.CreditNote);
    container.register('model:invoiceBaseGroup', Vosae.InvoiceBaseGroup);
    container.register('model:purchaseOrder', Vosae.PurchaseOrder);
    container.register('model:attendee', Vosae.Attendee);
    container.register('model:vosaeCalendar', Vosae.VosaeCalendar);
    container.register('model:calendarAcl', Vosae.CalendarAcl);
    container.register('model:calendarAclRule', Vosae.CalendarAclRule);
    container.register('model:calendarList', Vosae.CalendarList);
    container.register('model:vosaeEvent', Vosae.VosaeEvent);
    container.register('model:eventDateTime', Vosae.EventDateTime);
    container.register('model:eventOccurrence', Vosae.EventOccurrence);
    container.register('model:reminderSettings', Vosae.ReminderSettings);
    container.register('model:reminderEntry', Vosae.ReminderEntry);

    container.register('session:current', Vosae.Session, {singleton: true});
    container.injection('store', 'session', 'session:current');
    
    container.register('store:main', Vosae.Store.extend({
      adapter: adapter
    }));

    container.register('serializer:-default', Vosae.ApplicationSerializer);
    container.register('serializer:-rest', Vosae.ApplicationSerializer);
    container.register('adapter:-rest', Vosae.ApplicationAdapter);
    container.register('controller:application', Vosae.ApplicationController);

    container.injection('serializer', 'store', 'store:main');

    env.serializer = container.lookup('serializer:-default');
    env.restSerializer = container.lookup('serializer:-rest');
    env.store = container.lookup('store:main');
    env.adapter = env.store.get('defaultAdapter');

    return env;
  };

  window.createStore = function(options) {
    return setupStore(options).store;
  };

  var syncForTest = window.syncForTest = function(fn) {
    var callSuper;

    if (typeof fn !== "function") { callSuper = true; }

    return function() {
      var override = false, ret;

      if (Ember.run && !Ember.run.currentRunLoop) {
        Ember.run.begin();
        override = true;
      }

      try {
        if (callSuper) {
          ret = this._super.apply(this, arguments);
        } else {
          ret = fn.apply(this, arguments);
        }
      } finally {
        if (override) {
          Ember.run.end();
        }
      }

      return ret;
    };
  };

  Ember.config.overrideAccessors = function() {
    Ember.set = syncForTest(Ember.set);
    Ember.get = syncForTest(Ember.get);
  };

  Ember.config.overrideClassMixin = function(ClassMixin) {
    ClassMixin.reopen({
      create: syncForTest()
    });
  };

  Ember.config.overridePrototypeMixin = function(PrototypeMixin) {
    PrototypeMixin.reopen({
      destroy: syncForTest()
    });
  };

  QUnit.begin(function(){
    Ember.RSVP.configure('onerror', function(reason) {
      // only print error messages if they're exceptions;
      // otherwise, let a future turn of the event loop
      // handle the error.
      if (reason && reason instanceof Error) {
        Ember.Logger.log(reason, reason.stack)
        throw reason;
      }
    });

    Ember.RSVP.resolve = syncForTest(Ember.RSVP.resolve);

    Ember.View.reopen({
      _insertElementLater: syncForTest()
    });

    DS.Store.reopen({
      save: syncForTest(),
      createRecord: syncForTest(),
      deleteRecord: syncForTest(),
      push: syncForTest(),
      pushMany: syncForTest(),
      filter: syncForTest(),
      find: syncForTest(),
      findMany: syncForTest(),
      findByIds: syncForTest(),
      didSaveRecord: syncForTest(),
      didSaveRecords: syncForTest(),
      didUpdateAttribute: syncForTest(),
      didUpdateAttributes: syncForTest(),
      didUpdateRelationship: syncForTest(),
      didUpdateRelationships: syncForTest()
    });

    DS.Model.reopen({
      save: syncForTest(),
      reload: syncForTest(),
      deleteRecord: syncForTest(),
      dataDidChange: Ember.observer(syncForTest(), 'data'),
      updateRecordArraysLater: syncForTest()
    });

    DS.Errors.reopen({
      add: syncForTest(),
      remove: syncForTest(),
      clear: syncForTest()
    });

    var transforms = {
      'boolean': DS.BooleanTransform.create(),
      'date': DS.DateTransform.create(),
      'number': DS.NumberTransform.create(),
      'string': DS.StringTransform.create()
    };

    // Prevent all tests involving serialization to require a container
    DS.JSONSerializer.reopen({
      transformFor: function(attributeType) {
        return this._super(attributeType, true) || transforms[attributeType];
      }
    });

    Ember.RSVP.Promise.prototype.then = syncForTest(Ember.RSVP.Promise.prototype.then);
  });

  // Generate the jQuery expando on window ahead of time
  // to make the QUnit global check run clean
  jQuery(window).data('testing', true);

})();