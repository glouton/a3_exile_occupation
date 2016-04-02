////////////////////////////////////////////////////////////////////////
//
//		Server Occupation script by second_coming
//
//		Version 3
//
//		http://www.exilemod.com/profile/60-second_coming/
//
//		This script uses the fantastic DMS by Defent and eraser1
//
//		http://www.exilemod.com/topic/61-dms-defents-mission-system/
//
////////////////////////////////////////////////////////////////////////

// Shared Config for each occupation monitor

SC_debug 				    = false;				// set to true to turn on debug features (not for live servers) 
SC_extendedLogging          = true;                 // set to true for additional logging
SC_infiSTAR_log			    = true;					// true Use infiSTAR logging, false logs to server rpt
SC_maxAIcount 			    = 100;					// the maximum amount of AI, if the AI count is above this then additional AI won't spawn

SC_mapMarkers			    = false;				// Place map markers at the occupied areas (occupyPlaces and occupyMilitary only) true/false
SC_minFPS 				    = 5;					// any lower than minFPS on the server and additional AI won't spawn

SC_scaleAI 				    = 10; 					// any more than _scaleAI players on the server and _maxAIcount is reduced for each extra player

SC_useWaypoints			    = true;					// When spawning AI create waypoints to make them enter buildings 
												    // (can affect performance when the AI is spawned and the waypoints are calculated)

SC_occupyPlaces 			= true;				    // true if you want villages,towns,cities patrolled
SC_occupyMilitary 		    = false;				// true if you want military buildings patrolled (specify which types of building in occupationMilitary.sqf)
SC_occupyStatic	 		    = false;			    // true if you want to garrison AI in specific locations (not working yet)
SC_occupyVehicle			= true;					// true if you want to have roaming AI vehicles
SC_occupySky				= true;					// true if you want to have roaming AI helis
SC_occupyLootCrates		    = true;					// true if you want to have random loot crates with guards
SC_numberofLootCrates       = 6;                    // if SC_occupyLootCrates = true spawn this many loot crates (overrided for Namalsk in occupationLootCrates.sqf)
SC_occupyLootCratesMarkers	= true;					// true if you want to have markers on the loot crate spawns
SC_occupyHeliCrashes		= true;					// true if you want to have Dayz style helicrashes

SC_statics = [	[[1178,2524,0],4,100,true]	];      //[[pos],ai count,radius,search buildings]

// Which buildings to patrol with the occupyMilitary option (adding more classnames could affect server performance when the spawning occurs)
SC_buildings = [	"Land_Cargo_Patrol_V1_F",
				"Land_i_Barracks_V1_F",
				"Land_i_Barracks_V1_dam_F",
				"Land_i_Barracks_V2_F",
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
SC_maxNumberofVehicles 	= 3;						
SC_VehicleClassToUse 		= [	"Exile_Car_LandRover_Green","Exile_Car_UAZ_Open_Green","Exile_Car_Offroad_Guerilla03"];



// Settings for roaming airborne AI (non armed helis will just fly around)
SC_maxNumberofHelis		= 1;
SC_HeliClassToUse 		= [	"Exile_Chopper_Huey_Armed_Green"];
						

 // namalsk specific settings
if (worldName == 'Namalsk') then 
{ 
	SC_maxAIcount 			= 80; 
	SC_occupySky			= false;
};

// Don't alter anything below this point
SC_liveVehicles 		= 0;
publicVariable          "SC_liveVehicles";
SC_liveHelis	 		= 0;
publicVariable          "SC_liveHelis";
publicVariable          "SC_numberofLootCrates";