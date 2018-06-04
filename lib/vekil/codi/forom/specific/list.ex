defmodule Plymio.Vekil.Codi.Vekil.Forom.Specific.List do
  @moduledoc false

  use Plymio.Vekil.Attribute

  @type opts :: Plymio.Fontais.opts()
  @type error :: Plymio.Fontais.error()

  @vekil_state %{
    state_vekil_forom_list_defp_update_field_forom_normalise_forom_list:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_forom = k, v}) do
          values =
            v
            |> List.wrap()
            |> Enum.reject(&is_nil/1)

          values
          |> Enum.all?(&Plymio.Vekil.Utility.forom?/1)
          |> case do
            true -> {:ok, state |> struct!([{k, values}])}
            _ -> new_error_result(m: "forom list invalid", v: v)
          end
        end
      end,
    vekil_forom_list_defp_update_field_forom_validate_forom_list:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_forom = k, v}) do
          v
          |> is_list
          |> case do
            true ->
              v
              |> Enum.all?(&Plymio.Vekil.Utility.forom?/1)
              |> case do
                true -> {:ok, state |> struct!([{k, v}])}
                _ -> new_error_result(m: "forom list invalid", v: v)
              end

            _ ->
              new_error_result(m: "forom list invalid", v: v)
          end
        end
      end,
    state_vekil_forom_list_defp_update_field_other_propagate:
      quote do
        defp update_field(%__MODULE__{@plymio_vekil_field_forom => forom} = state, {k, v})
             when k in @plymio_vekil_fields_forom_list_propagate do
          forom
          |> Plymio.Fontais.Funcio.map_collate0_enum(fn forom ->
            forom |> Plymio.Vekil.Forom.update([{k, v}])
          end)
          |> case do
            {:error, %{__struct__: _}} = result -> result
            {:ok, forom} -> {:ok, state |> struct!([{@plymio_vekil_field_forom, forom}])}
          end
        end
      end
  }

  @vekil_protocol %{
    vekil_forom_list_def_produce_clause_t_l0_forom_set:
      quote do
        def produce(%__MODULE__{@plymio_vekil_field_forom => forom} = state, [])
            when Plymio.Fontais.Guard.is_value_set(forom) do
          forom
          |> Plymio.Fontais.Funcio.map_collate0_enum(fn forom ->
            with {:ok, forom} <- forom |> Plymio.Vekil.Utility.validate_forom(),
                 {:ok, {product, _}} <- forom |> Plymio.Vekil.Forom.produce() do
              {:ok, product}
            else
              {:error, %{__exception__: true}} = result -> result
            end
          end)
          |> case do
            {:error, %{__struct__: _}} = result ->
              result

            {:ok, products} ->
              with {:ok, product} <- products |> Plymio.Fontais.Option.opts_merge() do
                {:ok, {product, state}}
              else
                {:error, %{__exception__: true}} = result -> result
              end
          end
        end
      end,
    vekil_forom_list_def_produce: [
      :vekil_forom_def_produce_doc,
      :vekil_forom_def_produce_since,
      :vekil_forom_def_produce_spec,
      :vekil_forom_def_produce_header,

      # default
      :vekil_forom_list_def_produce_clause_t_l0_forom_set,

      # no form => no product (L0)
      :vekil_forom_def_produce_clause_t_l0_forom_unset,

      # update with the opts first
      :vekil_forom_def_produce_clause_t_l
    ],
    vekil_forom_list_def_realise_clause_default:
      quote do
        def realise(%__MODULE__{} = state, opts) do
          with {:ok, {product, %__MODULE__{} = state}} <- state |> produce(opts) do
            {:ok, {product |> Keyword.get_values(@plymio_vekil_key_forom), state}}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_forom_list_def_realise: [
      :vekil_forom_def_realise_doc,
      :vekil_forom_def_realise_since,
      :vekil_forom_def_realise_spec,
      :vekil_forom_def_realise_header,
      :vekil_forom_def_realise_clause_default
    ],
    vekil_forom_list_defp_realise_product: [
      :vekil_forom_defp_realise_product_header,
      :vekil_forom_defp_realise_product_clause_default
    ]
  }

  @vekil [
           @vekil_state,
           @vekil_protocol
         ]
         |> Enum.reduce(fn m, s -> Map.merge(s, m) end)

  def __vekil__() do
    @vekil
  end
end
