M = {}
function M.setup()
  vim.api.nvim_create_user_command("SortVis", function(args)
    if args.bang then
      require("sortvis").sort_visual_block("rev")
    else
      require("sortvis").sort_visual_block()
    end
  end, {range = true, bang = true})
end
return M
