# Database for asynRecord
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:1A},PORT=$(SYSPORT)_TSPC1A,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:1B},PORT=$(SYSPORT)_TSPC1B,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:1C},PORT=$(SYSPORT)_TSPC1C,ADDR=0,OMAX=0,IMAX=0")

# Database for TSPC
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev=:G1{TSP:1},P=$(SYS):G1,PORT=$(SYSPORT)_TSPC1A")
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev=:G1{TSP:2},P=$(SYS):G1,PORT=$(SYSPORT)_TSPC1B")
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev=:G1{TSP:3},P=$(SYS):G1,PORT=$(SYSPORT)_TSPC1C")

# Template allows TSP sublimation at the same time in S1
dbLoadRecords("$(VA_PACKAGE)/db/cell-tsp-s1-3-download.template","Sys=$(SYS)")



