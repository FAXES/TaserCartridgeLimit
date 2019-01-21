-----------------------------
--- Taser Cartridge Limit ---
---     Made by FAXES     ---
-----------------------------

--- Config ---

maxTaserCarts = 3 -- The amount of taser cartridges a person can have.
refillCommand = "reloadcart" -- The command to refill taser cartridges
longerTazeTime = true -- Want longer taze times? true/false
longerTazeSecTime = 20 -- Time in SECONDS to extend the longer taze time.

--- Code ---

local taserCartsLeft = maxTaserCarts

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

RegisterCommand(refillCommand, function(source, args, rawCommand)
    taserCartsLeft = maxTaserCarts
    print("[Fax Taser Cartridge] Taser Cartridges Left = " .. taserCartsLeft)
    ShowNotification("~g~Taser Cartridges Refilled.")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local taserModel = GetHashKey("WEAPON_STUNGUN")

        if GetSelectedPedWeapon(ped) == taserModel then
            if IsPedShooting(ped) then
                taserCartsLeft = taserCartsLeft - 1
                print("[Fax Taser Cartridge] Taser Cartridges Left = " .. taserCartsLeft)
            end
        end

        if taserCartsLeft <= 0 then
            if GetSelectedPedWeapon(ped) == taserModel then
                SetPlayerCanDoDriveBy(ped, false)
                DisablePlayerFiring(ped, true)
                if IsControlPressed(0, 106) then
                    ShowNotification("~y~You have no taser cartridges left. please use /" .. refillCommand)
                end
            else
                -- Do nothing
            end
        end

        if longerTazeTime then
            SetPedMinGroundTimeForStungun(ped, longerTazeSecTime * 1000)
        end
    end
end)
