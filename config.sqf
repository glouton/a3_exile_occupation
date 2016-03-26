// Shared Config for each occupation monitor

SC_debug 				= false;					// set to true for additional logging and to speed up the spawn rate for testing
SC_infiSTAR_log			= true;					// Use infiSTAR logging
SC_maxAIcount 			= 100;					// the maximum amount of AI, if the AI count is above this then additional AI won't spawn

 // As Namalsk is a smaller map, lower the maximum AI count
if (worldName == 'Namalsk') then { SC_maxAIcount = 80; };

SC_mapMarkers				= false;					// Place map markers at the occupied areas (occupyPlaces and occupyMilitary only) true/false
SC_minFPS 				= 8;						// any lower than minFPS on the server and additional AI won't spawn

SC_scaleAI 				= 10; 					// any more than _scaleAI players on the server and _maxAIcount is reduced for each extra player

SC_useWaypoints			= true;					// When spawning AI create waypoints to make them enter buildings 
												// (can affect performance when the AI is spawned and the waypoints are calculated)


SC_occupyPlaces 			= true;					// true if you want villages,towns,cities patrolled
SC_occupyMilitary 		= false;					// true if you want military buildings patrolled (specify which types of building in occupationMilitary.sqf)
SC_occupyStatic	 		= false;					// true if you want to garrison AI in specific locations (not working yet)
SC_occupyVehicle			= true;					// true if you want to have roaming AI vehicles
SC_occupySky				= true;					// true if you want to have roaming AI helis
SC_occupyLootCrates		= true;					// true if you want to have random loot crates with guards
SC_occupyLootCratesMarkers	= true;					// true if you want to have markers on the loot crate spawns

SC_statics = [
			[[4151,6697,0],4,100,true],
			[[3560,6673,0],4,100,true]
			]; //[[pos],ai count,radius,search buildings]

// Which buildings to patrol with the occupyMilitary option (adding more classnames could affect server performance when the spawning occurs)
SC_buildings = [	"Land_Cargo_Patrol_V1_F",
				"Land_i_Barracks_V1_F",
				"Land_i_Barracks_V1_dam_F",
				"Land_i_Barracks_V2_F",
				"Land_u_Barracks_V2_F",
				"Land_Cargo_House_V1_F",
				"Land_Cargo_HQ_V1_F",
				"Land_Cargo_HQ_V2_F",
				"Land_Cargo_HQ_V3_F",
				"Land_Cargo_Patrol_V2_F",
				"Land_Cargo_Patrol_V3_F",
				"Land_Cargo_Tower_V1_F",
				"Land_Cargo_Tower_V1_No1_F",
				"Land_Cargo_Tower_V1_No2_F",
				"Land_Cargo_Tower_V1_No3_F",
				"Land_Cargo_Tower_V1_No4_F",
				"Land_Cargo_Tower_V1_No5_F",
				"Land_Cargo_Tower_V1_No6_F",
				"Land_Cargo_Tower_V1_No7_F",
				"Land_Cargo_Tower_V2_F",
				"Land_Cargo_Tower_V3_F",
				"Land_MilOffices_V1_F",
				"Land_Radar_F",
				"Land_Radar_Small_F",
				"Land_Dome_Big_F",
				"Land_Dome_Small_F",
				"Land_Army_hut3_long_int",
				"Land_Army_hut_int",
				"Land_Army_hut2_int"
		   ]; 

// Settings for roaming ground vehicle AI
SC_maxNumberofVehicles 	= 3;						// Number of roaming vehicles required, randomly selected from VehicleClassToUse
SC_VehicleClassToUse 		= [	"Exile_Car_LandRover_Green",
							"Exile_Car_UAZ_Open_Green",
							"Exile_Car_Offroad_Armed_Guerilla01"];



// Settings for roaming airborne AI
SC_maxNumberofHelis		= 1;						// Number of roaming vehicles required, randomly selected from HeliClassToUse (only use armed helis for now)
SC_HeliClassToUse 		= [	"Exile_Chopper_Huey_Armed_Green"];
						



// Don't alter anything below this point
SC_liveVehicles 		= 0;
publicVariable "SC_liveVehicles";
SC_liveHelis	 		= 0;
publicVariable "SC_liveHelis";