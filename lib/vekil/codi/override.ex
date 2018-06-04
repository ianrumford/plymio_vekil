defmodule Plymio.Vekil.Codi.Override do
  @moduledoc false

  @vekil %{
    state_def_new_doc!:
      quote do
        @doc ~S"""
        `new!/1` calls `new/1` and, if the result is `{:ok, instance}`
        returns the `instance`.
        """
      end,
    state_def_update_doc!:
      quote do
        @doc ~S"""
        `update!/2` calls `update/2` and, if the result is `{:ok, instance}`
        returns the `instance`.
        """
      end
  }

  def __vekil__() do
    @vekil
  end
end
