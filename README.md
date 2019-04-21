[![Hex.pm](https://img.shields.io/hexpm/v/ex_cell.svg)](https://hex.pm/packages/ex_cell)
[![CircleCI](https://circleci.com/gh/DefactoSoftware/ex_cell/tree/master.svg?style=shield)](https://circleci.com/gh/DefactoSoftware/ex_cell)

# ex_cell

A module for creating coupled modules of CSS, Javascript and Views in Phoenix.

## Installation

Add the following to the dependencies in `mix.exs`:

```ex
{:ex_cell, "~> 0.0.14"}
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
    use ExCell.Cell, namespace: AppWeb,
                     adapter: ExCell.Adapters.CellJS

    use Phoenix.View, root: "lib/app_web/cells",
                      path: ExCell.View.relative_path(__MODULE__, AppWeb)

    import Phoenix.Controller,
           only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

    use Phoenix.HTML

    import AppWeb.Router.Helpers
    import AppWeb.Gettext

    # Add everything you want to use in the cells
  end
end
```

Now you can add a cells/ directory in lib/app_web and place cells in that
directory.

Every cell should contain a view.ex and a template.html.eex. The view and
template are tightly linked together by the Cell.

## CSS

To ensure all the CSS can be placed next to your cell you need to add the
following to your `brunch-config.js`:

```js
...
stylesheets: {
  joinTo: {
    "css/app.css": [
      "assets/css/app.css",
      "lib/app_web/cells/**/*.css"
    ]
  }
}
...
```

If you use something other than [Brunch](https://brunch.io) to manage your assets,
you need to add the files to the assets manager of choice.


## Javascript

If you wish to use the accompanying [cell-js](https://github.com/DefactoSoftware/cell-js)
library you can install it with your package manager. After you installed the
Javascript package, add the following to your `brunch-config.js`:

```js
...
javascripts: {
  joinTo: {
    "js/vendor.js": /^node_modules/,
    "js/app.js": [
      "assets/js/**/*.js",
      "lib/app_web/cells/**/*.js"
    ]
  }
}
...
```

## Usage

A cell consists of a couple of files:

```
cells
|- avatar
|  |- template.html.eex
|  |- view.ex
|  |- style.css (optional)
|  |- index.js (optional)
|- header
...
```

You can render the cell in a view, controller or another cell by adding the
following code:

```ex
cell(AvatarCell, class: "CustomClassName", user: %User{})
```

This would generate the following HTML when you render the cell:

```html
<span class="AvatarCell" data-cell="AvatarCell" data-cell-params="{}">
  <img src="/images/foo/avatar.jpg" class="AvatarCell-Image" alt="foo" />
</span>
```

### view.ex

Views of cells behave like normal views in Phoenix, except that they have
provide a container method that can be used in a template to render the
appropriate HTML needed to initialize the Javascript for a cell and have a
predefined class that is the same as the cell name minus the namespace.

```ex
# lib/app_web/cell/avatar/view.ex
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

### template.html.eex

The template behave like any other template in Phoenix except that they have
access to a container method to render the appropriate cell HTML container:

```eex
<!-- lib/app_web/cell/avatar/template.html.eex -->
<%= container(tag: :span,  class: class_names(assigns)) do %>
  <%= if image_path = avatar_image_path(@user) do %>
    <%= img_tag(image_path, class: class_name("image"), alt: avatar_image_alt(@user)) %>
  <% end %>
<% end %>
```

### style.css

This can be any type of CSS file that you wish (preprocessed or other wise).
Because cells provides methods to namespace your CSS you are advised to use a
similar namespace or use something like [postcss-modules](https://github.com/css-modules/postcss-modules)
to ensure all classes defined are unique.

```css
/* lib/app_web/cell/avatar/style.css */
.AvatarCell {
  border-radius: 50%;
  height: 50px;
  width: 50px;
}

.AvatarCell-image {
  display: inline-block;
  max-width: 100%;
}
```

### index.js

If you use [cell-js](https://github.com/DefactoSoftware/cell-js) you can create
Javascript that is tightly coupled to the cell:

```js
// lib/app_web/cell/avatar/index.js
import { Cell, Builder } from "cells-js";

class AvatarCell extends Cell {
  initialize() {
    this.element.addEventListener("click", this.onToggleOpenClass);
  }

  onToggleOpenClass = e => this.element.classList.toggle("open");
}

Builder.register(AvatarCell, "AvatarCell");

export default AvatarCell;
```

## Nested cells

For nested cells (e.g. `AppWeb.User.AvatarCell`) make sure you include the
namespace in the stylesheet/javascript.

```css
.User-AvatarCell {}
```

```js
Builder.register(AvatarCell, "User-AvatarCell");
```

When in doubt, the cell name corresponds to the `data-cell` attribute on the DOM element.


## Webpack configuration

If you use webpack, you can easily configure it.

#### 1. Import the context of the folder in which you have cells. Next import the library into app.js, which is a webpack input file:

```js
// assets/src/js/app.js

...
const importAll = function(r) {
  r.keys().forEach(r)
}

importAll(require.context("../../../lib/YOUR_DIRECTORY/cells", true, /\.js$/))

import Builder from "@vendor/cell/builder" // <-- @vendor is an alias from webpack.config.js, take a look below.
...
```

#### 2. Create aliases in the webpack configuration file:

```js
// assets/webpack.config.js

...
  resolve: {
    symlinks: false,
    modules: ["node_modules"],
    alias: {
      "@": path.resolve(__dirname, "./src/js"),
      "@cells": path.resolve(__dirname, "../lib/YOUR_DIRECTORY/cells"),
      "@vendor": path.resolve(__dirname, "./vendor"),
      "@libs": path.resolve(__dirname, "./node_modules")
    }
  },
...
```

#### 3. Also works fine with [cell-js](https://github.com/DefactoSoftware/cell-js) plugin. Just create the index.js file in the target cell and use the aliases to import the library.

#### E.g. calendar:

```js
// cells/calendar/index.js

...
import Cell  from "@vendor/cell/cell"
import Builder from "@vendor/cell/builder"
import moment from "@libs/moment" // <-- JS library

class CalendarCell extends Cell {
  initialize() {}
}

Builder.register(CalendarCell, "CalendarCell")

export default CalendarCell

...
```
