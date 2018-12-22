function startup()
    -- if config.json does not exist
        -- while not connected wifi
            -- soft ap file
            -- connq
        -- end while

    -- else
        -- while not connected
            -- connect wifi()
            -- listen mode()
    dofile("main.lua")
    print("--cikti--")
end

tmr.alarm(1, 1000, 1, function()
        tmr.stop(1)
        print("You have 5 seconds to abort")
        print("Waiting...")
        -- 5 saniye bekle sonra =>
        tmr.alarm(0, 5000, 0, startup)
end)
