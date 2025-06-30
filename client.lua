local effect_time = 20   
local spam_timer = 0   
local SIZE = 2.5        
local particleDict = "core"
local particleName = "proj_grenade_snt-tdismoke" 
local bone = "exhaust" 

carblacklist = { 
    "car1"  ,
    "car2"  ,
}

local snt-tdismoke_ready = true
local car_net = nil
local vehicle
local ped
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        ped = GetPlayerPed(PlayerId())
        
        if IsPedInAnyVehicle(ped, false) then

            vehicle = GetVehiclePedIsIn(ped, false)
            
            if IsControlJustPressed(0, key['CTRL']) and snt-tdismoke_ready == true then
                snt-tdismoke_ready = false
                checkCar(vehicle)

			elseif IsControlJustPressed(0, key['CTRL']) and snt-tdismoke_ready == false then
			 snt-tdismoke_ready = true
             checkCar1(vehicle)

            end
        end
    end
end)
local particleEffects = {}
RegisterNetEvent("snt-tdismoke:StartParticles")
AddEventHandler("snt-tdismoke:StartParticles", function(carid)
    local entity = NetToVeh(carid)
    local part = GetWorldPositionOfEntityBone(entity, bone)
    local rot = GetWorldRotationOfEntityBone(entity, bone)
    local loopAmount = 150


    for x=0,loopAmount do

        UseParticleFxAssetNextCall(particleDict)
        local particle = StartParticleFxLoopedOnEntityBone(particleName, entity, part.x, part.y, part.z, rot.x, rot.y, rot.z, GetEntityBoneIndexByName(entity, bone), SIZE, false, false, false)            

        SetParticleFxLoopedEvolution(particle, particleName, SIZE, true)
        table.insert(particleEffects, 1, particle)
        Citizen.Wait(0)
    end
end)
RegisterNetEvent("snt-tdismoke:StopParticles")
AddEventHandler("snt-tdismoke:StopParticles", function(carid)
    for _,particle in pairs(particleEffects) do
        StopParticleFxLooped(particle, true)
    end
end)

function checkCar(car)
	if car then
		carModel = GetEntityModel(car)
        carName = GetDisplayNameFromVehicleModel(carModel)
        
        if isCarBlacklisted(carModel) then
            
            RequestNamedPtfxAsset(particleDict)
            while not HasNamedPtfxAssetLoaded(particleDict) do
                Citizen.Wait(10)
            end
            
            local netid = VehToNet(vehicle)
            SetNetworkIdExistsOnAllMachines(netid, 1)
            NetworkSetNetworkIdDynamic(netid, 0)
            SetNetworkIdCanMigrate(netid, 0)
                
            car_net = netid
            TriggerServerEvent("snt-tdismoke:SyncStartParticles", car_net)
		end
	end
end

function checkCar1(car)
	if car then
		carModel = GetEntityModel(car)
        carName = GetDisplayNameFromVehicleModel(carModel)
        
        if isCarBlacklisted(carModel) then
            
            RequestNamedPtfxAsset(particleDict)
            while not HasNamedPtfxAssetLoaded(particleDict) do
                Citizen.Wait(10)
            end
            
            local netid = VehToNet(vehicle)
            SetNetworkIdExistsOnAllMachines(netid, 1)
            NetworkSetNetworkIdDynamic(netid, 0)
            SetNetworkIdCanMigrate(netid, 0)
                
            car_net = netid
            TriggerServerEvent("snt-tdismoke:SyncStopParticles", car_net)
		end
	end
end

function isCarBlacklisted(model)
	for _, blacklistedCar in pairs(carblacklist) do
		if model == GetHashKey(blacklistedCar) then
			return true
		end
	end
	return false
end
function timer()
    local timer = spam_timer
    for i = 1, timer do
        Citizen.Wait(60000)
    end
    snt-tdismoke_ready = true
end
