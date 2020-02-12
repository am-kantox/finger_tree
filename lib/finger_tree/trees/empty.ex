defmodule FingerTree.Empty do
  @moduledoc false

  use FingerTree

  @impl FingerTree.Measured
  def measure(%__MODULE__{}), do: []

  @impl FingerTree.Behaviour
  def empty?(%__MODULE__{}), do: true

  @impl FingerTree.Behaviour
  def push(%__MODULE__{}, e), do: FingerTree.new!(FingerTree.Single, e)

  @impl FingerTree.Behaviour
  def unshift(%__MODULE__{}, e), do: FingerTree.new!(FingerTree.Single, e)

  Enum.each([Empty, Single, Deep], fn mod ->
    mod = Module.concat(FingerTree, mod)

    @impl FingerTree.Behaviour
    def append(%__MODULE__{}, %unquote(mod){} = t), do: t

    @impl FingerTree.Behaviour
    def prepend(%__MODULE__{}, %unquote(mod){} = t), do: t
  end)
end
