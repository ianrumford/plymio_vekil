defmodule PlymioVekilForomTermDoctest1Test do
  use ExUnit.Case, async: true
  use PlymioVekilHelperTest
  import Plymio.Vekil.Forom.Term
  alias Plymio.Vekil.Forom.Term, as: FOROMTERM

  doctest Plymio.Vekil.Forom.Term
end
