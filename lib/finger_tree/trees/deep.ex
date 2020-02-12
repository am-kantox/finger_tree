defmodule FingerTree.Deep do
  @moduledoc false

  use FingerTree

  defmacrop deep(clauses, vars \\ []) do
    clauses =
      for clause <- clauses do
        case clause do
          :empty_spine ->
            quote do: {:spine, %FingerTree.Empty{}}

          :spine ->
            spine = vars |> Keyword.get(:spine, :spine) |> Macro.var(nil)
            quote do: {:spine, unquote(spine)}

          [clause, contents] when clause in [:left, :right] ->
            var = vars |> Keyword.get(clause, clause) |> Macro.var(nil)

            quote do
              {unquote(clause), %FingerTree.Digit{contents: unquote(contents)} = unquote(var)}
            end

          clause when clause in [:left, :right] ->
            var = vars |> Keyword.get(clause, clause) |> Macro.var(nil)
            quote do: {unquote(clause), %FingerTree.Digit{} = unquote(var)}
        end
      end

    aliases = __MODULE__ |> Module.split() |> Enum.map(&String.to_atom/1)
    contents = Keyword.get(vars, :contents, :contents)
    this = Keyword.get(vars, :this, :this)

    {:=, [],
     [
       {:%, [],
        [
          {:__aliases__, [alias: false], aliases},
          {:%{}, [], [contents: {:=, [], [{:%{}, [], clauses}, {contents, [], nil}]}]}
        ]},
       {this, [], nil}
     ]}
  end

  @impl FingerTree.Behaviour
  def empty?(%__MODULE__{}), do: false

  @impl FingerTree.Behaviour
  def first(%__MODULE__{contents: %{right: right}}),
    do: FingerTree.Digit.last(right)

  @impl FingerTree.Behaviour
  def last(%__MODULE__{contents: %{left: left}}),
    do: FingerTree.Digit.first(left)

  @impl FingerTree.Behaviour
  def push(deep([:right, :spine]), e) do
    case right.contents do
      [e0, e1, e2, e3] ->
        node = %FingerTree.Node{contents: [e0, e1, e2]}

        %FingerTree.Deep{
          this
          | contents: %{
              contents
              | spine: FingerTree.push(spine, node),
                right: FingerTree.Digit.collect([e3, e])
            }
        }

      _ ->
        %FingerTree.Deep{this | contents: %{contents | right: FingerTree.Digit.append(right, e)}}
    end
  end

  @impl FingerTree.Behaviour
  def unshift(deep([:left, :spine]), e) do
    case left.contents do
      [e0, e1, e2, e3] ->
        node = %FingerTree.Node{contents: [e1, e2, e3]}

        %FingerTree.Deep{
          this
          | contents: %{
              contents
              | spine: FingerTree.unshift(spine, node),
                left: FingerTree.Digit.collect([e, e0])
            }
        }

      _ ->
        %FingerTree.Deep{this | contents: %{contents | left: FingerTree.Digit.prepend(left, e)}}
    end
  end

  @impl FingerTree.Behaviour
  def pop(deep([[:right, [_, _ | _]]])),
    do: %FingerTree.Deep{
      this
      | contents: %{contents | right: FingerTree.Digit.all_but_last(right)}
    }

  def pop(deep([[:left, [l]], :empty_spine], left: :_, contents: :_, this: :_)),
    do: %FingerTree.Single{contents: l}

  def pop(deep([[:left, [l1, l2, l3, l4]], :empty_spine], left: :_)),
    do: %FingerTree.Deep{
      this
      | contents: %{
          contents
          | left: FingerTree.Digit.collect([l1, l2]),
            right: FingerTree.Digit.collect([l3, l4])
        }
    }

  def pop(deep([[:left, [lh | lt]], :empty_spine], left: :_)),
    do: %FingerTree.Deep{
      this
      | contents: %{
          contents
          | left: FingerTree.Digit.collect(lh),
            right: FingerTree.Digit.collect(lt)
        }
    }

  def pop(deep([:spine])),
    do: %FingerTree.Deep{
      this
      | contents: %{
          contents
          | spine: FingerTree.pop(spine),
            right: FingerTree.Digit.collect(FingerTree.first(spine).contents)
        }
    }

  @impl FingerTree.Behaviour
  def shift(deep([[:left, [_, _ | _]]])),
    do: %FingerTree.Deep{
      this
      | contents: %{contents | left: FingerTree.Digit.all_but_first(left)}
    }

  def shift(deep([[:right, [r]], :empty_spine], right: :_, contents: :_, this: :_)),
    do: %FingerTree.Single{contents: r}

  def shift(deep([[:right, [r1, r2, r3, r4]], :empty_spine], right: :_)),
    do: %FingerTree.Deep{
      this
      | contents: %{
          contents
          | left: FingerTree.Digit.collect([r1, r2]),
            right: FingerTree.Digit.collect([r3, r4])
        }
    }

  def shift(deep([[:right, [rh | rt]], :empty_spine], right: :_)),
    do: %FingerTree.Deep{
      this
      | contents: %{
          contents
          | left: FingerTree.Digit.collect(rh),
            right: FingerTree.Digit.collect(rt)
        }
    }

  def shift(deep([:spine])),
    do: %FingerTree.Deep{
      this
      | contents: %{
          contents
          | spine: FingerTree.shift(spine),
            left: FingerTree.Digit.collect(FingerTree.last(spine).contents)
        }
    }

  @impl FingerTree.Behaviour
  def append(%__MODULE__{} = this, %FingerTree.Deep{} = other),
    do: %FingerTree.Deep{
      other
      | contents: %{other.contents | left: this.contents.left, spine: fold(this, other)}
    }

  def append(%__MODULE__{} = this, %_single_or_empty{} = other),
    do: FingerTree.prepend(other, this)

  @impl FingerTree.Behaviour
  def prepend(%__MODULE__{} = this, %FingerTree.Deep{} = other),
    do: %FingerTree.Deep{
      this
      | contents: %{this.contents | left: other.contents.left, spine: fold(other, this)}
    }

  def prepend(%__MODULE__{} = this, %_single_or_empty{} = other),
    do: FingerTree.append(other, this)

  defp fold(%__MODULE__{} = port, %__MODULE__{} = starboard) do
    flist = port.contents.right.contents ++ starboard.contents.left.contents

    port.contents.spine
    |> do_fold(0, length(flist), flist)
    |> FingerTree.append(starboard.contents.spine)
  end

  defp do_fold(spine, seen, all, _fist) when seen >= all, do: spine

  defp do_fold(spine, seen, all, fist) when all - seen == 2 do
    spine =
      spine
      |> FingerTree.push(%FingerTree.Node{
        contents: [Enum.at(fist, seen), Enum.at(fist, seen + 1)]
      })

    do_fold(spine, seen + 2, all, fist)
  end

  defp do_fold(spine, seen, all, fist) when all - seen == 4 do
    spine =
      spine
      |> FingerTree.push(%FingerTree.Node{
        contents: [Enum.at(fist, seen), Enum.at(fist, seen + 1)]
      })
      |> FingerTree.push(%FingerTree.Node{
        contents: [Enum.at(fist, seen + 2), Enum.at(fist, seen + 3)]
      })

    do_fold(spine, seen + 4, all, fist)
  end

  defp do_fold(spine, seen, all, fist) do
    spine =
      spine
      |> FingerTree.push(%FingerTree.Node{
        contents: [Enum.at(fist, seen), Enum.at(fist, seen + 1), Enum.at(fist, seen + 2)]
      })

    do_fold(spine, seen + 3, all, fist)
  end
end