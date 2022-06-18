URL = 'https://github.com/retrontology/retroCCscripts/raw/'
DEFAULT_BRANCH = 'main'
TARGET_DIR = '/'
TEMP_DIR = '/retrotemp'
PROGRAMS = {
    'retrostd',
    'retroturtle',
    'mine',
    'audio',
    'main_tunnel',
    'drop_cobble',
    'play_gif',
    'clear_land',
    'dlretro'
}

function main()

    local current_dir = shell.dir()

    local base_url = URL
    if arg[1] == nil then
        base_url = base_url .. DEFAULT_BRANCH
    else
        base_url = base_url .. arg[1]
    end
    base_url = base_url .. '/'

    fs.makeDir(TEMP_DIR)
    shell.setDir(TEMP_DIR)

    for k,program in pairs(PROGRAMS) do
        local file_name = program .. '.lua'
        local full_url = base_url .. file_name
        local result = shell.run('wget', full_url)
        if result then
            local target_file = TARGET_DIR .. '/' .. file_name
            fs.delete(target_file)
            fs.move(TEMP_DIR .. '/' .. file_name, target_file)
        else
            print('Could not download ' .. program)
        end
    end

    shell.setDir(current_dir)
    fs.delete(TEMP_DIR)

end


main()