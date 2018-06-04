defmodule Plymio.Vekil.Form do
  @moduledoc ~S"""
  This module implements the `Plymio.Vekil` protocol  using a `Map` where the
  *proxies* (`keys`) are atoms and the *foroms* (`values`) hold quoted forms.

  The default when creating a **form** *vekil* is to create
  `Plymio.Vekil.Forom.Form` *forom* but any *vekil* can hold any
  *forom*.

  See `Plymio.Vekil` for the definitions of the protocol functions.

  ## Module State

  See `Plymio.Vekil` for the common fields.

  The module's state is held in a `struct` with the following field(s):

  | Field | Aliases | Purpose |
  | :---  | :--- | :--- |
  | `:dict` | *:d* | *holds the map of proxies v forom* |
  | `:forom_normalise` |  | *see field description* |
  | `:proxy_normalise` |  | *see field description* |

  ### Module State Field: `:forom_normalise`

  The `:forom_normalise` field holds an arity 1 or 2 function.

  If it is arity 2, it is passed the same arguments
  to the *vekil's* `forom_normalise/2` function and must return `{:ok, {forom, vekil}}`.

  If it is arity 1, just the second argument from the call to the
  *vekil's* `forom_normalise/2` function is passed and must return
  `{:ok, forom}`.

  The default for this *vekil* is `Plymio.Vekil.Forom.Form.normalise/1`.

  ### Module State Field: `:proxy_normalise`

  The `:proxy_normalise` field holds an arity 1 function that is
  usually passed the second argumnet from the call to the *vekil's*
  `proxy_normalise/2` function.

  The default for this *vekil* is `Plymio.Fontais.Utility.validate_key/1`.

  ## Test Environment

  See also notes in `Plymio.Vekil`.

  The vekil created in the example below of `new/1` is returned by
  `vekil_helper_form_vekil_example1/0`.

      iex> {:ok, vekil} = new()
      ...> dict = [
      ...>    x_add_1: quote(do: x = x + 1),
      ...>    x_mult_x: quote(do: x = x * x),
      ...>    x_sub_1: quote(do: x = x - 1),
      ...>    x_funs: [:x_add_1, :x_mul_x, :x_sub_1],
      ...>    x_loop: [:x_add_1, :x_loop, :x_sub_1]
      ...> ]
      ...> {:ok, vekil} = vekil |> update(dict: dict)
      ...> match?(%VEKILFORM{}, vekil)
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
  @type forom :: struct
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
    {@plymio_vekil_field_forom_normalise, &Plymio.Vekil.Forom.Form.normalise/1},
    {@plymio_vekil_field_proxy_normalise, &Plymio.Vekil.PVO.pvo_validate_atom_proxy/1},
    {@plymio_fontais_field_protocol_name, Plymio.Vekil},
    {@plymio_fontais_field_protocol_impl, __MODULE__}
  ]

  defstruct @plymio_fontais_vekil_defstruct

  @doc_new ~S"""
  `new/1` takes an optional *opts* and creates a new **form** *vekil*
  returning `{:ok, vekil}`.

  ## Examples

      iex> {:ok, vekil} = new()
      ...> match?(%VEKILFORM{}, vekil)
      true

  `Plymio.Vekil.Utility.vekil?/1` returns `true` if the value implements `Plymio.Vekil`

      iex> {:ok, vekil} = new()
      ...> vekil |> Plymio.Vekil.Utility.vekil?
      true

   The vekil dictionary can be supplied as a `Map` or `Keyword`. It
   will be validated to ensure all the *proxies* are atoms and all the
   *forom* are valid *forms*.

      iex> {:ok, vekil} = [dict: [
      ...>    x_add_1: quote(do: x = x + 1),
      ...>    x_mul_x: quote(do: x = x * x),
      ...>    x_sub_1: quote(do: x = x - 1),
      ...>    x_funs: [:x_add_1, :x_mul_x, :x_sub_1]
      ...> ]] |> new()
      ...> match?(%VEKILFORM{}, vekil)
      true

  In the above example the `:x_funs` *proxy* in the *vekil* dictionary
  was given a list of 3 atoms: `[:x_add_1, :x_mul_x, :x_sub_1]`. Each
  of the atoms is treated as a reference to another *proxy* in the
  *vekil* and are normalised into instances of
  `Plymio.Vekil.Forom.Proxy` (a *proxy forom*).

  List of atoms provide a simple way of defining a composite *forom*
  out of constituent *forom*.

  See the e.g. `proxy_fetch/2` examples for how this works in practice.
  """

  @doc_update ~S"""
  `update/2` takes a *vekil* and *opts* and update the field(s) in the
  *vekil* from the `{field,value}` typles in the *opts*.

  ## Examples

      iex> {:ok, vekil} = new()
      ...> dict = [
      ...>    x_add_1: quote(do: x = x + 1),
      ...>    x_mul_x: quote(do: x = x * x),
      ...>    x_sub_1: quote(do: x = x - 1),
      ...>    x_funs: [:x_add_1, :x_mul_x, :x_sub_1]
      ...> ]
      ...> {:ok, vekil} = vekil |> update(dict: dict)
      ...> match?(%VEKILFORM{}, vekil)
      true

  """

  @doc_proxy_get2 ~S"""
  See `Plymio.Vekil.proxy_get/2`

  ## Examples

  A single known, *proxy* is requested with no default

      iex> {:ok, {forom, %VEKILFORM{}}} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_get(:x_add_1)
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {8, ["x = x + 1"]}

  Two known *proxies* are requested:

      iex> {:ok, {forom, %VEKILFORM{}}} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_get([:x_mul_x, :x_add_1])
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {50, ["x = x * x", "x = x + 1"]}

  A single unknown, *proxy* is requested with no default. Note the use of
  `:realise_default` to provide a backstop default.

      iex> {:ok, {forom, %VEKILFORM{}}} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_get(:not_a_proxy)
      ...> {:ok, {forms, _}} = forom
      ...> |> FOROMPROT.realise(realise_default: quote(do: x = x + 35))
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {42, ["x = x + 35"]}

  """

  @doc_proxy_get3 ~S"""
  See `Plymio.Vekil.proxy_get/3`

  ## Examples

  A single unknown *proxy* is requested with a default:

      iex> {:ok, {forom, %VEKILFORM{}}} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_get(:not_a_proxy, quote(do: x = x *x * x))
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {343, ["x = x * x * x"]}

  A mix of known and unknown *proxies*, together with a default:

      iex> {:ok, {forom, %VEKILFORM{}}} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_get([:missing_proxy, :x_sub_1, :not_a_proxy], quote(do: x = x * x * x))
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 2])
      {343, ["x = x * x * x", "x = x - 1", "x = x * x * x"]}

  The default is not a valid *form(s)*

      iex> {:error, error} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_get(:not_a_proxy, %{a: 1})
      ...> error |> Exception.message
      "default invalid, got: %{a: 1}"

  """

  @doc_proxy_fetch ~S"""
  See `Plymio.Vekil.proxy_fetch/2`.

  ## Examples

  A single *proxy* is fetched:

      iex> {:ok, {forom, %VEKILFORM{}}} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch(:x_add_1)
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {8, ["x = x + 1"]}

  Two *proxies* are fetched:

      iex> {:ok, {forom, %VEKILFORM{}}} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch([:x_mul_x, :x_add_1])
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {50, ["x = x * x", "x = x + 1"]}

  *proxies* is nil / empty. Note the use and override of `:realise_default`.

      iex> {:ok, {forom, %VEKILFORM{}}} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch(nil)
      ...> {:ok, {value, _}} = forom |> FOROMPROT.realise
      ...> value |> Plymio.Fontais.Guard.is_value_unset
      true

      iex> {:ok, {forom, %VEKILFORM{}}} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch([])
      ...> {:ok, {forms, _}} = forom
      ...> |> FOROMPROT.realise(realise_default: quote(do: x = x + 35))
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {42, ["x = x + 35"]}

  One or more *proxies* not found

      iex> {:error, error} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch(:not_a_proxy)
      ...> error |> Exception.message
      "proxy invalid, got: :not_a_proxy"

      iex> {:error, error} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch([:missing_proxy, :x_sub_1, :not_a_proxy])
      ...> error |> Exception.message
      "proxies invalid, got: [:missing_proxy, :not_a_proxy]"

  Proxy loops are caught:

      iex> {:ok, %VEKILFORM{} = vekil} = [dict: [
      ...>    x_add_1: quote(do: x = x + 1),
      ...>    x_mul_x: quote(do: x = x * x),
      ...>    x_sub_1: quote(do: x = x - 1),
      ...>    x_loopa: [:x_add_1, :x_loopb, :x_sub_1],
      ...>    x_loopb: [:x_add_1, :x_sub_1, :x_loopc],
      ...>    x_loopc: [:x_loopa, :x_add_1, :x_sub_1],
      ...> ]] |> VEKILFORM.new()
      ...> {:ok, {forom, %VEKILFORM{}}} = vekil |> VEKILPROT.proxy_fetch(:x_loopa)
      ...> {:error, error} = forom |> FOROMPROT.realise
      ...> error |> Exception.message
      "proxy seen before, got: :x_loopa"

  In this example the *proxy* is `:x_funs` which was defined in the *vekil*
  dictionary as a list of 3 atoms: `[:x_add_1, :x_mul_x, :x_sub_1]`.

  Each of the atoms is treated as a reference to another *proxy* in
  the *vekil* and are normalised into instances of
  `Plymio.Vekil.Forom.Proxy` (a *proxy forom*). Since the fetch must
  return a *forom*, the 3 *proxy foroms* are normalised to a
  `Plymio.Vekil.Forom.List` for the result.

  When a *proxy forom* is realised, the original atom *proxy*
  (e.g. `:x_sub_1`) is used in a `proxy_fetch/2` and the *forom*
  returned by the fetch is realised.

      iex> {:ok, {forom, %VEKILFORM{}}} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_fetch(:x_funs)
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {63, ["x = x + 1", "x = x * x", "x = x - 1"]}

  """

  @doc_proxy_put2 ~S"""
  See `Plymio.Vekil.proxy_put/2`

  ## Examples

  A list of `{proxy,form}` tuples can be given.  Since a **form** *vekil's* *proxy* is
  an atom, `Keyword` syntax can be used here:

      iex> {:ok, %VEKILFORM{} = vekil} = VEKILFORM.new()
      ...> {:ok, %VEKILFORM{} = vekil} = vekil |> VEKILPROT.proxy_put(
      ...>    x_add_1: quote(do: x = x + 1),
      ...>    x_mul_x: quote(do: x = x * x),
      ...>    x_sub_1: quote(do: x = x - 1),
      ...>    x_funs: [:x_add_1, :x_mul_x, :x_sub_1])
      ...> {:ok, {forom, %VEKILFORM{}}} = vekil |> VEKILPROT.proxy_fetch(:x_funs)
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {63, ["x = x + 1", "x = x * x", "x = x - 1"]}
  """

  @doc_proxy_put3 ~S"""
  See `Plymio.Vekil.proxy_put/3`

  ## Examples

  This example puts a *proxy* into an empty *vekil* and then fetches it.

      iex> {:ok, %VEKILFORM{} = vekil} = VEKILFORM.new()
      ...> {:ok, %VEKILFORM{} = vekil} = vekil
      ...>    |> VEKILPROT.proxy_put(:x_add_1, quote(do: x = x + 1))
      ...> {:ok, {forom, %VEKILFORM{}}} = vekil |> VEKILPROT.proxy_fetch(:x_add_1)
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {8, ["x = x + 1"]}

  The *proxy* can have/put multiple forms:

      iex> {:ok, %VEKILFORM{} = vekil} = VEKILFORM.new()
      ...> {:ok, %VEKILFORM{} = vekil} = vekil |> VEKILPROT.proxy_put(:x_add_mul_sub,
      ...>  [quote(do: x = x + 1), quote(do: x = x * x), quote(do: x = x - 1)])
      ...> {:ok, {forom, %VEKILFORM{}}} = vekil |> VEKILPROT.proxy_fetch(:x_add_mul_sub)
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {63, ["x = x + 1", "x = x * x", "x = x - 1"]}
  """

  @doc_proxy_delete ~S"""
  See `Plymio.Vekil.proxy_delete/2`

  Note proxies are normalised.

  ## Examples

  Here a known *proxy* is deleted and then fetched, causing an error:

      iex> {:ok, %VEKILFORM{} = vekil} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_delete(:x_sub_1)
      ...> {:error, error} = vekil |> VEKILPROT.proxy_fetch([:x_add_1, :x_sub_1])
      ...> error |> Exception.message
      "proxy invalid, got: :x_sub_1"

  This example deletes `:x_mul_x` and but provides `quote(do: x = x *
  x * x)` as the default in the following get:

      iex> {:ok, %VEKILFORM{} = vekil} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_delete(:x_mul_x)
      ...> {:ok, {forom, %VEKILFORM{}}} = vekil
      ...> |> VEKILPROT.proxy_get([:x_add_1, :x_mul_x, :x_sub_1], quote(do: x = x * x * x))
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {511, ["x = x + 1", "x = x * x * x", "x = x - 1"]}

  Deleting unknown *proxies* does not cause an error:

      iex> {:ok, %VEKILFORM{} = vekil} = vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.proxy_delete([:x_sub_1, :not_a_proxy, :x_mul_x])
      ...> vekil |> Plymio.Vekil.Utility.vekil?
      true
  """

  @doc_has_proxy? ~S"""
  See `Plymio.Vekil.has_proxy?/2`

  Note: the *proxy* is not normalised in any way.

  ## Examples

  Here a known *proxy* is tested for:

      iex> vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.has_proxy?(:x_sub_1)
      true

  An unknown *proxy* returns `false`

      iex> vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.has_proxy?(:not_a_proxy)
      false

      iex> vekil_helper_form_vekil_example1()
      ...> |> VEKILPROT.has_proxy?(%{a: 1})
      false
  """

  @doc_forom_normalise ~S"""
  See `Plymio.Vekil.forom_normalise/2`

  The default action is to create a `Plymio.Vekil.Forom.Form` forom,

  ## Examples

  Here the value being normalised is a simple statement:

      iex> %VEKILFORM{} = vekil = vekil_helper_form_vekil_example1()
      ...> value = quote(do: x = x + 1)
      ...> {:ok, {forom, %VEKILFORM{}}} = vekil |> VEKILPROT.forom_normalise(value)
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 2])
      {3, ["x = x + 1"]}

   An existing *forom* is returned unchanged.

      iex> %VEKILFORM{} = vekil = vekil_helper_form_vekil_example1()
      ...> {:ok, %Plymio.Vekil.Forom.Form{} = forom} = quote(do: x = x + 1)
      ...>   |> Plymio.Vekil.Forom.Form.normalise
      ...> {:ok, {forom, %VEKILFORM{}}} = vekil |> VEKILPROT.forom_normalise(forom)
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 2])
      {3, ["x = x + 1"]}

  In this example the value is `:x_funs` which means it is a proxy and
  is normalised into a *proxy forom*.  When the *proxy forom* is
  realised, the original atom (i.e. `:x_funs`) is used in a
  `proxy_fetch/2` and the *forom* from the fetch realised.

      iex> %VEKILFORM{} = vekil = vekil_helper_form_vekil_example1()
      ...> value = :x_funs
      ...> {:ok, {%Plymio.Vekil.Forom.Proxy{} = forom, %VEKILFORM{}}} = vekil
      ...>    |> VEKILPROT.forom_normalise(value)
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 7])
      {63, ["x = x + 1", "x = x * x", "x = x - 1"]}

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
    :vekil_dict_defp_normalise_simple_dict,
    :vekil_dict_defp_reduce_gather_opts,
    :vekil_proxy_def_proxy_normalise,
    :vekil_proxy_def_proxies_normalise,
    :vekil_defp_forom_value_normalise,

    # protocol functions
    :vekil_dict_def_proxy_get,
    :vekil_dict_def_proxy_fetch,
    :vekil_dict_def_proxy_put,
    :vekil_dict_def_proxy_delete,
    :vekil_dict_def_has_proxy?,
    :vekil_dict_form_def_forom_normalise
  ]

  @codi_opts [
    {@plymio_fontais_key_dict, @vekil}
  ]

  @vekil_proxies
  |> PROXYFOROMDICT.reify_proxies(@codi_opts)
end

defimpl Plymio.Vekil, for: Plymio.Vekil.Form do
  @funs :functions
        |> @protocol.__info__
        |> Keyword.drop([:__protocol__, :impl_for, :impl_for!])

  for {fun, arity} <- @funs do
    defdelegate unquote(fun)(unquote_splicing(Macro.generate_arguments(arity, nil))), to: @for
  end
end

defimpl Inspect, for: Plymio.Vekil.Form do
  use Plymio.Vekil.Attribute

  import Plymio.Fontais.Guard,
    only: [
      is_value_unset_or_nil: 1
    ]

  def inspect(%Plymio.Vekil.Form{@plymio_vekil_field_dict => dict}, _opts) do
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

    "VEKILForm(#{vekil_telltale})"
  end
end
