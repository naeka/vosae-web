###
  This mixin helps us to transition to a lazy resource. For more
  explainations, please see `Vosae.LazyXXXResourceMixin`

  @class TransitionToLazyResourceMixin 
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.TransitionToLazyResourceMixin = Ember.Mixin.create
   actions: 
    transitionToResource: (resource) ->
      switch resource.type
        # Contact
        when "Vosae.Contact"
          @transitionToRoute "contact.show", @get('session.tenant'), resource.id
        
        # Organization
        when "Vosae.Organization"
          @transitionToRoute "organization.show", @get('session.tenant'), resource.id
        
        # Quotation
        when "Vosae.Quotation"
          console.log resource.id
          @transitionToRoute "quotation.show", @get('session.tenant'), resource.id
       
        # Invoice
        when "Vosae.Invoice"
          @transitionToRoute "invoice.show", @get('session.tenant'), resource.id
       
        # DownPaymentInvoice
        when "Vosae.DownPaymentInvoice"
          @transitionToRoute "downPaymentInvoice.show", @get('session.tenant'), resource.id

        # CreditNote
        when "Vosae.CreditNote"
          @transitionToRoute "creditNote.show", @get('session.tenant'), resource.id