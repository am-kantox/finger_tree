defmodule FingerTree.Single do
  use FingerTree

  @impl FingerTree.Behaviour
  def empty?(%__MODULE__{}), do: false

  @impl FingerTree.Behaviour
  def first(%__MODULE__{contents: contents}), do: contents

  @impl FingerTree.Behaviour
  def last(%__MODULE__{contents: contents}), do: contents

  @impl FingerTree.Behaviour
  def push(%__MODULE__{contents: contents}, e),
    do: %FingerTree.Deep{
      contents: %{
        left: FingerTree.Digit.collect(contents),
        spine: %FingerTree.Empty{},
        right: FingerTree.Digit.collect(e)
      }
    }

  @impl FingerTree.Behaviour
  def unshift(%__MODULE__{contents: contents}, e),
    do: %FingerTree.Deep{
      contents: %{
        left: FingerTree.Digit.collect(e),
        spine: %FingerTree.Empty{},
        right: FingerTree.Digit.collect(contents)
      }
    }

  @impl FingerTree.Behaviour
  def pop(%__MODULE__{}), do: %FingerTree.Empty{}

  @impl FingerTree.Behaviour
  def shift(%__MODULE__{}), do: %FingerTree.Empty{}

  @impl FingerTree.Behaviour
  def append(%__MODULE__{contents: contents}, %type{} = other),
    do: type.unshift(other, contents)

  @impl FingerTree.Behaviour
  def prepend(%__MODULE__{contents: contents}, %type{} = other),
    do: type.push(other, contents)
end
