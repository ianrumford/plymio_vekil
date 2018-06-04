defmodule PlymioVekilDictDoctest1Test do
  use ExUnit.Case, async: true
  use PlymioVekilHelperTest
  import Harnais.Helper
  import Plymio.Vekil.Term

  doctest Plymio.Vekil.Term
end
