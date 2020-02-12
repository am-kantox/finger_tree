defmodule FingerTree.Node do
  @moduledoc false

  use FingerTree

  @impl FingerTree.Behaviour
  def empty?(%__MODULE__{}), do: false

  @impl FingerTree.Behaviour
  def push(%__MODULE__{contents: [n1, n2]} = node, e),
    do: %__MODULE__{node | contents: [e, n1, n2]}

  @impl FingerTree.Behaviour
  def unshift(%__MODULE__{contents: [n1, n2]} = node, e),
    do: %__MODULE__{node | contents: [n1, n2, e]}

  @impl FingerTree.Behaviour
  def pop(%__MODULE__{contents: [n1, n2, n3]} = node),
    do: {n1, %__MODULE__{node | contents: [n2, n3]}}

  @impl FingerTree.Behaviour
  def shift(%__MODULE__{contents: [n1, n2, n3]} = node),
    do: {n3, %__MODULE__{node | contents: [n1, n2]}}
end
