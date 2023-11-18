local vim = vim

local function run(command)
  -- get command line output as space concat
  local result = {}
  local handle = io.popen(command)

  if handle then
    local text = handle:read("*a")
    handle:close()

    for match in string.gmatch(text, "(.-)\n") do
      table.insert(result, match)
    end
  end

  return result
end

local function save_buffers()
  for i = 1, vim.fn.bufnr('$') do
    local buf_info = vim.fn.getbufinfo(i)

    if #buf_info > 0 and buf_info[1].changed == 1 then
      vim.api.nvim_command('write')
    end
  end
end

local function close_buffers(args)
  local ignore_files = args.ignore_files or {}

  local name_set = {}
  for _, l in ipairs(ignore_files) do
    name_set[l] = true
  end

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
end

--
-- Git open blob file
--
local function goacf()
  -- check .git repository
  if vim.fn.empty(vim.fn.glob('.git')) == 1 then
    vim.notify('fatal: .git does not exist on current directory.', vim.log.levels.ERROR)
    return
  end

  -- save editing buffers
  save_buffers()

  -- fetch file names corresponding to git diff status
  local diff_file_names = run('git status -uall --porcelain | grep -wv D | cut -b4-')
  if #diff_file_names <= 0 then
    vim.notify('fatal: no changed files on .git repository.', vim.log.levels.ERROR)
    return
  end

  -- close buffers with some ignoring files
  close_buffers({
    ignore_files = diff_file_names,
  })

  -- open git changed files
  vim.api.nvim_command('args ' .. table.concat(diff_file_names, ' '))
  vim.notify('opened: ' .. #diff_file_names .. ' file(s)')
end

return {
  goacf = goacf,
}
