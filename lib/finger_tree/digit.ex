defmodule FingerTree.Digit do
  @moduledoc false

  @type t :: %{
          __struct__: FingerTree.Digit,
          contents: [FingerTree.Node.t()]
        }

  defstruct contents: []

  @spec empty?(t()) :: boolean()
  def empty?(%__MODULE__{contents: []}), do: true
  def empty?(%__MODULE__{}), do: false

  @spec first(t()) :: any()
  def first(%__MODULE__{contents: [e | _]}), do: e

  @spec last(t()) :: any()
  def last(%__MODULE__{contents: [e]}), do: e
  def last(%__MODULE__{contents: [_, e]}), do: e
  def last(%__MODULE__{contents: [_, _, e]}), do: e
  def last(%__MODULE__{contents: [_, _, _, e]}), do: e

  @spec all_but_first(t()) :: t()
  def all_but_first(%__MODULE__{contents: contents} = this) do
    [_ | rest] = contents
    %__MODULE__{this | contents: rest}
  end

  @spec all_but_last(t()) :: t()
  def all_but_last(%__MODULE__{contents: [_]} = this),
    do: %__MODULE__{this | contents: []}

  def all_but_last(%__MODULE__{contents: [e, _]} = this),
    do: %__MODULE__{this | contents: [e]}

  def all_but_last(%__MODULE__{contents: [e1, e2, _]} = this),
    do: %__MODULE__{this | contents: [e1, e2]}

  def all_but_last(%__MODULE__{contents: [e1, e2, e3, _]} = this),
    do: %__MODULE__{this | contents: [e1, e2, e3]}

  @spec get(t(), index :: non_neg_integer()) :: any()
  def get(%__MODULE__{contents: [e | _]}, 0), do: e
  def get(%__MODULE__{contents: [_, e | _]}, 1), do: e
  def get(%__MODULE__{contents: [_, _, e | _]}, 2), do: e
  def get(%__MODULE__{contents: [_, _, _, e | _]}, 3), do: e

  @spec append(t(), e :: any()) :: t()
  def append(%__MODULE__{contents: []} = this, e),
    do: %__MODULE__{this | contents: [e]}

  def append(%__MODULE__{contents: [e1]} = this, e),
    do: %__MODULE__{this | contents: [e1, e]}

  def append(%__MODULE__{contents: [e1, e2]} = this, e),
    do: %__MODULE__{this | contents: [e1, e2, e]}

  def append(%__MODULE__{contents: [e1, e2, e3]} = this, e),
    do: %__MODULE__{this | contents: [e1, e2, e3, e]}

  @spec prepend(t(), e :: any()) :: t()
  def prepend(%__MODULE__{contents: []} = this, e),
    do: %__MODULE__{this | contents: [e]}

  def prepend(%__MODULE__{contents: [e1]} = this, e),
    do: %__MODULE__{this | contents: [e, e1]}

  def prepend(%__MODULE__{contents: [e1, e2]} = this, e),
    do: %__MODULE__{this | contents: [e, e1, e2]}

  def prepend(%__MODULE__{contents: [e1, e2, e3]} = this, e),
    do: %__MODULE__{this | contents: [e, e1, e2, e3]}

  @spec collect(
          t :: FingerTree.Behaviour.finger_tree(any()) | [FingerTree.Behaviour.finger_tree(any())]
        ) :: t()
  def collect(t) when not is_list(t), do: collect([t])

  def collect([_ | _] = t) when is_list(t) and length(t) <= 4,
    do: %FingerTree.Digit{contents: t}

  unless Application.get_env(:finger_tree, :standard_inspect, true) do
    defimpl Inspect do
      import Inspect.Algebra

      def inspect(%_mod{contents: contents}, opts) do
        concat(["#Digit<", to_doc(contents, opts), ">"])
      end
    end
  end
end
