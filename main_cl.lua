speeddivider, speedLocker = 2.237, false

TriggerEvent('chat:addSuggestion', '/cam', 'Turn on/off or Lock Cinematic Cam', {
    { name="on or off", help ="on | off" }
})

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
            local ped = GetPlayerPed(-1)
            local vehicleId = GetVehiclePedIsIn(ped, false)
            local vehicleMPH = GetEntitySpeed(vehicleId)
            local driverPed = GetPedInVehicleSeat(vehicleId,-1)

if not IsPedInAnyBoat(ped) and not IsPedInAnyPlane(ped) and not IsPedInAnyHeli(ped) then                    
  if IsControlJustPressed(0, Config.Key) and driverPed == ped then                       
                speedLock()
                Citizen.Wait(1)                
   end
  end
 end
end)

function speedLock()
       local ped = GetPlayerPed(-1)
       local vehicleId = GetVehiclePedIsIn(ped, false)
       local vehicleMPH = GetEntitySpeed(vehicleId)
   
    if speedLocker == true then
        PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
        SetEntityMaxSpeed(GetVehiclePedIsIn(ped, false), 999.9)
        NTRP.Notify(" 🚦 Speedlock : Inactive ", "warning", math.random(2000, 2000))
        speedLocker = false  
    else
        PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
        SetEntityMaxSpeed(GetVehiclePedIsIn(ped, false), vehicleMPH )  
        NTRP.Notify(" 🚦 Speedlock : Active", "success", math.random(2000, 2000))  
        speedLocker = true  
    end 
  Citizen.Wait(300)   
end

Citizen.CreateThread(function() -- Driver Ped no Drive By
 while true do 
  Citizen.Wait(1)
    local ped = GetPlayerPed(-1)
    local vehicleId = GetVehiclePedIsIn(ped, false)
    local driverPed = GetPedInVehicleSeat(vehicleId, -1) 

  if driverPed == ped then
    if Config.noWeapons then
      SetCurrentPedWeapon(ped,GetHashKey("WEAPON_UNARMED"),true)
      DisableControlAction(0, 37, true) -- Weapon wheel
      DisableControlAction(0, 106, true) -- Weapon wheel
      if IsDisabledControlJustPressed(2, 37) then
		    --SetCurrentPedWeapon(ped,GetHashKey("WEAPON_UNARMED"),true) 	
      end
      if IsDisabledControlJustPressed(0, 106) then 
		    SetCurrentPedWeapon(ped,GetHashKey("WEAPON_UNARMED"),true)
      end
    end
    if VehCamOff then
      DisableControlAction(0, 80, true) -- no cin cam or lock it in cin mode
      SetFollowPedCamViewMode(1)
    end    
   end
  end
end)

if Config.fuelWarning then
Citizen.CreateThread(function() -- Driver Ped no Drive By
 while true do 
  Citizen.Wait(Config.fuelTimer)
     local ped = GetPlayerPed(-1)
     local vehicleId = GetVehiclePedIsIn(ped, false)
     local driverPed = GetPedInVehicleSeat(vehicleId, -1) 
     local IsInVehicle = IsPedInAnyVehicle(ped, false)
     local IsOnBike = IsPedOnAnyBike(ped	)

     local fuelLevel =  GetVehicleFuelLevel(vehicleId)
     local roundFuel = Round(fuelLevel)    
 
     if fuelLevel < Config.fuelPercent and IsInVehicle and driverPed == ped and not IsOnBike then
         NTRP.Notify("Warning Low Fuel : ⛽ "..roundFuel.." %", "error", math.random(3000, 3000))
     end
  end
 end)
end

RegisterCommand("cam", function(source, args)     
      camState = args[1]        
  if camState == "on" then
      VehCamOff = false
   end
  if camState == "off" then
      VehCamOff = true
   end               
end)

NTRP = {}
NTRP.Notify = function(text, type, timeout)
    exports.pNotify:SendNotification({ text = text, type =type, theme = "metroui", timeout = timeout, layout = "centerLeft", queue = "left"
})
end