defmodule FingerTree.Benches.Queue do
  use Benchfella

  @huge_range ?a..(1_000_000 + ?a)

  setup_all do
    q = Enum.reduce(@huge_range, :queue.new(), &:queue.in/2)
    ft = Enum.reduce(@huge_range, %FingerTree.Empty{}, &FingerTree.push(&2, &1))
    {:ok, q: q, ft: ft}
  end

  bench ":queue.in/2" do
    Enum.reduce(@huge_range, :queue.new(), &:queue.in/2)
  end

  bench "FingerTree.push/2" do
    Enum.reduce(@huge_range, %FingerTree.Empty{}, &FingerTree.push(&2, &1))
  end

  bench ":queue.in_r/2" do
    Enum.reduce(@huge_range, :queue.new(), &:queue.in_r/2)
  end

  bench "FingerTree.shift/2" do
    Enum.reduce(@huge_range, %FingerTree.Empty{}, &FingerTree.unshift(&2, &1))
  end

  bench ":queue.join/2" do
    :queue.join(bench_context[:q], bench_context[:q])
  end

  bench "FingerTree.append/2" do
    FingerTree.append(bench_context[:ft], bench_context[:ft])
  end
end
