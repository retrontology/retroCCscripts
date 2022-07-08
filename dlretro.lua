URL = 'https://github.com/'
API_URL = 'https://api.github.com/'
REPO = 'retrontology/retroCCscripts'
DEFAULT_BRANCH = 'main'
TARGET_DIR = '/'
INDEX = 'index'
META_DIR = '/retrometa/'


function main()
    fs.makeDir(META_DIR)
    update_index(INDEX)
    require(META_DIR .. INDEX)
    for k,program in pairs(PROGRAMS) do
        download_program(program)
    end
end

function update_index(index)
    if index == nil then
        index = INDEX
    end
    local file_name = META_DIR .. index .. '.lua'
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
    if branch == nil then
        branch = DEFAULT_BRANCH
    end
    local url = URL .. REPO .. '/raw/' .. branch .. url .. '/' .. program .. '.lua'
    return url 
end

function download(url, path)
    local result = http.get(url)
    if path == nil then 
        path = string.match(url, ".*/(.*)")
    end
    if not result then
        error('Could not download ' .. url)
    else
        local outfile = fs.open(path, 'w')
        outfile.write(result.readAll())
        outfile.close()
    end
    result.close()
end

function get_remote_sha(program, branch)
    if branch == nil then
        branch = DEFAULT_BRANCH
    end
    local url = API_URL .. 'repos/' .. REPO .. '/contents/' .. program .. '.lua?ref=' branch
    local result = http.get(url)
    if not result then
        error('Could not fetch sha for ' .. program)
    end
    result = unserializeJSON(result.readAll())
    return result.sha
end

function get_local_sha(program)

end

main()