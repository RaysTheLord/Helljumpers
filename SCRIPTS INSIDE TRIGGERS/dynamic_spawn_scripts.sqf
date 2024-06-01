0 spawn {   
        _plyr_cnt = count allPlayers;  
        _plyr_cnt_scaling = 2; 
        _max_units = 80; 
         
         _elite_units = ["WBK_EliteMainWeap_3", "WBK_EliteMainWeap_2", "WBK_EliteMainWeap_6", "IMS_Elite_Melee_1"];       
         _jackal_units = ["OPTRE_Jackal_Major_F", "OPTRE_Jackal_F", "OPTRE_Jackal_Infantry_F", "OPTRE_Jackal_Major2_F", "OPTRE_Jackal_Marksman_F", "OPTRE_Jackal_Sharpshooter_F", "OPTRE_Jackal_Sniper_F"];       
         _grunt_units = ["WBK_Grunt_2", "WBK_Grunt_1", "WBK_Grunt_5", "WBK_Grunt_3"];       
   
        _has_radio = 1; 
        _enableGroupReinforce = 1; 
         
        while { true } do { 
            _cur_enemy_count = count ((units opfor inAreaArray area_marker) select {!(dynamicSimulationEnabled (group _x))});   
            _floor_enemies = _max_units; 
            if (_cur_enemy_count < _floor_enemies) then { 
                _rem_enemies = _floor_enemies - _cur_enemy_count; 
                 _grp_elites = createGroup east;     
                 _grp_jackals = createGroup east;       
                 _grp_grunts = createGroup east;    
                _min_spawn_dist = (dynamicSimulationDistance "Group") * (dynamicSimulationDistanceCoef "IsMoving"); 
                 
                _plyr = selectRandom allPlayers; 
                _position = [_plyr, _min_spawn_dist, _min_spawn_dist + 250, 1, 0, 20, 0, [], [getPos area_marker, getPos area_marker]] call BIS_fnc_findSafePos; 
                for "_i" from 1 to (_rem_enemies min (_plyr_cnt * _plyr_cnt_scaling)) do { 
                    _unit = objNull; 
                    if (((_i - 1) mod 7) <= 3) then { 
                        _unit = _grp_grunts createUnit [selectRandom _grunt_units, [_position select 0, _position select 1, 0], [], 0, "NONE"];    
                    }; 
                    if (((_i - 1) mod 7) > 3 && ((_i - 1) mod 7) <= 5) then { 
                        _unit = _grp_jackals createUnit [selectRandom _jackal_units, [_position select 0, _position select 1, 0], [], 0, "NONE"]; 
                    }; 
                    if (((_i - 1) mod 7) == 6) then {
                        _unit = _grp_elites createUnit [selectRandom _elite_units, [_position select 0, _position select 1, 0], [], 0, "NONE"];
                    }; 
                     
                    if (!(_unit isEqualTo objNull)) then { 
                        [[_unit], _has_radio] execVM "\z\lambs\addons\danger\functions\ZEN\fnc_setHasRadio.sqf"; 
                    }; 
                }; 
             { 
                [units _x, _enableGroupReinforce] execVM "\z\lambs\addons\danger\functions\ZEN\fnc_setReinforcement.sqf"; 
                _wp = _x addWaypoint [getPos _plyr, 0];  
                _wp setWaypointType "SCRIPTED";  
                _wp setWaypointScript "\z\lambs\addons\wp\scripts\fnc_wpRush.sqf";  
             } forEach [_grp_elites, _grp_jackals, _grp_grunts]; 
            }; 
            sleep floor(random [ 120, 180, 240 ]);    
 
        }; 
         
};   
 
0 spawn { 
    _plyr_cnt = count allPlayers;  
    _plyr_cnt_scaling = 4; 
    _max_units = 80; 
     
    _score_placeholder = scoreSide west; 
    waitUntil { sleep 10; _score_placeholder = scoreSide west; _score_placeholder >= 10; }; 
     
    while { true } do { 
        _score_placeholder = scoreSide west; 
        _cur_enemy_count = count ((units opfor inAreaArray area_marker) select {!(dynamicSimulationEnabled (group _x))});   
        _floor_enemies = _max_units; 
        if (_cur_enemy_count < _floor_enemies) then { 
            _plyr = selectRandom allPlayers; 
            _min_spawn_dist = (dynamicSimulationDistance "Group") * (dynamicSimulationDistanceCoef "IsMoving"); 
 
            _enemy_pos = getPos _plyr; 
            _spawnpos = [_plyr, _min_spawn_dist, _min_spawn_dist + 250, 1, 0, 20, 0, [], [getPos area_marker, getPos area_marker]] call BIS_fnc_findSafePos; 
            _veh = createVehicle [selectRandom ["OPTRE_FC_Spirit", "OPTRE_FC_Spirit_Concussion"], [_spawnpos select 0, _spawnpos select 1, 50], [], 0, "FLY"]; 
            createVehicleCrew _veh; 
            _grp = group driver _veh; 
 
            _grp setCombatMode "BLUE";    
            _grp setBehaviour "CARELESS";    
 
            _landpos = [_enemy_pos, 30, 100, 3, 0, 20, 0] call BIS_fnc_findSafePos; 
 
            _aroundpos = [_landpos, 100, 150, 0, 0, 20, 0] call BIS_fnc_findSafePos; 
             
            _wp1 = _grp addWaypoint [_aroundpos, 0]; 
            _wp1 setWaypointType "MOVE"; 
            _wp1 setWaypointStatements ["true", "doStop leader this; (vehicle leader this) spawn {sleep 15; _this setFuel 0; _this allowDamage false;}"]; 
 
            _wp2 = _grp addWaypoint [_landpos, 0]; 
            _wp2 setWaypointType "MOVE"; 
            _wp2 setWaypointCompletionRadius 500; 
 
            _wp2 setWaypointStatements ["isTouchingGround vehicle leader this", "if (count ((units opfor inAreaArray area_marker) select {!(dynamicSimulationEnabled (group _x))}) < 100) then { _grp_elites = createGroup east; _grp_jackals = createGroup east; _grp_grunts = createGroup east; _elite_units = ['WBK_EliteMainWeap_3', 'WBK_EliteMainWeap_2', 'WBK_EliteMainWeap_6', 'IMS_Elite_Melee_1']; _jackal_units = ['OPTRE_Jackal_Major_F', 'OPTRE_Jackal_F', 'OPTRE_Jackal_Infantry_F', 'OPTRE_Jackal_Major2_F', 'OPTRE_Jackal_Marksman_F', 'OPTRE_Jackal_Sharpshooter_F', 'OPTRE_Jackal_Sniper_F']; _grunt_units = ['WBK_Grunt_2', 'WBK_Grunt_1', 'WBK_Grunt_5', 'WBK_Grunt_3']; for '_i' from 1 to 2 do { _grp_elites createUnit [selectRandom _elite_units, [getPos this select 0, getPos this select 1, 0], [], 0, 'NONE']; }; for '_j' from 1 to 2 do { _grp_jackals createUnit [selectRandom _jackal_units, [getPos this select 0, getPos this select 1, 0], [], 0, 'NONE']; }; for '_k' from 1 to 4 do { _grp_grunts createUnit [selectRandom _grunt_units, [getPos this select 0, getPos this select 1, 0], [], 0, 'NONE']; }; { _wp = _x addWaypoint [getPos (selectRandom allPlayers), 0]; _wp setWaypointType 'SCRIPTED'; _wp setWaypointScript '\z\lambs\addons\wp\scripts\fnc_wpRush.sqf';} forEach [_grp_elites, _grp_jackals, _grp_grunts]; }; this setCombatMode 'RED'; this setBehaviour 'COMBAT'; (vehicle leader this) setFuel 1; (vehicle leader this) allowDamage true; (units this) doFollow (leader this);"]; 
 
            _exit_pos = [nil, [area_marker]] call BIS_fnc_randomPos; 
            _wp3 = _grp addWaypoint [_exit_pos, 0]; 
            _wp3 setWaypointType "MOVE"; 
            _wp3 setWaypointStatements ["true", "deleteVehicle vehicle this; {deleteVehicle _x} forEach thisList;"]; 
 
        }; 
        sleep floor(random [ 120, 180, 300 ]);  
    }; 
}; 
 
0 spawn { 
    _plyr_cnt = count allPlayers;  
    _plyr_cnt_scaling = 2; 
    _max_units = 80; 
 
    _score_placeholder = scoreSide west; 
    waitUntil { sleep 10; _score_placeholder = scoreSide west; _score_placeholder >= (10 * _plyr_cnt); }; 
 
    while {true } do { 
        _score_placeholder = scoreSide west; 
        _cur_enemy_count = count ((units opfor inAreaArray area_marker) select {!(dynamicSimulationEnabled (group _x))}); 
        _floor_enemies = _max_units; 
        if (_cur_enemy_count < _floor_enemies) then { 
            private _position =  getPos selectRandom allPlayers;     
            if (_position isNotEqualTo [0, 0]) then {    
              _veh = "OPTRE_FC_Ghost";     
 
              if (_score_placeholder > (20 * _plyr_cnt)) then {     
               _veh = "OPTRE_FC_Spectre_AI_Needler";     
              };     
 
              if (_score_placeholder > (30 * _plyr_cnt)) then {     
               _veh = "OPTRE_FC_Spectre_AT";     
              };     
              if (_score_placeholder > (40 * _plyr_cnt)) then {     
               _veh = "OPTRE_FC_Wraith_Tank";     
              };     
 
              [_position, "OPTRE_FC_Spirit", _veh, true, 2000, random 365] call PHAN_ScifiSupportPlus_fnc_COV_SpiritVehicleDrop;     
            };     
        }; 
         sleep floor(random [ 180, 300, 480 ]);    
    };    
}; 
 
0 spawn { 
    _max_planes = 2; 
     
    _plane_classes = ["OPTRE_FC_Type26B_Ultra_Banshee", "OPTRE_FC_Type26N_Banshee", "OPTRE_FC_Type26B_Banshee"]; 
 
    while {true } do { 
        _cur_plane_count = count ((units opfor inAreaArray area_marker) select {typeOf (vehicle _x) in _plane_classes}); 
        if (_cur_plane_count < _max_planes) then { 
            _plyr = selectRandom allPlayers; 
 
            _min_spawn_dist = (dynamicSimulationDistance "Group") * (dynamicSimulationDistanceCoef "IsMoving"); 
            _spawnpos = [_plyr, _min_spawn_dist + 250, _min_spawn_dist + 500, 1, 0, 20, 0, [], [getPos area_marker, getPos area_marker]] call BIS_fnc_findSafePos; 
 
            _veh = createVehicle [selectRandom _plane_classes, [_spawnpos select 0, _spawnpos select 1, 50], [], 0, "FLY"]; 
            createVehicleCrew _veh; 
            _grp = group driver _veh; 
 
            _wp = _grp addWaypoint [getPos _plyr, 0];  
            _wp setWaypointType "SCRIPTED";  
            _wp setWaypointScript "\z\lambs\addons\wp\scripts\fnc_wpRush.sqf";  
        }; 
         sleep floor(random [ 180, 300, 480 ]);    
    };    
}; 
 
 
