# Configure serial port for TSP controller
drvAsynIPPortConfigure("$(SYSPORT)_TSPC1","$(TSADR):4007")
drvAsynIPPortConfigure("$(SYSPORT)_TSPC2","$(TSADR):4008")
drvAsynIPPortConfigure("$(SYSPORT)_TSPC3","$(TSADR):4009")
drvAsynIPPortConfigure("$(SYSPORT)_TSPC4","$(TSADR):4010")

# Database for asynRecord
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:1},PORT=$(SYSPORT)_TSPC1,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:2},PORT=$(SYSPORT)_TSPC2,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:3},PORT=$(SYSPORT)_TSPC3,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:4},PORT=$(SYSPORT)_TSPC4,ADDR=0,OMAX=0,IMAX=0")

# Database for TSPC
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev={TSP:1},P=SR:$(CELL)-VA:G2-G6,PORT=$(SYSPORT)_TSPC1")
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev={TSP:2},P=$(SYS),PORT=$(SYSPORT)_TSPC2")
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev={TSP:3},P=$(SYS),PORT=$(SYSPORT)_TSPC3")
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev={TSP:4},P=$(SYS),PORT=$(SYSPORT)_TSPC4")

# Template allows TSP2, TSP3, TSP4 sublimation at the same time 
dbLoadRecords("$(VA_PACKAGE)/db/fe-tsp-3-download.template","Sys=$(SYS)")
