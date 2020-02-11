defmodule FingerTree.Digit do
  defstruct contents: []

  @type t :: %{
          __struct__: FingerTree.Digit,
          contents: []
        }

  @spec to_tuple(t()) :: tuple()
  def to_tuple(%__MODULE__{contents: [e0]}), do: {e0}
  def to_tuple(%__MODULE__{contents: [e0, e1]}), do: {e0, e1}
  def to_tuple(%__MODULE__{contents: [e0, e1, e2]}), do: {e0, e1, e2}
  def to_tuple(%__MODULE__{contents: [e0, e1, e2, e3]}), do: {e0, e1, e2, e3}

  # def to_tuple(%__MODULE__{contents: contents}), do: List.to_tuple(contents)

  @spec empty?(t()) :: boolean()
  def empty?(%__MODULE__{contents: []}), do: true
  def empty?(%__MODULE__{}), do: false

  @spec first(t()) :: any()
  def first(%__MODULE__{contents: [e | _]}), do: e

  @spec last(t()) :: any()
  def last(%__MODULE__{contents: contents}), do: contents |> :lists.reverse() |> hd()

  @spec all_but_last(t()) :: t()
  def all_but_first(%__MODULE__{contents: contents} = this) do
    [_ | rest] = contents
    %__MODULE__{this | contents: rest}
  end

  @spec all_but_last(t()) :: t()
  def all_but_last(%__MODULE__{contents: contents} = this) do
    [_ | rest] = :lists.reverse(contents)
    %__MODULE__{this | contents: :lists.reverse(rest)}
  end

  @spec get(t(), index :: non_neg_integer()) :: any()
  def get(%__MODULE__{contents: [e | _]}, 0), do: e
  def get(%__MODULE__{contents: [_, e | _]}, 1), do: e
  def get(%__MODULE__{contents: [_, _, e | _]}, 2), do: e
  def get(%__MODULE__{contents: [_, _, _, e | _]}, 3), do: e

  # def get(%__MODULE__{contents: contents}, index), do: Enum.at(contents, index)

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

  @spec collect(t :: [FingerTree.finger_tree(any())]) :: t()
  def collect(t) when is_list(t), do: %FingerTree.Digit{contents: t}

  @spec collect(t1 :: FingerTree.finger_tree(any())) :: t()
  def collect(t1), do: %FingerTree.Digit{contents: [t1]}

  @spec collect(t1 :: FingerTree.finger_tree(any()), t2 :: FingerTree.finger_tree(any())) :: t()
  def collect(t1, t2), do: %FingerTree.Digit{contents: [t1, t2]}

  @spec collect(
          t1 :: FingerTree.finger_tree(any()),
          t2 :: FingerTree.finger_tree(any()),
          t3 :: FingerTree.finger_tree(any())
        ) :: t()
  def collect(t1, t2, t3), do: %FingerTree.Digit{contents: [t1, t2, t3]}

  @spec collect(
          t1 :: FingerTree.finger_tree(any()),
          t2 :: FingerTree.finger_tree(any()),
          t3 :: FingerTree.finger_tree(any()),
          t4 :: FingerTree.finger_tree(any())
        ) :: t()
  def collect(t1, t2, t3, t4), do: %FingerTree.Digit{contents: [t1, t2, t3, t4]}

  unless Application.get_env(:finger_tree, :standard_inspect, true) do
    defimpl Inspect do
      import Inspect.Algebra

      def inspect(%_mod{contents: contents}, opts) do
        concat(["#Dig<", to_doc(contents, opts), ">"])
      end
    end
  end
end
