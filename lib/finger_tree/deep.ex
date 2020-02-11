defmodule FingerTree.Deep do
  @moduledoc """

  """
  use FingerTree

  # defmacrop deep do
  #   quote generated: true do
  #     %__MODULE__{
  #       contents:
  #         %{
  #           left: %FingerTree.Digit{} = left,
  #           right: %FingerTree.Digit{} = right,
  #           spine: spine
  #         } = contents
  #     } = this
  #   end
  # end

  @impl FingerTree.Behaviour
  def empty?(%__MODULE__{}), do: false

  @impl FingerTree.Behaviour
  def first(%__MODULE__{contents: %{right: right}}),
    do: FingerTree.Digit.last(right)

  @impl FingerTree.Behaviour
  def last(%__MODULE__{contents: %{left: left}}),
    do: FingerTree.Digit.first(left)

  @impl FingerTree.Behaviour
  def push(
        %__MODULE__{
          contents: %{right: %FingerTree.Digit{} = right, spine: spine} = contents
        } = this,
        e
      ) do
    case right.contents do
      [e0, e1, e2, e3] ->
        node = %FingerTree.Node{contents: [e0, e1, e2]}

        %FingerTree.Deep{
          this
          | contents: %{
              contents
              | spine: FingerTree.push(spine, node),
                right: FingerTree.Digit.collect(e3, e)
            }
        }

      _ ->
        %FingerTree.Deep{this | contents: %{contents | right: FingerTree.Digit.append(right, e)}}
    end
  end

  @impl FingerTree.Behaviour
  def unshift(
        %__MODULE__{
          contents: %{left: %FingerTree.Digit{} = left, spine: spine} = contents
        } = this,
        e
      ) do
    case left.contents do
      [e0, e1, e2, e3] ->
        node = %FingerTree.Node{contents: [e1, e2, e3]}

        %FingerTree.Deep{
          this
          | contents: %{
              contents
              | spine: FingerTree.unshift(spine, node),
                left: FingerTree.Digit.collect(e, e0)
            }
        }

      _ ->
        %FingerTree.Deep{this | contents: %{contents | left: FingerTree.Digit.prepend(left, e)}}
    end
  end

  @impl FingerTree.Behaviour
  def pop(
        %__MODULE__{
          contents: %{right: %FingerTree.Digit{contents: [_, _ | _]} = right} = contents
        } = this
      ),
      do: %FingerTree.Deep{
        this
        | contents: %{contents | right: FingerTree.Digit.all_but_last(right)}
      }

  def pop(%__MODULE__{
        contents: %{left: %FingerTree.Digit{contents: [l]}, spine: %FingerTree.Empty{}}
      }),
      do: %FingerTree.Single{contents: l}

  def pop(
        %__MODULE__{
          contents:
            %{
              left: %FingerTree.Digit{contents: [l1, l2, l3, l4]},
              spine: %FingerTree.Empty{}
            } = contents
        } = this
      ),
      do: %FingerTree.Deep{
        this
        | contents: %{
            contents
            | left: FingerTree.Digit.collect(l1, l2),
              right: FingerTree.Digit.collect(l3, l4)
          }
      }

  def pop(
        %__MODULE__{
          contents:
            %{left: %FingerTree.Digit{contents: [lh | lt]}, spine: %FingerTree.Empty{}} = contents
        } = this
      ),
      do: %FingerTree.Deep{
        this
        | contents: %{
            contents
            | left: FingerTree.Digit.collect(lh),
              right: FingerTree.Digit.collect(lt)
          }
      }

  def pop(
        %__MODULE__{
          contents: %{spine: %_single_or_deep{} = spine} = contents
        } = this
      ),
      do: %FingerTree.Deep{
        this
        | contents: %{
            contents
            | spine: FingerTree.pop(spine),
              right: FingerTree.Digit.collect(FingerTree.first(spine).contents)
          }
      }

  @impl FingerTree.Behaviour
  def shift(
        %__MODULE__{
          contents: %{left: %FingerTree.Digit{contents: [_, _ | _]} = left} = contents
        } = this
      ),
      do: %FingerTree.Deep{
        this
        | contents: %{contents | left: FingerTree.Digit.all_but_first(left)}
      }

  def shift(%__MODULE__{
        contents: %{right: %FingerTree.Digit{contents: [r]}, spine: %FingerTree.Empty{}}
      }),
      do: %FingerTree.Single{contents: r}

  def shift(
        %__MODULE__{
          contents:
            %{
              right: %FingerTree.Digit{contents: [r1, r2, r3, r4]},
              spine: %FingerTree.Empty{}
            } = contents
        } = this
      ),
      do: %FingerTree.Deep{
        this
        | contents: %{
            contents
            | left: FingerTree.Digit.collect(r1, r2),
              right: FingerTree.Digit.collect(r3, r4)
          }
      }

  def shift(
        %__MODULE__{
          contents:
            %{right: %FingerTree.Digit{contents: [rh | rt]}, spine: %FingerTree.Empty{}} =
              contents
        } = this
      ),
      do: %FingerTree.Deep{
        this
        | contents: %{
            contents
            | left: FingerTree.Digit.collect(rh),
              right: FingerTree.Digit.collect(rt)
          }
      }

  def shift(
        %__MODULE__{
          contents: %{spine: %_single_or_deep{} = spine} = contents
        } = this
      ),
      do: %FingerTree.Deep{
        this
        | contents: %{
            contents
            | spine: FingerTree.shift(spine),
              left: FingerTree.Digit.collect(FingerTree.last(spine).contents)
          }
      }

  @impl FingerTree.Behaviour
  def append(
        %__MODULE__{
          contents: contents
        } = this,
        %FingerTree.Deep{
          contents: contents
        } = other
      ),
      do: %FingerTree.Deep{other | contents: %{contents | spine: fold(this, other)}}

  def append(%__MODULE__{} = this, %_single_or_empty{} = other),
    do: FingerTree.prepend(other, this)

  defp fold(%__MODULE__{} = port, %__MODULE__{} = starboard) do
    flist = port.right.content ++ starboard.left.content

    port.spine
    |> do_fold(0, length(flist), flist)
    |> FingerTree.append(starboard.spine)
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

    do_fold(seen + 4, all, fist, spine)
  end

  defp do_fold(seen, all, fist, spine) do
    spine =
      spine
      |> FingerTree.push(%FingerTree.Node{
        contents: [Enum.at(fist, seen), Enum.at(fist, seen + 1), Enum.at(fist, seen + 2)]
      })

    do_fold(seen + 3, all, fist, spine)
  end
end
