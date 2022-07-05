URL = 'https://github.com/retrontology/retroCCscripts/raw/'
DEFAULT_BRANCH = 'main'
TARGET_DIR = '/'
TEMP_DIR = '/retrotemp'
INDEX = 'index'


function main()

    local current_dir = shell.dir()
    

    download_index(INDEX)

    require INDEX

    fs.makeDir(TEMP_DIR)
    shell.setDir(TEMP_DIR)

    for k,program in pairs(PROGRAMS) do
        download_program(program)
    end

    shell.setDir(current_dir)
    fs.delete(TEMP_DIR)

end

function download_index(index)
    if index == nil then
        index = INDEX
    end
    local file_name = index .. '.lua'
    local full_url = get_program_url(index)
    local result = shell.run('wget', full_url)
    if not result then
        error('Could not download ' .. program)
    end
end

function download_program(program)
    local file_name = program .. '.lua'
    local full_url = get_program_url(program)
    local result = shell.run('wget', full_url)
    if result then
        local target_file = TARGET_DIR .. '/' .. file_name
        fs.delete(target_file)
        fs.move(TEMP_DIR .. '/' .. file_name, target_file)
    else
        error('Could not download ' .. program)
    end
end

function get_program_url(program, branch)
    local base_url = URL
    if branch == nil then
        base_url = base_url .. DEFAULT_BRANCH
    else
        base_url = base_url .. branch
    end
    local result_url = base_url .. '/' .. program .. '.lua'
    return result_url 
end

main()