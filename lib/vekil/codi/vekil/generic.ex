defmodule Plymio.Vekil.Codi.Vekil.Generic do
  @moduledoc false

  use Plymio.Vekil.Attribute

  @vekil_state %{
    state_vekil_defp_update_field_vekil_ignore:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_vekil, _v}) do
          {:ok, state}
        end
      end,
    state_vekil_defp_update_field_vekil_passthru:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_vekil = k, v}) do
          {:ok, state |> struct!([{k, v}])}
        end
      end,
    state_vekil_defp_update_field_vekil_validate_vekil:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_vekil = k, v}) do
          with {:ok, vekil} <- v |> validate_vekil do
            {:ok, state |> struct!([{k, vekil}])}
          else
            {:error, %{__struct__: _}} = result -> result
          end
        end
      end,
    state_vekil_defp_update_field_proxy_ignore:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_proxy = k, _v}) do
          {:ok, state}
        end
      end,
    state_vekil_defp_update_field_seen_ignore:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_seen = k, _v}) do
          {:ok, state}
        end
      end,
    state_vekil_defp_update_field_seen_validate:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_seen = k, v}) do
          v
          |> is_map
          |> case do
            true ->
              {:ok, state |> struct!([{@plymio_vekil_field_seen, v}])}

            _ ->
              new_error_result(m: "seen invalid", v: v)
          end
        end
      end,
    state_vekil_defp_update_field_produce_default_ignore:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_produce_default = k, _v}) do
          {:ok, state}
        end
      end,
    state_vekil_defp_update_field_produce_default_passthru:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_produce_default = k, v}) do
          {:ok, state |> struct!([{k, v}])}
        end
      end,
    state_vekil_defp_update_field_realise_default_ignore:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_realise_default = k, _v}) do
          {:ok, state}
        end
      end,
    state_vekil_defp_update_field_realise_default_passthru:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_realise_default = k, v}) do
          {:ok, state |> struct!([{k, v}])}
        end
      end
  }

  @vekil_protocol %{
    vekil_def_proxy_get2_doc:
      quote do
        @doc ~S"""
        See `Plymio.Vekil.proxy_get/2`
        """
      end,
    vekil_def_proxy_get2_since: nil,
    vekil_def_proxy_get2_spec:
      quote do
        @spec proxy_get(t, proxies) :: {:ok, {product, t}} | {:error, error}
      end,
    vekil_def_proxy_get2_header:
      quote do
        def proxy_get(vekil, proxies)
      end,
    vekil_def_proxy_get3_doc:
      quote do
        @doc ~S"""
        See `Plymio.Vekil.proxy_get/3`
        """
      end,
    vekil_def_proxy_get3_since: nil,
    vekil_def_proxy_get3_spec:
      quote do
        @spec proxy_get(t, any, any) :: {:ok, {product, t}} | {:error, error}
      end,
    vekil_def_proxy_get3_header:
      quote do
        def proxy_get(vekil, proxies, default)
      end,
    vekil_def_proxy_fetch_doc:
      quote do
        @doc ~S"""
        See `Plymio.Vekil.proxy_fetch/2`
        """
      end,
    vekil_def_proxy_fetch_since: nil,
    vekil_def_proxy_fetch_spec:
      quote do
        @spec proxy_fetch(t, any) :: {:ok, {product, t}} | {:error, error}
      end,
    vekil_def_proxy_fetch_header:
      quote do
        def proxy_fetch(vekil, proxies)
      end,
    vekil_def_proxy_put2_doc:
      quote do
        @doc ~S"""
        See `Plymio.Vekil.proxy_put/2`
        """
      end,
    vekil_def_proxy_put2_since: nil,
    vekil_def_proxy_put2_spec:
      quote do
        @spec proxy_put(t, any) :: {:ok, t} | {:error, error}
      end,
    vekil_def_proxy_put2_header:
      quote do
        def proxy_put(vekil, tuples)
      end,
    vekil_def_proxy_put3_doc:
      quote do
        @doc ~S"""
        See `Plymio.Vekil.proxy_put/3`
        """
      end,
    vekil_def_proxy_put3_since: nil,
    vekil_def_proxy_put3_spec:
      quote do
        @spec proxy_put(t, any, any) :: {:ok, t} | {:error, error}
      end,
    vekil_def_proxy_put3_header:
      quote do
        def proxy_put(vekil, proxy, forom)
      end,
    vekil_def_proxy_delete_doc:
      quote do
        @doc ~S"""
        See `Plymio.Vekil.proxy_delete/2`
        """
      end,
    vekil_def_proxy_delete_since: nil,
    vekil_def_proxy_delete_spec:
      quote do
        @spec proxy_delete(t, any) :: {:ok, t} | {:error, error}
      end,
    vekil_def_proxy_delete_header:
      quote do
        def proxy_delete(vekil, proxies)
      end,
    vekil_def_has_proxy_doc?:
      quote do
        @doc ~S"""
        See `Plymio.Vekil.has_proxy?/2`
        """
      end,
    vekil_def_has_proxy_since?: nil,
    vekil_def_has_proxy_spec?:
      quote do
        @spec has_proxy?(t, any) :: boolean
      end,
    vekil_def_has_proxy_header?:
      quote do
        def has_proxy?(vekil, proxy)
      end,
    vekil_def_forom_normalise_doc:
      quote do
        @doc ~S"""
        See `Plymio.Vekil.forom_normalise/2`
        """
      end,
    vekil_def_forom_normalise_since: nil,
    vekil_def_forom_normalise_spec:
      quote do
        @spec forom_normalise(any, any) :: {:ok, {forom, t}} | {:error, error}
      end,
    vekil_def_forom_normalise_header:
      quote do
        def forom_normalise(vekil, value \\ [])
      end,
    vekil_def_forom_normalise_clause_struct_validate_forom:
      quote do
        def forom_normalise(%__MODULE__{} = state, %{__struct__: _} = value) do
          with {:ok, forom} <- value |> Plymio.Vekil.Utility.validate_forom() do
            {:ok, {forom, state}}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_def_forom_normalise_clause_match_forom:
      quote do
        def forom_normalise(
              %__MODULE__{} = state,
              %{:__struct__ => _, @plymio_fontais_field_alias_protocol_name => Plymio.Vekil.Forom} =
                value
            ) do
          {:ok, {value, state}}
        end
      end,
    vekil_def_forom_normalise_clause_pvo:
      quote do
        def forom_normalise(
              %__MODULE__{@plymio_vekil_field_forom_normalise => forom_normalise} = state,
              pvo
            )
            when is_list(pvo) do
          cond do
            length(pvo) == 0 ->
              state |> forom_value_normalise(pvo)

            Keyword.keyword?(pvo) and Keyword.has_key?(pvo, @plymio_vekil_key_forom) ->
              with {:ok, pvo} <- pvo |> Plymio.Vekil.PVO.pvo_normalise(),
                   {:ok, forom} <- pvo |> Plymio.Vekil.PVO.pvo_fetch_forom() do
                cond do
                  Plymio.Vekil.Utility.forom?(forom) ->
                    {:ok, {forom, state}}

                  true ->
                    state |> forom_value_normalise(pvo)
                end
              else
                {:error, %{__exception__: true}} = result -> result
              end

            true ->
              pvo
              |> Plymio.Fontais.Funcio.map_collate0_enum(fn forom ->
                state |> forom_normalise(forom)
              end)
              |> case do
                {:error, %{__struct__: _}} = result ->
                  result

                {:ok, tuples} ->
                  forom_values = tuples |> Enum.unzip() |> elem(0)

                  with {:ok, forom} <- forom_values |> Plymio.Vekil.Utility.forom_reduce() do
                    {:ok, {forom, state}}
                  else
                    {:error, %{__exception__: true}} = result -> result
                  end
              end
          end
        end
      end,
    vekil_def_forom_normalise_clause_match_atom_new_proxy:
      quote do
        def forom_normalise(%__MODULE__{} = state, value)
            when is_atom(value) and not is_nil(value) do
          with {:ok, forom} <-
                 [
                   {@plymio_vekil_field_forom, value},
                   {@plymio_vekil_field_vekil, state}
                 ]
                 |> Plymio.Vekil.Forom.Proxy.new() do
            {:ok, {forom, state}}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_def_forom_normalise_clause_forom_value_normalise:
      quote do
        def forom_normalise(%__MODULE__{} = state, value) do
          state |> forom_value_normalise(value)
        end
      end
  }

  @vekil_other %{
    vekil_defp_validate_vekil:
      quote do
        @doc false
        defdelegate validate_vekil(vekil), to: Plymio.Vekil.Utility
      end,
    vekil_def_normalise_clause_match_vekil:
      quote do
        def normalise(
              %{
                :__struct__ => _,
                @plymio_fontais_field_protocol_name => Plymio.Vekil
              } = value
            ) do
          {:ok, value}
        end
      end,
    vekil_defp_forom_value_normalise_header:
      quote do
        @spec forom_value_normalise(any, any) :: {:ok, struct} | {:error, error}
        defp forom_value_normalise(vekil, value)
      end,
    vekil_defp_forom_value_normalise_clause_forom_normalise_fun:
      quote do
        defp forom_value_normalise(
               %__MODULE__{@plymio_vekil_field_forom_normalise => forom_normalise} = state,
               value
             )
             when is_function(forom_normalise, 1) do
          with {:ok, pvo} <-
                 value
                 |> Plymio.Vekil.PVO.pvo_normalise_forom_value([{@plymio_vekil_key_vekil, state}]),
               {:ok, forom} <- pvo |> forom_normalise.() do
            {:ok, {forom, state}}
          else
            {:error, %{__struct__: _}} = result -> result
          end
        end

        defp forom_value_normalise(
               %__MODULE__{@plymio_vekil_field_forom_normalise => forom_normalise} = state,
               value
             )
             when is_function(forom_normalise, 2) do
          with {:ok, {_forom, %__MODULE__{}}} = result <- forom_normalise.(state, value) do
            result
          else
            {:error, %{__struct__: _}} = result -> result
          end
        end

        defp forom_value_normalise(
               %__MODULE__{@plymio_vekil_field_forom_normalise => forom_normalise} = _state,
               _value
             ) do
          new_error_result(m: "forom normalise functio invalid", v: forom_normalise)
        end
      end,
    vekil_defp_forom_value_normalise: [
      :vekil_defp_forom_value_normalise_header,
      :vekil_defp_forom_value_normalise_clause_forom_normalise_fun
    ]
  }

  @vekil [
           @vekil_state,
           @vekil_protocol,
           @vekil_other
         ]
         |> Enum.reduce(fn m, s -> Map.merge(s, m) end)

  def __vekil__() do
    @vekil
  end
end
