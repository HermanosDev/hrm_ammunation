ESX = nil
ppa = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerCoords = GetEntityCoords(PlayerPedId())

		for k, v in pairs(ConfigAmmunation.Position) do
			local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)

            if distance < 10.0 then
                actualZone = v
                zoneDistance = GetDistanceBetweenCoords(playerCoords, actualZone.x, actualZone.y, actualZone.z, true)

				DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.5, 1.5, 1.5, 10, 150, 255, 50, false, true, 2, false, nil, nil, false)
            end
            
            if distance <= 1.5 then
                ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu.')

                if IsControlJustPressed(1, 51) then
                    RageUI.Visible(RMenu:Get('main_ammu', 'main'), not RageUI.Visible(RMenu:Get('main_ammu', 'main')))
                end
            end

            if zoneDistance ~= nil then
                if zoneDistance > 1.5 then
                    RageUI.CloseAll()
                end
            end
        end
    
	end
end)

RMenu.Add('main_ammu', 'main', RageUI.CreateMenu("Ammunation", "Armurerie"))
RMenu.Add('main_ammu', 'armurerie', RageUI.CreateSubMenu(RMenu:Get('main_ammu', 'main'), "Armurerie", nil))
RMenu.Add('main_ammu', 'feu', RageUI.CreateSubMenu(RMenu:Get('main_ammu', 'main'), "Armurerie", nil))
RMenu.Add('main_ammu', 'access', RageUI.CreateSubMenu(RMenu:Get('main_ammu', 'main'), "Armurerie", nil))
RMenu.Add('main_ammu', 'ppa', RageUI.CreateSubMenu(RMenu:Get('main_ammu', 'main'), "Armurerie", nil))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('main_ammu', 'main'), true, true, true, function()

            RageUI.ButtonWithStyle("Armes blanche", nil, {RightLabel = "→"},true, function()
            end, RMenu:Get('main_ammu', 'armurerie'))

			ESX.TriggerServerCallback('hrm_ammunation:checkLicense', function(cb)            
                if cb then
                    ppa = true 
                	else 
                 	ppa = false   
                end
              end)

			RageUI.ButtonWithStyle("Accessoires", nil, {RightLabel = "→"},true, function()
            end, RMenu:Get('main_ammu', 'access')) 

            RageUI.Separator("--------------------------------------")

        if ppa then

            RageUI.ButtonWithStyle("Acheter le Permis de port d'arme", "Vous avez déjà le permis de port d'arme.", { RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)     
                if (Selected) then
                    --ESX.showNotification("~r~Vous avez déjà le permis de port d'arme.")
                end
            end)

        else

            RageUI.ButtonWithStyle("Acheter le Permis de port d'arme", nil, {RightLabel = "~g~50,000$"},true, function()
            end, RMenu:Get('main_ammu', 'ppa'))  
        end


        if ppa then 
            RageUI.ButtonWithStyle("Armes à feu", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)     
              if (Selected) then
            
              end
            end, RMenu:Get('main_ammu', 'feu')) 
            
            else 

              RageUI.ButtonWithStyle("Armes à feu", nil, { RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)     
                  if (Selected) then
                  end
                end) 

              end


        end, function()
        end)

		RageUI.IsVisible(RMenu:Get('main_ammu', 'ppa'), true, true, true, function()

                RageUI.ButtonWithStyle("~g~Confirmer", nil, { }, true, function(Hovered, Active, Selected)
                    if Selected then
						local prix = 50000
						TriggerServerEvent('hrm_ammunation:givePPA', 'weapon')
						RageUI.GoBack()
                    end
                end)

				RageUI.ButtonWithStyle("~r~Annuler", nil, { }, true, function(Hovered, Active, Selected)
                    if Selected then
						RageUI.GoBack()
                    end
                end)

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('main_ammu', 'armurerie'), true, true, true, function()

            for k, v in pairs(ConfigAmmunation.Cat.Blanche) do
                RageUI.ButtonWithStyle(v.Label, nil, {RightLabel = "~g~"..v.Price.."$"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('hrm_ammunation:giveWeapon', v)
                    end
                end)
            end

        end, function()
        end)

		RageUI.IsVisible(RMenu:Get('main_ammu', 'feu'), true, true, true, function()

            for k, v in pairs(ConfigAmmunation.Cat.Feu) do
                RageUI.ButtonWithStyle(v.Label, nil, {RightLabel = "~g~"..v.Price.."$"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('hrm_ammunation:giveWeapon', v)
                    end
                end)
            end

        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('main_ammu', 'access'), true, true, true, function()

            for k, v in pairs(ConfigAmmunation.Cat.Access) do
                RageUI.ButtonWithStyle(v.Label, nil, {RightLabel = "~g~"..v.Price.."$"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('hrm_ammunation:giveItem', v)
                    end
                end)
            end
			
        end, function()
        end)

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
	for k, v in pairs(ConfigAmmunation.Position) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)

		SetBlipSprite(blip, 110)
		SetBlipScale (blip, 0.8)
		SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Armurerie')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_y_ammucity_01")
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
	end
	for k,v in pairs(ConfigAmmunation.Vendeur) do
        ped = CreatePed("PED_TYPE_CIVMALE", "s_m_y_ammucity_01", v.x, v.y, v.z, v.a, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
	end
end)