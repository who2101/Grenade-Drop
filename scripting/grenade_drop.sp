#pragma semicolon 1
#pragma newdecls required;

#include <sdktools>
#include <cstrike>

enum GrenadeOffset
{
	OFFSET_HEGRENADE=11,
	OFFSET_FLASHBANG=12,
	OFFSET_SMOKEGRENADE=13
}

public Plugin myinfo = 
{
	name = "Grenade Drop",
	author = "Rodrigo286 (rewritten by who)",
	description = "Allows players to drop all grenades"
};

public void OnPluginStart()
{
	AddCommandListener(OnHookDrop, "drop");
}

public Action OnHookDrop(int client, const char[] command, int argc)
{
	if(client > 0 && IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) > 1 && IsPlayerAlive(client))
	{
		int weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	
		if(!IsValidEntity(weapon)) return Plugin_Handled;
	
		if(DropWeapon(client, "weapon_hegrenade", weapon, OFFSET_HEGRENADE)) 			return Plugin_Handled;
		else if(DropWeapon(client, "weapon_flashbang", weapon, OFFSET_FLASHBANG)) 		return Plugin_Handled;
		else if(DropWeapon(client, "weapon_smokegrenade", weapon, OFFSET_SMOKEGRENADE)) return Plugin_Handled;
	}

	return Plugin_Continue;
}

stock bool DropWeapon(int client, char[] entity, int weapon, GrenadeOffset offset)
{
	if (!IsValidEntity(weapon)) return false;

	char classname[64]; 
	GetEntityClassname(weapon, classname, sizeof(classname));  

	if (strcmp(classname, entity, false)) return false;

	int quantity = GetEntProp(client, Prop_Send, "m_iAmmo", _, view_as<int>(offset));	

	if(quantity == 1)
	{
		CS_DropWeapon(client, weapon, true, true);
		return true;
	}

	if(quantity > 1)
	{
		quantity--;
		SetEntProp(client, Prop_Send, "m_iAmmo", quantity, _, view_as<int>(offset));
		
		float vec[3], origin[3], angles[3];
		GetClientEyePosition(client, vec);
		GetClientAbsOrigin(client, angles); 

		int randomx = GetRandomInt(!!GetRandomInt(0, 1) ? (-55, -60) : 55, 60);
		int randomy = GetRandomInt(-55, 60);

		origin[0] = vec[0] + randomx;
		origin[1] = vec[1] + randomy;
		origin[2] = angles[2] + 25;

		int drop = CreateEntityByName(entity);

		if(IsValidEntity(drop))
		{		
			DispatchKeyValue(drop, "ammo", "0");
			DispatchSpawn(drop); 
			TeleportEntity(drop, origin, angles, NULL_VECTOR);
		}
	}

	return true;
}
