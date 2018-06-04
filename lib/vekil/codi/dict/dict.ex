defmodule Plymio.Vekil.Codi.Dict do
  @moduledoc false

  require Plymio.Fontais.Vekil.ProxyForomDict, as: PROXYFOROMDICT

  @vekil [
           # this is the vekil-based fontais's dict codi
           Plymio.Fontais.Codi,

           # local state overrides, etc
           Plymio.Vekil.Codi.Override,

           # vekil builders
           Plymio.Vekil.Codi.Vekil.Generic,
           Plymio.Vekil.Codi.Vekil.State,
           Plymio.Vekil.Codi.Vekil.Specific.Dict,
           Plymio.Vekil.Codi.Vekil.Forom.Generic,
           Plymio.Vekil.Codi.Vekil.Forom.Specific.Term,
           Plymio.Vekil.Codi.Vekil.Forom.Specific.Form,
           Plymio.Vekil.Codi.Vekil.Forom.Specific.List,
           Plymio.Vekil.Codi.Vekil.Forom.Specific.Proxy,
           Plymio.Vekil.Codi.Vekil.Proxy.Generic
         ]
         |> PROXYFOROMDICT.create_proxy_forom_dict!()

  def __vekil__() do
    @vekil
  end
end
