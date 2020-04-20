defmodule CalculatorWeb.CalculatorLive do
  use Phoenix.LiveView
  alias Calculator.History

  def render(assigns) do
    ~L"""
    <form phx-change="update">
      <label>Operand 1</label>
      <input type="number" name="op1" value="<%= @op1 %>"/>

      <label>Operand 2</label>
      <input type="number" name="op2" value="<%= @op2 %>"/>
    </form>
    <button phx-click="add">+</button>
    <button phx-click="subtract">-</button>
    <button phx-click="multiply">x</button>
    <button phx-click="divide">&#247</button>

    <h1>Result: <%= @result %></h1>

    <h1 style="display: inline;">History</h1>
    <%= if length(@history) != 0 do %>
      <button phx-click="clear_history">Clear History</button>
    <% end %>

    <%= for entry <- @history do %>
    <li phx-click="load_entry" phx-value-op1="<%= entry.op1 %>" phx-value-op2="<%= entry.op2 %>">
      <span><%= entry.op1 %></span>
      <span><%= entry.operator %></span>
      <span><%= entry.op2 %></span>
    </li>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, pid} = History.start_link()

    {:ok, assign(socket, op1: 0, op2: 0, result: 0, history_pid: pid, history: History.list(pid))}
  end

  def handle_event("update", %{"op1" => op1, "op2" => op2}, socket) do
    {first, second} = parse_input(op1, op2)
    {:noreply, assign(socket, op1: first, op2: second)}
  end

  def handle_event(
        "add",
        _params,
        %{assigns: %{op1: op1, op2: op2, history_pid: history_pid}} = socket
      ) do
    History.update(history_pid, %{
      op1: op1,
      op2: op2,
      operator: "add"
    })

    {:noreply, assign(socket, result: op1 + op2, history: History.list(history_pid))}
  end

  def handle_event(
        "subtract",
        _params,
        %{assigns: %{op1: op1, op2: op2, history_pid: history_pid}} = socket
      ) do
    History.update(history_pid, %{
      op1: op1,
      op2: op2,
      operator: "subtract"
    })

    {:noreply, assign(socket, result: op1 - op2, history: History.list(history_pid))}
  end

  def handle_event(
        "multiply",
        _params,
        %{assigns: %{op1: op1, op2: op2, history_pid: history_pid}} = socket
      ) do
    History.update(history_pid, %{
      op1: op1,
      op2: op2,
      operator: "multiply"
    })

    {:noreply, assign(socket, result: op1 * op2, history: History.list(history_pid))}
  end

  def handle_event(
        "divide",
        _params,
        %{assigns: %{op1: op1, op2: op2, history_pid: history_pid}} = socket
      ) do
    History.update(history_pid, %{
      op1: op1,
      op2: op2,
      operator: "divided"
    })

    {:noreply, assign(socket, result: op1 / op2, history: History.list(history_pid))}
  end

  def handle_event("clear_history", _params, %{assigns: %{history_pid: history_pid}} = socket) do
    History.clear(history_pid)
    {:noreply, assign(socket, history: History.list(history_pid))}
  end

  def handle_event("load_entry", %{"op1" => op1, "op2" => op2}, socket) do
    {first, second} = parse_input(op1, op2)
    {:noreply, assign(socket, op1: first, op2: second)}
  end

  def handle_event(_event, params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end

  defp parse_input(op1, op2) do
    {first, _} = Float.parse(op1)
    {second, _} = Float.parse(op2)
    {first, second}
  end
end
