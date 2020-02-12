defmodule FingerTree.Node do
  @moduledoc false

  @type t :: %{
          __struct__: FingerTree.Node,
          contents: [FingerTree.Behaviour.finger(any())]
        }
  defstruct contents: []
end
