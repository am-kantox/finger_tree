defmodule FingerTree.IllegalOperation do
  @moduledoc """
  An exception to be thrown when an attempt to perform incorrect operation on the tree was made.
  """

  defexception [:tree, :operation, :data, :message]

  @doc false
  @impl Exception
  def exception(opts) do
    message = "This operation (#{opts[:operation]}) is illegal for (#{inspect(opts[:tree])})."

    message =
      if is_nil(opts[:data]),
        do: message,
        else: message <> "\nAdditional data:\n#{inspect(opts[:data])}"

    %FingerTree.IllegalOperation{
      operation: opts[:operation],
      tree: opts[:tree],
      data: opts[:data],
      message: message
    }
  end
end
