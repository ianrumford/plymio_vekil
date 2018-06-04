defmodule Plymio.Vekil.Forom.Term do
  @moduledoc ~S"""
  The module implements the `Plymio.Vekil.Forom` protocol and produces
  a valid term transparently ("passthru").

  See `Plymio.Vekil.Forom` for the definitions of the protocol functions.

  See `Plymio.Vekil` for an explanation of the test environment.

  ## Module State

  See `Plymio.Vekil.Forom` for the common fields.

  The default `:produce_default` is an empty list.

  The default `:realise_default` is *the unset value* (`Plymio.Fontais.the_unset_value/0`).

  The module's state is held in a `struct` with the following field(s):

  | Field | Aliases | Purpose |
  | :---  | :--- | :--- |
  | `:forom` | | *holds the term* |

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
      ...> match?(%FOROMTERM{}, forom)
      true

  `Plymio.Vekil.Utility.forom?/1` returns `true` if the value implements `Plymio.Vekil.Forom`

      iex> {:ok, forom} = new()
      ...> forom |> Plymio.Vekil.Utility.forom?
      true

  The value is passed using the `:forom` key:

      iex> {:ok, forom} = new(forom: [a: 1, b: 2, c: 3])
      ...> forom |> Plymio.Vekil.Utility.forom?
      true

      iex> {:ok, forom} = new(
      ...>    forom: [a: 1, b: 2, c: 3], proxy: :abc)
      ...> forom |> Plymio.Vekil.Utility.forom?
      true

  Same example but here the realise function is used to access the
  value in the `:forom` field:

      iex> {:ok, forom} = new(
      ...>    forom: [a: 1, b: 2, c: 3], proxy: :abc)
      ...> {:ok, {answer, _}} = forom |> FOROMPROT.realise
      ...> answer
      [a: 1, b: 2, c: 3]
  """

  @doc_update ~S"""
  `update/2` implements `Plymio.Vekil.Forom.update/2`.

  ## Examples

      iex> {:ok, forom} = new(
      ...>    forom: %{a: 1}, proxy: :map_a_1)
      ...> {:ok, forom} = forom |> update(forom: "Hello World!")
      ...> {:ok, {answer, _}} = forom |> FOROMPROT.realise
      ...> answer
      "Hello World!"
  """

  @doc_normalise ~S"""
  `normalise/1` creates a new *forom* from its argument unless the argument is already one.

  ## Examples

      iex> {:ok, forom} = 42 |> normalise
      ...> {:ok, {answer, _}} = forom |> FOROMPROT.realise
      ...> answer
      42

      iex> {:ok, forom} = normalise(
      ...>   forom: 42, proxy: :just_42)
      ...> {:ok, {answer, _}} = forom |> FOROMPROT.realise
      ...> answer
      42

   An existing *forom* (of any implementation) is returned unchanged:

      iex> {:ok, forom} = %{a: 1, b: 2, c: 3} |> normalise
      ...> {:ok, forom} = forom |> normalise
      ...> {:ok, {answer, _}} = forom |> FOROMPROT.realise
      ...> answer
      %{a: 1, b: 2, c: 3}
  """

  @doc_produce ~S"""
  `produce/2` takes a *forom* and an optional *opts*, calls `update/2`
  with the *vekil* and the *opts* if any, and returns `{:ok, {product, forom}}`.

  The *product* will be a `Keyword` with one `:forom` key with its value set to the original term..

  ## Examples

      iex> {:ok, forom} = quote(do: x = x + 1) |> normalise
      ...> {:ok, {product, %FOROMTERM{}}} = forom |> FOROMPROT.produce
      ...> [:forom] = product |> Keyword.keys |> Enum.uniq
      ...> product |> Keyword.get(:forom)
      quote(do: x = x + 1)

  If *opts* are given, `update/2` is called before producing the *forom*:

      iex> {:ok, forom} = 42 |> normalise()
      ...> {:ok, forom} = forom |> update(forom: quote(do: x = x + 1))
      ...> {:ok, {product, %FOROMTERM{}}} = forom |> FOROMPROT.produce
      ...> [:forom] = product |> Keyword.keys |> Enum.uniq
      ...> product |> Keyword.get(:forom)
      quote(do: x = x + 1)

  An empty *forom* does not produce any `:forom` keys:

      iex> {:ok, forom} = new()
      ...> {:ok, {product, _}} = forom |> FOROMPROT.produce
      ...> product |> Keyword.get(:forom)
      nil
  """

  @doc_realise ~S"""
  `realise/2` takes a *forom* and an optional *opts*, calls
  `produce/2`, gets (`Keyword.get_values/2`) the `:forom` key values,
  normalises (`Plymio.Fontais.Form.forms_normalise`) the `:forom`
  values and returns `{:ok, {forms, forom}}`

  ## Examples

      iex> {:ok, forom} = 42 |> normalise
      ...> {:ok, {answer, _}} = forom |> FOROMPROT.realise
      ...> answer
      42

  If *opts* are given, `update/2` is called before realising the *forom*:

      iex> {:ok, forom} = new()
      ...> {:ok, {answer, %FOROMTERM{}}} = forom
      ...>    |> FOROMPROT.realise(forom: "The Updated Term Value")
      ...> answer
      "The Updated Term Value"

  An empty *forom's* answer is the value of the `:realise_default` (*the unset value*).

      iex> {:ok, forom} = new()
      ...> {:ok, {answer, %FOROMTERM{}}} = forom |> FOROMPROT.realise
      ...> answer |> Plymio.Fontais.Guard.is_value_unset
      true

  The `:realise_default` value can be set in the optional *opts* to `realise/2`:

      iex> {:ok, forom} = new(realise_default: 42)
      ...> {:ok, {answer, %FOROMTERM{}}} = forom |> FOROMPROT.realise
      ...> answer
      42

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
    :state_vekil_forom_defp_update_field_forom_passthru,
    :state_vekil_defp_update_field_produce_default_passthru,
    :state_vekil_defp_update_field_realise_default_passthru,
    :state_vekil_defp_update_field_vekil_ignore,
    :state_vekil_proxy_defp_update_field_proxy_ignore,
    :state_vekil_defp_update_field_seen_ignore,
    :state_defp_update_field_unknown,
    :vekil_forom_term_def_produce,
    :vekil_forom_term_def_realise,
    :vekil_forom_term_defp_realise_product,
    :vekil_forom_def_normalise,
    :vekil_forom_term_defp_forom_value_normalise
  ]

  @codi_opts [
    {@plymio_fontais_key_dict, @vekil}
  ]

  @vekil_proxies
  |> PROXYFOROMDICT.reify_proxies(@codi_opts)
end

defimpl Plymio.Vekil.Forom, for: Plymio.Vekil.Forom.Term do
  @funs :functions
        |> @protocol.__info__
        |> Keyword.drop([:__protocol__, :impl_for, :impl_for!])

  for {fun, arity} <- @funs do
    defdelegate unquote(fun)(unquote_splicing(Macro.generate_arguments(arity, nil))), to: @for
  end
end

defimpl Inspect, for: Plymio.Vekil.Forom.Term do
  use Plymio.Vekil.Attribute

  import Plymio.Fontais.Guard,
    only: [
      is_value_unset_or_nil: 1
    ]

  def inspect(
        %Plymio.Vekil.Forom.Term{
          @plymio_vekil_field_forom => forom
        },
        _opts
      ) do
    forom_telltale =
      forom
      |> case do
        x when is_value_unset_or_nil(x) -> "-F"
        x -> "F=#{inspect(x)}"
      end

    forom_telltale =
      [
        forom_telltale
      ]
      |> List.flatten()
      |> Enum.reject(&is_nil/1)
      |> Enum.join("; ")

    "FOROMTerm(#{forom_telltale})"
  end
end
