# onepager.nvim

> **Note:** This is a vibecoded project built with AI assistance.

A minimal Neovim plugin that constrains editing to A4 paper dimensions. Opens `.omd` files in a fixed-width column/row grid (12pt font, 25.4mm margins).

## Features

- `.omd` files open with fixed `textwidth` and `colorcolumn`
- Lines wrap at column boundary (no soft wrap)
- Rows capped at A4 page height
- Buffer becomes read-only when full

## Installation

Using [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "dhanudhara/onepager-nvim",
  opts = {}
}
```

## Usage

Create or open any `.omd` file:

```vim
:edit my_document.omd
```

The buffer will be constrained to A4 dimensions at 12pt font size.
