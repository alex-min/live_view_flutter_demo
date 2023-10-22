defmodule FlutterServerWeb.HelloLive do
  use Phoenix.LiveView
  use LiveViewNative.LiveView
  use FlutterServerWeb, :html
  alias LiveViewNativeFlutter.Dart

  @topic "hello_live"

  @impl true
  def mount(_params, _session, socket) do
    FlutterServerWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, form_field: "", counter: 0, form: to_form(%{}, as: "user"))}
  end

  def switch_theme(theme) do
    Dart.switch_theme(theme)
    |> Dart.save_current_theme()
  end

  @impl true
  def render(%{platform_id: :flutter} = assigns) do
    # This UI renders on flutter
    ~FLUTTER"""
      <flutter>
        <AppBar>
          <title>hello</title>
        </AppBar>
        <viewBody>
          <Container padding="10">
            <Container padding={10 + @counter} decoration={bg_color(@counter)}>
              <Text>Margin Countere <%= @counter %></Text>
              <ElevatedButton flutter-click="go_back">go back</ElevatedButton>
            </Container>
            <Row>
              <ElevatedButton phx-click={Dart.switch_theme("dark")}>Switch dark theme</ElevatedButton>
              <Container margin="0 20 0 0">
                <ElevatedButton phx-click={Dart.switch_theme("light")}>Switch light theme</ElevatedButton>
              </Container>
            </Row>
          </Container>
        </viewBody>
        <BottomNavigationBar currentIndex="0" selectedItemColor="blue-500">
          <BottomNavigationBarIcon name="home" label="Page 1" />
          <BottomNavigationBarIcon live-patch="/second-page" name="home" label="Page 2" />
          <BottomNavigationBarIcon phx-click="inc" name="arrow_upward" label="Increment" />
          <BottomNavigationBarIcon phx-click="dec" name="arrow_downward" label="Decrement" />
        </BottomNavigationBar>
      </flutter>
    """
  end

  @impl true
  def render(%{} = assigns) do
    # This UI renders on the web
    ~H"""
    <div class="flex flex-col w-full h-screen items-center justify-center">
      <div>Margin Counter: <%= @counter %> on the web</div>
      <button phx-click="inc" class="ml-2 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
       Increment counter
      </button>
      <.link patch={~p"/second-page"}>Second page</.link>
    </div>
    """
  end

  @impl true
  def handle_event("inc", _, socket) do
    new_state = update(socket, :counter, &(&1 + 1))
    FlutterServerWeb.Endpoint.broadcast_from(self(), @topic, "inc", new_state.assigns)
    {:noreply, new_state}
  end

  @impl true
  def handle_event("dec", _, socket) do
    new_state = update(socket, :counter, &(&1 - 1))
    FlutterServerWeb.Endpoint.broadcast_from(self(), @topic, "dec", new_state.assigns)
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
