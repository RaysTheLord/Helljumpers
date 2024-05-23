if (isServer) then {
    _now = date;
    _times = ["day", "day","day", "night"];
    
    if (selectRandom _times isEqualTo "night") then {
        [[_now select 0, _now select 1, _now select 2, [0, 4] call BIS_fnc_randomInt, 0]] remoteExec ["setDate"];
    } else {
        [[_now select 0, _now select 1, _now select 2, [12, 15] call BIS_fnc_randomInt, 0]] remoteExec ["setDate"];
    };
        
}

