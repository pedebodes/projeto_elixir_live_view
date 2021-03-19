defmodule ProjetinhoWeb.PageLive do
  use ProjetinhoWeb, :live_view

  @colors_pt_en [
    {"rosa", "pink"},
    {"vermelho", "red"},
    {"roxo", "purple"},
    {"verde", "green"},
    {"branco", "white"},
    {"azul", "blue"}
  ]

  @interval 3000

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(@interval, :tick)
    end

    {:ok, assign(socket, x: 0, y: 0, color: choose_color(), cores: @colors_pt_en)}
  end

  def render(assigns) do
    ~L"""
    <section phx-window-keydown="keydown" class="phx-hero">
      <pre><%= inspect({@x, @y}) %></pre>
      <svg width="700" height="350">
        <rect x="<%= @x * 25 %>" y="<%= @y * 25 %>"
         width="25" height="25" style="fill:<%= @color %>;" />
      </svg>
      <pre><%= inspect(get_color_name(@color)) %></pre>
    </section>
    """
  end

  def handle_info(:tick, socket) do
    {:noreply, assign(socket, color: choose_color())}
  end

  defp choose_color() do
    @colors_pt_en
    |> Enum.map(fn {_, en} -> en end)
    |> Enum.random()
  end

  defp get_color_name(color) do
    @colors_pt_en
    |> Enum.find(fn {_pt, en} -> color == en end)
    |> elem(0)
  end

  def handle_event("keydown", %{"key" => "ArrowRight"}, socket) do
    {:noreply, update(socket, :x, &(&1 + 1))}
  end

  def handle_event("keydown", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, update(socket, :x, &(&1 - 1))}
  end

  def handle_event("keydown", %{"key" => "ArrowUp"}, socket) do
    {:noreply, update(socket, :y, &(&1 - 1))}
  end

  def handle_event("keydown", %{"key" => "ArrowDown"}, socket) do
    {:noreply, update(socket, :y, &(&1 + 1))}
  end

  def handle_event("keydown", _key, socket) do
    {:noreply, socket}
  end
end