params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];
player setUnitLoadout (player getVariable ["Saved_Loadout",[]]);

if (!alive liftoff_console) then {
    _playerUnit = _oldUnit;
    //Find respawn position
    _drop_pos = getPos _oldUnit;
    if (count ((allPlayers - [_playerUnit]) select {alive _x}) > 0) then {
        _drop_pos = getPos ([(allPlayers - [_playerUnit]) select {alive _x}, _playerUnit] call Bis_fnc_nearestPosition);
    };
    _HEV = createVehicle ["OPTRE_HEV", [0, 0, 6000], [], 0, "FLY"];
    _newUnit moveInGunner _HEV; 
    [_HEV, "LOCKED"] remoteExec ["setVehicleLock", _HEV];
    _HEV setVariable ["HEV_hasPilot", true, true];

    [_HEV, _drop_pos, false] remoteExec ["tts_fnc_HEV_launchHevPos", 2, false];
} else {
    _cbpos = getPos cryo_bay;
    _newUnit setPos [_cbpos select 0, (_cbpos select 1) + 1, (_cbpos select 2) - 3.5];
};
