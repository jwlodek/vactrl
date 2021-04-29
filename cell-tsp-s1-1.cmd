# Database for asynRecord
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={TSPC:1},PORT=$(SYSPORT)_TSPC1,ADDR=0,OMAX=0,IMAX=0")

# Database for TSPC
dbLoadRecords("$(VA_PACKAGE)/db/varian_tsp.template","Sys=$(SYS),Dev=:G1{TSP:1},P=$(SYS):G1,PORT=$(SYSPORT)_TSPC1")

dbLoadRecords("$(VA_PACKAGE)/db/cell-tsp-s1-1-download.template","Sys=$(SYS)")



