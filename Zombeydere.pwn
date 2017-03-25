/*
	Troydere made this out of his ballsack.
	I'm from Venezuela. We clean our assholes with copyright so you can do pretty much what you want with this script.
	
	I'll take advantage of this opportunity to make a global call: Please, scripters, programmers, whoever you are, stop doing the following:
	
	new
		variable
	;
	
	It's sick. You are sick. Single variable declarations in a new line are sick. Kill me.
	
	Disclaiming is gay aswell.
*/

#include <a_samp>
#include <rnpc>
#include <streamer>

#define FILTERSCRIPT
#if defined FILTERSCRIPT

// ------------ Definitions and such -------------

#define DUMMY_QUANT 100
#define MAX_ZOMBEY 100
#define MAX_ZOMBEY_PER_AREA 10

forward OnZombeySpawn(zombieid);
forward ZombeyDisconnect();
forward ZombeyFollow();
forward DummyZombeys();
forward DummyRemove();
forward RequestPoolZombeys(zone);
forward ReturnPoolZombeys(zone);
forward ZombeyCleanUp();
forward PoolZombeys();

enum ZOMBEY
{
	dArea,
	bool:dPool,
	dRecording
}
new NPCdere[MAX_ZOMBEY + DUMMY_QUANT][ZOMBEY];

new ZombeySkins[] = {77, 78, 79,75,134,135,136,137,162,160};

new Float:ZombeySpawns[][] =
{
	{0.0,0.0,0.0,0.0},{2595.5874,-1608.9442,19.4663,82.1258},{2265.5496,-1585.9697,3.0097,106.7576},{1950.3582,-1506.4686,3.3321,186.0241},{1669.3159,-1475.4679,25.2280,146.9734},
	{1672.1649,-912.8137,61.9070,48.9052},{1703.2264,-665.7866,43.5164,9.4717},{1657.1974,-60.2038,36.2351,19.0286},{1660.2299,292.5186,30.1836,58.5554},{2427.1458,-1664.6561,13.5385,268.5508},
	{2481.0369,-1662.1606,13.3438,257.9170},{2277.9478,-2298.6675,13.3750,302.0162},{2515.3696,-2161.5588,13.5543,5.1086},{2716.7759,-2163.1538,10.9297,12.1293},{2838.1960,-2026.0667,10.9375,319.7458},
	{2870.0239,-1660.7085,10.8750,76.0933},{2909.2749,-1407.6072,10.8828,310.4268},{2885.5740,-1135.2494,10.8750,140.4303},{2887.2515,-668.3461,10.8359,26.1002},{2717.2886,-347.4756,27.1166,78.4571}, 
	{2761.5569,-103.1078,35.1043,130.0416},{2491.0393,310.7569,30.4091,281.1032},{2045.3373,308.8565,34.6848,340.5339},{1860.9904,118.4504,35.1707,215.2239},{2343.1909,92.5266,26.3309,245.1010},
	{2267.6062,-91.9276,26.4844,157.7473},{2387.8333,-99.5720,26.2562,352.5076},{2539.5042,-408.0523,78.3301,173.2182},{2394.7131,-649.7354,127.3468,78.2163},{2272.6121,-762.8874,129.5537,88.5154},
	{2305.6648,-1010.0305,60.6608,73.1588},{2399.4248,-1050.8766,52.3468,135.2802},{2564.4756,-1048.8444,69.4389,58.7767},{2656.0908,-1079.5015,69.6314,13.6634},{2730.1838,-1256.3435,59.5535,109.9705},
	{2729.1230,-1486.8243,30.2813,311.8984},{2728.8003,-1644.6012,13.1563,300.1910},{2654.2441,-1428.0817,30.4241,345.8605},{2642.5618,-1255.2007,49.8470,39.0112},{2365.1921,-1154.4768,27.4531,269.1432},
	{2365.0742,-1301.3102,23.8339,171.4025},{2410.5491,-1531.9122,23.9922,98.8811},{2403.5857,-1743.0781,13.5469,84.8174},{2415.2676,-2007.5118,13.4154,224.8774},{2235.0173,-1744.0498,13.5430,170.7296},
	{2272.6436,-1485.0211,22.5859,346.4311},{2287.4294,-1297.2263,24.0000,3.7498},{2289.0200,-1152.9574,26.7523,23.5461},{2142.8389,-1107.2788,25.3228,113.9078},{2164.2000,-1298.5975,23.8281,180.3448},
	{1871.6132,-1381.9218,13.5309,57.4739},{1456.2003,-1439.3130,13.3828,207.2600},{1529.9166,-1621.1096,13.3828,122.6012},{1301.6754,-1720.6783,13.3828,270.6787},{1346.7673,-1455.6189,13.5469,66.7461},
	{1202.0665,-1339.4111,13.3988,55.7364},{1026.5844,-1810.1936,14.0443,162.4994},{812.4332,-1776.9305,13.5781,6.8967},{628.8810,-1680.2488,15.3802,357.3485},{638.2471,-1206.1913,18.1094,131.9934},
	{358.9488,-1375.1720,14.3513,120.2130},{1312.8452,-924.2622,38.2320,348.9708},{728.2896,-530.4733,16.1850,241.7961},{658.2929,-602.0730,16.1875,100.7097},{961.6380,-1145.7280,24.0240,7.6702},
	{450.6947,-522.5339,43.2546,255.2077},{470.3037,-412.8992,28.4404,356.2131},{528.6532,-125.0970,37.6413,12.4767},{596.2001,267.2160,18.5511,291.0198},{233.3161,46.3207,2.4297,257.1107},
	{230.6808,-144.4301,1.4297,307.6741},{68.5418,-224.1966,1.5781,154.8259},{-205.8146,-83.8445,3.1172,15.1139},{-167.7565,52.9434,3.1172,344.9300},{-399.6462,127.2543,12.7734,115.9479},
	{-520.1821,-81.9397,62.3759,156.3337},{-515.0512,-178.3375,77.0745,244.3826},{-770.0949,-177.1044,67.7461,168.4618},{-772.4377,189.3381,2.8650,45.3109},{-394.0524,277.1284,2.0781,13.5970},
	{-17.3656,176.8708,2.0851,7.5150},{-703.7324,44.6212,33.4896,348.6581},{463.7527,-599.0456,36.8788,259.7251},{1023.6531,-338.6958,73.9922,0.3194},{1068.3652,-320.1700,73.9922,301.2728},
	{1099.7715,-340.2053,73.9922,236.0988},{1069.8232,-308.4129,73.9922,0.3863},{1269.4587,-385.7039,2.4189,192.7362},{1179.0394,-163.7771,40.6114,186.1126},{1411.7035,-321.3133,2.9319,11.3431},
	{1905.3948,42.2525,34.6168,73.8062},{2259.7725,34.2772,26.4844,298.8076},{2294.6082,90.7981,26.3359,346.2668},{2394.2266,88.9377,26.3359,268.2143},{1631.6553,-1764.1259,3.9531,285.9689},
	{1363.8201,-1704.7351,8.5542,149.5754},{1882.9447,-1826.7518,3.9844,349.5415},{2040.8627,-1930.4333,7.9844,223.8346},{2109.7959,-2000.2394,7.9844,224.3692},{2375.6707,-2268.8157,6.0625,35.0913},
	{2318.6848,-2209.9216,6.0694,43.2164},{2268.4519,-2236.4795,13.6138,18.1992},{1800.0079,723.3448,13.9646,348.2270},{2047.8790,839.7574,6.7422,280.1606},{2279.4280,974.5772,10.7204,301.5622},
	{2401.0920,1030.6226,10.8130,9.1316},{2543.2971,950.6302,10.8175,243.0339},{2571.2166,738.5804,10.8203,65.2047},{2706.5933,668.7258,10.8203,134.4333},{2426.0444,712.6472,10.8722,357.4635},
	{2507.2683,839.7920,6.7344,281.1330},{2730.1729,863.8554,10.7500,173.6372},{2838.9890,923.3946,10.7500,344.4517},{2706.9092,1016.5305,6.7344,21.1352},{2893.1228,1094.3148,10.8984,274.9451},
	{2796.4287,1277.4871,10.7500,131.1480},{2877.2412,1719.3568,10.8203,324.9024},{2872.8721,2074.6482,10.8203,341.2417},{2863.0566,2391.5449,10.8203,120.4659},{2689.3740,2425.9680,6.7321,114.1701},
	{2379.0532,2744.5762,10.8203,96.8120},{2124.3706,2739.8960,10.8203,188.7030},{1819.5428,2781.1238,10.8359,90.9329},{1480.5972,2847.6606,10.8203,6.0142},{1337.3582,2679.3721,10.8203,192.8731},
	{1113.6622,2484.0378,10.6659,107.3217},{953.9368,2860.0393,41.1880,24.0617},{764.3046,2630.8057,17.3755,191.3913},{251.5331,2644.2000,16.4827,225.4502},{323.8607,2546.7458,16.8084,188.1633},
	{364.7496,2482.6716,16.4844,178.8832},{156.7204,2508.2866,16.5113,87.8000},{-380.7301,2569.6404,40.6936,54.8135},{-519.5166,2593.8284,53.4141,83.1742},{-609.7449,2758.6304,59.8804,36.3841},
	{-1075.6166,2703.0859,45.8672,97.2412},{-1550.1833,2596.0820,55.6875,173.7935},{-1912.8340,2618.8298,48.3532,124.0958},{-2505.1238,2421.1594,16.5981,223.9596},{-2469.2417,2233.8799,4.8051,188.1555},
	{-2261.8599,2318.5603,4.8125,209.3206},{-1934.5503,2386.0576,49.4922,187.6683},{-1818.1865,2120.1565,8.1043,206.0322},{-1690.6919,1823.0107,25.3659,283.0673},{-1484.5781,1844.3569,31.8336,246.4059},
	{-1207.6155,1820.2594,41.7188,304.6866},{-1175.2727,1681.2064,21.1006,244.7506},{-1031.0171,1254.6851,39.5574,318.7119},{-768.9958,710.3133,18.5315,240.8592},{-126.4927,534.2534,7.1719,270.9475},
	{422.5144,613.1608,18.9433,331.5051},{545.6509,735.6124,12.1510,352.2113},{847.1707,701.7158,11.7823,275.1620},{812.5788,844.0918,10.1005,49.4369},{653.6065,919.6617,-40.5375,66.6462},
	{573.5066,857.7878,-42.8453,74.1497},{1013.2640,1122.5544,10.8203,321.2251},{1092.6566,1064.9885,10.8359,227.0902},{1145.7108,861.6921,10.7262,174.5185},{1375.7797,737.2265,10.8203,194.4594},
	{1409.4922,919.7701,10.8203,321.5886},{1637.0300,718.7372,10.8203,281.8382},{1685.8696,982.1932,10.8100,78.2365},{1417.6132,1004.8981,10.8203,85.0771},{1696.1882,1612.0049,10.8203,61.7185},
	{1477.2115,1815.9962,10.8125,26.9379},{1323.3706,1588.7765,10.8203,144.9388},{1319.6866,1305.9309,10.8203,198.7130},{1905.9954,1579.0353,10.8203,264.9946},{2057.0259,1451.7617,10.6797,270.5583},
	{2150.2544,1417.0151,10.8203,263.1646},{2186.4731,1203.2944,10.6644,178.1867},{2426.0479,1071.4696,11.0528,268.2878},{2592.0278,981.7451,10.8203,227.5667},{2549.1931,1468.3203,10.8331,353.9362},
	{2441.0730,1646.7374,10.8203,63.4905},{2103.0735,1772.9695,10.6719,89.2113},{2320.7627,1460.4625,10.8203,175.8278},{2334.2000,1395.0389,23.6250,176.4956},{2303.5635,1396.5680,36.4219,64.1598},
	{2325.1392,1436.8323,42.8203,179.8077},{2505.9797,1451.5029,10.8203,350.1845},{2032.5996,1914.2384,12.3359,15.7889},{2349.1545,2139.3567,10.6806,274.6083},{2351.1738,1908.9243,10.6719,183.3887},
	{2255.5967,1950.5341,9.8671,272.8133},{2258.9741,1963.8489,20.8221,84.4149},{2262.1414,1961.7854,31.7797,349.6241},{2267.3235,2055.9478,10.8203,302.1714},{2270.7617,2458.0435,10.8203,280.3839},
	{2248.4773,2474.5828,3.2734,139.0876},{2514.2539,2513.5090,10.8203,268.3383},{2301.9399,2625.5164,6.7492,104.8737},{1343.1592,2448.9392,6.6953,116.8646},{1128.4910,2154.5852,10.8203,59.6362},
	{1104.7521,1885.2665,10.8203,2.6265},{1076.1465,1759.6414,10.8203,186.8116},{961.2682,1730.6890,8.6484,147.9221},{1068.9893,1292.8248,10.8203,175.1133},{1603.5455,-1359.7460,29.2631,25.9220}
};

new dZombeySpawns[sizeof ZombeySpawns][2],ZombeyTimer;

// ---------- Things you can edit ----------------

public OnRNPCDeath(npcid, killerid, reason)
{
	if(!IsPlayerNPC(npcid)) return 1;
	// Add whatever function you want to execute after killing a zombey (such as giving score to the player or money or whores)
	
	
	// Dont edit this
	NPCdere[npcid][dArea] = -1;
	NPCdere[npcid][dPool] = true;
	SpawnPlayer(npcid);
	return 1;
}

// -------- Disorganized code and such -----------

public OnFilterScriptInit()
{
	printf("[Zombeydere] Zombeydere loaded.");
	ZombeyTimer = SetTimer("ZombeyFollow",1000,true);
	DummyZombeys();
	for(new z = 1; z < sizeof ZombeySpawns; z++)
	{
		dZombeySpawns[z][0] = CreateDynamicSphere(ZombeySpawns[z][0],ZombeySpawns[z][1],ZombeySpawns[z][2],200,0,0);
		dZombeySpawns[z][1] = 0;
	}
	return 1;
}

public OnFilterScriptExit()
{
	ZombeyDisconnect();
	
	for(new z = 1; z < sizeof ZombeySpawns; z++)
	{
		DestroyDynamicArea(dZombeySpawns[z][0]);
		dZombeySpawns[z][1] = 0;
	}	

	printf("[Zombeydere] Zombeydere unloaded.");
	KillTimer(ZombeyTimer);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return OnZombeySpawn(playerid);
	return 1;
}

public ZombeyFollow()
{
	new Float:xz,Float:yz,Float:zz,Float:xy,Float:yy,Float:zy,target;
	for(new i = 0, u = GetPlayerPoolSize(); i <= u;  i++)
	{	
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerNPC(i)) continue;
		if(NPCdere[i][dPool] == true) continue;
		GetPlayerPos(i,xy,yy,zy);
		for(new play = 0, j = GetPlayerPoolSize(); play <= j; play++)
		{
			// if(IsPlayerNPC(play)) continue; // Comment this in if you don't want the Zombeys to follow and hit themselves (looks sad tho)
			if(!IsPlayerInRangeOfPoint(play,40,xy,yy,zy)) continue;
			target = play;
			break;
		}
		GetPlayerPos(target,xz,yz,zz);
		if(IsPlayerInRangeOfPoint(target,2,xy,yy,zy))
		{
			ClearAnimations(i);
			NPCdere[i][dRecording] = 0;
			RNPC_StopPlayback(i);
			NPCdere[i][dRecording] = RNPC_CreateBuild_s(i,PLAYER_RECORDING_TYPE_ONFOOT);
			RNPC_SetKeys(4);
			RNPC_FinishBuild();
			RNPC_StartBuildPlayback(i,NPCdere[i][dRecording]);
		}
		else if(IsPlayerInRangeOfPoint(target,45,xy,yy,zy) && (floatround(zy) == floatround(zz) || floatround(zy) == floatround(zz) -1 || floatround(zy) == floatround(zz) +1))
		{
			MoveRNPC(i,xz-1+random(2),yz-1+random(2),zz,RNPC_SPEED_RUN);
		}
	}	
	return 1;
}

public OnZombeySpawn(zombieid)
{
	if(NPCdere[zombieid][dPool] == true)
	{
		SetPlayerPos(zombieid,0.0,0.0,0.0);
		SetPlayerVirtualWorld(zombieid,zombieid);
	}
	RNPC_SetShootable(zombieid,1);
	SetPlayerColor(zombieid,0xFFFFFF00);
	SetPlayerSkin(zombieid,ZombeySkins[random(sizeof ZombeySkins)]);
	return 1;
}

public ZombeyDisconnect()
{
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerNPC(i)) continue;
		Kick(i);
		NPCdere[i][dArea] = -1;
		NPCdere[i][dPool] = false;
	}
	return 1;
}

public DummyZombeys()
{
	new naem[MAX_PLAYER_NAME],DummyCount;
	format(naem,sizeof naem,"DummyNPC%d%d%d",random(400),random(300),random(100));
	DummyCount = ConnectRNPC(naem);
	if(DummyCount < DUMMY_QUANT) SetTimer("DummyZombeys",90,false);
	else {PoolZombeys(); SetTimer("DummyRemove",200 * MAX_ZOMBEY,false);}
	return 1;
}

public PoolZombeys()
{
	new name[MAX_PLAYER_NAME],zombey;
	format(name,sizeof name,"Z%d%d%d",random(10),random(200),random(500));
	zombey = ConnectRNPC(name);
	NPCdere[zombey][dArea] = -1;
	NPCdere[zombey][dPool] = true;
	if(zombey < DUMMY_QUANT + MAX_ZOMBEY) SetTimer("PoolZombeys",70,false);
	return 1;
}

public DummyRemove()
{
	for(new i = 0; i < DUMMY_QUANT; i++)
	{
		if(!IsPlayerNPC(i)) continue;
		Kick(i);
	}
	printf("[Zombeydere] %d Zombeys successfully spawned.",MAX_ZOMBEY);
	printf("[Zombeydere] %d Dummy zombies were kicked.",DUMMY_QUANT);
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA areaid)
{
	for(new zom = 1; zom < sizeof ZombeySpawns; zom++)
	{
		if(STREAMER_TAG_AREA areaid == dZombeySpawns[zom][0])
		{
			if(dZombeySpawns[zom][1] == 0)
			{
				RequestPoolZombeys(zom);
				dZombeySpawns[zom][1] = 1;
			}
		}
	}
	return 1;
}
	
public OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA areaid)
{
	for(new zom = 1; zom < sizeof ZombeySpawns; zom++)
	{
		if(STREAMER_TAG_AREA areaid == dZombeySpawns[zom][0])
		{
			ReturnPoolZombeys(zom);
		}
	}
	return 1;
}

public RequestPoolZombeys(zone)
{	
	new zombiecount = 0;
		
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerNPC(i))	continue;
		if(NPCdere[i][dPool] != true) continue;
		SetPlayerPos(i,ZombeySpawns[zone][0] - 15 + random(30),ZombeySpawns[zone][1] - 15 + random(30),ZombeySpawns[zone][2]);
		SetPlayerVirtualWorld(i,0);
		NPCdere[i][dArea] = zone;
		NPCdere[i][dPool] = false;
		zombiecount ++;
		if(zombiecount >= MAX_ZOMBEY_PER_AREA) break;
	}
	
	if(zombiecount <= floatround(MAX_ZOMBEY_PER_AREA / 2)) return ZombeyCleanUp();
	return 1;
}

public ReturnPoolZombeys(zone)
{
	for(new i = 0,j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(IsPlayerNPC(i)) continue;
		if(IsPlayerInDynamicArea(i,dZombeySpawns[zone][0])) return 1;
	}

	for(new i = 0,j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerNPC(i)) continue;
		if(NPCdere[i][dArea] != zone) continue;
		NPCdere[i][dArea] = -1;
		NPCdere[i][dPool] = true;
		SpawnPlayer(i);
	}
	dZombeySpawns[zone][1] = 0;
	return 1;
}

public ZombeyCleanUp()
{
	for(new i = 0,j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerNPC(i)) continue;
		if(NPCdere[i][dPool] == true) continue;
		ReturnPoolZombeys(NPCdere[i][dArea]);
	}
	return 1;
}

#endif 
