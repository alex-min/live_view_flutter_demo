defmodule FlutterServerWeb.SecondPageLive do
  use Phoenix.LiveView
  use LiveViewNative.LiveView
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(%{platform_id: :flutterui} = assigns) do
    # This UI renders on flutter
    ~FLUTTERUI"""
      <Scaffold>
        <Text flutter-click="go_back">Second page</Text>
      </Scaffold>
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
