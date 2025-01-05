defmodule ServerTestWeb.Layouts.SwiftUI do
  use ServerTestNative, [:layout, format: :swiftui]

  embed_templates "layouts_swiftui/*"
end
