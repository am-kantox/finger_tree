defmodule FingerTree do
  @moduledoc """
  Documentation for `FingerTree`.

  Implementation is based on http://www.staff.city.ac.uk/~ross/papers/FingerTree.pdf

  http://www.staff.city.ac.uk/~ross/papers/FingerTree.html
  """

  @doc """
  """
  defmacro __using__(opts \\ []) do
    type = Keyword.get(opts, :type, nil)
    measure = Keyword.get(opts, :measure, [])
    contents = Keyword.get(opts, :contents, [])

    [
      quote do
        @behaviour FingerTree.Behaviour
        @behaviour FingerTree.Measured

        @type t :: FingerTree.Behaviour.finger_tree(unquote(type))

        defstruct measure: unquote(measure), contents: unquote(contents)

        @impl FingerTree.Measured
        def measure(%__MODULE__{} = tree),
          do: raise(FingerTree.IllegalOperation, tree: tree, operation: :measure)

        @impl FingerTree.Behaviour
        def type, do: unquote(type)

        @impl FingerTree.Behaviour
        def first(%__MODULE__{} = tree),
          do: raise(FingerTree.IllegalOperation, tree: tree, operation: :first)

        @impl FingerTree.Behaviour
        def last(%__MODULE__{} = tree),
          do: raise(FingerTree.IllegalOperation, tree: tree, operation: :last)

        @impl FingerTree.Behaviour
        def push(%__MODULE__{} = tree, e),
          do: raise(FingerTree.IllegalOperation, tree: tree, operation: :shift, data: e)

        @impl FingerTree.Behaviour
        def unshift(%__MODULE__{} = tree, e),
          do: raise(FingerTree.IllegalOperation, tree: tree, operation: :unshift, data: e)

        @impl FingerTree.Behaviour
        def pop(%__MODULE__{} = tree),
          do: raise(FingerTree.IllegalOperation, tree: tree, operation: :pop)

        @impl FingerTree.Behaviour
        def shift(%__MODULE__{} = tree),
          do: raise(FingerTree.IllegalOperation, tree: tree, operation: :shift)
      end
      | Enum.map([Empty, Single, Deep], fn mod ->
          mod = Module.concat(FingerTree, mod)

          quote do
            @impl FingerTree.Behaviour
            def append(%__MODULE__{} = tree, %unquote(mod){} = other),
              do: raise(FingerTree.IllegalOperation, tree: tree, operation: :append, data: other)

            @impl FingerTree.Behaviour
            def prepend(%__MODULE__{} = tree, %unquote(mod){} = other),
              do: raise(FingerTree.IllegalOperation, tree: tree, operation: :prepend, data: other)
          end
        end)
    ] ++
      [
        quote do
          defoverridable first: 1,
                         push: 2,
                         unshift: 2,
                         pop: 1,
                         shift: 1,
                         last: 1,
                         append: 2,
                         prepend: 2,
                         measure: 1

          unless Application.get_env(:finger_tree, :standard_inspect, true) do
            defimpl Inspect do
              import Inspect.Algebra

              def inspect(%_mod{contents: contents}, opts) do
                mod = __MODULE__ |> Module.split() |> :lists.reverse() |> hd() |> to_string()
                concat(["##{mod}<", to_doc(contents, opts), ">"])
              end
            end
          end
        end
      ]
  end

  @behaviour FingerTree.Measured

  @impl FingerTree.Measured
  def measure(%type{} = tree), do: type.measure(tree)
  def measure(tree) when is_list(tree), do: Enum.map(tree, &measure/1)
  def measure(tree), do: [tree]

  @behaviour FingerTree.Behaviour

  @impl FingerTree.Behaviour
  def type,
    do: raise(FingerTree.IllegalOperation, tree: __MODULE__, operation: :type)

  @impl FingerTree.Behaviour
  def empty?(%type{} = tree), do: type.empty?(tree)

  @impl FingerTree.Behaviour
  def first(%type{} = tree), do: type.first(tree)

  @impl FingerTree.Behaviour
  def push(%type{} = tree, e), do: type.push(tree, e)

  @impl FingerTree.Behaviour
  def unshift(%type{} = tree, e), do: type.unshift(tree, e)

  @impl FingerTree.Behaviour
  def pop(%type{} = tree), do: type.pop(tree)

  @impl FingerTree.Behaviour
  def shift(%type{} = tree), do: type.shift(tree)

  @impl FingerTree.Behaviour
  def last(%type{} = tree), do: type.last(tree)

  @impl FingerTree.Behaviour
  def append(%type{} = tree, other), do: type.append(tree, other)

  @impl FingerTree.Behaviour
  def prepend(%type{} = tree, other), do: type.prepend(tree, other)

  def new!(type, contents \\ []) do
    instance = struct(type, contents: contents)
    %{instance | measure: measure(instance)}
  end

  def update!(%_type{} = old, contents) do
    instance = %{old | contents: contents}
    %{instance | measure: measure(instance)}
  end
end
