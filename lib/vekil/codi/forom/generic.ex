defmodule Plymio.Vekil.Codi.Vekil.Forom.Generic do
  @moduledoc false

  use Plymio.Vekil.Attribute

  @vekil_state %{
    state_vekil_forom_defp_update_field_forom_passthru:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_forom = k, v}) do
          {:ok, state |> struct!([{k, v}])}
        end
      end
  }

  @vekil_protocol %{
    vekil_forom_def_produce_doc:
      quote do
        @doc ~S"""
        produce/2 inplements `Plymio.Vekil.Forom.produce/2`
        """
      end,
    vekil_forom_def_produce_since: nil,
    vekil_forom_def_produce_spec:
      quote do
        @spec produce(t, opts) :: {:ok, {product, t}} | {:error, error}
      end,
    vekil_forom_def_produce_header:
      quote do
        def produce(forom, opts \\ [])
      end,
    vekil_forom_def_produce_clause_t_l0_forom_unset:
      quote do
        def produce(
              %__MODULE__{
                @plymio_vekil_field_forom => forom,
                @plymio_vekil_field_produce_default => produce_default
              } = state,
              []
            )
            when Plymio.Fontais.Guard.is_value_unset(forom) do
          {:ok, {produce_default, state}}
        end
      end,
    vekil_forom_def_produce_clause_t_any_forom_unset:
      quote do
        def produce(%__MODULE__{@plymio_vekil_field_forom => forom} = state, _opts)
            when Plymio.Fontais.Guard.is_value_unset_or_nil(forom) do
          {:ok, {[], state}}
        end
      end,
    vekil_forom_def_produce_clause_t_l:
      quote do
        def produce(%__MODULE__{} = state, opts) when is_list(opts) do
          with {:ok, %_MODULE__{} = state} <- state |> update(opts),
               {:ok, {_product, %__MODULE{}}} = result <- state |> produce do
            result
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_forom_def_realise_doc:
      quote do
        @doc ~S"""
        realise/2 inplements `Plymio.Vekil.Forom.realise/2`
        """
      end,
    vekil_forom_def_realise_since: nil,
    vekil_forom_def_realise_spec:
      quote do
        @spec realise(t, opts) :: {:ok, {any, t}} | {:error, error}
      end,
    vekil_forom_def_realise_header:
      quote do
        def realise(forom, opts \\ [])
      end,
    vekil_forom_def_realise_clause_get_key_forom:
      quote do
        def realise(%__MODULE__{} = state, opts) do
          with {:ok, {product, %__MODULE__{} = state}} <- state |> produce(opts) do
            {:ok, {product |> Keyword.get(@plymio_vekil_key_forom), state}}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_forom_def_realise_clause_get_values_key_forom:
      quote do
        def realise(%__MODULE__{} = state, opts) do
          with {:ok, {product, %__MODULE__{} = state}} <- state |> produce(opts) do
            {:ok, {product |> Keyword.get_values(@plymio_vekil_key_forom), state}}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_forom_def_realise_clause_default:
      quote do
        def realise(%__MODULE__{} = state, opts) do
          with {:ok, {product, %__MODULE__{} = state}} <- state |> produce(opts),
               {:ok, {_answer, %__MODULE__{}}} = result <- state |> realise_product(product) do
            result
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end
  }

  @vekil_other %{
    vekil_forom_def_normalise_doc: :doc_false,
    vekil_forom_def_normalise_since: nil,
    vekil_forom_def_normalise_spec:
      quote do
        # struct not t
        @spec normalise(any) :: {:ok, struct} | {:error, error}
      end,
    vekil_forom_def_normalise_header:
      quote do
        def normalise(value)
      end,
    vekil_forom_def_normalise_clause_match_nil:
      quote do
        def normalise(value) when is_nil(value) do
          {:ok, nil}
        end
      end,
    vekil_forom_def_normalise_clause_l0_new:
      quote do
        def normalise(value)
            when is_list(value) and length(value) == 0 do
          new()
        end
      end,
    vekil_forom_def_normalise_clause_match_forom:
      quote do
        def normalise(
              %{
                :__struct__ => _,
                @plymio_fontais_field_protocol_name => Plymio.Vekil.Forom
              } = value
            ) do
          {:ok, value}
        end
      end,
    vekil_forom_def_normalise_clause_validate_forom:
      quote do
        def normalise(value) do
          value |> Plymio.Vekil.Utility.validate_forom()
        end
      end,
    vekil_forom_def_normalise_clause_pvo:
      quote do
        def normalise(pvo) when is_list(pvo) do
          cond do
            Keyword.keyword?(pvo) and Keyword.has_key?(pvo, @plymio_vekil_key_forom) ->
              with {:ok, pvo} <- pvo |> Plymio.Vekil.PVO.pvo_normalise(),
                   {:ok, forom} <- pvo |> Plymio.Vekil.PVO.pvo_fetch_forom() do
                forom
                |> List.wrap()
                |> Plymio.Fontais.Funcio.map_collate0_enum(fn v ->
                  cond do
                    Plymio.Vekil.Utility.forom?(v) ->
                      {:ok, v}

                    true ->
                      v |> forom_value_normalise(pvo)
                  end
                end)
                |> case do
                  {:error, %{__struct__: _}} = result -> result
                  {:ok, forom} -> forom |> Plymio.Vekil.Utility.forom_reduce()
                end
              else
                {:error, %{__exception__: true}} = result -> result
              end

            true ->
              pvo |> forom_value_normalise
          end
        end
      end,
    vekil_forom_def_normalise_clause_forom_value_normalise:
      quote do
        def normalise(value) do
          value |> forom_value_normalise
        end
      end,
    vekil_forom_def_normalise: [
      :vekil_forom_def_normalise_doc,
      :vekil_forom_def_normalise_since,
      :vekil_forom_def_normalise_spec,
      :vekil_forom_def_normalise_header,
      :vekil_forom_def_normalise_clause_match_forom,
      :vekil_forom_def_normalise_clause_l0_new,
      :vekil_forom_def_normalise_clause_pvo,
      :vekil_forom_def_normalise_clause_forom_value_normalise
    ],
    vekil_forom_defp_forom_value_normalise_header:
      quote do
        @spec forom_value_normalise(any, any) :: {:ok, struct} | {:error, error}
        defp forom_value_normalise(value, opts \\ [])
      end,
    vekil_forom_defp_forom_value_normalise_clause_validate_forom:
      quote do
        defp forom_value_normalise(value, _opts) do
          value |> Plymio.Vekil.Utility.validate_forom()
        end
      end,
    vekil_forom_defp_forom_value_normalise_clause_match_forom:
      quote do
        defp forom_value_normalise(
               %{
                 :__struct__ => _,
                 @plymio_fontais_field_protocol_name => Plymio.Vekil.Forom
               } = value,
               _pvo
             ) do
          {:ok, value}
        end
      end,
    vekil_forom_defp_forom_value_normalise_clause_match_atom_new_proxy:
      quote do
        defp forom_value_normalise(value, pvo)
             when is_atom(value) and not is_nil(value) do
          with {:ok, pvo} <- pvo |> Plymio.Vekil.Forom.Proxy.update_canonical_opts(),
               {:ok, pvo} <- pvo |> Plymio.Vekil.PVO.pvo_put_forom(value),
               {:ok, %Plymio.Vekil.Forom.Proxy{}} = result <-
                 pvo |> Plymio.Vekil.Forom.Proxy.new() do
            result
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_forom_defp_forom_value_normalise_clause_new_form_forom:
      quote do
        defp forom_value_normalise(value, pvo) do
          with {:ok, pvo} <- value |> Plymio.Vekil.PVO.pvo_normalise_forom_value(pvo),
               {:ok, %Plymio.Vekil.Forom.Form{}} = result <- pvo |> Plymio.Vekil.Forom.Form.new() do
            result
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_forom_defp_forom_value_normalise_clause_new_term_forom:
      quote do
        defp forom_value_normalise(value, pvo) do
          with {:ok, pvo} <- value |> Plymio.Vekil.PVO.pvo_normalise_forom_value(pvo),
               {:ok, %Plymio.Vekil.Forom.Term{}} = result <- pvo |> Plymio.Vekil.Forom.Term.new() do
            result
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_forom_defp_forom_value_normalise_clause_new_proxy_forom:
      quote do
        defp forom_value_normalise(value, pvo) do
          with {:ok, pvo} <- value |> Plymio.Vekil.PVO.pvo_normalise_forom_value(pvo),
               {:ok, %Plymio.Vekil.Forom.Proxy{}} = result <-
                 pvo |> Plymio.Vekil.Forom.Proxy.new() do
            result
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_forom_defp_forom_value_normalise_clause_l0_new:
      quote do
        defp forom_value_normalise(value, _pvo)
             when is_list(value) and length(value) == 0 do
          new()
        end
      end,
    vekil_forom_defp_forom_value_normalise_clause_l_gt_0:
      quote do
        defp forom_value_normalise(value, opts)
             when is_list(value) and length(value) > 0 do
          value
          |> Plymio.Fontais.Funcio.map_collate0_enum(fn v ->
            v |> forom_value_normalise(opts)
          end)
          |> case do
            {:error, %{__struct__: _}} = result -> result
            {:ok, forom} -> forom |> Plymio.Vekil.Utility.forom_reduce()
          end
        end
      end,
    vekil_forom_defp_realise_product_header:
      quote do
        @spec realise_product(t, product) :: {:ok, {any, t}} | {:error, error}
        defp realise_product(forom, product \\ [])
      end,
    vekil_forom_defp_realise_product_clause_default:
      quote do
        defp realise_product(
               %__MODULE__{@plymio_vekil_field_realise_default => realise_default} = state,
               product
             ) do
          cond do
            Keyword.keyword?(product) ->
              product
              |> Keyword.get_values(@plymio_vekil_key_forom)
              |> case do
                [] -> {:ok, {realise_default, state}}
                [value] -> {:ok, {value, state}}
                values -> {:ok, {values, state}}
              end

            Plymio.Fontais.Guard.is_value_unset(product) ->
              {:ok, {realise_default, state}}

            true ->
              new_error_result(m: "product invalid", v: product)
          end
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
