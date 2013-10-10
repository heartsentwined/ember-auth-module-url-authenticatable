Em.onLoad 'Ember.Application', (application) ->
  application.initializer
    name: 'ember-auth.module.url-authenticatable'
    before: 'ember-auth-load'

    initialize: (container, app) ->
      app.register 'authModule:urlAuthenticatable', \
      Em.Auth.UrlAuthenticatableAuthModule, { singleton: true }
      app.inject 'authModule:urlAuthenticatable', 'auth', 'auth:main'
