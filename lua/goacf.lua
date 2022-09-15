local vim = vim

local function run(command)
  -- get command line output as space concat
  local handle = io.popen(command)
  local text = handle:read("*a")
  handle:close()

  result = {}
  for match in string.gmatch(text, "(.-)\n") do
    table.insert(result, match)
  end

  return result
end

local function exists(path)
  local f = io.open(path, "r")
  io.close(f)

  return f ~= nil
end

local function goacf()
  -- check .git repository
  if not exists('.git') then
    error('fatal: .git repository does not exist.')
  end

  -- save editing file before getting git status
  for i = 1, vim.fn.bufnr('$') do
    local buf_info = vim.fn.getbufinfo(i)

    if #buf_info > 0 and buf_info[1].changed == 1 then
      vim.api.nvim_command('write')
    end
  end

  local file_names = run('git status -uall --porcelain | grep -wv D | cut -b4-')

  if #file_names <= 0 then
    error('fatal: no changed files on .git repository.')
  end

  local name_set = {}
  for _, l in ipairs(file_names) do name_set[l] = true end

  for i = 1, vim.fn.bufnr('$') do
    local buf_name = vim.fn.bufname(i)
    local buf_listed = vim.fn.buflisted(i)

    if buf_listed == 1 and buf_name ~= '' then
      local relative_buf_file_name = vim.fn.fnamemodify(buf_name, ":~:.")

      -- close file if no git diff
      if name_set[relative_buf_file_name] ~= true then
        vim.api.nvim_command('bdelete ' .. relative_buf_file_name)
      end
    end
  end

  -- open git changed files
  vim.api.nvim_command('args ' .. table.concat(file_names, ' '))
  print('opened: ' .. #file_names .. ' file(s)')
end

return {
  goacf = goacf
}
