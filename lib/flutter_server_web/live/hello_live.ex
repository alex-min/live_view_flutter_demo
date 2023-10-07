defmodule FlutterServerWeb.HelloLive do
  use Phoenix.LiveView
  use LiveViewNative.LiveView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, form_field: "", counter: 0, form: to_form(%{}, as: "user"))}
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
            <Container decoration="background: white">
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
            <TextButton phx-click="inc">
              <Text>
                Increment margin
              </Text>
            </TextButton>
            <Container margin="10 0 0 0">
              <TextButton type="submit">
                <Text>
                  Submit form
                </Text>
              </TextButton>
            </Container>
            <Text><%= @form_field %></Text>
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
    <div class="flex w-full h-screen items-center">
      implement here your web stuff
    </div>
    """
  end

  @impl true
  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :counter, &(&1 + 1))}
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
    "background: blueGrey"
  end
end
