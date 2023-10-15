-----------------------------
--- Taser Cartridge Limit ---
---     Made by FAXES     ---
-----------------------------

--- Config ---

maxTaserCarts = 2 -- The amount of taser cartridges a person can have.
refillCommand = "refill" -- The command to refill taser cartridges
longerTazeTime = false -- Want longer taze times? true/false
longerTazeSecTime = 20 -- Time in SECONDS to extend the longer taze time.
PoliceVehicle = true -- If player needs to be in a police vehicle to obtain new carts.

--- Code ---

local taserCartsLeft = maxTaserCarts

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

RegisterCommand(refillCommand, function(source, args, rawCommand)		
    local ped = PlayerPedId()
	if PoliceVehicle then 
    	if IsPedInAnyPoliceVehicle(ped, true) then
        	taserCartsLeft = maxTaserCarts
        	ShowNotification("~g~Taser Cartridges Refilled.")
    	else
			    ShowNotification("~r~You must be in your patrol vehicle to refill.")
		  end
	else
      ShowNotification("~w~Refilling...")
      Citizen.Wait(3000)
      taserCartsLeft = maxTaserCarts
      ShowNotification("~g~Taser Cartridges Refilled.")
  end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local taserModel = GetHashKey("WEAPON_STUNGUN")

        if not HasStreamedTextureDictLoaded("mpweaponsgang0") then
            RequestStreamedTextureDict("mpweaponsgang0", true)
            while not HasStreamedTextureDictLoaded("mpweaponsgang0") do
                Wait(1)
            end
        end 

        if GetSelectedPedWeapon(ped) == taserModel then
            DrawSprite("mpweaponsgang0", "w_pi_stungun", 0.685 - 1.0 / 2, 1.325 - 1.0 / 2 + 0.005, 0.055, 0.055, 0.0, 200, 200, 200, 255)
            draw(taserCartsLeft,  0.684 - 1.0 / 2, 1.315 - 1.0 / 2 + 0.005);
            if IsPedShooting(ped) then
                taserCartsLeft = taserCartsLeft - 1
                --print("[Fax Taser Cartridge] Taser Cartridges Left = " .. taserCartsLeft)
            end
        end

        if taserCartsLeft <= 0 then
            if GetSelectedPedWeapon(ped) == taserModel then
                draw2("X",  0.682 - 1.0 / 2, 1.315 - 1.0 / 2 + 0.005);
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

function draw(text, posx, posy)
    SetTextFont(4);
    SetTextScale(0.0, 0.55);
    SetTextJustification(1);
    SetTextColour(250, 250, 120, 255);
    SetTextDropshadow(1, 255, 255, 255, 255);
    SetTextEdge(1, 0, 0, 0, 205);
    BeginTextCommandDisplayText("STRING");
    AddTextComponentSubstringPlayerName(text);
    EndTextCommandDisplayText(posx, posy);
end

function draw2(text, posx, posy)
    SetTextFont(4);
    SetTextScale(0.0, 0.55);
    SetTextJustification(1);
    SetTextColour(255, 0, 0, 255)
    SetTextDropshadow(1, 255, 255, 255, 255);
    SetTextEdge(1, 0, 0, 0, 205);
    BeginTextCommandDisplayText("STRING");
    AddTextComponentSubstringPlayerName(text);
    EndTextCommandDisplayText(posx, posy);
end
