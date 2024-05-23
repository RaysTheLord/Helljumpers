params ["_playerUnit", "_didJIP"];
[west, 5] call BIS_fnc_respawnTickets;
if (!alive liftoff_console) then {
    _drop_pos = getPos area_marker;
    if (count (allPlayers - [_playerUnit]) > 0) then {
        _drop_pos = getPos ([allPlayers - [_playerUnit], _playerUnit] call Bis_fnc_nearestPosition);
    };
    
    _HEV = createVehicle ["OPTRE_HEV", [0, 0, 6000], [], 0, "FLY"];
    [_playerUnit, _HEV] remoteExec ["moveInGunner", 0, false];
    [_HEV, "LOCKED"] remoteExec ["setVehicleLock", _HEV];
    _HEV setVariable ["HEV_hasPilot", true, true];
    
    [_HEV, _drop_pos, false] remoteExec ["tts_fnc_HEV_launchHevPos", 2, false];
};