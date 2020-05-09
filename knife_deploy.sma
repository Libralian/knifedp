#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <cstrike>
#include <fun>

new bool:Knife[33];

public plugin_init()
{
	register_plugin("GodMode", "1.0", "Meliodas")
	RegisterHam(Ham_Spawn, "player", "Ham_PlayerSpawn_Post", 1)
	register_clcmd("say /knifedp", "DmgGm")
	register_clcmd("knifedp", "DmgGm")
//	register_clcmd("godmode", "DmgGm")
}

public client_putinserver(id)
{
	Knife[id] = false
}
public client_disconnected(id)
{
	Knife[id] = false
}

public Ham_PlayerSpawn_Post(id)
{
	if(Knife[id])
	{
	fm_strip_user_weapons(id)
	}
}

public DmgGm(id)
{
	if(is_user_alive(id) && get_user_flags(id) & ADMIN_BAN)
	{
		if(Knife[id])
		{		
//			if(id && is_user_alive(id))
//			{
			fm_give_item(id, "weapon_knife")
					
//			}
			Knife[id] = false;
//			client_print_color(id, print_team_default, "^4[INFO] ^1Нож вкл!");
		}
		else
		{
			fm_strip_user_weapons(id)
			Knife[id] = true;
//			client_print_color(id, print_team_default, "^4[INFO] ^1Нож выкл!");
		}
	}
	else client_print_color(id, print_team_default, "^4[INFO] ^1Недоступно!");
	return PLUGIN_HANDLED;
}

public respawn(const id)
{
	if(!is_user_alive(id))// && get_user_team(id) == 2)
	{
		ExecuteHam(Ham_CS_RoundRespawn, id);	
	}
	return PLUGIN_HANDLED;
}

stock fm_give_item(index, const item[])
{
	if (!equal(item, "weapon_", 7) && !equal(item, "ammo_", 5) && !equal(item, "item_", 5) && !equal(item, "tf_weapon_", 10))
		return 0

	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, item))
	if (!pev_valid(ent))
		return 0

	new Float:origin[3];
	pev(index, pev_origin, origin)
	set_pev(ent, pev_origin, origin)
	set_pev(ent, pev_spawnflags, pev(ent, pev_spawnflags) | SF_NORESPAWN)
	dllfunc(DLLFunc_Spawn, ent)

	new save = pev(ent, pev_solid)
	dllfunc(DLLFunc_Touch, ent, index)
	if (pev(ent, pev_solid) != save)
		return ent

	engfunc(EngFunc_RemoveEntity, ent)

	return -1
}

stock fm_strip_user_weapons(id)
{
        static ent
        ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "player_weaponstrip"))
        if (!pev_valid(ent)) return;
       
        dllfunc(DLLFunc_Spawn, ent)
        dllfunc(DLLFunc_Use, ent, id)
        engfunc(EngFunc_RemoveEntity, ent)
}