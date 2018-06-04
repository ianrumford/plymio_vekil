defmodule Plymio.Vekil.Codi.Vekil.Proxy.Generic do
  @moduledoc false

  use Plymio.Vekil.Attribute

  @vekil_state %{
    state_vekil_proxy_defp_update_field_proxy_passthru:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_proxy = k, v}) do
          {:ok, state |> struct!([{k, v}])}
        end
      end,
    state_vekil_proxy_defp_update_field_proxy_ignore:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_proxy = _k, _v}) do
          {:ok, state}
        end
      end
  }

  @vekil_other %{
    vekil_proxy_def_proxy_normalise_doc: :doc_false,
    vekil_proxy_def_proxy_normalise_since: nil,
    vekil_proxy_def_proxy_normalise_spec:
      quote do
        @spec proxy_normalise(t, any) :: {:ok, any} | {:error, error}
      end,
    vekil_proxy_def_proxy_normalise_header:
      quote do
        def proxy_normalise(vekil, value)
      end,
    vekil_proxy_def_proxy_normalise_clause_pvo:
      quote do
        def proxy_normalise(
              %__MODULE__{
                @plymio_vekil_field_proxy_normalise => proxy_normalise
              } = state,
              pvo
            )
            when is_list(pvo) and is_function(proxy_normalise, 1) do
          with {:ok, pvo} <- pvo |> Plymio.Vekil.PVO.pvo_normalise(),
               {:ok, _proxy} = result <- pvo |> proxy_normalise.() do
            result
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_proxy_def_proxy_normalise_clause_default:
      quote do
        def proxy_normalise(
              %__MODULE__{
                @plymio_vekil_field_proxy_normalise => proxy_normalise
              } = state,
              proxy
            )
            when is_function(proxy_normalise, 1) do
          norm_opts = [
            {@plymio_vekil_field_proxy, proxy},
            {@plymio_vekil_field_vekil, state}
          ]

          norm_opts |> proxy_normalise.()
        end
      end,
    vekil_proxy_def_proxy_normalise: [
      :vekil_proxy_def_proxy_normalise_doc,
      :vekil_proxy_def_proxy_normalise_since,
      :vekil_proxy_def_proxy_normalise_spec,
      :vekil_proxy_def_proxy_normalise_header,
      :vekil_proxy_def_proxy_normalise_clause_pvo,
      :vekil_proxy_def_proxy_normalise_clause_default
    ],
    vekil_proxy_def_proxies_normalise_doc: :doc_false,
    vekil_proxy_def_proxies_normalise_since: nil,
    vekil_proxy_def_proxies_normalise_spec:
      quote do
        @spec proxies_normalise(t, any) :: {:ok, any} | {:error, error}
      end,
    vekil_proxy_def_proxies_normalise_header:
      quote do
        def proxies_normalise(vekil, proxies)
      end,
    vekil_proxy_def_proxies_normalise_clause_nil:
      quote do
        def proxies_normalise(%__MODULE__{} = state, proxies) when is_nil(proxies) do
          {:ok, []}
        end
      end,
    vekil_proxy_def_proxies_normalise_clause_l:
      quote do
        def proxies_normalise(%__MODULE__{} = state, proxies) when is_list(proxies) do
          proxies
          |> Plymio.Fontais.Funcio.map_collate0_enum(fn proxy ->
            state |> proxy_normalise(proxy)
          end)
        end
      end,
    vekil_proxy_def_proxies_normalise_clause_default:
      quote do
        def proxies_normalise(%__MODULE__{} = state, proxy) do
          with {:ok, proxy} <- state |> proxy_normalise(proxy) do
            {:ok, [proxy]}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_proxy_def_proxies_normalise: [
      :vekil_proxy_def_proxies_normalise_doc,
      :vekil_proxy_def_proxies_normalise_since,
      :vekil_proxy_def_proxies_normalise_spec,
      :vekil_proxy_def_proxies_normalise_header,
      :vekil_proxy_def_proxies_normalise_clause_l,
      :vekil_proxy_def_proxies_normalise_clause_nil,
      :vekil_proxy_def_proxies_normalise_clause_default
    ]
  }

  @vekil [
           @vekil_state,
           @vekil_other
         ]
         |> Enum.reduce(fn m, s -> Map.merge(s, m) end)

  def __vekil__() do
    @vekil
  end
end
