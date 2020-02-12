defmodule FingerTree.Digit do
  @moduledoc false

  @behaviour FingerTree.Measured

  @type t(type) :: %{
          __struct__: FingerTree.Digit,
          measure: any(),
          contents: [type | FingerTree.Node.t(type)]
        }

  defstruct measure: [], contents: []

  @impl FingerTree.Measured
  def measure(%FingerTree.Digit{contents: contents}),
    do: Enum.flat_map(contents, &FingerTree.measure/1)

  @spec empty?(t(any())) :: boolean()
  def empty?(%FingerTree.Digit{contents: []}), do: true
  def empty?(%FingerTree.Digit{}), do: false

  @spec first(t(any())) :: any()
  def first(%FingerTree.Digit{contents: [e | _]}), do: e

  @spec last(t(any())) :: any()
  def last(%FingerTree.Digit{contents: [e]}), do: e
  def last(%FingerTree.Digit{contents: [_, e]}), do: e
  def last(%FingerTree.Digit{contents: [_, _, e]}), do: e
  def last(%FingerTree.Digit{contents: [_, _, _, e]}), do: e

  @spec all_but_first(t(any())) :: t(any())
  def all_but_first(%FingerTree.Digit{contents: contents} = this) do
    [_ | rest] = contents
    %FingerTree.Digit{this | contents: rest}
  end

  @spec all_but_last(t(any())) :: t(any())
  def all_but_last(%FingerTree.Digit{contents: [_]} = this),
    do: %FingerTree.Digit{this | contents: []}

  def all_but_last(%FingerTree.Digit{contents: [e, _]} = this),
    do: %FingerTree.Digit{this | contents: [e]}

  def all_but_last(%FingerTree.Digit{contents: [e1, e2, _]} = this),
    do: %FingerTree.Digit{this | contents: [e1, e2]}

  def all_but_last(%FingerTree.Digit{contents: [e1, e2, e3, _]} = this),
    do: %FingerTree.Digit{this | contents: [e1, e2, e3]}

  @spec get(t(any()), index :: non_neg_integer()) :: any()
  def get(%FingerTree.Digit{contents: [e | _]}, 0), do: e
  def get(%FingerTree.Digit{contents: [_, e | _]}, 1), do: e
  def get(%FingerTree.Digit{contents: [_, _, e | _]}, 2), do: e
  def get(%FingerTree.Digit{contents: [_, _, _, e | _]}, 3), do: e

  @spec append(t(any()), e :: any()) :: t(any())
  def append(%FingerTree.Digit{contents: []}, e),
    do: FingerTree.new!(FingerTree.Digit, [e])

  def append(%FingerTree.Digit{contents: [e1]}, e),
    do: FingerTree.new!(FingerTree.Digit, [e1, e])

  def append(%FingerTree.Digit{contents: [e1, e2]}, e),
    do: FingerTree.new!(FingerTree.Digit, [e1, e2, e])

  def append(%FingerTree.Digit{contents: [e1, e2, e3]}, e),
    do: FingerTree.new!(FingerTree.Digit, [e1, e2, e3, e])

  @spec prepend(t(any()), e :: any()) :: t(any())
  def prepend(%FingerTree.Digit{contents: []}, e),
    do: FingerTree.new!(FingerTree.Digit, [e])

  def prepend(%FingerTree.Digit{contents: [e1]}, e),
    do: FingerTree.new!(FingerTree.Digit, [e, e1])

  def prepend(%FingerTree.Digit{contents: [e1, e2]}, e),
    do: FingerTree.new!(FingerTree.Digit, [e, e1, e2])

  def prepend(%FingerTree.Digit{contents: [e1, e2, e3]}, e),
    do: FingerTree.new!(FingerTree.Digit, [e, e1, e2, e3])

  @spec collect(
          t :: FingerTree.Behaviour.finger_tree(any()) | [FingerTree.Behaviour.finger_tree(any())]
        ) :: t(any())
  def collect(t) when not is_list(t), do: collect([t])

  def collect([_ | _] = t) when is_list(t) and length(t) <= 4,
    do: FingerTree.new!(FingerTree.Digit, t)

  unless Application.get_env(:finger_tree, :standard_inspect, true) do
    defimpl Inspect do
      import Inspect.Algebra

      def inspect(%_mod{contents: contents}, opts) do
        concat(["#Digit<", to_doc(contents, opts), ">"])
      end
    end
  end
end
