print("hello world!")

-- FA722409011133
-- FA722406011121
-- FA722406023452
-- FA722406011134
-- FA722406036545
-- FA722406011156
-- FA722406036947
-- FA722406035248
-- FA722408011139

local function table_invert(t)
  local s = {}
  for k, v in ipairs(t) do
    print(vim.inspect(v), k)
    s[vim.inspect(v)] = k
  end
  return s
end

vim.api.nvim_create_user_command("SortVis", function(_)
  local mode = vim.fn.visualmode()
  if mode == "" then
    table.unpack = table.unpack or unpack -- 5.1 compatibility
    -- get the selection area
    local vis_start_row, vis_start_col = table.unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local vis_end_row, vis_end_col = table.unpack(vim.api.nvim_buf_get_mark(0, ">"))
    if vis_start_row > vis_end_row then
      vis_end_row, vis_start_row = vis_start_row, vis_end_row
    end
    if vis_start_col > vis_end_col then
      vis_end_col, vis_start_col = vis_start_col, vis_end_col
    end

    -- build the (line, string) array
    local vis_selection = {}
    local index = 1
    for i = vis_start_row - 1, vis_end_row - 1, 1 do
      vis_selection[index] = {
        index + vis_start_row - 1,
        vim.api.nvim_buf_get_text(0, i, vis_start_col, i, vis_end_col + 1, {})[1],
      }
      index = index + 1
    end

    --sort the (line, string array)
    table.sort(vis_selection, function(a, b)
      if a[2] == "" then
        return false
      end
      return a[2] < b[2]
    end)
    local inverted_table = table_invert(vis_selection)

    -- vis_selection is now sorted
    for k, item in ipairs(vis_selection) do
      local original_line = vim.api.nvim_buf_get_lines(0, vis_start_row - 2 + k, vis_start_row - 1 + k, false)
      local target_line = vim.api.nvim_buf_get_lines(0, item[1] - 1, item[1], false)
      local original_line_range = vim.api.nvim_buf_get_text(
        0,
        vis_start_row - 2 + k,
        vis_start_col,
        vis_start_row - 2 + k,
        vis_end_col + 1,
        {}
      )[1]
      local original_line_string = "{ " .. vis_start_row - 1 + k .. ', "' .. original_line_range .. '" }'
      local index_in_sorted = inverted_table[original_line_string]
      print("original_string")
      print(original_line_string)
      print("inverted_table")
      print(vim.inspect(inverted_table))
      print("index_in_inverted")
      print(index_in_sorted)
      print("sorted_vis_selection")
      print(vim.inspect(vis_selection))
      vis_selection[index_in_sorted][1] = item[1]
      vim.api.nvim_buf_set_lines(0, vis_start_row - 1, vis_start_row, false, target_line)
      vim.api.nvim_buf_set_lines(0, item[1], item[1] + 1, false, original_line)
    end
  end
end, { range = true })
