defmodule FingerTree.Behaviour do
  @moduledoc """
  Documentation for `FingerTree.Behaviour`.

  http://www.staff.city.ac.uk/~ross/papers/FingerTree.html
  """

  @type finger_tree_type ::
          FingerTree.Empty | FingerTree.Single | FingerTree.Deep
  @type finger(type) :: type
  @type finger_tree(type) :: %{
          :__struct__ => finger_tree_type(),
          measure: any(),
          contents:
            []
            | FingerTree.Node.t(type)
            | %{
                left: FingerTree.Digit.t(type),
                spine: finger_tree(type),
                right: FingerTree.Digit.t(type)
              }
        }
  @type finger_any(type) :: finger_tree(type) | FingerTree.Node.t(type) | FingerTree.Digit.t(type)

  @callback type :: finger(any())

  @callback empty?(this :: finger_tree(any())) :: boolean()
  @callback first(this :: finger_tree(any())) :: finger(any())
  @callback push(this :: finger_tree(any()), e :: finger(any())) :: finger_tree(any())
  @callback unshift(this :: finger_tree(any()), e :: finger(any())) :: finger_tree(any())
  @callback pop(this :: finger_tree(any())) :: finger_tree(any())
  @callback shift(this :: finger_tree(any())) :: finger_tree(any())
  @callback last(this :: finger_tree(any())) :: finger(any())
  @callback append(this :: finger_tree(any()), other :: finger_tree(any())) :: finger_tree(any())
  @callback prepend(this :: finger_tree(any()), other :: finger_tree(any())) :: finger_tree(any())
  @callback split(
              this :: finger_tree(any()),
              splitter :: (any(), any() -> boolean()),
              acc :: any()
            ) ::
              {:ok, finger_tree(any()), finger_tree(any()), finger_tree(any())} | {:error, any()}
end

defmodule FingerTree.Measured do
  @moduledoc """
  The measured interface to be used for monoids to split / find / random access
  """
  @callback measure(this :: FingerTree.Behaviour.finger_any(any())) :: any()
end
