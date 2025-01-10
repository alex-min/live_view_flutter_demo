defmodule ServerTestWeb.SecondPageLive.Flutter do
  use ServerTestNative, [:render_component, format: :flutter]

  alias LiveViewNative.Flutter.Dart

  @impl true
  def render(assigns) do
    ~LVN"""
      <Text>Second page</Text>
    """
  end
end
