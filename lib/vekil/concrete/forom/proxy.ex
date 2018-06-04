defmodule Plymio.Vekil.Forom.Proxy do
  @moduledoc ~S"""
  The module implements the `Plymio.Vekil.Forom` protocol and manages
  a *proxy*.

  A **proxy** *forom* holds a reference to another *proxy* in its `:forom`
  field.

  When a **proxy** *forom* is produced or realised the *proxy* in the
  `:forom` fields is used, together with the *vekil*, in a call to
  `Plymio.Vekil.proxy_fetch/2` and the *forom* returned by the fetch
  is produced or realised.

  If the **proxy** *form* does not have a *vekil* an error result is returned.

  In many examples the *proxy* is an atom but that is not a
  constraint: its type (e.g. atom, string, whatever) is defined and
  decided by the *vekil*.  (So, for example, looking up an atom in a
  *vekil* where the *proxies* ("keys") are strings will never succeed).
  The *vekils* used in the doctests below use atom *proxies*.

  See `Plymio.Vekil.Forom` for the definitions of the protocol functions.

  See `Plymio.Vekil` for an explanation of the test environment.

  ## Module State

  See `Plymio.Vekil.Forom` for the common fields.

  The default `:produce_default` is an empty list.

  The default `:realise_default` is *the unset value* (`Plymio.Fontais.the_unset_value/0`).

  The module's state is held in a `struct` with the following field(s):

  | Field | Aliases | Purpose |
  | :---  | :--- | :--- |
  | `:forom` | | *holds the proxy* |

  """

  require Plymio.Fontais.Guard
  require Plymio.Fontais.Option
  require Plymio.Fontais.Vekil.ProxyForomDict, as: PROXYFOROMDICT
  use Plymio.Fontais.Attribute
  use Plymio.Vekil.Attribute

  @type t :: %__MODULE__{}
  @type opts :: Plymio.Fontais.opts()
  @type error :: Plymio.Fontais.error()
  @type kv :: Plymio.Fontais.kv()
  @type product :: Plymio.Vekil.product()

  import Plymio.Fontais.Error,
    only: [
      new_error_result: 1
    ],
    warn: false

  import Plymio.Fontais.Guard,
    only: [
      is_value_set: 1,
      is_value_unset_or_nil: 1
    ]

  import Plymio.Fontais.Option,
    only: [
      opts_create_aliases_dict: 1,
      opts_canonical_keys: 2
    ]

  @plymio_vekil_forom_proxy_kvs_aliases [
    # struct
    @plymio_vekil_field_alias_vekil,
    @plymio_vekil_field_alias_forom,
    @plymio_vekil_field_alias_proxy,
    @plymio_vekil_field_alias_seen,
    @plymio_vekil_field_alias_produce_default,
    @plymio_vekil_field_alias_realise_default,
    @plymio_fontais_field_alias_protocol_name,
    @plymio_fontais_field_alias_protocol_impl,

    # virtual
    @plymio_vekil_field_alias_realise_default
  ]

  @plymio_vekil_forom_proxy_dict_aliases @plymio_vekil_forom_proxy_kvs_aliases
                                         |> opts_create_aliases_dict

  @doc false

  def update_canonical_opts(opts, dict \\ @plymio_vekil_forom_proxy_dict_aliases) do
    opts |> opts_canonical_keys(dict)
  end

  @plymio_vekil_defstruct [
    {@plymio_vekil_field_vekil, @plymio_fontais_the_unset_value},
    {@plymio_vekil_field_forom, @plymio_fontais_the_unset_value},
    {@plymio_vekil_field_proxy, @plymio_fontais_the_unset_value},
    {@plymio_vekil_field_seen, @plymio_fontais_the_unset_value},
    {@plymio_vekil_field_produce_default, []},
    {@plymio_vekil_field_realise_default, @plymio_fontais_the_unset_value},
    {@plymio_fontais_field_protocol_name, Plymio.Vekil.Forom},
    {@plymio_fontais_field_protocol_impl, __MODULE__}
  ]

  defstruct @plymio_vekil_defstruct

  @doc_new ~S"""
  `new/1` takes an optional *opts* and creates a new *forom* returning `{:ok, forom}`.

  ## Examples

      iex> {:ok, forom} = new()
      ...> match?(%FOROMPROXY{}, forom)
      true

  `Plymio.Vekil.Utility.forom?/1` returns `true` if the value implements `Plymio.Vekil.Forom`

      iex> {:ok, forom} = new()
      ...> forom |> Plymio.Vekil.Utility.forom?
      true

  The *proxy* is passed using the `:forom` key:

      iex> {:ok, forom1} = FOROMFORM.new(forom: :x_add_1)
      ...> {:ok, forom} = new(forom: forom1)
      ...> forom |> Plymio.Vekil.Utility.forom?
      true
  """

  @doc_update ~S"""
  `update/2` implements `Plymio.Vekil.Forom.update/2`.

  ## Examples

      iex> {:ok, forom} = new(forom: :x_add_1)
      ...> {:ok, forom} = forom |> FOROMPROT.update(forom: :x_mul_x)
      ...> realise_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:ok, {form, _}} = forom |> FOROMPROT.realise(realise_opts)
      ...> form |> harnais_helper_test_forms!(binding: [x: 3])
      {9, ["x = x * x"]}
  """

  @doc_normalise ~S"""
  `normalise/1` creates a new *forom* from its argument unless the argument is already one.

  For a **proxy** *forom* `normalise/1` offers a small way to reduce boilerplate.

  ## Examples

  Here the argument is an atom and a *proxy forom* is created. Note a
  *vekil* is needed to resolve the *proxy*.

      iex> {:ok, %FOROMPROXY{} = forom} = :x_mul_x |> normalise
      ...> realise_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:ok, {form, _}} = forom |> FOROMPROT.realise(realise_opts)
      ...> form |> harnais_helper_test_forms!(binding: [x: 3])
      {9, ["x = x * x"]}

  The function accepts any value as the *proxy*; it is only when the
  *proxy* is accessed by a *vekil* (e.g. `Plymio.Vekil.proxy_fetch/2`)
  can the type of the proxy be known (e.g. an atom) and invalid ones caught.

      iex> {:ok, %FOROMPROXY{} = forom} = "maybe a proxy" |> normalise
      ...> realise_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:error, error} = forom |> FOROMPROT.realise(realise_opts)
      ...> error |> Exception.message
      "proxy invalid, got: maybe a proxy"
  """

  @doc_produce ~S"""
  `produce/2` takes a *forom* and an optional *opts*.

  The value in the `:forom` field is used, together with the essential *vekil*, in a call to
  `Plymio.Vekil.proxy_fetch/2` and the *forom* returned by the fetch.
  is produced.

  ## Examples

      iex> {:ok, forom} = new(forom: :x_add_1)
      ...> produce_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:ok, {product, _}} = forom |> FOROMPROT.produce(produce_opts)
      ...> product |> Keyword.get_values(:forom)
      ...> |> harnais_helper_test_forms!(binding: [x: 7])
      {8, ["x = x + 1"]}

  A variation of the above example showing that the product has
  multiple `:forom` keys, one for each of the constituent, terminal
  *forom* in the `x_funs` **list** *forom*.

      iex> {:ok, forom} = new(forom: :x_funs)
      ...> produce_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:ok, {product, _}} = forom |> FOROMPROT.produce(produce_opts)
      ...> [:forom] = product |> Keyword.keys |> Enum.uniq
      ...> 3 = product |> Keyword.keys |> length
      ...> product |> Keyword.get_values(:forom)
      ...> |> harnais_helper_test_forms!(binding: [x: 7])
      {63, ["x = x + 1", "x = x * x", "x = x - 1"]}

  A **proxy** *forom* can reference another *proxy* which is itself a
  **proxy** *forom* **proxy** *forom* and so on:

      iex> {:ok, %VEKILFORM{} = vekil} = [dict: [
      ...>    p1: :p2,
      ...>    p2: :p3,
      ...>    p3: "The End"
      ...> ]] |> VEKILFORM.new()
      ...> {:ok, forom} = new(forom: :p1)
      ...> produce_opts = [vekil: vekil]
      ...> {:ok, {product, _}} = forom |> FOROMPROT.produce(produce_opts)
      ...> product |> Keyword.get_values(:forom)
      ["The End"]

  There must be a valid *vekil*:

      iex> {:ok, forom} = new(forom: :x_add_1)
      ...> produce_opts = [vekil: :invalid_vekil]
      ...> {:error, error}= forom |> FOROMPROT.produce(produce_opts)
      ...> error |> Exception.message
      "vekil invalid, got: :invalid_vekil"

      iex> {:ok, forom} = new(forom: :not_a_proxy)
      ...> {:error, error}= forom |> FOROMPROT.produce
      ...> error |> Exception.message
      "vekil is unset"

  An empty *forom* does not produce any `:forom` keys:

      iex> {:ok, forom} = new()
      ...> {:ok, {product, _}} = forom |> FOROMPROT.produce
      ...> product |> Keyword.get_values(:forom)
      []
  """

  @doc_realise ~S"""
  `realise/2` takes a *forom* and an optional *opts*, calls
  `produce/2`, and then gets (`Keyword.get_values/2`) the `:forom` key values.

  The example are reqorked ones from `produce/2`

  ## Examples

      iex> {:ok, forom} = new(forom: :x_funs)
      ...> realise_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise(realise_opts)
      ...> 3 = forms |> length
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {63, ["x = x + 1", "x = x * x", "x = x - 1"]}

      iex> {:ok, %VEKILFORM{} = vekil} = [dict: [
      ...>    p1: :p2,
      ...>    p2: :p3,
      ...>    p3: "The End"
      ...> ]] |> VEKILFORM.new()
      ...> {:ok, forom} = new(forom: :p1)
      ...> realise_opts = [vekil: vekil]
      ...> {:ok, {values, _}} = forom |> FOROMPROT.realise(realise_opts)
      ...> values
      ["The End"]
  """

  @vekil [
           Plymio.Vekil.Codi.Dict.__vekil__(),

           # overrides to the defaults
           %{
             state_def_new_doc: quote(do: @doc(unquote(@doc_new))),
             state_def_update_doc: quote(do: @doc(unquote(@doc_update))),
             vekil_forom_def_normalise_doc: quote(do: @doc(unquote(@doc_normalise))),
             vekil_forom_def_produce_doc: quote(do: @doc(unquote(@doc_produce))),
             vekil_forom_def_realise_doc: quote(do: @doc(unquote(@doc_realise)))
           }
         ]
         |> PROXYFOROMDICT.create_proxy_forom_dict!()

  @vekil_proxies [
    :state_base_package,
    :state_defp_update_field_header,
    :state_vekil_defp_update_field_vekil_passthru,
    :state_vekil_proxy_defp_update_field_proxy_passthru,
    :state_vekil_forom_defp_update_field_forom_passthru,
    :state_vekil_defp_update_field_produce_default_passthru,
    :state_vekil_defp_update_field_realise_default_passthru,
    :state_vekil_defp_update_field_seen_validate,
    :state_defp_update_field_unknown,
    :vekil_defp_validate_vekil,
    :vekil_forom_proxy_def_produce,
    :vekil_forom_proxy_def_realise,
    :vekil_forom_proxy_defp_realise_product,
    :vekil_forom_def_normalise,
    :vekil_forom_proxy_defp_forom_value_normalise
  ]

  @codi_opts [
    {@plymio_fontais_key_dict, @vekil}
  ]

  @vekil_proxies
  |> PROXYFOROMDICT.reify_proxies(@codi_opts)

  @doc false
  @since "0.1.0"

  def seen_ensure(seen \\ nil)

  def seen_ensure(seen) when is_map(seen) do
    {:ok, seen}
  end

  def seen_ensure(seen) when is_value_unset_or_nil(seen) do
    {:ok, %{}}
  end

  def seen_ensure(seen) do
    new_error_result(m: "seen invalid", v: seen)
  end

  @doc false
  @since "0.1.0"

  def seen_has_proxy?(seen, proxy) when is_map(seen) do
    seen |> Map.has_key?(proxy)
  end

  @doc false
  @since "0.1.0"

  def seen_put_proxy(seen, proxy, value \\ nil) when is_map(seen) do
    {:ok, seen |> Map.put(proxy, value)}
  end

  defp forom_ensure_seen_init(forom)

  defp forom_ensure_seen_init(%__MODULE__{@plymio_vekil_field_seen => seen} = state)
       when is_value_unset_or_nil(seen) do
    {:ok, state |> struct!([{@plymio_vekil_field_seen, %{}}])}
  end

  defp forom_ensure_seen_init(%__MODULE__{@plymio_vekil_field_seen => seen} = state)
       when is_map(seen) do
    {:ok, state}
  end

  @doc false
  @since "0.1.0"

  def forom_add_seen_proxy(%__MODULE__{} = state, proxy, value \\ nil) do
    with {:ok, %__MODULE__{@plymio_vekil_field_seen => seen} = state} <-
           state
           |> forom_ensure_seen_init,
         {:ok, seen} <- seen |> seen_put_proxy(proxy, value),
         {:ok, %__MODULE__{}} = result <- state |> forom_update_seen(seen) do
      result
    else
      {:error, %{__exception__: true}} = result -> result
    end
  end

  @doc false
  @since "0.1.0"

  def forom_has_seen_proxy?(forom, proxy)

  def forom_has_seen_proxy?(%__MODULE__{@plymio_vekil_field_seen => seen}, proxy)
      when is_map(seen) do
    seen |> seen_has_proxy?(proxy)
  end

  def forom_has_seen_proxy?(%__MODULE__{}, _proxy) do
    false
  end

  defp forom_update_seen(%__MODULE__{} = state, seen)
       when is_map(seen) do
    {:ok, state |> struct!([{@plymio_vekil_field_seen, seen}])}
  end
end

defimpl Plymio.Vekil.Forom, for: Plymio.Vekil.Forom.Proxy do
  @funs :functions
        |> @protocol.__info__
        |> Keyword.drop([:__protocol__, :impl_for, :impl_for!])

  for {fun, arity} <- @funs do
    defdelegate unquote(fun)(unquote_splicing(Macro.generate_arguments(arity, nil))), to: @for
  end
end

defimpl Inspect, for: Plymio.Vekil.Forom.Proxy do
  use Plymio.Vekil.Attribute

  import Plymio.Fontais.Guard,
    only: [
      is_value_unset_or_nil: 1
    ]

  def inspect(
        %Plymio.Vekil.Forom.Proxy{
          @plymio_vekil_field_vekil => vekil,
          @plymio_vekil_field_forom => forom,
          @plymio_vekil_field_proxy => proxy
        },
        _opts
      ) do
    vekil_telltale =
      vekil
      |> case do
        x when is_value_unset_or_nil(x) -> nil
        _ -> "+K"
      end

    forom_telltale =
      forom
      |> case do
        x when is_value_unset_or_nil(x) -> "-F"
        x when is_list(x) -> "F=L#{length(x)}"
        x when is_atom(x) -> "F=#{to_string(x)}"
        _x -> "+F"
      end

    proxy_telltale =
      proxy
      |> case do
        x when is_value_unset_or_nil(x) -> nil
        x when is_atom(x) -> "P=#{to_string(proxy)}"
        _x -> "+P"
      end

    forom_telltale =
      [
        proxy_telltale,
        forom_telltale,
        vekil_telltale
      ]
      |> List.flatten()
      |> Enum.reject(&is_nil/1)
      |> Enum.join("; ")

    "FOROMProxy(#{forom_telltale})"
  end
end
