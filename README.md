[![Hex.pm](https://img.shields.io/hexpm/v/ex_cell.svg)](https://hex.pm/packages/ex_cell)
[![CircleCI](https://circleci.com/gh/DefactoSoftware/ex_cell/tree/master.svg?style=shield)](https://circleci.com/gh/DefactoSoftware/ex_cell)

# ex_cell
A module for creating coupled modules of CSS, Javascript and Views in Phoenix

## Installation

add the following to the dependencies in `mix.exs`
```ex
{:ex_cell, "~> 0.0.4"}
```

In Phoenix 1.3.0+ add the following to `lib/app_web/web.ex`:

```ex

def controller do
  quote do
  ...

  import ExCell.Controller

  ...
  end
end

def view(opts \\ []) do
  quote do
    ...

    import ExCell.View

    ...
  end
end

def cell(opts \\ []) do
  quote do
    use ExCell.Cell, namespace: unquote(opts[:namespace]) || AppWeb

    use Phoenix.View, root: unquote(opts[:root]) || "lib/app_web/cells",
                      path: __MODULE__
                            |> ExCell.View.relative_path(
                              unquote(opts[:namespace]) || AppWeb
                            )

    import Phoenix.Controller,
           only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

    use Phoenix.HTML

    import AppWeb.Router.Helpers
    import AppWeb.Gettext

    # Add everything you want to use in the cells
  end
end
```

Now you can add a cells/ directory in lib/app_web and place cells in that directory.
Every cell should contain a view.ex and a template.html.eex

For an AvatarCell the following would apply

```ex
#lib/app_web/cell/avatar/template.html.ex
<%= container(tag: :span,  class: class_names(assigns)) do %>
  <%= if image_path = avatar_image_path(@user) do %>
    <%= img_tag(image_path, class: class_name("image"), alt: avatar_image_alt(@user)) %>
  <% end %>
<% end %>
```

```ex
#lib/app_web/cell/avatar/view.ex
defmodule AppWeb.AvatarCell do
  @moduledoc """
  The avatar cell used to render the user avatars.
  """

  use AppWeb, :cell
  alias App.Accounts.Avatar

  def class_names(assigns) do
    [assigns[:class], class_name(assigns[:size])]
    |> Enum.reject(fn(v) -> is_nil(v) end)
  end

  def avatar_image_path(user) do
    Avatar.url({user.avatar, user}, :thumb)
  end

  def avatar_image_alt(user) do
    [user.first_name, user.last_name]
    |> Enum.join(" ")
    |> String.trim()
  end
end
```
