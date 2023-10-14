defmodule FlutterServerWeb.HelloLive do
  use Phoenix.LiveView
  use LiveViewNative.LiveView
  use FlutterServerWeb, :html
  alias LiveViewNativeFlutterUi.Dart

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
  def render(%{platform_id: :flutterui} = assigns) do
    # This UI renders on flutter
    ~FLUTTERUI"""
    <Scaffold>
      <AppBar>
        <title>
          <Text>Hello Native</Text>
        </title>
        <leading>
        <Icon size="20" name="menu" />
        </leading>
      </AppBar>
      <Container padding={10 + @counter} decoration={bg_color(@counter)}>
        <Form phx-change="validate" phx-submit="save">
          <ListView>
            <Container decoration="background: blue">
              <TextField decoration="fillColor: white; filled: true" name="myfield" value={"Current margin #{@counter}"}>
                <icon>
                  <Container decoration="background" padding="10">
                    <Icon size="20" name="key" />
                  </Container>
                </icon>
              </TextField>
            </Container>
            <Container decoration="background: white" margin="10 0 0 0">
              <TextField name="myfield2" decoration="fillColor: white; filled: true" value="Second field" />
            </Container>
            <Center>
              <Text style="textTheme: headlineMedium; fontWeight: bold; fontStyle: italic">
                Current Margin: <%= @counter %>
              </Text>
            </Center>
            <%= if rem(@counter, 2) == 1 do %>
              <Center><Text>the current margin is odd</Text></Center>
            <% else %>
              <Center><Text>the current margin is even</Text></Center>
            <% end %>
            <ElevatedButton phx-click="inc">
              <Text>
                Increment counter
              </Text>
            </ElevatedButton>
            <Container margin="10 0 0 0">
              <ElevatedButton phx-click={switch_theme("dark")}>
                <Text>
                  Switch dark
                </Text>
              </ElevatedButton>
            </Container>
            <Container margin="10 0 0 0">
            <ElevatedButton phx-click={switch_theme("light")}>
              <Text>
                Switch light
              </Text>
            </ElevatedButton>
          </Container>
            <Container margin="10 0 0 0">
              <ElevatedButton type="submit">
                <Text>
                  Submit form
                </Text>
              </ElevatedButton>
            </Container>
            <link patch={~p"/second-page"}><Text>LINK</Text></link>
            <Text><%= @form_field %></Text>
              <Container id="to_hide" padding="100 0 100 0" decoration="background: green">
                <Text>Text to hide</Text>
              </Container>
              <Text>something else</Text>
            <ElevatedButton phx-click={Dart.hide(to: "#to_hide")}>
              Hide Text
            </ElevatedButton>
            <ElevatedButton phx-click={Dart.show(to: "#to_hide")}>
              Show Text
            </ElevatedButton>
          </ListView>
        </Form>
      </Container>
    </Scaffold>
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
