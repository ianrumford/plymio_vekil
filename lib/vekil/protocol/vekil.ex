defprotocol Plymio.Vekil do
  @moduledoc ~S"""
  The `Plymio.Vekil` protocol is implemented by a collection -- the *vekil* -- that
  associates  *proxies* with *foroms*.

  The *vekil* may be thought of as a dictionary where a
  *proxy* is a `key` and its `value` is a *forom*.

  A *vekil's* *proxies* will usually be homogeneous (e.g. all atoms) but its *forom* are
  heterogeneous: the *vekil* may use *forom* of different
  implementations.

  The values returned by the protocol's accessor functions
  (`proxy_fetch/2`, `proxy_get/3`) implement the `Plymio.Vekil.Forom`
  protocol.  (Whether the values *stored* by a *vekil* implements
  `Plymio.Vekil.Forom` is an implementation decision.)

  The dictionary may be a `Map` that but is implementation-specific.

  ## Documentation Terms

  See `Plymio.Fontais` for an explanation of common documentation terms.

  ## Implementation  Modules' State

  All implementations of both protocols have these fields in their
  `struct` which can e.g. be pattern matched.

  ### Module State Field: `:protocol_name`

  This field will be set to `Plymio.Vekil` or `Plymio.Vekil.Forom`.

  ### Module State Field: `:protocol_impl`

  This field will be set to the module's name e.g. `Plymio.Vekil.Form`,
  `Plymio.Vekil.Forom.Term`, etc.

  ## Implementation Modules Test Environment

  In the  implementation modules' doctests, `VEKILPROT` is
  an alias for `Plymio.Vekil`, `VEKILFORM` for `Plymio.Vekil.Form`,
  `FOROMTERM` for `Plymio.Vekil.Forom.Term` and so on.
  """

  @type opts :: Plymio.Fontais.opts()
  @type error :: Plymio.Fontais.error()

  @type proxy :: any
  @type proxies :: nil | proxy | [proxy]
  @type forom :: any
  @type product :: any
  @type answer :: any

  @doc ~S"""
  `proxy_get/2` takes a *vekil* and *proxies*.

  For each *proxy* in the *proxies*, it checks if the *vekil* contains
  the *proxy* and, if so, appends the *proxy's* *forom* to the
  existing, found *forom*.

  It returns `{:ok, {forom, vekil}` or `{:error, error}`.
  """

  @spec proxy_get(t, proxies) :: {:ok, {forom, t}} | {:error, error}

  def proxy_get(vekil, proxies)

  @doc ~S"""
  `proxy_get/3` takes a *vekil*, *proxies* and a default and get the
  *proxies'* *forom* from the *vekil*, using the default for unknown
  *proxies*

  For each *proxy* in the *proxies*, it checks if the *vekil* contains
  the *proxy* and, if so, appends the *proxy's* *forom* to the
  existing, found *forom*.

  If the *proxy* is not found, the "foromised"
  (`Plymio.Vekil.forom_normalise/2`) default is added to the
  existing, found *forom*

  It returns `{:ok, {forom, vekil}` or `{:error, error}`.
  """

  @spec proxy_get(t, proxies, any) :: {:ok, {forom, t}} | {:error, error}

  def proxy_get(vekil, proxies, default)

  @doc ~S"""
  `proxy_fetch/2` takes a *vekil* and *proxies* and fetches the *proxies'* *forom* from the *vekil*.

  For each *proxy* in the *proxies*, it checks if the *vekil* contains
  the *proxy* and, if so, appends the *proxy's* *forom* to the
  existing found *forom*, returning `{:ok, {forom, vekil}`.

  If any *proxies* are not found, it returns `{:error, error}` where
  `error` will be a `KeyError` whose `key` field will be a list of the
  missing *proxies*.

  For any other error  `{:error, error}` is returned.
  """

  @spec proxy_fetch(t, proxies) :: {:ok, {forom, t}} | {:error, error}

  def proxy_fetch(vekil, proxies)

  @doc ~S"""
  `proxy_put/2` takes a *vekil* and a list of `{proxy,forom}` tuples
  and stores the tuples into the *vekil* returning `{:ok, vekil}`.
  """

  @spec proxy_put(t, any) :: {:ok, t} | {:error, error}

  def proxy_put(vekil, tuples)

  @doc ~S"""
  `proxy_put/3` takes a *vekil*, *proxy* and *forom* and stores the
  *proxy* in the *vekil* with the *forom* as its value, returning `{:ok, vekil}`.
  """

  @spec proxy_put(t, proxy, forom) :: {:ok, t} | {:error, error}

  def proxy_put(vekil, proxy, forom)

  @doc ~S"""
  `proxy_delete/2` takes a *vekil* and one or more *proxies* and
  deletes the *proxies* from the *vekil* returning `{:ok, vekil}`.

  Unknown *proxies* are ignored.
  """

  @spec proxy_delete(t, proxies) :: {:ok, t} | {:error, error}

  def proxy_delete(vekil, proxies)

  @doc ~S"""
  `has_proxy?/2` takes a *vekil* and a *proxy* and returns `true` if
  the *vekil* contains the *proxy*, else `false`.
  """

  @spec has_proxy?(t, proxy) :: true | false

  def has_proxy?(vekil, proxy)

  @doc ~S"""
  `forom_normalise/2` takes a *vekil* and a value and "normalises" the
  value into a *forom*, returning `{:ok, {forom, vekil}}`.

  Normalising the value may change the *vekil*.
  """

  @spec forom_normalise(t, any) :: {:ok, {struct, t}} | {:error, error}

  def forom_normalise(vekil, value)

  @doc ~S"""
  `update/2` takes a *vekil* and optional *opts* and updates the
  fields in the *vekil* with the `{field,value}` tuples in the *opts*,
  returning `{:ok, vekil}`.
  """

  @spec update(t, opts) :: {:ok, t} | {:error, error}

  def update(vekil, opts)
end
