Citizen.CreateThread(function()
    for _, blipConfig in pairs(Config.Blips) do

        local blip = AddBlipForCoord(blipConfig.coords)

        SetBlipSprite(blip, blipConfig.id)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, blipConfig.scale)
        SetBlipColour(blip, blipConfig.color)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipConfig.name)
        EndTextCommandSetBlipName(blip)

        local area = AddBlipForRadius(blipConfig.coords.x, blipConfig.coords.y, blipConfig.coords.z, blipConfig.blipRadius)
        SetBlipColour(area, 1) 
        SetBlipAlpha(area, 100) 

        blipConfig.blip = blip
        blipConfig.area = area
    end
end)

function Draw3DSphere(coords, radius, r, g, b, a)
    DrawMarker(28, coords.x, coords.y, coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius * 2.0, radius * 2.0, radius * 2.0, r, g, b, a, false, false, 2, false, nil, nil, false)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, blipConfig in pairs(Config.Blips) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - blipConfig.coords)

            if distance < blipConfig.zoneRadius * 2 then
                Draw3DSphere(blipConfig.coords, blipConfig.zoneRadius, 255, 0, 0, 150)

                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    if DoesEntityExist(vehicle) then
                        local isDeleteEnabled = blipConfig.deleteVehicle
                        if isDeleteEnabled then
                            DeleteVehicle(vehicle)
                        end
                    end
                end
            end
        end
    end
end)