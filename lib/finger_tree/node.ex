defmodule FingerTree.Node do
  @moduledoc false

  @behaviour FingerTree.Measured

  @type t(type) :: %{
          __struct__: FingerTree.Node,
          measure: any(),
          contents: [FingerTree.Behaviour.finger(type)]
        }

  defstruct measure: [], contents: []

  @impl FingerTree.Measured
  def measure(%__MODULE__{contents: contents}),
    do: Enum.flat_map(contents, &FingerTree.measure/1)
end
