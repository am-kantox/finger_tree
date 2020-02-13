defmodule FingerTree.Empty do
  @moduledoc false

  use FingerTree

  @impl FingerTree.Measured
  def measure(%FingerTree.Empty{}), do: []

  @impl FingerTree.Behaviour
  def empty?(%FingerTree.Empty{}), do: true

  @impl FingerTree.Behaviour
  def push(%FingerTree.Empty{}, e), do: FingerTree.new!(FingerTree.Single, e)

  @impl FingerTree.Behaviour
  def unshift(%FingerTree.Empty{}, e), do: FingerTree.new!(FingerTree.Single, e)

  Enum.each([Empty, Single, Deep], fn mod ->
    mod = Module.concat(FingerTree, mod)

    @impl FingerTree.Behaviour
    def append(%FingerTree.Empty{}, %unquote(mod){} = t), do: t

    @impl FingerTree.Behaviour
    def prepend(%FingerTree.Empty{}, %unquote(mod){} = t), do: t
  end)

  @impl FingerTree.Behaviour
  def split(%FingerTree.Empty{}, _splitter, _acc), do: {:error, :empty}
end
