defmodule FingerTree.Single do
  @moduledoc false

  use FingerTree

  @impl FingerTree.Measured
  def measure(%FingerTree.Single{contents: contents}), do: FingerTree.measure(contents)

  @impl FingerTree.Behaviour
  def empty?(%FingerTree.Single{}), do: false

  @impl FingerTree.Behaviour
  def first(%FingerTree.Single{contents: contents}), do: contents

  @impl FingerTree.Behaviour
  def last(%FingerTree.Single{contents: contents}), do: contents

  @impl FingerTree.Behaviour
  def push(%FingerTree.Single{contents: contents}, e),
    do:
      FingerTree.new!(FingerTree.Deep, %{
        left: FingerTree.Digit.collect(contents),
        spine: %FingerTree.Empty{},
        right: FingerTree.Digit.collect(e)
      })

  @impl FingerTree.Behaviour
  def unshift(%FingerTree.Single{contents: contents}, e),
    do:
      FingerTree.new!(FingerTree.Deep, %{
        left: FingerTree.Digit.collect(e),
        spine: %FingerTree.Empty{},
        right: FingerTree.Digit.collect(contents)
      })

  @impl FingerTree.Behaviour
  def pop(%FingerTree.Single{}), do: FingerTree.new!(FingerTree.Empty)

  @impl FingerTree.Behaviour
  def shift(%FingerTree.Single{}), do: FingerTree.new!(FingerTree.Empty)

  @impl FingerTree.Behaviour
  def append(%FingerTree.Single{contents: contents}, %type{} = other),
    do: type.unshift(other, contents)

  @impl FingerTree.Behaviour
  def prepend(%FingerTree.Single{contents: contents}, %type{} = other),
    do: type.push(other, contents)

  @impl FingerTree.Behaviour
  def split(%FingerTree.Single{measure: measure} = this, splitter)
      when is_function(splitter, 1) do
    if splitter.(measure),
      do: {:ok, FingerTree.new!(FingerTree.Empty), this, FingerTree.new!(FingerTree.Empty)},
      else: {:error, :not_found}
  end
end
