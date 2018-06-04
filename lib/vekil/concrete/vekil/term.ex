defmodule Plymio.Vekil.Term do
  @moduledoc ~S"""
  This module implements the `Plymio.Vekil` protocol using a `Map` where the
  *proxies* (`keys`) are atoms and the *foroms* (`values`) hold any valid term.

  The default when creating a **term** *vekil* is to create a
  `Plymio.Vekil.Forom.Term` *forom* but any *vekil* can hold any
  *forom*.

  See `Plymio.Vekil` for the definitions of the protocol functions.

  ## Module State

  The module's state is held in a `struct` with the following field(s):

  | Field | Aliases | Purpose |
  | :---  | :--- | :--- |
  | `:dict` | *:d* | *hold the map of proxies v forom* |
  | `:forom_normalise` |  | *see Plymio.Vekil.Form field description* |
  | `:proxy_normalise` |  | *see Plymio.Vekil.Form field description* |

  See `Plymio.Vekil.Form` for an explanation of `:forom_normalise` and `:proxy_normalise`.

  ## Test Environent

  See also notes in `Plymio.Vekil`.

  The vekil created in the example below of `new/1` is returned by
  `vekil_helper_term_vekil_example1/0`.

      iex> {:ok, vekil} = new()
      ...> dict = [
      ...>    x_add_1: quote(do: x = x + 1),
      ...>    x_mult_x: quote(do: x = x * x),
      ...>    x_sub_1: quote(do: x = x - 1),
      ...>    value_42: 42,
      ...>    value_x_add_1: :x_add_1,
      ...>    proxy_x_add_1: [forom: :x_add_1] |> Plymio.Vekil.Forom.Proxy.new!
      ...> ]
      ...> {:ok, vekil} = vekil |> update(dict: dict)
      ...> match?(%VEKILTERM{}, vekil)
      true
  """

  require Plymio.Fontais.Option
  require Plymio.Fontais.Guard
  require Plymio.Fontais.Vekil.ProxyForomDict, as: PROXYFOROMDICT
  use Plymio.Fontais.Attribute
  use Plymio.Vekil.Attribute

  @type t :: %__MODULE__{}
  @type form :: Plymio.Fontais.form()
  @type forms :: Plymio.Fontais.forms()
  @type proxy :: Plymio.Fontais.key()
  @type proxies :: Plymio.Fontais.keys()
  @type forom :: any
  @type opts :: Plymio.Fontais.opts()
  @type error :: Plymio.Fontais.error()
  @type kv :: Plymio.Fontais.kv()
  @type product :: Plymio.Fontais.product()

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

  @plymio_fontais_vekil_kvs_aliases [
    # struct
    @plymio_vekil_field_alias_dict,
    @plymio_vekil_field_alias_proxy_normalise,
    @plymio_vekil_field_alias_forom_normalise,
    @plymio_fontais_field_alias_protocol_name,
    @plymio_fontais_field_alias_protocol_impl
  ]

  @plymio_fontais_vekil_dict_aliases @plymio_fontais_vekil_kvs_aliases
                                     |> opts_create_aliases_dict

  @doc false

  def update_canonical_opts(opts, dict \\ @plymio_fontais_vekil_dict_aliases) do
    opts |> opts_canonical_keys(dict)
  end

  @plymio_fontais_vekil_defstruct [
    {@plymio_vekil_field_dict, @plymio_fontais_the_unset_value},
    {@plymio_vekil_field_forom_normalise, &Plymio.Vekil.Forom.Term.normalise/1},
    {@plymio_vekil_field_proxy_normalise, &Plymio.Vekil.PVO.pvo_validate_atom_proxy/1},
    {@plymio_fontais_field_protocol_name, Plymio.Vekil},
    {@plymio_fontais_field_protocol_impl, __MODULE__}
  ]

  defstruct @plymio_fontais_vekil_defstruct

  @doc_new ~S"""
  `new/1` takes an optional *opts* and creates a new *vekil* returning `{:ok, vekil}`.

  ## Examples

      iex> {:ok, vekil} = new()
      ...> match?(%VEKILTERM{}, vekil)
      true

  `Plymio.Vekil.Utility.vekil?/1` returns `true` if the value implements `Plymio.Vekil`

      iex> {:ok, vekil} = new()
      ...> vekil |> Plymio.Vekil.Utility.vekil?
      true

   The vekil dictionary can be supplied as a `Map` or `Keyword`. It
   will be validated to ensure all the *proxies* are atoms and all the
   *forom* are valid *forms*.

   A **term** *vekil* does *not* recognise / normalise atom values
   (e.g. the `:x_add_1` value for `:value_x_add_1` below) as a
   *proxy*; it is just a term. When a *proxy* is wanted, it must be
   given explicitly (see entry for `proxy_x_add_1`). See also the fetch examples.

      iex> {:ok, vekil} = [dict: [
      ...>    x_add_1: [forom: quote(do: x = x + 1)] |> FOROMFORM.new!,
      ...>    x_mul_x: [forom: quote(do: x = x * x)] |> FOROMFORM.new!,
      ...>    x_sub_1: [forom: quote(do: x = x - 1)] |> FOROMFORM.new!,
      ...>    value_42: 42,
      ...>    value_x_add_1: :x_add_1,
      ...>    proxy_x_add_1: [forom: :x_add_1] |> Plymio.Vekil.Forom.Proxy.new!
      ...> ]] |> new()
      ...> match?(%VEKILTERM{}, vekil)
      true
  """

  @doc_update ~S"""
  `update/2` takes a *vekil* and *opts* and update the field(s) in the
  *vekil* from the `{field,value}` tuples in the *opts*.

  ## Examples

      iex> {:ok, vekil} = new()
      ...> dict = [
      ...>    an_integer: 42,
      ...>    an_atom: :nothing_special,
      ...>    a_string: "Hello World!",
      ...> ]
      ...> {:ok, vekil} = vekil |> update(dict: dict)
      ...> match?(%VEKILTERM{}, vekil)
      true

  """

  @doc_proxy_get2 ~S"""
  See `Plymio.Vekil.proxy_get/2`

  ## Examples

  A single known, *proxy* is requested with no default

      iex> {:ok, {forom, %VEKILTERM{}}} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_get(:value_42)
      ...> {:ok, {value, _}} = forom |> FOROMPROT.realise
      ...> value
      42

  Two known *proxies* are requested:

      iex> {:ok, {forom, %VEKILTERM{}}} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_get([:value_42, :value_x_add_1])
      ...> {:ok, {values, _}} = forom |> FOROMPROT.realise
      ...> values
      [42, :x_add_1]

  A single unknown, *proxy* is requested with no default. The the
  `:realise_default` has been overridden.

      iex> {:ok, {forom, %VEKILTERM{}}} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_get(:not_a_proxy)
      ...> {:ok, {value, _}} = forom
      ...> |> FOROMPROT.realise(realise_default: :proxy_not_found)
      ...> value
      :proxy_not_found
  """

  @doc_proxy_get3 ~S"""
  See `Plymio.Vekil.proxy_get/3`

  ## Examples

  A single unknown *proxy* is requested with a default:

      iex> {:ok, {forom, %VEKILTERM{}}} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_get(:value_42, 123)
      ...> {:ok, {value, _}} = forom |> FOROMPROT.realise
      ...> value
      42

  A mix of known and unknown *proxies*, together with a default:

      iex> {:ok, {forom, %VEKILTERM{}}} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_get([:missing_proxy, :value_42, :not_a_proxy], 123)
      ...> {:ok, {values, _}} = forom |> FOROMPROT.realise
      ...> values
      [123, 42, 123]
  """

  @doc_proxy_fetch ~S"""
  See `Plymio.Vekil.proxy_fetch/2`.

  ## Examples

  A single *proxy* is requested:

      iex> {:ok, {forom, %VEKILTERM{}}} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch(:value_42)
      ...> {:ok, {value, _}} = forom |> FOROMPROT.realise
      ...> value
      42

  Two *proxies* are requested:

      iex> {:ok, {forom, %VEKILTERM{}}} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch([:value_42, :value_x_add_1])
      ...> {:ok, {values, _}} = forom |> FOROMPROT.realise
      ...> values
      [42, :x_add_1]

  In the example *vekil* the *proxy* `:value_x_add_` is a **term**
  *forom* holding a simple atom (`:x_add_`):

      iex> {:ok, {forom, %VEKILTERM{}}} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch(:value_x_add_1)
      ...> {:ok, {value, _}} = forom |> FOROMPROT.realise
      ...> value
      :x_add_1

  But the *proxy* `:proxy_x_add_1` does hold a **proxy** *forom* pointing to the `:x_add_1` *proxy*:

      iex> {:ok, {forom, %VEKILTERM{}}} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_get(:proxy_x_add_1)
      ...> {:ok, {form, _}} = forom |> FOROMPROT.realise
      ...> form |> harnais_helper_test_forms!(binding: [x: 7])
      {8, ["x = x + 1"]}

  *proxies* is nil / empty. Note the use and override of the `:realise_default` field:

      iex> {:ok, {forom, %VEKILTERM{}}} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch(nil)
      ...> {:ok, {value, _}} = forom |> FOROMPROT.realise
      ...> value |> Plymio.Fontais.Guard.is_value_unset
      true

      iex> {:ok, {forom, %VEKILTERM{}}} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch([])
      ...> {:ok, {value, _}} = forom |> FOROMPROT.realise(realise_default: nil)
      ...> value
      nil

  One or more *proxies* not found

      iex> {:error, error} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch(:not_a_proxy)
      ...> error |> Exception.message
      "proxy invalid, got: :not_a_proxy"

      iex> {:error, error} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch([:missing_proxy, :x_sub_1, :not_a_proxy])
      ...> error |> Exception.message
      "proxies invalid, got: [:missing_proxy, :not_a_proxy]"
  """

  @doc_proxy_put2 ~S"""
  See `Plymio.Vekil.proxy_put/2`

  ## Examples

  A list of `{proxy,value}` tuples can be given.  Since a form vekil's proxy is
  an atom, `Keyword` syntax can be used:

      iex> {:ok, %VEKILTERM{} = vekil} = VEKILTERM.new()
      ...> {:ok, %VEKILTERM{} = vekil} = vekil |> VEKILPROT.proxy_put(
      ...>    one: 1, due: :two, tre: "three")
      ...> {:ok, {forom, %VEKILTERM{}}} = vekil |> VEKILPROT.proxy_fetch(:tre)
      ...> {:ok, {value, _}} = forom |> FOROMPROT.realise
      ...> value
      "three"
  """

  @doc_proxy_put3 ~S"""
  See `Plymio.Vekil.proxy_put/3`

  ## Examples

  This example puts a *proxy* into an empty *vekil* and then fetches it.

      iex> {:ok, %VEKILTERM{} = vekil} = VEKILTERM.new()
      ...> {:ok, %VEKILTERM{} = vekil} = vekil
      ...>    |> VEKILPROT.proxy_put(:z, %{a: 1})
      ...> {:ok, {forom, %VEKILTERM{}}} = vekil |> VEKILPROT.proxy_fetch(:z)
      ...> {:ok, {value, _}} = forom |> FOROMPROT.realise
      ...> value
      %{a: 1}
  """

  @doc_proxy_delete ~S"""
  See `Plymio.Vekil.proxy_delete/2`

  Note proxies are normalised.

  ## Examples

  Here a known *proxy* is deleted and then fetched, causing an error:

      iex> {:ok, %VEKILTERM{} = vekil} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_delete(:x_sub_1)
      ...> {:error, error} = vekil |> VEKILPROT.proxy_fetch([:x_add_1, :x_sub_1])
      ...> error |> Exception.message
      "proxy invalid, got: :x_sub_1"

  This example deletes `:x_mul_x` and but provides `quote(do: x = x *
  x * x)` as the default in the following get:

      iex> {:ok, %VEKILTERM{} = vekil} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_delete(:x_mul_x)
      ...> {:ok, {forom, %VEKILTERM{}}} = vekil
      ...> |> VEKILPROT.proxy_get([:x_add_1, :x_mul_x, :x_sub_1], quote(do: x = x * x * x))
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {511, ["x = x + 1", "x = x * x * x", "x = x - 1"]}

  Deleting unknown *proxies* does not cause an error:

      iex> {:ok, %VEKILTERM{} = vekil} = vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.proxy_delete([:x_sub_1, :not_a_proxy, :x_mul_x])
      ...> vekil |> Plymio.Vekil.Utility.vekil?
      true
  """

  @doc_has_proxy? ~S"""
  See `Plymio.Vekil.has_proxy?/2`

  Note: the *proxy* is not normalised in any way.

  ## Examples

  Here a known *proxy* is tested for:

      iex> vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.has_proxy?(:x_sub_1)
      true

  An unknown *proxy* returns `false`

      iex> vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.has_proxy?(:not_a_proxy)
      false

      iex> vekil_helper_term_vekil_example1()
      ...> |> VEKILPROT.has_proxy?(%{a: 1})
      false
  """

  @doc_forom_normalise ~S"""
  See `Plymio.Vekil.forom_normalise/2`

  The default action is to create a **term** *forom* (`Plymio.Vekil.Forom.Term`).

  ## Examples

  Here the value being normalised is a keyword:

      iex> %VEKILTERM{} = vekil = vekil_helper_term_vekil_example1()
      ...> value = [a: 1, b: 2, c: 3]
      ...> {:ok, {forom, %VEKILTERM{}}} = vekil |> VEKILPROT.forom_normalise(value)
      ...> {:ok, {value, _}} = forom |> FOROMPROT.realise
      ...> value
      [a: 1, b: 2, c: 3]

  An atom is normalise to a **term** *forom*, not a **proxy** *forom*:

      iex> %VEKILTERM{} = vekil = vekil_helper_term_vekil_example1()
      ...> value = :x_add_1
      ...> {:ok, {forom, %VEKILTERM{}}} = vekil |> VEKILPROT.forom_normalise(value)
      ...> {:ok, {value, _}} = forom |> FOROMPROT.realise
      ...> value
      :x_add_1

   An existing *forom* is returned unchanged.

      iex> %VEKILTERM{} = vekil = vekil_helper_term_vekil_example1()
      ...> {:ok, %Plymio.Vekil.Forom.Form{} = forom} = quote(do: x = x + 1)
      ...>   |> Plymio.Vekil.Forom.Form.normalise
      ...> {:ok, {forom, %VEKILTERM{}}} = vekil |> VEKILPROT.forom_normalise(forom)
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 2])
      {3, ["x = x + 1"]}
  """

  @vekil [
           Plymio.Vekil.Codi.Dict.__vekil__(),

           # overrides to the defaults
           %{
             state_def_new_doc: quote(do: @doc(unquote(@doc_new))),
             state_def_update_doc: quote(do: @doc(unquote(@doc_update))),

             # protocol function docs
             vekil_def_proxy_get2_doc: quote(do: @doc(unquote(@doc_proxy_get2))),
             vekil_def_proxy_get3_doc: quote(do: @doc(unquote(@doc_proxy_get3))),
             vekil_def_proxy_fetch_doc: quote(do: @doc(unquote(@doc_proxy_fetch))),
             vekil_def_proxy_put2_doc: quote(do: @doc(unquote(@doc_proxy_put2))),
             vekil_def_proxy_put3_doc: quote(do: @doc(unquote(@doc_proxy_put3))),
             vekil_def_proxy_delete_doc: quote(do: @doc(unquote(@doc_proxy_delete))),
             vekil_def_has_proxy_doc?: quote(do: @doc(unquote(@doc_has_proxy?))),
             vekil_def_forom_normalise_doc: quote(do: @doc(unquote(@doc_forom_normalise)))
           }
         ]
         |> PROXYFOROMDICT.create_proxy_forom_dict!()

  @vekil
  |> Enum.sort_by(fn {k, _v} -> k end)

  @vekil_proxies [
    :state_base_package,
    :state_defp_update_field_header,
    :state_vekil_dict_defp_update_field_dict_normalise_vekil_dict,
    :state_vekil_dict_defp_update_field_normalise_proxy_or_normalise_forom,
    :vekil_dict_defp_normalise_vekil_dict,
    :vekil_dict_defp_reduce_gather_opts,
    :vekil_defp_forom_value_normalise,
    :vekil_proxy_def_proxy_normalise,
    :vekil_proxy_def_proxies_normalise,

    # protocol functions
    :vekil_dict_def_proxy_get,
    :vekil_dict_def_proxy_fetch,
    :vekil_dict_def_proxy_put,
    :vekil_dict_def_proxy_delete,
    :vekil_dict_def_has_proxy?,
    :vekil_dict_term_def_forom_normalise
  ]

  @codi_opts [
    {@plymio_fontais_key_dict, @vekil}
  ]

  @vekil_proxies
  |> PROXYFOROMDICT.reify_proxies(@codi_opts)
end

defimpl Plymio.Vekil, for: Plymio.Vekil.Term do
  @funs :functions
        |> @protocol.__info__
        |> Keyword.drop([:__protocol__, :impl_for, :impl_for!])

  for {fun, arity} <- @funs do
    defdelegate unquote(fun)(unquote_splicing(Macro.generate_arguments(arity, nil))), to: @for
  end
end

defimpl Inspect, for: Plymio.Vekil.Term do
  use Plymio.Vekil.Attribute

  import Plymio.Fontais.Guard,
    only: [
      is_value_unset_or_nil: 1
    ]

  def inspect(%Plymio.Vekil.Term{@plymio_vekil_field_dict => dict}, _opts) do
    dict_telltale =
      dict
      |> case do
        x when is_value_unset_or_nil(x) -> nil
        x when is_map(x) -> "D=#{inspect(map_size(x))}"
        _ -> "D=?"
      end

    keys_telltale =
      dict
      |> case do
        x when is_map(x) ->
          case x |> map_size do
            0 -> nil
            n when n in [1, 2, 3, 4, 5] -> x |> Map.keys() |> Enum.join("/")
            _ -> nil
          end

        _ ->
          nil
      end

    vekil_telltale =
      [
        dict_telltale,
        keys_telltale
      ]
      |> List.flatten()
      |> Enum.reject(&is_nil/1)
      |> Enum.join("; ")

    "VEKILTerm(#{vekil_telltale})"
  end
end
