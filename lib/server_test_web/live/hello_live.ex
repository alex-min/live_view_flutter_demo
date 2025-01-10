defmodule ServerTestWeb.HelloLive do
  use ServerTestWeb, :live_view
  use ServerTestNative, :live_view
  alias LiveViewNative.Flutter.Dart

  @topic "hello_live"

  @impl true
  def mount(_params, _session, socket) do
    ServerTestWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, form_field: "", counter: 0, form: to_form(%{}, as: "user"))}
  end

  def switch_theme(theme) do
    Dart.switch_theme(theme)
    |> Dart.save_current_theme()
  end

  @impl true
  def handle_event("inc", _, socket) do
    new_state = update(socket, :counter, &(&1 + 1))
    ServerTestWeb.Endpoint.broadcast_from(self(), @topic, "inc", new_state.assigns)
    {:noreply, new_state}
  end

  @impl true
  def handle_event("dec", _, socket) do
    new_state = update(socket, :counter, &(&1 - 1))
    ServerTestWeb.Endpoint.broadcast_from(self(), @topic, "dec", new_state.assigns)
    {:noreply, new_state}
  end

  def handle_event("validate", %{"myfield2" => field}, socket) do
    {:noreply, assign(socket, form_field: field)}
  end

  def handle_event("save", _params, socket) do
    {:noreply, socket}
  end

  def bg_color(counter) when counter > 10 do
    "background: green-50"
  end

  def bg_color(_counter) do
    "background: @theme.colorScheme.background"
  end

  def handle_info(msg, socket) do
    {:noreply, assign(socket, counter: msg.payload.counter)}
  end
end
