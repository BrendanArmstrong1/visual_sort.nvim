local config = require("sortvis.config")
local support = require("sortvis.support")

M = {}

M.setup = config.setup

M.sort_visual_block = function(descending)
  local mode = vim.fn.visualmode()
  if mode == "" then
    local y1, x1, y2, x2 = support.get_bounds()
    -- build the (line, string) array
    local visual_selection = support.build_visual_selection(y1, y2, x1, x2)
    --sort the (line, string array)
    support.sort_visual_selection(visual_selection, descending)

    for k, item in ipairs(visual_selection) do
      vim.api.nvim_buf_set_lines(0, y1 + k - 2, y1 + k - 1, false, item[3])
    end
  end
end

return M
