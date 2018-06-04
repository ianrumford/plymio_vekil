defmodule Plymio.Vekil.Codi.Vekil.Specific.Dict do
  @moduledoc false

  use Plymio.Vekil.Attribute

  @vekil_state %{
    state_vekil_dict_defp_update_field_dict_normalise_vekil_dict:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_dict = k, v}) do
          with {:ok, dict} <- state |> normalise_vekil_dict(v) do
            {:ok, state |> struct!([{@plymio_vekil_field_dict, dict}])}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    state_vekil_dict_defp_update_field_normalise_proxy_or_normalise_forom:
      quote do
        defp update_field(%__MODULE__{} = state, {k, v})
             when k in [
                    @plymio_vekil_field_forom_normalise,
                    @plymio_vekil_field_proxy_normalise
                  ] do
          cond do
            is_function(v, 1) ->
              {:ok, state |> struct!([{k, v}])}

            Plymio.Fontais.Guard.is_value_unset(v) ->
              {:ok, state |> struct!([{k, v}])}

            true ->
              new_error_result(m: "#{to_string(k)} invalid", v: v)
          end
        end
      end
  }

  @vekil_protocol %{
    vekil_dict_def_proxy_get2_clause_default:
      quote do
        def proxy_get(%__MODULE__{@plymio_vekil_field_dict => dict} = state, proxies) do
          with {:ok, proxies} <- state |> proxies_normalise(proxies) do
            proxies
            |> Plymio.Fontais.Funcio.map_gather0_enum(fn proxy ->
              dict
              |> Map.has_key?(proxy)
              |> case do
                true ->
                  state |> forom_normalise(Map.get(dict, proxy))

                _ ->
                  {:ok, nil}
              end
            end)
            |> case do
              {:error, %{__struct__: _}} = result ->
                result

              {:ok, gather_opts} ->
                gather_opts
                |> reduce_gather_opts
                |> case do
                  {:error, %{__struct__: _}} = result ->
                    result

                  {:ok, []} ->
                    state |> forom_normalise(nil)

                  {:ok, ok_tuples} ->
                    ok_tuples
                    |> Enum.reject(fn
                      {_proxy, nil} -> true
                      _ -> false
                    end)
                    |> case do
                      [] ->
                        state |> forom_normalise

                      tuples ->
                        tuples
                        |> Plymio.Vekil.Utility.proxy_forom_vekil_tuples_reduce()
                    end
                end
            end
          else
            {:error, %{__struct__: _}} = result -> result
          end
        end
      end,
    vekil_dict_def_proxy_get3_clause_default:
      quote do
        def proxy_get(%__MODULE__{@plymio_vekil_field_dict => dict} = state, proxies, default) do
          with {:ok, {default_forom, state}} <- state |> forom_normalise(default),
               {:ok, proxies} <- state |> proxies_normalise(proxies) do
            proxies
            |> Plymio.Fontais.Funcio.map_gather0_enum(fn proxy ->
              dict
              |> Map.has_key?(proxy)
              |> case do
                true ->
                  state |> forom_normalise(Map.get(dict, proxy))

                _ ->
                  {:ok, {default_forom, state}}
              end
            end)
            |> case do
              {:error, %{__struct__: _}} = result ->
                result

              {:ok, gather_opts} ->
                gather_opts
                |> reduce_gather_opts
                |> case do
                  {:error, %{__struct__: _}} = result ->
                    result

                  {:ok, ok_tuples} ->
                    ok_tuples
                    |> Plymio.Vekil.Utility.proxy_forom_vekil_tuples_reduce()
                end
            end
          else
            {:error, _} -> new_error_result(m: "default invalid", v: default)
          end
        end
      end,
    vekil_dict_def_proxy_get2: [
      :vekil_def_proxy_get2_doc,
      :vekil_def_proxy_get2_since,
      :vekil_def_proxy_get2_spec,
      :vekil_def_proxy_get2_header,
      :vekil_dict_def_proxy_get2_clause_default
    ],
    vekil_dict_def_proxy_get3: [
      :vekil_def_proxy_get3_doc,
      :vekil_def_proxy_get3_since,
      :vekil_def_proxy_get3_spec,
      :vekil_def_proxy_get3_header,
      :vekil_dict_def_proxy_get3_clause_default
    ],
    vekil_dict_def_proxy_get: [
      :vekil_dict_def_proxy_get2,
      :vekil_dict_def_proxy_get3
    ],
    vekil_dict_def_proxy_fetch_clause_default:
      quote do
        def proxy_fetch(%__MODULE__{@plymio_vekil_field_dict => dict} = state, proxies) do
          state
          |> proxies_normalise(proxies)
          |> case do
            {:error, %{__struct__: _}} = result ->
              result

            {:ok, []} ->
              state |> forom_normalise

            {:ok, proxies} ->
              proxies
              |> Plymio.Fontais.Funcio.map_gather0_enum(fn proxy ->
                dict
                |> Map.fetch(proxy)
                |> case do
                  {:ok, forom} ->
                    forom
                    |> Plymio.Vekil.Utility.forom?()
                    |> case do
                      true -> {:ok, {forom, state}}
                      _ -> state |> forom_normalise(forom)
                    end

                  :error ->
                    new_error_result(m: "proxy invalid", v: proxy)
                end
              end)
              |> case do
                {:error, %{__struct__: _}} = result ->
                  result

                {:ok, gather_opts} ->
                  gather_opts
                  |> reduce_gather_opts
                  |> case do
                    {:error, %{__struct__: _}} = result ->
                      result

                    {:ok, ok_tuples} ->
                      ok_tuples
                      |> Plymio.Vekil.Utility.proxy_forom_vekil_tuples_reduce()
                  end
              end
          end
        end
      end,
    vekil_dict_def_proxy_fetch: [
      :vekil_def_proxy_fetch_doc,
      :vekil_def_proxy_fetch_since,
      :vekil_def_proxy_fetch_spec,
      :vekil_def_proxy_fetch_header,
      :vekil_dict_def_proxy_fetch_clause_default
    ],
    vekil_dict_def_proxy_put3_clause_default:
      quote do
        def proxy_put(%__MODULE__{@plymio_vekil_field_dict => dict} = state, proxy, forom) do
          state |> proxy_put([{proxy, forom}])
        end
      end,
    vekil_dict_def_proxy_put2_clause_default:
      quote do
        def proxy_put(%__MODULE__{@plymio_vekil_field_dict => dict} = state, tuples) do
          with {:ok, new_dict} <- state |> normalise_vekil_dict(tuples) do
            dict
            |> Plymio.Fontais.Guard.is_value_unset_or_nil()
            |> case do
              true ->
                {:ok, state |> struct!([{@plymio_vekil_field_dict, new_dict}])}

              _ ->
                {:ok, state |> struct!([{@plymio_vekil_field_dict, Map.merge(dict, new_dict)}])}
            end
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_dict_def_proxy_put2: [
      :vekil_def_proxy_put2_doc,
      :vekil_def_proxy_put2_since,
      :vekil_def_proxy_put2_spec,
      :vekil_def_proxy_put2_header,
      :vekil_dict_def_proxy_put2_clause_default
    ],
    vekil_dict_def_proxy_put3: [
      :vekil_def_proxy_put3_doc,
      :vekil_def_proxy_put3_since,
      :vekil_def_proxy_put3_spec,
      :vekil_def_proxy_put3_header,
      :vekil_dict_def_proxy_put3_clause_default
    ],
    vekil_dict_def_proxy_put: [
      :vekil_dict_def_proxy_put2,
      :vekil_dict_def_proxy_put3
    ],
    vekil_dict_def_proxy_delete_clause_default:
      quote do
        def proxy_delete(%__MODULE__{@plymio_vekil_field_dict => dict} = state, proxies)
            when is_map(dict) do
          with {:ok, proxies} <- state |> proxies_normalise(proxies) do
            dict = dict |> Map.drop(proxies)

            state |> update([{@plymio_vekil_field_dict, dict}])
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end

        def proxy_delete(%__MODULE__{} = vekil, _proxies) do
          {:ok, vekil}
        end
      end,
    vekil_dict_def_proxy_delete: [
      :vekil_def_proxy_delete_doc,
      :vekil_def_proxy_delete_since,
      :vekil_def_proxy_delete_spec,
      :vekil_def_proxy_delete_header,
      :vekil_dict_def_proxy_delete_clause_default
    ],
    vekil_dict_def_has_proxy_clause_default?:
      quote do
        def has_proxy?(%__MODULE__{@plymio_vekil_field_dict => dict} = state, proxy)
            when is_map(dict) do
          with {:ok, proxy} <- state |> proxy_normalise(proxy) do
            dict |> Map.has_key?(proxy)
          else
            {:error, %{__exception__: true}} = result -> false
          end
        end

        def has_proxy?(%__MODULE__{}, _proxy) do
          false
        end
      end,
    vekil_dict_def_has_proxy?: [
      :vekil_def_has_proxy_doc?,
      :vekil_def_has_proxy_since?,
      :vekil_def_has_proxy_spec?,
      :vekil_def_has_proxy_header?,
      :vekil_dict_def_has_proxy_clause_default?
    ],
    vekil_dict_form_def_forom_normalise: [
      :vekil_def_forom_normalise_doc,
      :vekil_def_forom_normalise_since,
      :vekil_def_forom_normalise_spec,
      :vekil_def_forom_normalise_header,
      :vekil_def_forom_normalise_clause_match_atom_new_proxy,
      :vekil_def_forom_normalise_clause_pvo,
      :vekil_def_forom_normalise_clause_struct_validate_forom,
      :vekil_def_forom_normalise_clause_forom_value_normalise
    ],
    vekil_dict_term_def_forom_normalise: [
      :vekil_def_forom_normalise_doc,
      :vekil_def_forom_normalise_since,
      :vekil_def_forom_normalise_spec,
      :vekil_def_forom_normalise_header,
      :vekil_def_forom_normalise_clause_pvo,
      :vekil_def_forom_normalise_clause_struct_validate_forom,
      :vekil_def_forom_normalise_clause_forom_value_normalise
    ]
  }

  @vekil_other %{
    vekil_dict_defp_reduce_gather_opts:
      quote do
        defp reduce_gather_opts(gather_opts) do
          with {:ok, gather_opts} <- gather_opts |> Plymio.Fontais.Option.opts_validate() do
            gather_opts
            |> Plymio.Fontais.Funcio.gather_opts_error_get()
            |> case do
              {:ok, []} ->
                gather_opts |> Plymio.Fontais.Funcio.gather_opts_ok_get()

              {:ok, error_tuples} ->
                error_tuples
                |> case do
                  [{_proxy, error}] -> {:error, error}
                  tuples -> new_error_result(m: "proxies invalid", v: tuples |> Keyword.keys())
                end
            end
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_dict_defp_normalise_simple_dict:
      quote do
        defp normalise_vekil_dict(vekil, dict)

        defp normalise_vekil_dict(%__MODULE__{} = state, dict) when is_map(dict) do
          dict
          |> Plymio.Fontais.Funcio.map_collate0_enum(fn {proxy, forom} ->
            with {:ok, proxy} <- state |> proxy_normalise(proxy) do
              {:ok, {proxy, forom}}
            else
              {:error, %{__exception__: true}} = result -> result
            end
          end)
          |> case do
            {:error, %{__struct__: _}} = result ->
              result

            {:ok, tuples} ->
              {:ok, tuples |> Enum.into(%{})}
          end
        end

        defp normalise_vekil_dict(%__MODULE__{} = state, dict) when is_list(dict) do
          dict
          |> Enum.all?(fn
            {k, v} -> true
            _ -> false
          end)
          |> case do
            true -> state |> normalise_vekil_dict(dict |> Enum.into(%{}))
            _ -> new_error_result(m: "vekil dict invalid", v: dict)
          end
        end

        defp normalise_vekil_dict(%__MODULE__{}, dict) do
          new_error_result(m: "vekil dict invalid", v: dict)
        end
      end,
    vekil_dict_defp_normalise_vekil_dict:
      quote do
        defp normalise_vekil_dict(vekil, dict)

        defp normalise_vekil_dict(%__MODULE__{} = state, dict) when is_map(dict) do
          dict
          |> Plymio.Fontais.Funcio.map_collate0_enum(fn {proxy, forom} ->
            forom
            |> Plymio.Vekil.Utility.forom?()
            |> case do
              true ->
                {:ok, {proxy, forom}}

              _ ->
                pvo = [
                  {@plymio_vekil_field_proxy, proxy},
                  {@plymio_vekil_field_vekil, state}
                ]

                with {:ok, proxy} <- state |> proxy_normalise(pvo) do
                  forom
                  |> List.wrap()
                  |> Plymio.Fontais.Funcio.map_collate0_enum(fn forom ->
                    with {:ok, pvo} <- pvo |> Plymio.Vekil.PVO.pvo_put_forom(forom),
                         {:ok, {forom, _}} <- state |> forom_normalise(pvo) do
                      {:ok, forom}
                    else
                      {:error, %{__exception__: true}} = result -> result
                    end
                  end)
                  |> case do
                    {:error, %{__struct__: _}} = result ->
                      result

                    # single forom?
                    {:ok, [forom]} ->
                      {:ok, {proxy, forom}}

                    # multiple forom => create a list forom to hold them
                    {:ok, forom_list} when is_list(forom_list) ->
                      with {:ok, forom} <-
                             [{@plymio_vekil_field_forom, forom_list}]
                             |> Plymio.Vekil.Forom.List.new() do
                        {:ok, {proxy, forom}}
                      else
                        {:error, %{__exception__: true}} = result -> result
                      end
                  end
                else
                  {:error, %{__struct__: _}} = result -> result
                end
            end
          end)
          |> case do
            {:error, %{__struct__: _}} = result ->
              result

            {:ok, tuples} ->
              {:ok, tuples |> Enum.into(%{})}
          end
        end

        defp normalise_vekil_dict(%__MODULE__{} = state, dict) when is_list(dict) do
          dict
          |> Enum.all?(fn
            {k, v} -> true
            _ -> false
          end)
          |> case do
            true -> state |> normalise_vekil_dict(dict |> Enum.into(%{}))
            _ -> new_error_result(m: "vekil dict invalid", v: dict)
          end
        end

        defp normalise_vekil_dict(%__MODULE__{}, dict) do
          new_error_result(m: "vekil dict invalid", v: dict)
        end
      end
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
