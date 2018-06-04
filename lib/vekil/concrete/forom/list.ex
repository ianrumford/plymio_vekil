defmodule Plymio.Vekil.Forom.List do
  @moduledoc ~S"""
  The module implements the `Plymio.Vekil.Forom` protocol and manages a list of other *forom*

  See `Plymio.Vekil.Forom` for the definitions of the protocol functions.

  See `Plymio.Vekil` for an explanation of the test environment.

  ## Module State

  See `Plymio.Vekil.Forom` for the common fields.

  The default `:produce_default` is an empty list.

  The default `:realise_default` is an empty list.

  The module's state is held in a `struct` with the following field(s):

  | Field | Aliases | Purpose |
  | :---  | :--- | :--- |
  | `:forom` | | *holds the list of child forom* |

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
      # is_value_unset_or_nil: 1,
      is_value_set: 1
    ]

  import Plymio.Fontais.Option,
    only: [
      opts_create_aliases_dict: 1,
      opts_canonical_keys: 2
    ]

  @plymio_vekil_forom_list_kvs_aliases [
    # struct
    @plymio_vekil_field_alias_forom,
    @plymio_vekil_field_alias_produce_default,
    @plymio_vekil_field_alias_realise_default,
    @plymio_fontais_field_alias_protocol_name,
    @plymio_fontais_field_alias_protocol_impl,

    # virtual
    @plymio_vekil_field_alias_vekil,
    @plymio_vekil_field_alias_proxy,
    @plymio_vekil_field_alias_seen
  ]

  @plymio_vekil_forom_list_dict_aliases @plymio_vekil_forom_list_kvs_aliases
                                        |> opts_create_aliases_dict

  @doc false

  def update_canonical_opts(opts, dict \\ @plymio_vekil_forom_list_dict_aliases) do
    opts |> opts_canonical_keys(dict)
  end

  @plymio_vekil_defstruct [
    {@plymio_vekil_field_forom, @plymio_fontais_the_unset_value},
    {@plymio_vekil_field_produce_default, []},
    {@plymio_vekil_field_realise_default, []},
    {@plymio_fontais_field_protocol_name, Plymio.Vekil.Forom},
    {@plymio_fontais_field_protocol_impl, __MODULE__}
  ]

  defstruct @plymio_vekil_defstruct

  @doc_new ~S"""
  `new/1` takes an optional *opts* and creates a new *forom* returning `{:ok, forom}`.

  ## Examples

      iex> {:ok, forom} = new()
      ...> match?(%FOROMLIST{}, forom)
      true

  `Plymio.Vekil.Utility.forom?/1` returns `true` if the value implements `Plymio.Vekil.Forom`

      iex> {:ok, forom} = new()
      ...> forom |> Plymio.Vekil.Utility.forom?
      true

  The list is passed using the `:forom` key:

      iex> {:ok, forom1} = FOROMFORM.new(forom: quote(do: x = x + 1))
      ...> {:ok, forom} = new(forom: forom1)
      ...> forom |> Plymio.Vekil.Utility.forom?
      true

      iex> {:ok, forom} = new(
      ...>    forom: [
      ...>      FOROMTERM.new!(forom: 42),
      ...>      FOROMFORM.new!(forom: quote(do: x = x * x * x)),
      ...>      FOROMPROXY.new!(forom: :x_sub_1),
      ...> ])
      ...> forom |> Plymio.Vekil.Utility.forom?
      true
  """

  @doc_update ~S"""
  `update/2` implements `Plymio.Vekil.Forom.update/2`.

  ## Examples

      iex> {:ok, forom} = new(forom: FOROMTERM.new!(forom: 7))
      ...> {:ok, forom} = forom |> FOROMPROT.update(
      ...>    forom: [FOROMTERM.new!(forom: 33), FOROMTERM.new!(forom: 2)])
      ...> {:ok, {values, %FOROMLIST{}}} = forom |> FOROMPROT.realise
      ...> values |> Enum.sum
      35
  """

  @doc_normalise ~S"""
  `normalise/1` creates a new *forom* from its argument unless the argument is already one.

  The function tries to make it as as convenient as possible to
  create a new *forom*,  making some assumptions and may *not* return a **list** *forom*.

  If the argument is a list, each element is treated as below and the created *forom* uses to create a **list** *forom*.

  If an atom is found, a `Plymio.Vekil.Forom.Proxy` is created.

  If the argument is a valid *form* (`Macro.validate/1`) a new `Plymio.Vekil.Forom.Form` is created.

  Any other argument creates a `Plymio.Vekil.Forom.Term`.

  ## Examples

  Here a *form* is recognised:

      iex> {:ok, %FOROMFORM{} = forom} = quote(do: x = x + 1) |> normalise
      ...> {:ok, {form, _}} = forom |> FOROMPROT.realise
      ...> form |> harnais_helper_test_forms!(binding: [x: 6])
      {7, ["x = x + 1"]}

  Here the argument is an atom and a *proxy forom* is created. Note a
  *vekil* is needed to resolve the *proxy*.

      iex> {:ok, %FOROMPROXY{} = forom} = :x_mul_x |> normalise
      ...> realise_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:ok, {form, _}} = forom |> FOROMPROT.realise(realise_opts)
      ...> form |> harnais_helper_test_forms!(binding: [x: 3])
      {9, ["x = x * x"]}

  A list of atoms works. Note the returned *forom* is a **list** *forom*.

      iex> {:ok, %FOROMLIST{} = forom} = [:x_add_1, :x_mul_x, :x_sub_1] |> normalise
      ...> realise_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:ok, {form, _}} = forom |> FOROMPROT.realise(realise_opts)
      ...> form |> harnais_helper_test_forms!(binding: [x: 7])
      {63, ["x = x + 1", "x = x * x", "x = x - 1"]}

  A mixture works:

      iex> {:ok, %FOROMLIST{} = forom} = [
      ...>   42,
      ...>   quote(do: x = x * x * x),
      ...>   :x_sub_1
      ...> ] |> normalise
      ...> realise_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:ok, {values, _}} = forom |> FOROMPROT.realise(realise_opts)
      ...> values |> harnais_helper_show_forms
      {:ok, ["42", "x = x * x * x", "x = x - 1"]}

   The other examples don't really highlight that the child *forom* of a
   **list** *forom* can themselves be **list** *forom*.

      iex> {:ok, forom1} = [:x_sub_1, :x_add_1, :x_mul_x] |> normalise
      ...> {:ok, forom2} = [
      ...>    quote(do: x = x + 9),
      ...>    quote(do: x = x - 5),
      ...>    quote(do: x = x * x * x),
      ...> ] |> normalise
      ...> {:ok, forom3} = :x_funs |> normalise
      ...> {:ok, forom} = [forom1, forom2, forom3] |> normalise
      ...> realise_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise(realise_opts)
      ...> forms |> harnais_helper_test_forms!(binding: [x: 3])
      {4831203, ["x = x - 1", "x = x + 1", "x = x * x",
                 "x = x + 9", "x = x - 5", "x = x * x * x",
                 "x = x + 1", "x = x * x", "x = x - 1"]}

  Anything else creates a **term** *forom*:

      iex> {:ok, %FOROMTERM{} = forom} = %{a: 1} |> normalise
      ...> {:ok, {value, _}} = forom |> FOROMPROT.realise
      ...> value
      %{a: 1}
  """

  @doc_produce ~S"""
  `produce/2` takes a *forom* and an optional *opts*.

  It calls `produce/2` on each of the *forom's* children and merges
  their products into a single `Keyword` returning `{:ok, {product, forom}}`

  ## Examples

  Here the list contains integers:

      iex> {:ok, forom} = new(
      ...>    forom: [
      ...>      FOROMTERM.new!(forom: 7),
      ...>      FOROMTERM.new!(forom: 33),
      ...>      FOROMTERM.new!(forom: 2),
      ...> ])
      ...> {:ok, {product, %FOROMLIST{}}} = forom |> FOROMPROT.produce
      ...> product |> Keyword.get_values(:forom) |> Enum.sum
      42

  Here the list contains code snippets:

      iex> {:ok, forom} = [forom: [
      ...>    FOROMFORM.new!(forom: quote(do: x = x + 1)),
      ...>    FOROMFORM.new!(forom: quote(do: x = x * x)),
      ...>    FOROMFORM.new!(forom: quote(do: x = x - 1))
      ...> ]] |> FOROMLIST.new
      ...> {:ok, {product, _}} = forom |> FOROMPROT.produce
      ...> product |> Keyword.get_values(:forom)
      ...> |> harnais_helper_test_forms!(binding: [x: 3])
      {15, ["x = x + 1", "x = x * x", "x = x - 1"]}

   As an aside, and same example, `normalise/1` helps reduce the boilerplace:

      iex> {:ok, forom} = [
      ...>    quote(do: x = x + 1),
      ...>    quote(do: x = x * x),
      ...>    quote(do: x = x - 1)
      ...> ] |> normalise
      ...> {:ok, {product, _}} = forom |> FOROMPROT.produce
      ...> product |> Keyword.get_values(:forom)
      ...> |> harnais_helper_test_forms!(binding: [x: 3])
      {15, ["x = x + 1", "x = x * x", "x = x - 1"]}

  A similar example to the one above but the list contains *proxy
  foroms* which are recursively produced. Note the *proxy foroms* need
  a *vekil* to resolve the proxies.

      iex> {:ok, forom} = [forom: [
      ...>    FOROMPROXY.new!(forom: :x_add_1),
      ...>    FOROMPROXY.new!(forom: :x_mul_x),
      ...>    FOROMPROXY.new!(forom: :x_sub_1)
      ...> ]] |> FOROMLIST.new
      ...> produce_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:ok, {product, _}} = forom |> FOROMPROT.produce(produce_opts)
      ...> product |> Keyword.get_values(:forom)
      ...> |> harnais_helper_test_forms!(binding: [x: 3])
      {15, ["x = x + 1", "x = x * x", "x = x - 1"]}

  An empty *forom* does not produce any `:forom` keys so the `:produce_default` value is returned. Here the default `:produce_default` is an empty list.

      iex> {:ok, forom} = new()
      ...> {:ok, {product, _}} = forom |> FOROMPROT.produce
      ...> product |> Keyword.get_values(:forom)
      []

  Same example but the `:produce_default` value is set:

      iex> {:ok, forom} = new()
      ...> {:ok, {product, _}} = forom
      ...> |> FOROMPROT.produce(produce_default: [forom: 1, forom: :due, forom: "tre"])
      ...> product |> Keyword.get_values(:forom)
      [1, :due, "tre"]

  """

  @doc_realise ~S"""
  `realise/2` takes a *forom* and an optional *opts*, calls
  `produce/2`, and then gets (`Keyword.get_values/2`) the `:forom` key values.

  The example are essentially the same as `produce/2`

  ## Examples

      iex> {:ok, forom} = new(
      ...>    forom: [
      ...>      FOROMTERM.new!(forom: 7),
      ...>      FOROMTERM.new!(forom: 33),
      ...>      FOROMTERM.new!(forom: 2),
      ...> ])
      ...> {:ok, {values, %FOROMLIST{}}} = forom |> FOROMPROT.realise
      ...> values |> Enum.sum
      42

      iex> {:ok, forom} = [forom: [
      ...>    FOROMFORM.new!(forom: quote(do: x = x + 1)),
      ...>    FOROMFORM.new!(forom: quote(do: x = x * x)),
      ...>    FOROMFORM.new!(forom: quote(do: x = x - 1))
      ...> ]] |> FOROMLIST.new
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise
      ...> forms |> harnais_helper_test_forms!(binding: [x: 3])
      {15, ["x = x + 1", "x = x * x", "x = x - 1"]}

      iex> {:ok, forom} = [forom: [
      ...>    FOROMPROXY.new!(forom: :x_add_1),
      ...>    FOROMPROXY.new!(forom: :x_mul_x),
      ...>    FOROMPROXY.new!(forom: :x_sub_1)
      ...> ]] |> FOROMLIST.new
      ...> realise_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise(realise_opts)
      ...> forms |> harnais_helper_test_forms!(binding: [x: 3])
      {15, ["x = x + 1", "x = x * x", "x = x - 1"]}

      iex> {:ok, forom} = [:x_add_1, :x_mul_x, :x_sub_1] |> normalise
      ...> realise_opts = [vekil: vekil_helper_form_vekil_example1()]
      ...> {:ok, {forms, _}} = forom |> FOROMPROT.realise(realise_opts)
      ...> forms |> harnais_helper_test_forms!(binding: [x: 3])
      {15, ["x = x + 1", "x = x * x", "x = x - 1"]}

      iex> {:ok, forom} = new()
      ...> {:ok, {values, _forom}} = forom |> FOROMPROT.realise
      ...> values
      []
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
    :state_vekil_forom_list_defp_update_field_forom_normalise_forom_list,
    :state_vekil_defp_update_field_produce_default_passthru,
    :state_vekil_defp_update_field_realise_default_passthru,
    :state_vekil_forom_list_defp_update_field_other_propagate,
    :state_defp_update_field_unknown,
    :vekil_forom_list_def_produce,
    :vekil_forom_list_def_realise,
    :vekil_forom_list_defp_realise_product,
    :vekil_forom_def_normalise,

    # forom_value_normalise - other clauses below
    :vekil_forom_defp_forom_value_normalise_header,
    :vekil_forom_defp_forom_value_normalise_clause_match_forom,
    :vekil_forom_defp_forom_value_normalise_clause_l0_new,
    :vekil_forom_defp_forom_value_normalise_clause_l_gt_0,
    :vekil_forom_defp_forom_value_normalise_clause_match_atom_new_proxy
  ]

  @codi_opts [
    {@plymio_fontais_key_dict, @vekil}
  ]

  @vekil_proxies
  |> PROXYFOROMDICT.reify_proxies(@codi_opts)

  defp forom_value_normalise(value, pvo) do
    value
    |> Macro.validate()
    |> case do
      :ok ->
        with {:ok, pvo} <- pvo |> Plymio.Vekil.Forom.Form.update_canonical_opts(),
             {:ok, pvo} <- pvo |> Plymio.Vekil.PVO.pvo_put_forom(value),
             {:ok, %Plymio.Vekil.Forom.Form{}} = result <- pvo |> Plymio.Vekil.Forom.Form.new() do
          result
        else
          {:error, %{__exception__: true}} = result -> result
        end

      _ ->
        with {:ok, pvo} <- pvo |> Plymio.Vekil.Forom.Term.update_canonical_opts(),
             {:ok, pvo} <- pvo |> Plymio.Vekil.PVO.pvo_put_forom(value),
             {:ok, %Plymio.Vekil.Forom.Term{}} = result <- pvo |> Plymio.Vekil.Forom.Term.new() do
          result
        else
          {:error, %{__exception__: true}} = result -> result
        end
    end
  end
end

defimpl Plymio.Vekil.Forom, for: Plymio.Vekil.Forom.List do
  @funs :functions
        |> @protocol.__info__
        |> Keyword.drop([:__protocol__, :impl_for, :impl_for!])

  for {fun, arity} <- @funs do
    defdelegate unquote(fun)(unquote_splicing(Macro.generate_arguments(arity, nil))), to: @for
  end
end

defimpl Inspect, for: Plymio.Vekil.Forom.List do
  use Plymio.Vekil.Attribute

  import Plymio.Fontais.Guard,
    only: [
      is_value_unset_or_nil: 1
    ]

  def inspect(
        %Plymio.Vekil.Forom.List{
          @plymio_vekil_field_forom => forom
        },
        _opts
      ) do
    forom_telltale =
      forom
      |> case do
        x when is_value_unset_or_nil(x) ->
          nil

        x when is_list(x) and length(x) < 4 ->
          x
          |> Enum.map(&inspect/1)
          |> (fn texts ->
                texts |> Enum.join(",")
              end).()

        x when is_list(x) ->
          "#{length(x)}"

        _x ->
          "?"
      end

    forom_telltale =
      [
        forom_telltale
      ]
      |> List.flatten()
      |> Enum.reject(&is_nil/1)
      |> Enum.join("; ")

    "FOROMList(#{forom_telltale})"
  end
end
