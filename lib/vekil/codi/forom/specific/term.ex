defmodule Plymio.Vekil.Codi.Vekil.Forom.Specific.Term do
  @moduledoc false

  use Plymio.Vekil.Attribute

  @type opts :: Plymio.Fontais.opts()
  @type error :: Plymio.Fontais.error()

  @vekil_state %{}

  @vekil_protocol %{
    vekil_forom_term_def_produce_clause_t_l0_forom_set:
      quote do
        def produce(%__MODULE__{@plymio_vekil_field_forom => form} = state, [])
            when Plymio.Fontais.Guard.is_value_set(form) do
          {:ok, {[{@plymio_vekil_key_forom, form}], state}}
        end
      end,
    vekil_forom_term_def_produce: [
      :vekil_forom_def_produce_doc,
      :vekil_forom_def_produce_since,
      :vekil_forom_def_produce_spec,
      :vekil_forom_def_produce_header,

      # default
      :vekil_forom_term_def_produce_clause_t_l0_forom_set,

      # no form => no product (L0)
      :vekil_forom_def_produce_clause_t_l0_forom_unset,

      # update with the opts first
      :vekil_forom_def_produce_clause_t_l
    ],
    vekil_forom_term_def_realise_clause_default:
      quote do
        def realise(%__MODULE__{} = state, opts) do
          with {:ok, {product, %__MODULE__{} = state}} <- state |> produce(opts) do
            {:ok, {product |> Keyword.get_values(@plymio_vekil_key_forom), state}}
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_forom_term_def_realise: [
      :vekil_forom_def_realise_doc,
      :vekil_forom_def_realise_since,
      :vekil_forom_def_realise_spec,
      :vekil_forom_def_realise_header,
      :vekil_forom_def_realise_clause_default
    ],
    vekil_forom_term_defp_realise_product: [
      :vekil_forom_defp_realise_product_header,
      :vekil_forom_defp_realise_product_clause_default
    ]
  }

  @vekil_other %{
    vekil_forom_term_defp_forom_value_normalise: [
      :vekil_forom_defp_forom_value_normalise_header,
      :vekil_forom_defp_forom_value_normalise_clause_match_forom,
      :vekil_forom_defp_forom_value_normalise_clause_l0_new,
      :vekil_forom_defp_forom_value_normalise_clause_new_term_forom
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
