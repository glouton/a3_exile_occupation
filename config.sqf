// Shared Config for each occupation monitor

debug 			= false;			// set to true for additional logging
maxAIcount 		= 100;				// the maximum amount of AI, if the AI count is above this then additional AI won't spawn

 // As Namalsk is a smaller map, lower the maximum AI count
if (worldName == 'Namalsk') then { maxAIcount = 80; };

mapMarkers		= false;			// Place map markers at the occupied areas (occupyPlaces and occupyMilitary only) true/false
minFPS 			= 8;				// any lower than minFPS on the server and additional AI won't spawn

scaleAI 		= 10; 				// any more than _scaleAI players on the server and _maxAIcount is reduced for each extra player

useWaypoints		= true;				// When spawning AI create waypoints to make them enter buildings 
											            // (can affect performance when the AI is spawned and the waypoints are calculated)


occupyPlaces 		= true;				// true if you want villages,towns,cities patrolled
occupyMilitary 		= false;			// true if you want military buildings patrolled (specify which types of building in occupationMilitary.sqf)
occupyStatic	 	= false;			// true if you want to garrison AI in specific locations (not working yet)
occupyVehicle		= true;				// true if you want to have roaming AI vehicles
occupySky		= true;				// true if you want to have roaming AI helis

// Which buildings to patrol with the occupyMilitary option (adding more classnames could affect server performance when the spawning occurs)
buildings = ["Land_Cargo_Patrol_V1_F",
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
      			"Land_Dome_Small_F"]; 

// Settings for roaming ground vehicle AI
maxNumberofVehicles 	= 3;				// Number of roaming vehicles required, randomly selected from VehicleClassToUse
VehicleClassToUse 	= ["Exile_Car_LandRover_Green",
			"Exile_Car_UAZ_Open_Green",
			"Exile_Car_Offroad_Armed_Guerilla01"];



// Settings for roaming airborne AI
maxNumberofHelis	= 1;				// Number of roaming vehicles required, randomly selected from HeliClassToUse
HeliClassToUse 		= ["Exile_Chopper_Huey_Armed_Green",
			"Exile_Chopper_Hellcat_Green",
			"Exile_Chopper_Mohawk_FIA"];
						



// Don't alter anything below this point
liveVehicles 		= 0;
publicVariable "liveVehicles";
liveHelis	 	= 0;
publicVariable "liveHelis";
