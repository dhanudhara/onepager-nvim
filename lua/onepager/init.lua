local M = {}

local function calculate_dimensions()
  local pt_to_mm = 0.352778

  local font_size_pt = 12
  local font_size_mm = font_size_pt * pt_to_mm
  local char_width_mm = font_size_mm * 0.6

  local a4_width_mm = 210
  local a4_height_mm = 297
  local margin_mm = 25.4

  local usable_width_mm = a4_width_mm - 2 * margin_mm
  local usable_height_mm = a4_height_mm - 2 * margin_mm

  local cols = math.floor(usable_width_mm / char_width_mm)
  local rows = math.floor(usable_height_mm / font_size_mm)

  return cols, rows
end

local function setup_buffer_boundary(bufnr, cols, rows)
  vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    local win = vim.fn.bufwinid(bufnr)
    if win > 0 then
      vim.wo[win].wrap = false
      vim.wo[win].colorcolumn = tostring(cols)
    end
    vim.bo[bufnr].textwidth = cols
    vim.bo[bufnr].formatoptions = "t"

    local group = vim.api.nvim_create_augroup("OnePagerBlock", { clear = true })
    vim.api.nvim_create_autocmd("TextChangedI", {
      group = group,
      buffer = bufnr,
      callback = function()
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local last_line = lines[#lines]
        if last_line and #last_line > cols then
          lines[#lines] = string.sub(last_line, 1, cols)
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        end
        if #lines > rows then
          vim.api.nvim_buf_set_lines(bufnr, rows, -1, false, {})
          vim.bo[bufnr].readonly = true
          vim.notify("[OnePager] Rows full! Read-only.")
        end
      end,
    })
  end)
end

function M.setup()
  local cols, rows = calculate_dimensions()
  local group = vim.api.nvim_create_augroup("OnePager", { clear = true })

  vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
    group = group,
    pattern = "*.omd",
    callback = function(args)
      local bufnr = args.buf
      vim.bo[bufnr].filetype = "markdown"
      setup_buffer_boundary(bufnr, cols, rows)
      vim.notify(string.format("[OnePager] Bound to %d x %d (A4 @ 12pt)", cols, rows))
    end,
  })

  print(string.format("OnePager: .omd → %d cols × %d rows (A4 @ 12pt)", cols, rows))
end

M.setup()

return {}