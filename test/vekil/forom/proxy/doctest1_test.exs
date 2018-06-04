defmodule PlymioVekilForomProxyDoctest1Test do
  use ExUnit.Case, async: true
  use PlymioVekilHelperTest
  import Harnais.Helper
  import Plymio.Vekil.Forom.Proxy
  alias Plymio.Vekil.Form, as: VEKILFORM
  alias Plymio.Vekil.Forom.Proxy, as: FOROMPROXY
  alias Plymio.Vekil.Forom.Form, as: FOROMFORM

  doctest Plymio.Vekil.Forom.Proxy
end
