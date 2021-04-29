# Configure serial port for TSP controller
drvAsynIPPortConfigure("$(FESYSPORT)_TSPC1","$(FETSADR):4007")
drvAsynIPPortConfigure("$(FESYSPORT)_TSPC2","$(FETSADR):4008")
drvAsynIPPortConfigure("$(FESYSPORT)_TSPC3","$(FETSADR):4009")
drvAsynIPPortConfigure("$(FESYSPORT)_TSPC4","$(FETSADR):4010")

# Database for asynRecord
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(FESYS),R={TSPC:1},PORT=$(FESYSPORT)_TSPC1,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(FESYS),R={TSPC:2},PORT=$(FESYSPORT)_TSPC2,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(FESYS),R={TSPC:3},PORT=$(FESYSPORT)_TSPC3,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(FESYS),R={TSPC:4},PORT=$(FESYSPORT)_TSPC4,ADDR=0,OMAX=0,IMAX=0")

# Database for TSPC
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(FESYS),Dev={TSP:1},PORT=$(FESYSPORT)_TSPC1")
#dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(FESYS),Dev={TSP:2},PORT=$(FESYSPORT)_TSPC2")
#dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(FESYS),Dev={TSP:3},PORT=$(FESYSPORT)_TSPC3")
#dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(FESYS),Dev={TSP:4},PORT=$(FESYSPORT)_TSPC4")

# Template allows TSP2, TSP3, TSP4 sublimation at the same time 
dbLoadRecords("$(VA_PACKAGE)/db/fe-tsp-3-download.template","Sys=$(FESYS)")
