defmodule PlymioVekilForomFormDoctest1Test do
  use ExUnit.Case, async: true
  use PlymioVekilHelperTest
  import Harnais.Helper
  import Plymio.Vekil.Forom.Form
  alias Plymio.Vekil.Forom.Form, as: FOROMFORM

  doctest Plymio.Vekil.Forom.Form
end
