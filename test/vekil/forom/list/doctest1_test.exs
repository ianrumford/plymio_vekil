defmodule PlymioVekilForomListDoctest1Test do
  use ExUnit.Case, async: true
  use PlymioVekilHelperTest
  import Harnais.Helper
  import Plymio.Vekil.Forom.List
  alias Plymio.Vekil.Forom.List, as: FOROMLIST
  alias Plymio.Vekil.Forom.Term, as: FOROMTERM
  alias Plymio.Vekil.Forom.Form, as: FOROMFORM
  alias Plymio.Vekil.Forom.Proxy, as: FOROMPROXY

  doctest Plymio.Vekil.Forom.List
end
