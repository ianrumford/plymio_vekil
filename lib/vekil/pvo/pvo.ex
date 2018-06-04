defmodule Plymio.Vekil.PVO do
  @moduledoc false

  require Plymio.Fontais.Option.Macro, as: PFOM
  require Plymio.Fontais.Option, as: POU
  use Plymio.Fontais.Attribute
  use Plymio.Vekil.Attribute

  @type form :: Plymio.Fontais.form()
  @type forms :: Plymio.Fontais.forms()
  @type error :: Plymio.Fontais.error()

  import Plymio.Fontais.Option,
    only: [
      opts_validate: 1
    ]

  import Plymio.Fontais.Option,
    only: [
      opts_get: 3,
      opts_put: 3,
      opts_fetch: 2
    ]

  @plymio_vekil_pvo_kvs_aliases [
    {@plymio_vekil_key_forom, nil},
    {@plymio_vekil_key_proxy, nil},
    {@plymio_vekil_key_vekil, nil}
  ]

  @plymio_vekil_pvo_dict_aliases @plymio_vekil_pvo_kvs_aliases
                                 |> POU.opts_create_aliases_dict()

  def pvo_canonical_opts(pvo, dict \\ @plymio_vekil_pvo_dict_aliases) do
    pvo |> POU.opts_canonical_keys(dict)
  end

  defdelegate pvo_normalise(pvo), to: __MODULE__, as: :pvo_canonical_opts
  defdelegate pvo_normalise(pvo, dict), to: __MODULE__, as: :pvo_canonical_opts

  def pvo?(pvo) do
    pvo
    |> pvo_canonical_opts
    |> case do
      {:ok, _} -> true
      _ -> false
    end
  end

  [
    pvo_get_forom: %{key: @plymio_vekil_key_forom, default: @plymio_fontais_the_unset_value},
    pvo_get_proxy: %{key: @plymio_vekil_key_proxy, default: @plymio_fontais_the_unset_value},
    pvo_get_vekil: %{key: @plymio_vekil_key_vekil, default: @plymio_fontais_the_unset_value}
  ]
  |> PFOM.def_custom_opts_get()

  [
    pvo_fetch_forom: @plymio_vekil_key_forom,
    pvo_fetch_proxy: @plymio_vekil_key_proxy,
    pvo_fetch_vekil: @plymio_vekil_key_vekil
  ]
  |> PFOM.def_custom_opts_fetch()

  [
    pvo_put_forom: @plymio_vekil_key_forom,
    pvo_put_proxy: @plymio_vekil_key_proxy,
    pvo_put_vekil: @plymio_vekil_key_vekil
  ]
  |> PFOM.def_custom_opts_put()

  def pvo_maybe_put_vekil(pvo, vekil) do
    pvo
    |> pvo_normalise
    |> case do
      {:error, %{__struct__: _}} = result ->
        result

      {:ok, pvo} ->
        pvo
        |> Keyword.has_key?(@plymio_vekil_key_vekil)
        |> case do
          true ->
            {:ok, pvo}

          _ ->
            with {:ok, vekil} <- vekil |> Plymio.Vekil.Utility.validate_vekil(),
                 {:ok, _pvo} = result <- pvo |> pvo_put_vekil(vekil) do
              result
            else
              {:error, %{__exception__: true}} = result -> result
            end
        end
    end
  end

  def pvo_normalise_forom_value(value, opts \\ []) do
    with {:ok, opts_pvo} <- opts |> pvo_normalise do
      value
      |> pvo_normalise
      |> case do
        {:ok, pvo} ->
          # pvo wins!
          {:ok, opts_pvo ++ pvo}

        _ ->
          opts_pvo |> pvo_put_forom(value)
      end
    else
      {:error, %{__exception__: true}} = result -> result
    end
  end

  def pvo_validate_atom_proxy(pvo) do
    with {:ok, pvo} <- pvo |> pvo_normalise,
         {:ok, proxy} <- pvo |> pvo_fetch_proxy do
      proxy
      |> Plymio.Fontais.Utility.validate_key()
      |> case do
        {:ok, _proxy} = result -> result
        _ -> Plymio.Fontais.Error.new_error_result(m: "proxy invalid", v: proxy)
      end
    else
      {:error, %{__exception__: true}} = result -> result
    end
  end
end
