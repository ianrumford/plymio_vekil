defmodule Plymio.Vekil.Codi.Vekil.Forom.Specific.Proxy do
  @moduledoc false

  use Plymio.Vekil.Attribute

  use Plymio.Vekil.Attribute

  @vekil_protocol %{
    vekil_forom_proxy_def_produce_clause_t_l0_forom_set:
      quote do
        # need to catch loops i.e. proxy referring to same proxy downstream
        def produce(
              %__MODULE__{
                @plymio_vekil_field_forom => forom,
                @plymio_vekil_field_proxy => proxy,
                @plymio_vekil_field_vekil => vekil,
                @plymio_vekil_field_seen => seen
              } = state,
              []
            )
            when is_value_set(forom) do
          # add the "parent" proxy to seen list
          with {:ok, seen} <- seen |> Plymio.Vekil.Forom.Proxy.seen_ensure(),
               {:ok, seen} <- seen |> Plymio.Vekil.Forom.Proxy.seen_put_proxy(proxy),
               true <- true do
            # seen the forom-is-the-proxy before?
            seen
            |> Plymio.Vekil.Forom.Proxy.seen_has_proxy?(forom)
            |> case do
              # looping
              true ->
                new_error_result(m: "proxy seen before", v: forom)

              _ ->
                with {:ok, vekil} <- vekil |> Plymio.Vekil.Utility.validate_vekil(),
                     {:ok, {forom_fetch, _}} <- vekil |> Plymio.Vekil.proxy_fetch(forom),
                     # add the current forom-is-the-proxy to seen list
                     {:ok, seen} <- seen |> Plymio.Vekil.Forom.Proxy.seen_put_proxy(forom),
                     true <- true do
                  # add the most recent seen to the opts for the forom
                  opts = [] |> Keyword.put(@plymio_vekil_field_seen, seen)

                  forom_fetch
                  |> List.wrap()
                  |> Plymio.Fontais.Funcio.map_collate0_enum(fn forom ->
                    with {:ok, {product, _}} = result <- forom |> Plymio.Vekil.Forom.produce(opts) do
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
                else
                  {:error, %{__exception__: true}} = result -> result
                end
            end
          else
            {:error, %{__exception__: true}} = result -> result
          end
        end
      end,
    vekil_forom_proxy_def_produce: [
      :vekil_forom_def_produce_doc,
      :vekil_forom_def_produce_since,
      :vekil_forom_def_produce_spec,
      :vekil_forom_def_produce_header,

      # default
      :vekil_forom_proxy_def_produce_clause_t_l0_forom_set,

      # no forom => no product (L0)
      :vekil_forom_def_produce_clause_t_l0_forom_unset,

      # update with the opts first
      :vekil_forom_def_produce_clause_t_l
    ],
    vekil_forom_proxy_def_realise: [
      :vekil_forom_def_realise_doc,
      :vekil_forom_def_realise_since,
      :vekil_forom_def_realise_spec,
      :vekil_forom_def_realise_header,
      :vekil_forom_def_realise_clause_get_values_key_forom
    ],
    vekil_forom_proxy_defp_realise_product: [
      :vekil_forom_defp_realise_product_header,
      :vekil_forom_defp_realise_product_clause_default
    ]
  }

  @vekil_other %{
    vekil_forom_proxy_defp_forom_value_normalise: [
      :vekil_forom_defp_forom_value_normalise_header,
      :vekil_forom_defp_forom_value_normalise_clause_match_forom,
      :vekil_forom_defp_forom_value_normalise_clause_l0_new,
      :vekil_forom_defp_forom_value_normalise_clause_match_atom_new_proxy,
      :vekil_forom_defp_forom_value_normalise_clause_new_proxy_forom
    ]
  }

  @vekil [
           @vekil_protocol,
           @vekil_other
         ]
         |> Enum.reduce(fn m, s -> Map.merge(s, m) end)

  def __vekil__() do
    @vekil
  end
end
