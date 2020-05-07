local CFG = exports['fq_essentials']:getCFG()
local mCFG = CFG.menu
local gCFG = CFG.gangs

local gangid = nil
local mainSpawn = nil
local r, g, b

local spawns = {
	[1] = {
		{name='bmx', x=85.827911376953,y=-1943.9868164063,z=20.139272689819,h=305.33291625977, color1=145},
		{name='jackal', x=95.510620117188, y=-1960.1118164063, z=20.108514785767, h=321.56817626953, color1=145},
		{name='emperor', x=88.127433776855, y=-1918.3231201172, z=19.976676940918, h=52.502487182617, color1=148},
		{name='moonbeam', x=91.174949645996, y=-1941.1102294922, z=19.947259902954, h=26.3675365448, color1=145},
		{name='baller3', x=114.2032699585, y=-1947.4528808594, z=19.938356399536, h=321.07119750977, color1=148},
		{name='bati', x=103.58518981934, y=-1927.9637451172, z=19.962217330933, h=78.312591552734, color1=145},
		{name='bmx', x=120.36226654053,y=-1939.2561035156,z=20.139795303345,h=8.9433536529541, color1=145}
	},
	[2] = {
		{name='bmx', x=337.25485229492,y=-206.97483825684,z=53.411914825439,h=67.065353393555, color1=50},
		{name='dubsta2', x=315.19622802734,y=-209.7075958252,z=53.411514282227,h=249.47384643555, color1=50},
		{name='intruder', x=335.14883422852,y=-213.62664794922,z=53.41215133667,h=248.56652832031, color1=128},
		{name='hermes', x=317.5126953125,y=-215.12297058105,z=53.411911010742,h=199.64758300781, color1=50},
		{name='esskey', x=327.93325805664,y=-203.87376403809,z=53.411754608154,h=159.40202331543, color1=128},
		{name='bmx', x=333.50698852539,y=-217.35656738281,z=53.413543701172,h=242.2858581543, color1=128},
	},
	[3] = {
		{name='deathbike', x=953.1416015625,y=-2176.3876953125,z=30.0628490448,h=84.833435058594, color1=42},
		{name='oracle2', x=939.68768310547,y=-2195.5573730469,z=29.874685287476,h=171.68391418457, color1=88},
		{name='toros', x=941.12957763672,y=-2167.9086914063,z=29.864542007446,h=174.0213470459, color1=42},
		{name='nightshade', x=956.40441894531,y=-2194.9768066406,z=29.879089355469,h=56.56173324585, color1=88},
		{name='bmx', x=947.23352050781,y=-2197.2353515625,z=29.940654754639,h=5.3414125442505, color1=42},
		{name='bmx', x=959.34783935547,y=-2189.0866699219,z=29.906967163086,h=28.562847137451, color1=88},
	},
	[4] = {
		{name='imperator', x=-847.35711669922,y=-928.11242675781,z=14.870594024658,h=356.18539428711, color1=27},
		{name='bf400', x=-803.79278564453,y=-931.21826171875,z=17.392042160034,h=345.59634399414, color1=39},
		{name='freecrawler', x=-791.31530761719,y=-924.48400878906,z=18.117008209229,h=273.31219482422, color1=27},
		{name='glendale', x=-763.12854003906,y=-942.70635986328,z=16.775867462158,h=162.18057250977, color1=39},
		{name='bmx', x=-824.73120117188,y=-907.11535644531,z=17.284097671509,h=87.496841430664, color1=27},
		{name='bmx', x=-812.76733398438,y=-932.68786621094,z=16.227045059204,h=249.4200592041, color1=39},
	}
}

-- metaliczny: 145
-- matowy: 148
AddEventHandler('fq:pickedCharacter', function(gangIndex, modelIndex)
    if gCFG[gangIndex] and gCFG[gangIndex].models[modelIndex] then
		gangid = gangIndex
		mainSpawn = gCFG[gangIndex].spawnPoint
		r, g, b = table.unpack(gCFG[gangIndex].rgbColor)
		print('picked ' .. gangid)
	end
end)

AddEventHandler('onClientResourceStart', function (resourceName)
	if(GetCurrentResourceName() == resourceName) then
		Citizen.CreateThread(function()
            while true do
				Citizen.Wait(1) 
				if gangid and mainSpawn then

					local pos = GetEntityCoords(GetPlayerPed(-1))
					for i, v in ipairs(spawns[gangid]) do
						if GetDistanceBetweenCoords(pos.x,pos.y,pos.z,v.x,v.y,v.z,false) < 80.0 then
							local veh = GetClosestVehicle(v.x, v.y, v.z, 2.0, GetHashKey(v.name), 23)
							if veh == 0 then
								DrawMarker(36, v.x,v.y,v.z+2.0, 0,0,0, 0,0,0, 1.0,1.0,1.0, 0,0,0,90, false,true,2,false, nil,nil,false)
							else
								local check = IsVehicleTyreBurst(veh, 0, false) or IsVehicleTyreBurst(veh, 1, false) or IsVehicleTyreBurst(veh, 2, false) or IsVehicleTyreBurst(veh, 4, false) or IsVehicleTyreBurst(veh, 5, false)
								if not IsVehicleDriveable(veh, false) or check then
									SetVehicleFixed(veh)
									-- SetEntityAsMissionEntity(veh)
									-- DeleteVehicle(veh)
								end
								DrawMarker(36, v.x,v.y,v.z+2.0, 0,0,0, 0,0,0, 1.0,1.0,1.0, r,g,b,135, false,true,2,false, nil,nil,false)
							end
						end
					end
				end
            end
        end)
	end
end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1000)
		if gangid and mainSpawn then
			local plCoords = GetEntityCoords(GetPlayerPed(-1))
			local spawnPos = vec(mainSpawn.x, mainSpawn.y, mainSpawn.z)

			local dist = #(spawnPos - plCoords)

			if dist < 250 then
				for i, v in ipairs(spawns[gangid]) do
					local veh = GetClosestVehicle(v.x, v.y, v.z, 255.0, GetHashKey(v.name), 23)
					if veh == 0 or not IsVehicleDriveable(veh, false) then
						
						RequestModel(v.name)
						
						while not HasModelLoaded(v.name) do
							Citizen.Wait(5)
						end

						local veh = CreateVehicle(GetHashKey(v.name), v.x, v.y, v.z, v.h, true, false)
						SetVehicleColours(veh, v.color1, v.color1)
						SetVehicleDoorsLockedForAllPlayers(veh, false)

						SetEntityAsNoLongerNeeded(veh)
						SetModelAsNoLongerNeeded(v.name)
					end
				end
			end
		end
	end
end)

