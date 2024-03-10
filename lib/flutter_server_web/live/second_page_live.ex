defmodule FlutterServerWeb.SecondPageLive do
  use Phoenix.LiveView
  use LiveViewNative.LiveView
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(%{platform_id: :flutter} = assigns) do
    # This UI renders on flutter
    ~FLUTTER"""
      <flutter>
        <AppBar>
          <title>second page</title>
        </AppBar>
        <viewBody>
          <Center>
            <Container>
              <Text style="textTheme: bodyLarge; fontWeight: bold" flutter-click="go_back">Second page</Text>
            </Container>
          </Center>
        </viewBody>
        <BottomNavigationBar currentIndex="1" selectedItemColor="blue-500">
          <BottomNavigationBarItem live-patch="/" icon="home" label="Page 1" />
          <BottomNavigationBarItem icon="home" label="Page 2" />
          <BottomNavigationBarItem phx-click="inc" icon="arrow_upward" label="Increment" />
          <BottomNavigationBarItem phx-click="dec" icon="arrow_downward" label="Decrement" />
        </BottomNavigationBar>
      </flutter>
    """
  end

  @impl true
  def render(%{} = assigns) do
    # This UI renders on the web
    ~H"""
    <div class="flex w-full h-screen items-center justify-center">
      Second page
    </div>
    """
  end
end
