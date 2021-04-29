# Database for asynRecord
#dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:2},PORT=$(SYSPORT)_TSPC2,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:3},PORT=$(SYSPORT)_TSPC3,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:4A},PORT=$(SYSPORT)_TSPC4A,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:4B},PORT=$(SYSPORT)_TSPC4B,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:5},PORT=$(SYSPORT)_TSPC5,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:6},PORT=$(SYSPORT)_TSPC6,ADDR=0,OMAX=0,IMAX=0")

# Database for TSPC
#dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev=:G2{TSP:1},P=$(SYS):G2-G6,PORT=$(SYSPORT)_TSPC2")
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev=:G3{TSP:1},P=$(SYS):G2-G6,PORT=$(SYSPORT)_TSPC3")
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev=:G4{TSP:1},P=$(SYS):G2-G6,PORT=$(SYSPORT)_TSPC4A")
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev=:G4{TSP:2},P=$(SYS):G2-G6,PORT=$(SYSPORT)_TSPC4B")
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev=:G5{TSP:1},P=$(SYS):G2-G6,PORT=$(SYSPORT)_TSPC5")
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev=:G6{TSP:1},P=$(SYS):G2-G6,PORT=$(SYSPORT)_TSPC6")

# Template allows TSP sublimation at the same time from S2 to S6 and FE
dbLoadRecords("$(VA_PACKAGE)/db/c30-tsp-with-fe-download.template","Sys=$(SYS),FE_Sys=FE:$(CELL)B-VA")


