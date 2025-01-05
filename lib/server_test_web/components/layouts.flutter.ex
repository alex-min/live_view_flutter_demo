defmodule ServerTestWeb.Layouts.Flutter do
  use ServerTestNative, [:layout, format: :flutter]

  embed_templates("layouts_flutter/*")
end
