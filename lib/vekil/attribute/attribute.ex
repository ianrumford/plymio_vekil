defmodule Plymio.Vekil.Attribute do
  @moduledoc false

  defmacro __using__(_opts \\ []) do
    quote do
      @plymio_vekil_key_form :form
      @plymio_vekil_key_vekil :vekil
      @plymio_vekil_key_proxy :proxy
      @plymio_vekil_key_forom :forom

      @plymio_vekil_field_vekil :vekil
      @plymio_vekil_field_dict :dict
      @plymio_vekil_field_proxy :proxy
      @plymio_vekil_field_forom :forom
      @plymio_vekil_field_seen :seen

      @plymio_vekil_field_produce_default :produce_default
      @plymio_vekil_field_realise_default :realise_default

      @plymio_vekil_field_forom_normalise :forom_normalise
      @plymio_vekil_field_proxy_normalise :proxy_normalise

      @plymio_vekil_fields_forom_list_propagate [
        @plymio_vekil_field_vekil,
        @plymio_vekil_field_proxy,
        @plymio_vekil_field_seen
      ]

      @plymio_vekil_field_alias_vekil {@plymio_vekil_field_vekil, []}
      @plymio_vekil_field_alias_forom {@plymio_vekil_field_forom, []}
      @plymio_vekil_field_alias_proxy {@plymio_vekil_field_proxy, []}

      @plymio_vekil_field_alias_produce_default {@plymio_vekil_field_produce_default,
                                                 [:product_default]}
      @plymio_vekil_field_alias_realise_default {@plymio_vekil_field_realise_default,
                                                 [:answer_default]}

      @plymio_vekil_field_alias_dict {@plymio_vekil_field_dict, [:d]}
      @plymio_vekil_field_alias_seen {@plymio_vekil_field_seen, []}

      @plymio_vekil_field_alias_forom_normalise {@plymio_vekil_field_forom_normalise, []}
      @plymio_vekil_field_alias_proxy_normalise {@plymio_vekil_field_proxy_normalise, []}
    end
  end
end
