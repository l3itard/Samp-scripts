function main()
    while not isSampAvailable() do wait(200) end
    sampRegisterChatCommand("zakaz", zk)
    while true do
        wait(0)
    end
end

function zk()
    lua_thread.create(function()
        for id = 0, sampGetMaxPlayerId() do
            if sampIsPlayerConnected(id) then
                sampSendChat('/contract '..id..' 10000')
                wait(1500)
            end
        end
    end)
end