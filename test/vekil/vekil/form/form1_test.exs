defmodule PlymioVekilFormForm1Vekil1 do
  require Plymio.Vekil.Utility

  @vekil %{
           x_add_1:
             quote do
               def x_add_1(x) do
                 x = x + 1
               end
             end,
           x_mul_x:
             quote do
               def x_mul_x(x) do
                 x = x * x
               end
             end,
           x_sub_1:
             quote do
               def x_sub_1(x) do
                 x = x - 1
               end
             end,
           x_funs: [:x_add_1, :x_mul_x, :x_sub_1]
         }
         |> Plymio.Vekil.Utility.create_form_vekil!()

  def __vekil__() do
    @vekil
  end
end

defmodule PlymioVekilFormForm1ModuleA do
  require Plymio.Vekil.Utility
  use Plymio.Vekil.Attribute

  @codi_opts [
    {@plymio_vekil_key_vekil, PlymioVekilFormForm1Vekil1.__vekil__()}
  ]

  [:x_add_1, :x_mul_x, :x_sub_1]
  |> Plymio.Vekil.Utility.reify_proxies(@codi_opts)
end

defmodule PlymioVekilFormForm1ModuleB do
  require Plymio.Vekil.Utility
  use Plymio.Vekil.Attribute

  @codi_opts [
    {@plymio_vekil_key_vekil, PlymioVekilFormForm1Vekil1.__vekil__()}
  ]

  :x_funs |> Plymio.Vekil.Utility.reify_proxies(@codi_opts)
end

defmodule PlymioVekilFormForm1ModuleC do
  require Plymio.Vekil.Utility
  use Plymio.Fontais.Attribute
  use Plymio.Vekil.Attribute

  @codi_opts [
    {@plymio_vekil_key_vekil, PlymioVekilFormForm1Vekil1.__vekil__()}
  ]

  :x_funs
  |> Plymio.Vekil.Utility.reify_proxies(
    @codi_opts ++
      [
        {@plymio_fontais_key_postwalk,
         fn
           {:x, ctx, mod} when is_atom(mod) -> {:a, ctx, mod}
           {:x_add_1, ctx, args} -> {:a_add_1, ctx, args}
           {:x_mul_x, ctx, args} -> {:a_mul_a, ctx, args}
           {:x_sub_1, ctx, args} -> {:a_sub_1, ctx, args}
           x -> x
         end}
      ]
  )
end

defmodule PlymioVekilFormForm1Test do
  use PlymioVekilHelperTest
  alias PlymioVekilFormForm1ModuleA, as: TestModA
  alias PlymioVekilFormForm1ModuleB, as: TestModB
  alias PlymioVekilFormForm1ModuleC, as: TestModC
  use Plymio.Fontais.Attribute

  test "testmoda: 100a" do
    assert 1 = 0 |> TestModA.x_add_1()
    assert 42 = 41 |> TestModA.x_add_1()
    assert -42 = -43 |> TestModA.x_add_1()

    assert 0 = 0 |> TestModA.x_mul_x()
    assert 1 = 1 |> TestModA.x_mul_x()
    assert 4 = 2 |> TestModA.x_mul_x()

    assert -1 = 0 |> TestModA.x_sub_1()
    assert 42 = 43 |> TestModA.x_sub_1()
    assert -42 = -41 |> TestModA.x_sub_1()
  end

  test "testmodb: 100a" do
    assert 1 = 0 |> TestModB.x_add_1()
    assert 42 = 41 |> TestModB.x_add_1()
    assert -42 = -43 |> TestModB.x_add_1()

    assert 0 = 0 |> TestModB.x_mul_x()
    assert 1 = 1 |> TestModB.x_mul_x()
    assert 4 = 2 |> TestModB.x_mul_x()

    assert -1 = 0 |> TestModB.x_sub_1()
    assert 42 = 43 |> TestModB.x_sub_1()
    assert -42 = -41 |> TestModB.x_sub_1()
  end

  test "testmodc: 100a" do
    assert 1 = 0 |> TestModC.a_add_1()
    assert 42 = 41 |> TestModC.a_add_1()
    assert -42 = -43 |> TestModC.a_add_1()

    assert 0 = 0 |> TestModC.a_mul_a()
    assert 1 = 1 |> TestModC.a_mul_a()
    assert 4 = 2 |> TestModC.a_mul_a()

    assert -1 = 0 |> TestModC.a_sub_1()
    assert 42 = 43 |> TestModC.a_sub_1()
    assert -42 = -41 |> TestModC.a_sub_1()
  end
end
