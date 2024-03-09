M = {}
function M.setup()
  vim.api.nvim_create_user_command("SortVis", function()
    require("sortvis").sort_visual_block()
  end, {range = true})
end
return M
