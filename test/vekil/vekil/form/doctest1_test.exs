defmodule PlymioVekilFormDoctest1Test do
  use ExUnit.Case, async: true
  use PlymioVekilHelperTest
  import Harnais.Helper
  import Plymio.Vekil.Form
  alias Plymio.Vekil.Form, as: VEKILFORM

  doctest Plymio.Vekil.Form
end
