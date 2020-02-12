defmodule FingerTreeTest do
  use ExUnit.Case
  doctest FingerTree

  @empty %FingerTree.Empty{contents: []}

  setup_all do
    %{
      tree_fwd_push:
        Enum.reduce(97..122, %FingerTree.Empty{}, fn x, acc -> FingerTree.push(acc, x) end),
      tree_bwd_push:
        Enum.reduce(122..97, %FingerTree.Empty{}, fn x, acc -> FingerTree.push(acc, x) end),
      tree_fwd_unsh:
        Enum.reduce(97..122, %FingerTree.Empty{}, fn x, acc -> FingerTree.unshift(acc, x) end),
      tree_bwd_unsh:
        Enum.reduce(122..97, %FingerTree.Empty{}, fn x, acc -> FingerTree.unshift(acc, x) end)
    }
  end

  test "push/2 + pop/1", ctx do
    assert Enum.map_reduce(97..122, ctx.tree_fwd_push, fn _, acc ->
             {FingerTree.first(acc), FingerTree.pop(acc)}
           end) == {Enum.to_list(122..97), @empty}
  end

  test "push/2 + shift/1", ctx do
    assert Enum.map_reduce(97..122, ctx.tree_fwd_push, fn _, acc ->
             {FingerTree.last(acc), FingerTree.shift(acc)}
           end) == {Enum.to_list(97..122), @empty}
  end

  test "unshift/2 + pop/1", ctx do
    assert Enum.map_reduce(97..122, ctx.tree_fwd_unsh, fn _, acc ->
             {FingerTree.first(acc), FingerTree.pop(acc)}
           end) == {Enum.to_list(97..122), @empty}
  end

  test "unshift/2 + shift/1", ctx do
    assert Enum.map_reduce(97..122, ctx.tree_fwd_unsh, fn _, acc ->
             {FingerTree.last(acc), FingerTree.shift(acc)}
           end) == {Enum.to_list(122..97), @empty}
  end

  test "append/2", ctx do
    double = FingerTree.append(ctx.tree_fwd_push, ctx.tree_fwd_push)

    assert Enum.map_reduce(97..(122 + 26), double, fn _, acc ->
             {FingerTree.last(acc), FingerTree.shift(acc)}
           end) ==
             {97..122 |> Enum.to_list() |> List.duplicate(2) |> Enum.reduce(&Kernel.++/2), @empty}
  end

  test "prepend/2", ctx do
    a = FingerTree.append(ctx.tree_fwd_push, ctx.tree_bwd_push)
    p = FingerTree.prepend(ctx.tree_bwd_push, ctx.tree_fwd_push)

    assert a == p

    {'abcdefghijklmnopqrstuvwxyz', bwd} =
      Enum.map_reduce(97..122, a, fn _, acc ->
        {FingerTree.first(acc), FingerTree.pop(acc)}
      end)

    assert {'abcdefghijklmnopqrstuvwxyz', @empty} =
             Enum.map_reduce(97..122, bwd, fn _, acc ->
               {FingerTree.last(acc), FingerTree.shift(acc)}
             end)
  end
end
