defmodule FingerTreeTest do
  use ExUnit.Case
  doctest FingerTree

  @empty %FingerTree.Empty{contents: []}

  setup_all do
    %{
      tree_fwd_push:
        Enum.reduce(?a..?z, %FingerTree.Empty{}, fn x, acc -> FingerTree.push(acc, x) end),
      tree_bwd_push:
        Enum.reduce(?z..?a, %FingerTree.Empty{}, fn x, acc -> FingerTree.push(acc, x) end),
      tree_fwd_unsh:
        Enum.reduce(?a..?z, %FingerTree.Empty{}, fn x, acc -> FingerTree.unshift(acc, x) end),
      tree_bwd_unsh:
        Enum.reduce(?z..?a, %FingerTree.Empty{}, fn x, acc -> FingerTree.unshift(acc, x) end)
    }
  end

  test "push/2 + pop/1", ctx do
    assert Enum.map_reduce(?a..?z, ctx.tree_fwd_push, fn _, acc ->
             {FingerTree.first(acc), FingerTree.pop(acc)}
           end) == {Enum.to_list(?z..?a), @empty}
  end

  test "push/2 + shift/1", ctx do
    assert Enum.map_reduce(?a..?z, ctx.tree_fwd_push, fn _, acc ->
             {FingerTree.last(acc), FingerTree.shift(acc)}
           end) == {Enum.to_list(?a..?z), @empty}
  end

  test "unshift/2 + pop/1", ctx do
    assert Enum.map_reduce(?a..?z, ctx.tree_fwd_unsh, fn _, acc ->
             {FingerTree.first(acc), FingerTree.pop(acc)}
           end) == {Enum.to_list(?a..?z), @empty}
  end

  test "unshift/2 + shift/1", ctx do
    assert Enum.map_reduce(?a..?z, ctx.tree_fwd_unsh, fn _, acc ->
             {FingerTree.last(acc), FingerTree.shift(acc)}
           end) == {Enum.to_list(?z..?a), @empty}
  end

  test "append/2", ctx do
    double = FingerTree.append(ctx.tree_fwd_push, ctx.tree_fwd_push)

    assert Enum.map_reduce(?a..(?z + 26), double, fn _, acc ->
             {FingerTree.last(acc), FingerTree.shift(acc)}
           end) ==
             {?a..?z |> Enum.to_list() |> List.duplicate(2) |> Enum.reduce(&Kernel.++/2), @empty}
  end

  test "prepend/2", ctx do
    a = FingerTree.append(ctx.tree_fwd_push, ctx.tree_bwd_push)
    p = FingerTree.prepend(ctx.tree_bwd_push, ctx.tree_fwd_push)

    assert a == p

    {'abcdefghijklmnopqrstuvwxyz', bwd} =
      Enum.map_reduce(?a..?z, a, fn _, acc ->
        {FingerTree.first(acc), FingerTree.pop(acc)}
      end)

    assert {'abcdefghijklmnopqrstuvwxyz', @empty} =
             Enum.map_reduce(?a..?z, bwd, fn _, acc ->
               {FingerTree.last(acc), FingerTree.shift(acc)}
             end)
  end
end
