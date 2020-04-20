defmodule Calculator.History do
  def start_link() do
    Agent.start_link(fn -> [] end)
  end

  @spec update(atom | pid | {atom, any} | {:via, atom, any}, any) :: :ok
  def update(pid, latest) do
    Agent.update(pid, fn h ->
      h ++ [latest]
    end)
  end

  def list(pid) do
    Agent.get(pid, fn h -> h end)
  end

  def clear(pid) do
    Agent.update(pid, fn _h ->
      []
    end)
  end
end
