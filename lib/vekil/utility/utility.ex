defmodule Plymio.Vekil.Utility do
  @moduledoc false

  alias Plymio.Vekil, as: VEKILPROT
  alias Plymio.Vekil.Term, as: VEKILTERM
  alias Plymio.Vekil.Form, as: VEKILFORM
  use Plymio.Fontais.Attribute
  use Plymio.Vekil.Attribute

  @type form :: Plymio.Fontais.form()
  @type forms :: Plymio.Fontais.forms()
  @type error :: Plymio.Fontais.error()

  import Plymio.Fontais.Error,
    only: [
      new_error_result: 1
    ]

  import Plymio.Fontais.Guard,
    only: [
      is_value_set: 1
    ]

  import Plymio.Fontais.Option,
    only: [
      opts_validate: 1
    ]

  import Plymio.Funcio.Enum.Map.Collate,
    only: [
      map_collate0_enum: 2
    ]

  import Plymio.Vekil.Utility.ProxyForomDict,
    only: [
      create_proxy_forom_dict: 1
    ]

  def validate_vekil(value)

  def validate_vekil(value) when is_value_set(value) do
    value
    |> Plymio.Vekil.impl_for()
    |> case do
      x when is_nil(x) -> new_error_result(m: "vekil invalid", v: value)
      _ -> {:ok, value}
    end
  end

  def validate_vekil(_value) do
    new_error_result(m: "vekil is unset")
  end

  def vekil?(value) do
    value
    |> Plymio.Vekil.impl_for()
    |> case do
      x when is_nil(x) -> false
      _ -> true
    end
  end

  def validate_forom(value) do
    value
    |> Plymio.Vekil.Forom.impl_for()
    |> case do
      x when is_nil(x) -> new_error_result(m: "forom invalid", v: value)
      _ -> {:ok, value}
    end
  end

  def forom?(value) do
    value
    |> Plymio.Vekil.Forom.impl_for()
    |> case do
      x when is_nil(x) -> false
      _ -> true
    end
  end

  @doc false

  @spec proxy_forom_vekil_tuple_integrate({any, {struct, struct}}) ::
          {:ok, {struct, struct}} | {:error, error}

  defp proxy_forom_vekil_tuple_integrate(tuple)

  defp proxy_forom_vekil_tuple_integrate({proxy, {forom, vekil}}) do
    forom_opts = [{@plymio_vekil_field_vekil, vekil}, {@plymio_vekil_field_proxy, proxy}]

    with {:ok, vekil} <- vekil |> Plymio.Vekil.proxy_put([{proxy, forom}]),
         {:ok, forom} <- forom |> Plymio.Vekil.Forom.update(forom_opts) do
      {:ok, {forom, vekil}}
    else
      {:error, %{__exception__: true}} = result -> result
    end
  end

  defp proxy_forom_vekil_tuple_integrate(tuple) do
    new_error_result(m: "proxy_forom_vekil tuple invalid", v: tuple)
  end

  @doc false

  @spec proxy_forom_vekil_tuples_reduce(any) :: {:ok, {struct, struct}} | {:error, error}

  def proxy_forom_vekil_tuples_reduce(tuples)

  def proxy_forom_vekil_tuples_reduce([tuple]) do
    tuple |> proxy_forom_vekil_tuple_integrate
  end

  def proxy_forom_vekil_tuples_reduce(tuples) when is_list(tuples) do
    tuples
    |> Plymio.Fontais.Funcio.map_collate0_enum(&proxy_forom_vekil_tuple_integrate/1)
    |> case do
      {:error, %{__struct__: _}} = result ->
        result

      {:ok, forom_vekil_tuples} ->
        {forom_values, vekil_values} = forom_vekil_tuples |> Enum.unzip()

        vekil = vekil_values |> List.last()

        with {:ok, forom} <- forom_values |> forom_reduce do
          {:ok, {forom, vekil}}
        else
          {:error, %{__exception__: true}} = result -> result
        end
    end
  end

  @doc false

  @since "0.1.0"

  @spec forom_reduce(any) :: {:ok, struct} | {:error, error}

  def forom_reduce(forom) do
    cond do
      forom?(forom) ->
        {:ok, forom}

      is_list(forom) ->
        forom
        |> map_collate0_enum(&validate_forom/1)
        |> case do
          {:error, %{__struct__: _}} = result ->
            result

          {:ok, [forom]} ->
            {:ok, forom}

          {:ok, forom_list} ->
            [{@plymio_vekil_field_forom, forom_list}] |> Plymio.Vekil.Forom.List.new()
        end

      true ->
        new_error_result(m: "forom invalid", v: forom)
    end
  end

  @doc false

  @spec normalise_term_vekil(any) :: {:ok, %VEKILTERM{}} | {:error, error}

  def normalise_term_vekil(value)

  def normalise_term_vekil(
        %{
          :__struct__ => _,
          @plymio_fontais_field_protocol_name => VEKILPROT,
          @plymio_fontais_field_protocol_impl => VEKILTERM
        } = state
      ) do
    {:ok, state}
  end

  def normalise_term_vekil(value) do
    with {:ok, %VEKILTERM{}} = result <- value |> create_term_vekil do
      result
    else
      {:error, %{__struct__: _}} = result -> result
    end
  end

  @doc false

  @spec create_term_vekil(any) :: {:ok, %VEKILTERM{}} | {:error, error}

  def create_term_vekil(value) do
    with {:ok, term_dict} <- value |> create_proxy_forom_dict,
         {:ok, %VEKILTERM{} = vekil} <- VEKILTERM.new(),
         {:ok, %VEKILTERM{}} = result <-
           vekil
           |> VEKILTERM.update([{@plymio_vekil_field_dict, term_dict}]),
         true <- true do
      result
    else
      {:error, %{__struct__: _}} = result -> result
    end
  end

  @doc false

  @spec create_term_vekil!(any) :: %VEKILFORM{} | no_return

  def create_term_vekil!(value) do
    with {:ok, %VEKILTERM{} = vekil} <- value |> create_term_vekil do
      vekil
    else
      {:error, %{__struct__: _} = error} -> raise error
    end
  end

  @doc false

  @spec normalise_form_vekil(any) :: {:ok, %VEKILFORM{}} | {:error, error}

  def normalise_form_vekil(value)

  def normalise_form_vekil(
        %{
          :__struct__ => _,
          @plymio_fontais_field_protocol_name => VEKILPROT,
          @plymio_fontais_field_protocol_impl => VEKILFORM
        } = state
      ) do
    {:ok, state}
  end

  def normalise_form_vekil(value) do
    with {:ok, %VEKILFORM{}} = result <- value |> create_form_vekil do
      result
    else
      {:error, %{__struct__: _}} = result -> result
    end
  end

  @doc false

  @spec create_form_vekil(any) :: {:ok, %VEKILFORM{}} | {:error, error}

  def create_form_vekil(value) do
    with {:ok, form_dict} <- value |> create_proxy_forom_dict,
         {:ok, %VEKILFORM{} = vekil} <- VEKILFORM.new(),
         {:ok, %VEKILFORM{}} = result <-
           vekil |> VEKILFORM.update([{@plymio_vekil_field_dict, form_dict}]),
         true <- true do
      result
      # nil
    else
      {:error, %{__struct__: _}} = result -> result
    end
  end

  @doc false

  @spec create_form_vekil!(any) :: %VEKILFORM{} | no_return

  def create_form_vekil!(value) do
    with {:ok, %VEKILFORM{} = vekil} <- value |> create_form_vekil do
      vekil
    else
      {:error, %{__struct__: _} = error} -> raise error
    end
  end

  @doc false

  @spec build_form_vekil(any) :: {:ok, %VEKILFORM{}} | {:error, error}

  def build_form_vekil(value) do
    with {:ok, %VEKILFORM{@plymio_vekil_field_dict => dict} = vekil} <- value |> create_form_vekil do
      dict
      |> Plymio.Fontais.Funcio.map_collate0_enum(fn
        {proxy, value}
        when is_atom(value) or is_tuple(value) or is_list(value) ->
          with {:ok, {forom, _}} <- vekil |> VEKILPROT.forom_normalise(value) do
            {:ok, {proxy, forom}}
          else
            {:error, %{__exception__: true}} = result -> result
          end

        {proxy, forom} ->
          {:ok, {proxy, forom}}
      end)
      |> case do
        {:error, %{__struct__: _}} = result ->
          result

        {:ok, form_tuples} ->
          vekil |> VEKILFORM.update([{@plymio_vekil_field_dict, Map.new(form_tuples)}])
      end
    else
      {:error, %{__struct__: _}} = result -> result
    end
  end

  @doc false

  @spec build_form_vekil!(any) :: %VEKILFORM{} | no_return

  def build_form_vekil!(value) do
    with {:ok, %VEKILFORM{} = vekil} <- value |> build_form_vekil do
      vekil
    else
      {:error, %{__struct__: _} = error} -> raise error
    end
  end

  @since "0.1.0"

  @spec produce_proxies(any, any) :: {:ok, {any, struct}} | {:error, error}

  def produce_proxies(proxies, t_or_opts \\ [])

  def produce_proxies(proxies, opts) when is_list(opts) do
    with {:ok, opts} <- opts |> opts_validate do
      opts
      |> Keyword.has_key?(@plymio_vekil_key_vekil)
      |> case do
        true ->
          with {:ok, {forms, state}} <-
                 proxies
                 |> produce_proxies(opts |> Keyword.fetch!(@plymio_vekil_key_vekil)),
               edit_opts = opts |> Keyword.take(@plymio_fontais_form_edit_keys),
               {:ok, forms} <- forms |> Plymio.Fontais.Form.forms_edit(edit_opts) do
            {:ok, {forms, state}}
          else
            {:error, %{__exception__: true}} = result -> result
          end

        _ ->
          with {:ok, state} <- opts |> Plymio.Vekil.Form.new(),
               {:ok, _} = result <- opts |> produce_proxies(state) do
            result
          else
            {:error, %{__exception__: true}} = result -> result
          end
      end
    else
      {:error, %{__exception__: true}} = result -> result
    end
  end

  def produce_proxies(proxies, state) do
    cond do
      vekil?(state) ->
        with {:ok, {forom, state}} <- state |> Plymio.Vekil.proxy_fetch(proxies),
             {:ok, {forms, _forom}} <- forom |> Plymio.Vekil.Forom.realise(),
             {:ok, forms} <- forms |> Plymio.Fontais.Form.forms_normalise() do
          {:ok, {forms, state}}
        else
          {:error, %{__exception__: true}} = result -> result
        end

      true ->
        new_error_result(m: "vekil invalid PRODUCE_PROXIES=(?,?)", v: state)
    end
  end

  @doc false

  @since "0.1.0"

  defmacro reify_proxies(proxies, opts \\ []) do
    quote bind_quoted: [proxies: proxies, opts: opts] do
      with {:ok, {forms, _}} <- proxies |> Plymio.Vekil.Utility.produce_proxies(opts) do
        forms
        |> Code.eval_quoted([], __ENV__)
      else
        {:error, %{__exception__: true} = error} -> raise error
      end
    end
  end
end
