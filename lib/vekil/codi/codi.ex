defmodule Plymio.Vekil.Codi do
  @moduledoc false

  @vekil [
           # this is the vekil-based fontais's dict codi
           Plymio.Fontais.Codi,

           # local state overrides, etc
           Plymio.Vekil.Codi.Override
         ]
         |> Plymio.Vekil.Utility.build_form_vekil!()

  def __vekil__() do
    @vekil
  end
end
