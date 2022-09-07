local vim = vim

local function run(command)
  -- get command line output as space concat
  local handle = io.popen(command)
  local result = handle:read("*a")
  local status = handle:close()

  return string.gsub(result, '\n', ' ')
end

function exists(path)
   local f = io.open(path, "r")

   if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function goacf()
  -- check .git repository
  if not exists('.git') then
    print('fatal: .git repository does not exist.')
    return
  end

  local file_names = run('git status -uall --porcelain | grep -wv D | cut -b4-')

  if #file_names <= 0 then
    print('fatal: no changed files on .git repository.')
    return
  end

  -- close all buffer
  vim.api.nvim_command('bufdo bwipeout')
  -- open git changed files
  vim.api.nvim_command('args ' .. file_names)
end

return {
  goacf = goacf
}
