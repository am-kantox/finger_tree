defmodule FingerTree.Empty do
  use FingerTree

  @impl FingerTree.Behaviour
  def empty?(%__MODULE__{}), do: true

  @impl FingerTree.Behaviour
  def push(%__MODULE__{}, e), do: %FingerTree.Single{contents: e}

  @impl FingerTree.Behaviour
  def unshift(%__MODULE__{}, e), do: %FingerTree.Single{contents: e}

  Enum.each([Empty, Single, Deep], fn mod ->
    mod = Module.concat(FingerTree, mod)

    @impl FingerTree.Behaviour
    def append(%__MODULE__{}, %unquote(mod){} = t), do: t

    @impl FingerTree.Behaviour
    def prepend(%__MODULE__{}, %unquote(mod){} = t), do: t
  end)
end
