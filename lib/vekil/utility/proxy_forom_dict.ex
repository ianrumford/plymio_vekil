defmodule Plymio.Vekil.Utility.ProxyForomDict do
  @moduledoc false

  use Plymio.Fontais.Attribute
  use Plymio.Vekil.Attribute

  @type form :: Plymio.Fontais.form()
  @type forms :: Plymio.Fontais.forms()
  @type error :: Plymio.Fontais.error()

  import Plymio.Fontais.Error,
    only: [
      new_error_result: 1
    ]

  import Plymio.Funcio.Enum.Map.Collate,
    only: [
      map_concurrent_collate0_enum: 2
    ]

  import Plymio.Fontais.Vekil.ProxyForomDict,
    only: [
      validate_proxy_forom_dict: 1
    ]

  @doc false

  @since "0.1.0"

  @spec create_proxy_forom_dict(any) :: {:ok, map} | {:error, error}

  def create_proxy_forom_dict(value) do
    cond do
      Keyword.keyword?(value) -> [value]
      true -> value |> List.wrap()
    end
    |> map_concurrent_collate0_enum(fn
      v when is_atom(v) ->
        {:ok, apply(v, :__vekil__, [])}

      v ->
        {:ok, v}
    end)
    |> case do
      {:error, %{__struct__: _}} = result ->
        result

      {:ok, dicts} ->
        dicts
        |> map_concurrent_collate0_enum(fn
          %{__struct__: _} = v ->
            v
            |> Map.get(@plymio_fontais_key_dict)
            |> case do
              x when is_map(x) ->
                {:ok, x}

              x ->
                new_error_result(m: "struct dict invalid", v: x)
            end

          v when is_map(v) ->
            {:ok, v}

          v when is_list(v) ->
            case v |> Keyword.keyword?() do
              true ->
                {:ok, v |> Enum.into(%{})}

              _ ->
                new_error_result(m: "proxy forom dict invalid", v: v)
            end

          v ->
            new_error_result(m: "proxy forom dict", v: v)
        end)
    end
    |> case do
      {:error, %{__struct__: _}} = result ->
        result

      {:ok, dicts} ->
        dicts
        |> Enum.reduce(%{}, fn m, s -> Map.merge(s, m) end)
        |> validate_proxy_forom_dict
    end
  end

  @doc false

  @spec create_proxy_forom_dict!(any) :: map | no_return

  def create_proxy_forom_dict!(value) do
    with {:ok, dict} <- value |> create_proxy_forom_dict do
      dict
    else
      {:error, error} -> raise error
    end
  end
end
