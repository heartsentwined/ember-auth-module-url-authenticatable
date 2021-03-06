$ = jQuery
class Em.Auth.UrlAuthenticatableAuthModule
  init: ->
    @auth._config 'urlAuthenticatable', @_defaultConfig
    @config? || (@config = @auth._config 'urlAuthenticatable')
    @patch()

  _defaultConfig:
    # [array<string>] list of params used for authentication - those that
    #   should be passed on to the server in the sign in call
    params: []

    # [string|null] (opt) a different end point for sign in requests
    #   from urlAuthenticatable
    endPoint: null

  # try to authenticate user from query params
  #
  # @param queryParams [object] the query params
  # @param opts [object] (opt) jquery.ajax(settings) -style options object,
  #   default: {}
  #
  # @return [Em.RSVP.Promise]
  #   if there is no active signed in session,
  #     and if any of the params specified in config.params is found,
  #     returns the auth.signIn() promise;
  #   else returns a resolved empty promise
  authenticate: (queryParams, opts = {}) ->
    return new Em.RSVP.resolve if @auth.signedIn

    data  = {}
    empty = true
    for param in @config.params
      if queryParams[param]?
        data[param] = queryParams[param]
        empty = false

    return new Em.RSVP.resolve if empty

    opts.data = $.extend true, data, (opts.data || {})

    if @config.endPoint?
      @auth.signIn @config.endPoint, opts
    else
      @auth.signIn opts

  patch: ->
    self = this
    Em.Route.reopen
      beforeModel: (queryParams, transition) ->
        self.auth._ensurePromise(super.apply this, arguments).then ->
          return unless transition?
          self.authenticate queryParams
