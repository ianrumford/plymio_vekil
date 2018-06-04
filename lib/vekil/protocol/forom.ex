defprotocol Plymio.Vekil.Forom do
  @moduledoc ~S"""
  The `Plymio.Vekil.Forom` protocol is implemented by the values
  returned by the *vekil* accessor functions (e.g. `Plymio.Vekil.proxy_fetch/2`).

  See `Plymio.Vekil` for a general overview and explanation of the documentation terms.

  ## Implementation  Modules' State

  See `Plymio.Vekil` for other common fields.

  All implementations have these fields in their
  `struct` which can e.g. be pattern matched.

  | Field | Aliases | Purpose |
  | :---  | :--- | :--- |
  | `:produce_default` | *:produce_default* | *holds the produce default value* |
  | `:realise_default` | *:answer_default* | *holds the realise default value* |

  ### Module State Field: `:produce_default`

  This field can hold a default value `produce/2` can use / return as
  the *product*. For example, some *forom* return a `Keyword` as their
  *product* and `:produce_default` is an empty list.

  ### Module State Field: `:realise_default`

  This field can hold a default value `realise/2` can use / return as the
  *answer*. It could be, for example, *the unset value*
  (`Plymio.Fontais.the_unset_value/0`)

  """

  @dialyzer {:nowarn_function, __protocol__: 1}

  @type error :: Plymio.Vekil.error()
  @type opts :: Plymio.Vekil.opts()

  @type proxy :: any
  @type proxies :: nil | proxy | [proxy]
  @type forom :: any
  @type product :: Keyword
  @type answer :: any

  @doc ~S"""
  `update/2` takes a *forom* and optional *opts* and updates the
  fields in the *forom* with the `{field,value}` tuples in the *opts*,
  returning `{:ok, forom}`.

  All implementations should be prepared to be passed values for
  the *vekil* and / or *proxy* fields.
  """

  @spec update(t, opts) :: {:ok, t} | {:error, error}

  def update(forom, opts)

  @doc ~S"""
  `produce/1` takes a *forom* and "produces" the
  *forom* to create the *product*, returning `{:ok, {product, forom}}`.

  The protocol does not define what the *product* will be, but most
  implemenations return a `Keyword` with zero, one or more `:forom`
  keys, together with other implementation-specific keys.  (The
  `@spec` for produce uses the type `product` which is defined
  as a `Keyword` by default.)

  Producing the *forom* may change it.
  """

  @spec produce(t) :: {:ok, {product, t}} | {:error, error}

  def produce(forom)

  @doc ~S"""
  `produce/2` takes a *forom* and optional *opts*, calls `update/2`
  with the *vekil* and the *opts*, and then "produces" the *forom* to create the *product*,
  returning `{:ok, {product, forom}}`.

  The protocol does not define what the *product* will be, but
  often will  be a `Keyword`.

  Producing the *forom* may change it.
  """

  @spec produce(t, opts) :: {:ok, {product, t}} | {:error, error}

  def produce(forom, opts)

  @doc ~S"""
  `realise/1` takes a *forom* the realises the *forom* to create the
  *answer* returning `{:ok, {answer, forom}}`.

  Usually `realise/1` calls `produce/1` and then transforms the
  *product* to generate the *answer* returning `{:ok, {answer, forom}}`.
  """

  @spec realise(t) :: {:ok, {answer, t}} | {:error, error}

  def realise(forom)

  @doc ~S"""
  `realise/2` takes a *forom* and optional *opts* the realises the
  *forom* to create the *answer* returning `{:ok, {answer, forom}}`.

  Usually `realise/2` calls `produce/2` and reduces the *product* in some way to generate the *answer".
  """

  @spec realise(t, opts) :: {:ok, {answer, t}} | {:error, error}

  def realise(forom, opts)
end
