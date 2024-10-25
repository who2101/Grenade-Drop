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
	
		if(DropGrenade(client, "weapon_hegrenade", weapon, OFFSET_HEGRENADE)) 			return Plugin_Handled;
		else if(DropGrenade(client, "weapon_flashbang", weapon, OFFSET_FLASHBANG)) 		return Plugin_Handled;
		else if(DropGrenade(client, "weapon_smokegrenade", weapon, OFFSET_SMOKEGRENADE)) return Plugin_Handled;
	}

	return Plugin_Continue;
}

stock bool DropGrenade(int client, char[] entity, int weapon, GrenadeOffset offset)
{
	char classname[64]; 
	GetEntityClassname(weapon, classname, sizeof(classname));  

	if (strcmp(classname, entity, false)) return false;

	int grenadeCount = GetEntProp(client, Prop_Send, "m_iAmmo", _, view_as<int>(offset));

	if(grenadeCount > 1)
	{
		int index = GivePlayerItem(client, "weapon_flashbang");
		SetEntProp(client, Prop_Send, "m_iAmmo", grenadeCount-1, _, view_as<int>(offset));
		SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", index);		
	}

	return true;
}
