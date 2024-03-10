M = {}
function M.setup()
  vim.api.nvim_create_user_command("SortVis", function(args)
    local largs = args.fargs[1]
    require("sortvis").sort_visual_block(largs)
  end, {range = true, nargs = "*"})
end
return M
