if ((!isServer) && (player != player)) then {waitUntil {player == player};};

_id = ["ace_arsenal_displayClosed", {

player setVariable["Saved_Loadout", getUnitLoadout player];

}] call CBA_fnc_addEventHandler;

[missionNamespace, "arsenalClosed", {      

      player setVariable ["Saved_Loadout",getUnitLoadout player];

}] call BIS_fnc_addScriptedEventHandler;

player setUnitFreefallHeight 1000;

[player, "Support_MAC_strike"] call BIS_fnc_addCommMenuItem;
[player, "Support_Archer_missiles"] call BIS_fnc_addCommMenuItem;
[player, "Support_Orbital_autocannon"] call BIS_fnc_addCommMenuItem;
[player, "Support_Pelican_veh_warthog"] call BIS_fnc_addCommMenuItem;