# Zombeydere
Simple script with RNPC and Icognito's Streamer to create Zombie NPCs

*[ENGLISH]*

IMPORTANT: Add the following line on top of your gamemode's OnPlayerConnect and OnPlayerSpawn callbacks.

`if(IsPlayerNPC(playerid)) return 1;`

How to use?

Open the Zombeydere.pwn file and find the following:

```
#define DUMMY_QUANT
#define MAX_ZOMBEY
#define MAX_ZOMBEY_PER_AREA
```

Although their names can give you a hint, i'll explain what each one of these settings do:

`DUMMY_QUANT` is the quantity of dummy npcs that will connect to your server before the actual NPCs (zombies). This is made in order to keep player IDs and NPC IDs separated from eachother. Default is 100. There's no limit set but keep the MAX below 400.

`MAX_ZOMBEY` is the quantity of zombeys that will connect to your server. They connect once the filterscript starts and will be kept in a pool of zombies until called to spawn in a certain zone. Default is 100. There's no limit set but keep the MAX below 400.

`MAX_ZOMBEY_PER_AREA` is the number of zombeys that will spawn in the areas. Default is 10. There's no limit set but keep the MAX below 20.

*[ESPAÑOL]*

IMPORTANTE: Añade la siguiente linea en el tope de las callbacks OnPlayerConnect y OnPlayerSpawn de tu gamemode.

`if(IsPlayerNPC(playerid)) return 1;`

¿Como usar?

Abre el archivo Zombeydere.pwn y busca lo siguiente:

```
#define DUMMY_QUANT
#define MAX_ZOMBEY
#define MAX_ZOMBEY_PER_AREA
```

Aunque sus nombres pueden darte una idea, explicaré que hace cada una de esas opciones:

`DUMMY_QUANT` es la cantidad de 'dummy' npc que se conectarán a tu servidor antes de los NPC reales (zombies). Esto está hecho para separar las IDs de los jugadores con las IDs de los NPC. El valor por defecto es 100. No hay un limite concreto pero mantengan el máximo por debajo de 400.

`MAX_ZOMBEY` es la cantidad de zombeys que conectarán a tu servidor. Los mismos conectarán una vez se inicie el filterscript y permanecerán en una piscina de zombeys hasta que sean llamados para spawnear en una cierta zona. El valor por defecto es 100. No hay un limite concreto pero mantengan el máximo por debajo de 400.

`MAX_ZOMBEY_PER_AREA` es el número de zombies que spawnearán por cada área. El valor por defecto es 10. No hay un limite concreto pero mantengan el máximo por debajo de 20.
