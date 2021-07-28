# iCharger-X8-Log-Parser
Simple parser that generates a csv of total time, charge v, charge a, cumulative charged Ah and pack voltage for concatenated Junsi iCharger X8 logs

Each time you restart charging, a new log file with the name 'X8/Log/LiFe1s_30&2A[Charge_XX].txt' is created, where 'Life1s_30&2A' is the charge profile name and 'XX' is a simple sequence. Create a single file with all the log data in it, update the '$file' variable to point to the file you created, and run it.

This is exceedingly simplistic and should be improved a lot if anyone plans to use it for any real use.

Example output;

```
$1;1;0;3;0;0;12268;3287;0;264;0;3288;0;0;0;0;0;0;0;44
$1;1;1000;3;0;0;12269;3286;0;264;0;3288;0;0;0;0;0;0;0;29
$1;1;2000;3;0;7;12268;3285;0;264;0;3288;0;0;0;0;0;0;0;27
$1;1;3000;3;0;94;12266;3289;0;264;0;3288;0;0;0;0;0;0;0;34
$1;1;4000;3;0;1205;12249;3332;0;264;0;3289;0;0;0;0;0;0;0;35
$1;1;5000;3;0;2235;12228;3373;5;265;0;3291;0;0;0;0;0;0;0;45
$1;1;6000;3;0;2948;12215;3403;12;266;0;3293;0;0;0;0;0;0;0;22
$1;1;7000;3;0;2997;12209;3405;20;266;0;3294;0;0;0;0;0;0;0;24
$1;1;8000;3;0;3002;12214;3407;28;267;0;3294;0;0;0;0;0;0;0;20
$1;1;9000;3;0;3000;12213;3407;37;267;0;3294;0;0;0;0;0;0;0;30
```

Decyphered (and possibly inaccurate) columns;

```
0        1     2           3        4        5             6         7          8            9       10   11         12   13   14   15   16   17   18  19
$1     ; 1   ; 756000    ; 3      ; 0      ; 300         ; 12283   ; 3621     ; 4515       ; 360   ; 0  ; 3600     ; 0  ; 0  ; 0  ; 0  ; 0  ; 0  ; 0 ; 34
ignore  mode   time (ms)   ignore   ignore   charge amps   input v   output v   charged Ah   Avg v   ?    cell 1 v   cell 2~8v
               % 1000                        % 100         % 1000    % 1000     % 1000       % 100        % 100
```

Modes:

````
Mode of Operation
mop[1]  = "Charging"
mop[2]  = "Discharging"
mop[3]  = "Monitor"
mop[4]  = "Waiting"
mop[5]  = "Motor burn-in"
mop[6]  = "Finished"
mop[7]  = "Error"
mop[8]  = "LIxx trickle"
mop[9]  = "NIxx trickle"
mop[10] = "Foam cut"
mop[11] = "Info"
mop[12] = "External-discharging"
```
