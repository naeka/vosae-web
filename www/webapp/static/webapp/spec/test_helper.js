window.getAdapterForTest = function(type) {
  ajaxUrl = undefined;
  ajaxType = undefined;
  ajaxHash = undefined;

  store = Vosae.Store.create();
  adapter = store.adapterForType(type);
  adapter.ajax = function(url, type, hash) {
    var adapter = this;
    return new Ember.RSVP.Promise(function(resolve, reject){
      hash = hash || {};
      var success = hash.success;

      hash.context = adapter;

      ajaxUrl = url;
      ajaxType = type;
      ajaxHash = hash;

      hash.success = function(json) {
        Ember.run(function(){
          resolve(json);
        });
      };

      hash.error = function(xhr) {
        Ember.run(function(){
          reject(xhr);
        });
      };

    });
  };
  store.set('adapter', adapter);
  return [ajaxUrl, ajaxType, ajaxHash, store];
};