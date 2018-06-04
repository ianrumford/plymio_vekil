defmodule Plymio.Vekil.Forom.Form do
  @moduledoc ~S"""
  The module implements the `Plymio.Vekil.Forom` protocol and produces *quoted forms*.

  See `Plymio.Vekil.Forom` for the definitions of the protocol functions.

  See `Plymio.Vekil` for an explanation of the test environment.

  The default `:produce_default` is an empty list.

  The default `:realise_default` is *the unset value* (`Plymio.Fontais.the_unset_value/0`).

  ## Module State

  See `Plymio.Vekil.Forom` for the common fields.

  The module's state is held in a `struct` with the following field(s):

  | Field | Aliases | Purpose |
  | :---  | :--- | :--- |
  | `:forom` | | *holds the quoted form* |

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

  import Plymio.Fontais.Option,
    only: [
      opts_create_aliases_dict: 1,
      opts_canonical_keys: 2
    ]

  @plymio_vekil_forom_form_kvs_aliases [
    # struct
    @plymio_vekil_field_alias_forom,
    @plymio_vekil_field_alias_produce_default,
    @plymio_vekil_field_alias_realise_default,
    @plymio_fontais_field_alias_protocol_name,
    @plymio_fontais_field_alias_protocol_impl,

    # virtual
    @plymio_vekil_field_alias_seen,
    @plymio_vekil_field_alias_vekil,
    @plymio_vekil_field_alias_proxy
  ]

  @plymio_vekil_forom_form_dict_aliases @plymio_vekil_forom_form_kvs_aliases
                                        |> opts_create_aliases_dict

  @doc false

  def update_canonical_opts(opts, dict \\ @plymio_vekil_forom_form_dict_aliases) do
    opts |> opts_canonical_keys(dict)
  end

  @plymio_vekil_defstruct [
    {@plymio_vekil_field_forom, @plymio_fontais_the_unset_value},
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
      ...> match?(%FOROMFORM{}, forom)
      true

  `Plymio.Vekil.Utility.forom?/1` returns `true` if the value implements `Plymio.Vekil.Forom`

      iex> {:ok, forom} = new()
      ...> forom |> Plymio.Vekil.Utility.forom?
      true

  The form is passed using the `:forom` key:

      iex> {:ok, forom} = new(forom: quote(do: x = x + 1))
      ...> forom |> Plymio.Vekil.Utility.forom?
      true

      iex> {:ok, forom} = new(
      ...>    forom: quote(do: x = x + 1), proxy: :x_add_1)
      ...> forom |> Plymio.Vekil.Utility.forom?
      true

  Same example but here the realise function is used to access the
  *form* in the `:forom` field:

      iex> {:ok, forom} = new(
      ...>    forom: quote(do: x = x + 1), proxy: :x_add_1)
      ...> {:ok, {form, _}} = forom |> FOROMPROT.realise
      ...> form |> harnais_helper_test_forms!(binding: [x: 7])
      {8, ["x = x + 1"]}

   The *form* is validated:

      iex> {:error, error} = new(forom: %{a: 1})
      ...> error |> Exception.message
      "form invalid, got: %{a: 1}"

  """

  @doc_update ~S"""
  `update/2` implements `Plymio.Vekil.Forom.update/2`.

  ## Examples

      iex> {:ok, forom} = new(
      ...>    forom: quote(do: x = x + 1), proxy: :x_add_1)
      ...> {:ok, forom} = forom |> update(forom: quote(do: x = x * x))
      ...> {:ok, {form, _}} = forom |> FOROMPROT.realise
      ...> form |> harnais_helper_test_forms!(binding: [x: 7])
      {49, ["x = x * x"]}
  """

  @doc_normalise ~S"""
  `normalise/1` creates a new *forom* from its argument unless the argument is already one.

  ## Examples

      iex> {:ok, forom} = quote(do: x = x + 1) |> normalise
      ...> {:ok, {form, _}} = forom |> FOROMPROT.realise
      ...> form |> harnais_helper_test_forms!(binding: [x: 3])
      {4, ["x = x + 1"]}

      iex> {:ok, forom} = normalise(
      ...>   forom: quote(do: x = x + 1), proxy: :add_1)
      ...> {:ok, {form, _}} = forom |> FOROMPROT.realise
      ...> form |> harnais_helper_test_forms!(binding: [x: 3])
      {4, ["x = x + 1"]}

  Multiples *forms* can be stored:

      iex> {:ok, forom} = [
      ...>    quote(do: x = x + 1),
      ...>    quote(do: x = x * x),
      ...>    quote(do: x = x - 1)
      ...> ] |> normalise
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 3])
      {15, ["x = x + 1", "x = x * x", "x = x - 1"]}

  An invalid *form* returns an error result:

      iex> {:error, error} = %{a: 1} |> normalise
      ...> error |> Exception.message
      "form invalid, got: %{a: 1}"

   An existing *forom* (of any implementation) is returned unchanged:

      iex> {:ok, forom} = quote(do: x = x + 1) |> normalise
      ...> {:ok, forom} = forom |> normalise
      ...> {:ok, {form, _}} = forom |> FOROMPROT.realise
      ...> form |> harnais_helper_test_forms!(binding: [x: 8])
      {9, ["x = x + 1"]}
  """

  @doc_produce ~S"""
  `produce/2` takes a *forom* and an optional *opts*, calls `update/2`
  with the *vekil* and the *opts* if any, and returns `{:ok, {product, forom}}`.

  The `product` will be `Keyword` with one or more `:forom` keys where the values are the *forms*.

  ## Examples

      iex> {:ok, forom} = quote(do: x = x + 1) |> normalise
      ...> {:ok, {product, %FOROMFORM{}}} = forom |> FOROMPROT.produce
      ...> [:forom] = product |> Keyword.keys |> Enum.uniq
      ...> product |> Keyword.get_values(:forom)
      ...> |> harnais_helper_test_forms!(binding: [x: 41])
      {42, ["x = x + 1"]}

      iex> {:ok, forom} = [
      ...>    quote(do: x = x + 1),
      ...>    quote(do: x = x * x),
      ...>    quote(do: x = x - 1)
      ...> ] |> normalise
      ...> {:ok, {product, _}} = forom |> FOROMPROT.produce
      ...> product |> Keyword.get_values(:forom)
      ...> |> harnais_helper_test_forms!(binding: [x: 3])
      {15, ["[x = x + 1, x = x * x, x = x - 1]"]}

  If *opts* are given, `update/2` is called before producing the *forom*:

      iex> {:ok, forom} = new()
      ...> {:ok, forom} = forom |> update(forom: quote(do: x = x + 1))
      ...> {:ok, {product, %FOROMFORM{}}} = forom |> FOROMPROT.produce
      ...> [:forom] = product |> Keyword.keys |> Enum.uniq
      ...> product |> Keyword.get_values(:forom)
      ...> |> harnais_helper_test_forms!(binding: [x: 41])
      {42, ["x = x + 1"]}

  An empty *forom* does not produce any `:forom` keys:

      iex> {:ok, forom} = new()
      ...> {:ok, {product, _}} = forom |> FOROMPROT.produce
      ...> product |> Keyword.get_values(:forom)
      ...> |> harnais_helper_test_forms!(binding: [x: 41])
      {nil, []}
  """

  @doc_realise ~S"""
  `realise/2` takes a *forom* and an optional *opts*, calls
  `produce/2` and then gets (`Keyword.get_values/2`) the `:forom` key
  values from the *product*.

  The forms are then normalised
  (`Plymio.Fontais.Form.forms_normalise/1`) and `{:ok, {forms, forom}}` returned.

  ## Examples

      iex> {:ok, forom} = quote(do: x = x + 1) |> normalise
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 41])
      {42, ["x = x + 1"]}

      iex> {:ok, forom} = [
      ...>    quote(do: x = x + 1),
      ...>    quote(do: x = x * x),
      ...>    quote(do: x = x - 1)
      ...> ] |> normalise
      ...> {:ok, {forms, %FOROMFORM{}}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 3])
      {15, ["x = x + 1", "x = x * x", "x = x - 1"]}

  If *opts* are given, `update/2` is called before realising the *forom*:

      iex> {:ok, forom} = new()
      ...> {:ok, {forms, %FOROMFORM{}}} = forom
      ...>    |> FOROMPROT.realise(forom: quote(do: x = x + 1))
      ...> forms |> harnais_helper_test_forms!(binding: [x: 41])
      {42, ["x = x + 1"]}

  An empty *forom* does not produce any `:forom` keys so the `:realise_default` is returned:

      iex> {:ok, forom} = new()
      ...> {:ok, {value, _forom}} = forom |> FOROMPROT.realise
      ...> value |> Plymio.Fontais.Guard.is_value_unset
      true
  """

  @vekil [
           Plymio.Vekil.Codi.Dict.__vekil__(),

           # overrides to the defaults
           %{
             doc_false: quote(do: @doc(false)),
             state_def_new_doc: quote(do: @doc(unquote(@doc_new))),
             state_def_update_doc: quote(do: @doc(unquote(@doc_update))),
             vekil_forom_def_normalise_doc: quote(do: @doc(unquote(@doc_normalise))),
             vekil_forom_def_produce_doc: quote(do: @doc(unquote(@doc_produce))),
             vekil_forom_def_realise_doc: quote(do: @doc(unquote(@doc_realise)))
           }
         ]
         |> PROXYFOROMDICT.create_proxy_forom_dict!()

  @vekil
  |> Enum.sort_by(fn {k, _v} -> k end)

  @vekil_proxies [
    :state_base_package,
    :state_defp_update_field_header,
    :state_vekil_defp_update_field_vekil_ignore,
    :state_vekil_proxy_defp_update_field_proxy_ignore,
    :state_vekil_defp_update_field_seen_ignore,
    :vekil_forom_form_defp_update_field_forom_validate_form,
    :state_vekil_defp_update_field_produce_default_passthru,
    :state_vekil_defp_update_field_realise_default_passthru,
    :state_defp_update_field_unknown,
    :vekil_defp_validate_vekil,
    :vekil_forom_form_def_produce,
    :vekil_forom_form_def_realise,
    :vekil_forom_form_defp_realise_product,
    :vekil_forom_def_normalise,
    :vekil_forom_form_defp_forom_value_normalise
  ]

  @codi_opts [
    {@plymio_fontais_key_dict, @vekil}
  ]

  @vekil_proxies
  |> PROXYFOROMDICT.reify_proxies(@codi_opts)
end

defimpl Plymio.Vekil.Forom, for: Plymio.Vekil.Forom.Form do
  @funs :functions
        |> @protocol.__info__
        |> Keyword.drop([:__protocol__, :impl_for, :impl_for!])

  for {fun, arity} <- @funs do
    defdelegate unquote(fun)(unquote_splicing(Macro.generate_arguments(arity, nil))), to: @for
  end
end

defimpl Inspect, for: Plymio.Vekil.Forom.Form do
  use Plymio.Vekil.Attribute

  import Plymio.Fontais.Guard,
    only: [
      is_value_unset_or_nil: 1
    ]

  def inspect(
        %Plymio.Vekil.Forom.Form{@plymio_vekil_field_forom => forom},
        _opts
      ) do
    forom_telltale =
      forom
      |> case do
        x when is_value_unset_or_nil(x) -> "-F"
        x when is_list(x) -> "F=L#{length(x)}"
        x when is_atom(x) -> "F=#{to_string(x)}"
        _x -> "+F"
      end

    forom_telltale =
      [
        forom_telltale
      ]
      |> List.flatten()
      |> Enum.reject(&is_nil/1)
      |> Enum.join("; ")

    "FOROMForm(#{forom_telltale})"
  end
end
