ExUnit.start()

defmodule PlymioVekilHelperTest do
  alias Plymio.Vekil.Forom.Form, as: FOROMFORM

  @vekil_form_example1 [
                         x_add_1: quote(do: x = x + 1),
                         x_mul_x: quote(do: x = x * x),
                         x_sub_1: quote(do: x = x - 1),
                         x_funs: [:x_add_1, :x_mul_x, :x_sub_1],
                         x_loop: [:x_add_1, :x_loop, :x_sub_1]
                       ]
                       |> Plymio.Vekil.Utility.create_form_vekil!()

  def vekil_helper_form_vekil_example1() do
    @vekil_form_example1
  end

  @vekil_term_example1 [
                         x_add_1: [forom: quote(do: x = x + 1)] |> FOROMFORM.new!(),
                         x_mul_x: [forom: quote(do: x = x * x)] |> FOROMFORM.new!(),
                         x_sub_1: [forom: quote(do: x = x - 1)] |> FOROMFORM.new!(),
                         value_42: 42,
                         value_x_add_1: :x_add_1,
                         proxy_x_add_1: [forom: :x_add_1] |> Plymio.Vekil.Forom.Proxy.new!()
                       ]
                       |> Plymio.Vekil.Utility.create_term_vekil!()

  def vekil_helper_term_vekil_example1() do
    @vekil_term_example1
  end

  defmacro __using__(_opts \\ []) do
    quote do
      use ExUnit.Case, async: true
      import PlymioVekilHelperTest

      require Plymio.Fontais.Guard

      alias Plymio.Vekil, as: VEKILPROT
      alias Plymio.Vekil.Form, as: VEKILFORM
      alias Plymio.Vekil.Term, as: VEKILTERM

      alias Plymio.Vekil.Forom, as: FOROMPROT
      alias Plymio.Vekil.Forom.Form, as: FOROMFORM
      alias Plymio.Vekil.Forom.Term, as: FOROMTERM
      alias Plymio.Vekil.Forom.List, as: FOROMLIST
      alias Plymio.Vekil.Forom.Proxy, as: FOROMPROXY
    end
  end
end
