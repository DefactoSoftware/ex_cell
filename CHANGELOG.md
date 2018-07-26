# v0.0.12

* Use Phoenix.Controller.put_view to address the view that's shown since
  render/4 is being depricated in 1.4 (#44)

# v0.0.11

* Added fallback when `data: nil` to prevent errors (#39) (#40).

# v0.0.10

* Introduced an extra argument to the containers that creates a unique ID. The unique ID is used to create specific cell elements. The cell elements function can be used by passing a function instead of content that contains a map with a `element` function (#35) (#36).

# v0.0.9

## Changes

* Reworked the approach to render the containers. It now uses an adapter that
  you have to configure. The adapter is used to output the actual HTML. For now,
  the adapter provided is the
  [CellJS adapter](https://github.com/DefactoSoftware/cells-js) (#30)
* The CellJS adapter no longer accepts a `closing_tag` attribute as added in the
  previous release. The CellJS adapter no automatically closes self closing tags
  (#31)

# v0.0.8

## Changed

* Use Phoenix.content_tag instead of Phoenix.tag by default and add option to
  remove the closing tag by adding `closing_tag: false` to the options (#27)
* The attribute name is now used to set the `data-cell` attribute and can be
  overridden to allow prefixing (#28)

# v0.0.7

## Changed

* Added a cell render method to ExCell.Controller to directly render cells as a
  view (#23)

## Fixed

* Removed unused Base alias in `lib/ex_cell/base.ex` (#22)

# v0.0.6

## Changed

* Updated `README.md` with more elaborate examples and install instructions
  (#19)
* Removed the need for a `MockCellAdapter` in tests (#18)
* Restructured the code to allow documentation (#18)

## Removed

* The option to provide a `MockCellAdapter` in the configuration (#18)

# v0.0.5

## Changed

* Cell module didn't use a fallback adapter for the `__using__` macro (#16)
* Added back the `View.relative_path` method (#15)

# v0.0.4

## Changed

* Fixed a bug where the Mix configuration wasn't allowing empty configurations
  (#13)

# v0.0.3

## Added

* Adapters can are now in a `config.ex` (#10)

## Changed

* Removed the need to specify an adapter for views and controllers (#10)
* ExCell.Controller is imported instead of using the `__using__` macro (#10)

## Removed

* It's no longer possible to specify the adapter through the `__using__` Macro
  (#10)
