defmodule FingerTreeTest do
  use ExUnit.Case
  doctest FingerTree

  @empty %FingerTree.Empty{contents: []}
  @range ?a..?z
  @inversed_range @range.last..@range.first
  @double_range @range.first..(2 * @range.last - @range.first + 1)

  setup_all do
    %{
      tree_fwd_push: Enum.reduce(@range, %FingerTree.Empty{}, &FingerTree.push(&2, &1)),
      tree_bwd_push: Enum.reduce(@inversed_range, %FingerTree.Empty{}, &FingerTree.push(&2, &1)),
      tree_fwd_unsh: Enum.reduce(@range, %FingerTree.Empty{}, &FingerTree.unshift(&2, &1)),
      tree_bwd_unsh:
        Enum.reduce(@inversed_range, %FingerTree.Empty{}, &FingerTree.unshift(&2, &1))
    }
  end

  test "huge tree → push/2 + pop/1" do
    huge_range = ?a..(1_000 + ?a)

    tree_huge =
      Enum.reduce(huge_range, %FingerTree.Empty{}, fn x, acc ->
        FingerTree.push(acc, x)
      end)

    assert Enum.map_reduce(huge_range, tree_huge, fn _, acc ->
             {FingerTree.first(acc), FingerTree.pop(acc)}
           end) == {Enum.to_list(huge_range.last..huge_range.first), @empty}
  end

  test "push/2 + pop/1", ctx do
    assert Enum.map_reduce(@range, ctx.tree_fwd_push, fn _, acc ->
             {FingerTree.first(acc), FingerTree.pop(acc)}
           end) == {Enum.to_list(@inversed_range), @empty}
  end

  test "push/2 + shift/1", ctx do
    assert Enum.map_reduce(@range, ctx.tree_fwd_push, fn _, acc ->
             {FingerTree.last(acc), FingerTree.shift(acc)}
           end) == {Enum.to_list(@range), @empty}
  end

  test "unshift/2 + pop/1", ctx do
    assert Enum.map_reduce(@range, ctx.tree_fwd_unsh, fn _, acc ->
             {FingerTree.first(acc), FingerTree.pop(acc)}
           end) == {Enum.to_list(@range), @empty}
  end

  test "unshift/2 + shift/1", ctx do
    assert Enum.map_reduce(@range, ctx.tree_fwd_unsh, fn _, acc ->
             {FingerTree.last(acc), FingerTree.shift(acc)}
           end) == {Enum.to_list(@inversed_range), @empty}
  end

  test "append/2", ctx do
    double = FingerTree.append(ctx.tree_fwd_push, ctx.tree_fwd_push)

    assert Enum.map_reduce(@double_range, double, fn _, acc ->
             {FingerTree.last(acc), FingerTree.shift(acc)}
           end) ==
             {@range |> Enum.to_list() |> List.duplicate(2) |> Enum.reduce(&Kernel.++/2), @empty}
  end

  test "prepend/2", ctx do
    a = FingerTree.append(ctx.tree_fwd_push, ctx.tree_bwd_push)
    p = FingerTree.prepend(ctx.tree_bwd_push, ctx.tree_fwd_push)

    assert a == p

    {'abcdefghijklmnopqrstuvwxyz', bwd} =
      Enum.map_reduce(@range, a, fn _, acc ->
        {FingerTree.first(acc), FingerTree.pop(acc)}
      end)

    assert {'abcdefghijklmnopqrstuvwxyz', @empty} =
             Enum.map_reduce(@range, bwd, fn _, acc ->
               {FingerTree.last(acc), FingerTree.shift(acc)}
             end)
  end
end
