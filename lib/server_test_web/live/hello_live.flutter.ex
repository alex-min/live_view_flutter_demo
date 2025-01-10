defmodule ServerTestWeb.HelloLive.Flutter do
  use ServerTestNative, [:render_component, format: :flutter]
  import ServerTestWeb.HelloLive

  alias LiveViewNative.Flutter.Dart

  @impl true
  def render(assigns) do
    # This UI renders on flutter
    ~LVN"""
        <Container padding="10">
          <Container padding={10 + @counter} decoration={bg_color(@counter)}>
            <Text>Margin Counter <%= @counter %></Text>
          </Container>
          <Row>
            <Column>
              <ElevatedButton phx-value-rr="ee" phx-click={Dart.switch_theme("dark")}>Switch dark theme</ElevatedButton>
              <Container margin="10 0 0 0">
                <ElevatedButton phx-click={Dart.switch_theme("light")}>Switch light theme</ElevatedButton>
              </Container>
            </Column>
            <Container margin="0 10 0 0">
              <Column>
                <ElevatedButton phx-click="inc">Increment counter</ElevatedButton>
                <Container margin="10 0 0 0">
                  <ElevatedButton phx-click="dec">Decrement counter</ElevatedButton>
                </Container>
              </Column>
            </Container>
          </Row>
        </Container>
    """
  end
end
