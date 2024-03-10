local M = {}

M.table_invert = function(t)
  local s = {}
  for k, v in ipairs(t) do
    s[vim.inspect(v)] = k
  end
  return s
end

M.get_bounds = function()
  table.unpack = table.unpack or unpack -- 5.1 compatibility
  -- get the selection area
  local y1, x1 = table.unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local y2, x2 = table.unpack(vim.api.nvim_buf_get_mark(0, ">"))
  if y1 > y2 then
    y2, y1 = y1, y2
  end
  if x1 > x2 then
    x2, x1 = x1, x2
  end
  return y1, x1, y2, x2
end

M.build_visual_selection = function(y1, y2, x1, x2)
  local visual_selection = {}
  local index = 1
  for i = y1 - 1, y2 - 1, 1 do
    visual_selection[index] = {
      index + y1 - 1,
      vim.api.nvim_buf_get_text(0, i, x1, i, x2 + 1, {})[1],
    }
    index = index + 1
  end
  return visual_selection
end

M.sort_visual_selection = function(visual_selection, descending)
  table.sort(visual_selection, function(a, b)
    if a[2] == "" then
      return false
    end
    if descending == "rev" then
      return a[2] > b[2]
    else
      return a[2] < b[2]
    end
  end)
end

M.get_lines = function(y1)
  local function wrapper(k, item)
    local original_line = vim.api.nvim_buf_get_lines(0, y1 - 2 + k, y1 - 1 + k, false)
    local target_line = vim.api.nvim_buf_get_lines(0, item[1] - 1, item[1], false)
    return original_line, target_line
  end
  return wrapper
end


return M
