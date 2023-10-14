defmodule FlutterServerWeb.Flutter.ThemesController do
  use FlutterServerWeb, :controller

  def default_light(conn, _params) do
    render(conn, :default_light)
  end

  def default_dark(conn, _params) do
    render(conn, :default_dark)
  end
end
