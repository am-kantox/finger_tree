defmodule FingerTree.Behaviour do
  @moduledoc """
  Documentation for `FingerTree.Behaviour`.

  http://www.staff.city.ac.uk/~ross/papers/FingerTree.html
  """

  @type finger_tree_type ::
          FingerTree.Empty | FingerTree.Single | FingerTree.Deep | FingerTree.Node
  @type finger(type) :: %{
          :__struct__ => FingerTree.Type,
          type: type,
          value: any()
        }
  @type finger_tree(type) :: %{
          :__struct__ => finger_tree_type(),
          type: type,
          digit: integer(),
          value: any()
        }

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
end
