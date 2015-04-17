-- This file contains functions which are called on each pulse when the bot is active n running

gw2_common_tasks = {}

function gw2_common_tasks.OnUpdate( tickcount )
	
	gw2_common_tasks.Downed(tickcount)
	gw2_common_tasks.DepositItems(tickcount)
	gw2_common_tasks.AoELoot(tickcount)
	gw2_common_tasks.SalvageItems(tickcount)
	gw2_common_tasks.SwimUp(tickcount)
	gw2_common_tasks.HealnBuff(tickcount) -- we have to see if this is a working solution for every botmode 
	gw2_common_tasks.ClaimRewards(tickcount)
	gw2_common_tasks.EquipGatheringTools(tickcount)
end

function gw2_common_tasks.Downed(tickcount)
	if ( not ml_global_information.Player_Alive and c_Downed:evaluate() ) then
		e_Downed:execute()
	end
end

gw2_common_tasks.depositLastUsed = 0
function gw2_common_tasks.DepositItems(tickcount)
	if ( TimeSince(gw2_common_tasks.depositLastUsed) > 5000 and gDepositItems == "1" and ml_global_information.Player_Inventory_SlotsFree <= 20 and ml_global_information.Player_Alive) then
		gw2_common_tasks.depositLastUsed = tickcount + math.random(500,5000)
		Inventory:DepositCollectables()
	end
end

gw2_common_tasks.aoeLootLastUsed = 0
function gw2_common_tasks.AoELoot(tickcount)
	if( TimeSince(gw2_common_tasks.aoeLootLastUsed) > 1050 and ml_global_information.Player_Inventory_SlotsFree > 0 and ml_global_information.Player_Alive) then
		gw2_common_tasks.aoeLootLastUsed = tickcount + math.random(50,500)
		Player:AoELoot()
	end
end

function gw2_common_tasks.SalvageItems(tickcount)
	if( ml_global_information.Player_InCombat == false and ml_global_information.Player_Alive) then
		gw2_salvage_manager.salvage()
	end
end


gw2_common_tasks.swimUpLastUsed = 0
gw2_common_tasks.swimUp = false
function gw2_common_tasks.SwimUp(tickcount)
	if( TimeSince(gw2_common_tasks.swimUpLastUsed) > 1000 and ml_global_information.Player_Alive) then
		gw2_common_tasks.swimUpLastUsed = tickcount + math.random(50,500)
		if ( gBotMode ~= GetString("assistMode") and ml_global_information.Player_SwimState == GW2.SWIMSTATE.Diving ) then
			gw2_common_tasks.swimUp = true
			Player:SetMovement(GW2.MOVEMENTTYPE.SwimUp)
		elseif( gw2_common_tasks.swimUp == true ) then
			gw2_common_tasks.swimUp = false
			Player:UnSetMovement(GW2.MOVEMENTTYPE.SwimUp)
		end		
	end
end

gw2_common_tasks.healnBuffLastUsed = 0
function gw2_common_tasks.HealnBuff(tickcount)
	if( TimeSince(gw2_common_tasks.healnBuffLastUsed) > 1500 and ml_global_information.Player_Alive and ml_global_information.Player_IsMoving and Player.castinfo.duration == 0) then
		gw2_common_tasks.healnBuffLastUsed = tickcount + math.random(500,2000)
		gw2_skill_manager.Heal()
	end
end

gw2_common_tasks.claimRewardsLastUsed = 0
function gw2_common_tasks.ClaimRewards(tickcount)
	if( TimeSince(gw2_common_tasks.claimRewardsLastUsed) > 15000 and ml_global_information.Player_Alive and ml_global_information.Player_Inventory_SlotsFree > 2) then
		gw2_common_tasks.claimRewardsLastUsed = tickcount + math.random(5000,15000)
		if ( Player:CanClaimReward() ) then
			-- Need to fix the item claiming first -.- Player:ClaimReward()
		end
	end
end

gw2_common_tasks.equipGatheringToolsLastUsed = 0
function gw2_common_tasks.EquipGatheringTools(tickcount)
	if( TimeSince(gw2_common_tasks.equipGatheringToolsLastUsed) > 10000 and ml_global_information.Player_Alive and c_equipGatheringTools:evaluate() == true) then
		gw2_common_tasks.equipGatheringToolsLastUsed = tickcount + math.random(5000,15000)
		e_equipGatheringTools:execute()
	end
end

