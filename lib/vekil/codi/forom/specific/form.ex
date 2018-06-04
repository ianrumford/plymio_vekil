defmodule Plymio.Vekil.Codi.Vekil.Forom.Specific.Form do
  @moduledoc false

  use Plymio.Vekil.Attribute

  @type opts :: Plymio.Fontais.opts()
  @type error :: Plymio.Fontais.error()

  @vekil_state %{
    vekil_forom_form_defp_update_field_forom_validate_form:
      quote do
        defp update_field(%__MODULE__{} = state, {@plymio_vekil_field_forom = k, v}) do
          with {:ok, form} <- v |> Plymio.Fontais.Form.form_validate() do
            {:ok, state |> struct!([{k, form}])}
          else
            {:error, %{__struct__: _}} = result -> result
          end
        end
      end
  }

  @vekil_protocol %{
    vekil_forom_form_def_produce_clause_t_l0_forom_set:
      quote do
        def produce(%__MODULE__{@plymio_vekil_field_forom => forom} = state, [])
            when Plymio.Fontais.Guard.is_value_set(forom) do
          {:ok, {[{@plymio_vekil_key_forom, forom}], state}}
        end
      end,
    vekil_forom_form_def_produce: [
      :vekil_forom_def_produce_doc,
      :vekil_forom_def_produce_since,
      :vekil_forom_def_produce_spec,
      :vekil_forom_def_produce_header,

      # default
      :vekil_forom_form_def_produce_clause_t_l0_forom_set,

      # no form => no product (L0)
      :vekil_forom_def_produce_clause_t_l0_forom_unset,

      # update with the opts first
      :vekil_forom_def_produce_clause_t_l
    ],
    vekil_forom_form_def_realise_clause_default:
      quote do
        def realise(%__MODULE__{} = state, opts) do
          with {:ok, {product, %__MODULE__{} = state}} <- state |> produce(opts),
               {:ok, {forms, %__MODULE__{} = state}} <- state |> realise_product(product) do
            forms
            |> Plymio.Fontais.Guard.is_value_set()
            |> case do
              true ->
                with {:ok, forms} <- forms |> Plymio.Fontais.Form.forms_normalise() do
                  {:ok, {forms, state}}
                else
                  {:error, %{__exception__: true}} = result -> result
                end

              _ ->
                {:ok, {forms, state}}
            end
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_forom_form_def_realise: [
      :vekil_forom_def_realise_doc,
      :vekil_forom_def_realise_since,
      :vekil_forom_def_realise_spec,
      :vekil_forom_def_realise_header,
      :vekil_forom_form_def_realise_clause_default
    ],
    vekil_forom_form_defp_realise_product: [
      :vekil_forom_defp_realise_product_header,
      :vekil_forom_defp_realise_product_clause_default
    ]
  }

  @vekil_other %{
    # use by e.g. vorm
    vekil_forom_form_defp_forom_value_normalise_clause_match_syntax:
      quote do
        defp forom_value_normalise({k, _ctx, _args} = form, pvo)
             when k in [
                    :def,
                    :defp,
                    :__block__
                  ] do
          pvo |> Plymio.Vekil.Forom.Form.new()
        end
      end,
    vekil_forom_form_defp_forom_value_normalise: [
      :vekil_forom_defp_forom_value_normalise_header,
      :vekil_forom_defp_forom_value_normalise_clause_match_forom,
      :vekil_forom_defp_forom_value_normalise_clause_l0_new,
      :vekil_forom_defp_forom_value_normalise_clause_match_atom_new_proxy,
      :vekil_forom_defp_forom_value_normalise_clause_new_form_forom
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
