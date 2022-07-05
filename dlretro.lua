require "retrostd"

URL = 'https://github.com/retrontology/retroCCscripts/raw/'
DEFAULT_BRANCH = 'main'
TARGET_DIR = '/'
INDEX = 'index'


function main()
    update_index(INDEX)
    require(INDEX)
    for k,program in pairs(PROGRAMS) do
        download_program(program)
    end
end

function update_index(index)
    if index == nil then
        index = INDEX
    end
    local file_name = TARGET_DIR .. '/' .. index .. '.lua'
    local full_url = get_program_url(index)
    download(full_url, file_name)
    print('Successfully updated package index from ' .. full_url)
end

function download_program(program)
    local file_name = TARGET_DIR .. '/' .. program .. '.lua'
    local full_url = get_program_url(program)
    download(full_url, file_name)
    print('Downloaded ' .. program)
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