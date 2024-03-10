local config = require("sortvis.config")
local support = require("sortvis.support")

M = {}

M.setup = config.setup

-- 3
-- 1
-- 2
-- 0

-- 4
-- 5
-- 6

-- 1
-- 2
-- 3

-- FA722406011121
-- FA722406011121
-- FA722406011134
-- FA722406011156
-- FA722406023452
-- FA722406035248
-- FA722406036545
-- FA722406036947
-- FA722408011139

M.sort_visual_block = function(descending)
  local mode = vim.fn.visualmode()
  if mode == "" then
    local y1, x1, y2, x2 = support.get_bounds()
    -- build the (line, string) array
    local visual_selection = support.build_visual_selection(y1, y2, x1, x2)
    --sort the (line, string array)
    support.sort_visual_selection(visual_selection, descending)
    -- partial functions for cleaner look
    local get_lines = support.get_lines(y1)

    -- visual_selection is now sorted
    local seen = {}

    for k, item in ipairs(visual_selection) do
      local orig, targ = get_lines(k, item)
      if seen[item[1]] then
        vim.api.nvim_buf_set_lines(0, y1 - 2 + k, y1 - 1 + k, false, seen[item[1]])
      else
        vim.api.nvim_buf_set_lines(0, y1 - 2 + k, y1 - 1 + k, false, targ)
        seen[k + y1 - 1] = orig
      end
    end
  end
end

return M
