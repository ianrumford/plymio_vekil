defmodule Plymio.Vekil.Codi.Vekil.State do
  @moduledoc false

  @vekil %{
    state_delegate_vekil_field_def_proxy_get2_doc: :doc_false,
    state_delegate_vekil_field_def_proxy_get2_since: nil,
    state_delegate_vekil_field_def_proxy_get2_spec:
      quote do
        @spec proxy_fun_name(any, any) :: {:ok, t} | {:error, error}
      end,
    state_delegate_vekil_field_def_proxy_get2_header:
      quote do
        def proxy_fun_name(vekil, proxies)
      end,
    state_delegate_vekil_field_def_proxy_get2_clause_default:
      quote do
        def proxy_fun_name(%__MODULE__{:proxy_field => vekil} = state, proxies) do
          with {:ok, vekil} <- vekil |> Plymio.Vekil.Utility.validate_vekil(),
               {:ok, {forom, vekil}} <- vekil |> Plymio.Vekil.proxy_get(proxies),
               {:ok, %__MODULE__{} = state} <- state |> update([{:proxy_field, vekil}]) do
            {:ok, {forom, state}}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    state_delegate_vekil_field_def_proxy_get2: [
      :state_delegate_vekil_field_def_proxy_get2_doc,
      :state_delegate_vekil_field_def_proxy_get2_since,
      :state_delegate_vekil_field_def_proxy_get2_spec,
      :state_delegate_vekil_field_def_proxy_get2_header,
      :state_delegate_vekil_field_def_proxy_get2_clause_default
    ],
    state_delegate_vekil_field_def_proxy_get3_doc: :doc_false,
    state_delegate_vekil_field_def_proxy_get3_since: nil,
    state_delegate_vekil_field_def_proxy_get3_spec:
      quote do
        @spec proxy_fun_name(any, any, any) :: {:ok, t} | {:error, error}
      end,
    state_delegate_vekil_field_def_proxy_get3_header:
      quote do
        def proxy_fun_name(vekil, proxy, default)
      end,
    state_delegate_vekil_field_def_proxy_get3_clause_default:
      quote do
        def proxy_fun_name(%__MODULE__{:proxy_field => vekil} = state, proxy, default) do
          with {:ok, vekil} <- vekil |> Plymio.Vekil.Utility.validate_vekil(),
               {:ok, {forom, vekil}} <- vekil |> Plymio.Vekil.proxy_get(proxy, default),
               {:ok, %__MODULE__{}} <- state |> update([{:proxy_field, vekil}]) do
            {:ok, {forom, state}}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    state_delegate_vekil_field_def_proxy_get3: [
      :state_delegate_vekil_field_def_proxy_get3_doc,
      :state_delegate_vekil_field_def_proxy_get3_since,
      :state_delegate_vekil_field_def_proxy_get3_spec,
      :state_delegate_vekil_field_def_proxy_get3_header,
      :state_delegate_vekil_field_def_proxy_get3_clause_default
    ],
    state_delegate_vekil_field_def_proxy_get: [
      :state_delegate_vekil_field_def_proxy_get2,
      :state_delegate_vekil_field_def_proxy_get3
    ],
    state_delegate_vekil_field_def_proxy_fetch_doc: :doc_false,
    state_delegate_vekil_field_def_proxy_fetch_since: nil,
    state_delegate_vekil_field_def_proxy_fetch_spec:
      quote do
        @spec proxy_fun_name(any, any) :: {:ok, {any, t}} | {:error, error}
      end,
    state_delegate_vekil_field_def_proxy_fetch_header:
      quote do
        def proxy_fun_name(vekil, proxies)
      end,
    state_delegate_vekil_field_def_proxy_fetch_clause_default:
      quote do
        def proxy_fun_name(%__MODULE__{:proxy_field => vekil} = state, proxies) do
          with {:ok, vekil} <- vekil |> Plymio.Vekil.Utility.validate_vekil(),
               {:ok, {forom, vekil}} <- vekil |> Plymio.Vekil.proxy_fetch(proxies),
               {:ok, %__MODULE__{}} <- state |> update([{:proxy_field, vekil}]) do
            {:ok, {forom, state}}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    state_delegate_vekil_field_def_proxy_fetch: [
      :state_delegate_vekil_field_def_proxy_fetch_doc,
      :state_delegate_vekil_field_def_proxy_fetch_since,
      :state_delegate_vekil_field_def_proxy_fetch_spec,
      :state_delegate_vekil_field_def_proxy_fetch_header,
      :state_delegate_vekil_field_def_proxy_fetch_clause_default
    ],
    state_delegate_vekil_field_def_proxy_put2_doc: :doc_false,
    state_delegate_vekil_field_def_proxy_put2_since: nil,
    state_delegate_vekil_field_def_proxy_put2_spec:
      quote do
        @spec proxy_fun_name(any, any) :: {:ok, t} | {:error, error}
      end,
    state_delegate_vekil_field_def_proxy_put2_header:
      quote do
        def proxy_fun_name(vekil, tuples)
      end,
    state_delegate_vekil_field_def_proxy_put2_clause_default:
      quote do
        def proxy_fun_name(%__MODULE__{:proxy_field => vekil} = state, tuples) do
          with {:ok, vekil} <- vekil |> Plymio.Vekil.Utility.validate_vekil(),
               {:ok, vekil} = result <- vekil |> Plymio.Vekil.proxy_put(tuples),
               {:ok, %__MODULE__{}} = result <- state |> update([{:proxy_field, vekil}]) do
            result
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    state_delegate_vekil_field_def_proxy_put2: [
      :state_delegate_vekil_field_def_proxy_put2_doc,
      :state_delegate_vekil_field_def_proxy_put2_since,
      :state_delegate_vekil_field_def_proxy_put2_spec,
      :state_delegate_vekil_field_def_proxy_put2_header,
      :state_delegate_vekil_field_def_proxy_put2_clause_default
    ],
    state_delegate_vekil_field_def_proxy_put3_doc: :doc_false,
    state_delegate_vekil_field_def_proxy_put3_since: nil,
    state_delegate_vekil_field_def_proxy_put3_spec:
      quote do
        @spec proxy_fun_name(any, any, any) :: {:ok, t} | {:error, error}
      end,
    state_delegate_vekil_field_def_proxy_put3_header:
      quote do
        def proxy_fun_name(vekil, proxy, forom)
      end,
    state_delegate_vekil_field_def_proxy_put3_clause_default:
      quote do
        def proxy_fun_name(%__MODULE__{:proxy_field => vekil} = state, proxy, forom) do
          with {:ok, vekil} <- vekil |> Plymio.Vekil.Utility.validate_vekil(),
               {:ok, vekil} = result <- vekil |> Plymio.Vekil.proxy_put(proxy, forom),
               {:ok, %__MODULE__{}} = result <- state |> update([{:proxy_field, vekil}]) do
            result
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    state_delegate_vekil_field_def_proxy_put3: [
      :state_delegate_vekil_field_def_proxy_put3_doc,
      :state_delegate_vekil_field_def_proxy_put3_since,
      :state_delegate_vekil_field_def_proxy_put3_spec,
      :state_delegate_vekil_field_def_proxy_put3_header,
      :state_delegate_vekil_field_def_proxy_put3_clause_default
    ],
    state_delegate_vekil_field_def_proxy_put: [
      :state_delegate_vekil_field_def_proxy_put2,
      :state_delegate_vekil_field_def_proxy_put3
    ],
    state_delegate_vekil_field_def_proxy_delete_doc: :doc_false,
    state_delegate_vekil_field_def_proxy_delete_since: nil,
    state_delegate_vekil_field_def_proxy_delete_spec:
      quote do
        @spec proxy_fun_name(any, any) :: {:ok, t} | {:error, error}
      end,
    state_delegate_vekil_field_def_proxy_delete_header:
      quote do
        def proxy_fun_name(vekil, proxies)
      end,
    state_delegate_vekil_field_def_proxy_delete_clause_default:
      quote do
        def proxy_fun_name(%__MODULE__{:proxy_field => vekil} = state, proxies) do
          with {:ok, vekil} <- vekil |> Plymio.Vekil.Utility.validate_vekil(),
               {:ok, vekil} = result <- vekil |> Plymio.Vekil.proxy_delete(proxies),
               {:ok, %__MODULE__{}} = result <- state |> update([{:proxy_field, vekil}]) do
            result
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    state_delegate_vekil_field_def_proxy_delete: [
      :state_delegate_vekil_field_def_proxy_delete_doc,
      :state_delegate_vekil_field_def_proxy_delete_since,
      :state_delegate_vekil_field_def_proxy_delete_spec,
      :state_delegate_vekil_field_def_proxy_delete_header,
      :state_delegate_vekil_field_def_proxy_delete_clause_default
    ],
    state_delegate_vekil_field_def_has_proxy_doc?: :doc_false,
    state_delegate_vekil_field_def_has_proxy_since?: nil,
    state_delegate_vekil_field_def_has_proxy_spec?:
      quote do
        @spec proxy_fun_name(any, any) :: boolean
      end,
    state_delegate_vekil_field_def_has_proxy_header?:
      quote do
        def proxy_fun_name(vekil, proxy)
      end,
    state_delegate_vekil_field_def_has_proxy_clause_default?:
      quote do
        def proxy_fun_name(%__MODULE__{:proxy_field => vekil} = state, proxy) do
          with {:ok, vekil} <- vekil |> Plymio.Vekil.Utility.validate_vekil() do
            vekil |> Plymio.Vekil.has_proxy?(proxy)
          else
            {:error, %{__exception__: true}} -> false
          end
        end
      end,
    state_delegate_vekil_field_def_has_proxy?: [
      :state_delegate_vekil_field_def_has_proxy_doc?,
      :state_delegate_vekil_field_def_has_proxy_since?,
      :state_delegate_vekil_field_def_has_proxy_spec?,
      :state_delegate_vekil_field_def_has_proxy_header?,
      :state_delegate_vekil_field_def_has_proxy_clause_default?
    ],
    state_vekil_defp_update_proxy_field_normalise_form_vekil:
      quote do
        defp update_field(%__MODULE__{} = state, {k, v})
             when k == :proxy_field do
          with {:ok, %Plymio.Vekil.Form{} = vekil} <-
                 v |> Plymio.Vekil.Utility.normalise_form_vekil() do
            {:ok, state |> struct!([{k, vekil}])}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    state_vekil_defp_update_proxy_field_normalise_term_vekil:
      quote do
        defp update_field(%__MODULE__{} = state, {k, v})
             when k == :proxy_field do
          with {:ok, %Plymio.Vekil.Term{} = vekil} <-
                 v |> Plymio.Vekil.Utility.normalise_term_vekil() do
            {:ok, state |> struct!([{k, vekil}])}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    state_vekil_defp_update_proxy_field_validate_vekil:
      quote do
        defp update_field(%__MODULE__{} = state, {k, v})
             when k == :proxy_field do
          with {:ok, vekil} <- v |> Plymio.Vekil.Utility.validate_vekil() do
            {:ok, state |> struct!([{k, vekil}])}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end
  }

  def __vekil__() do
    @vekil
  end
end
