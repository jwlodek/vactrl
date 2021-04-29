# Database for G1IP2
dbLoadRecords("$(VA_PACKAGE)/db/variandual_ip.template","Sys=$(SYS),Cntl={IPC:1},Dev=:G1{IP:2},CHAN=2,PORT=$(SYSPORT)_IPC1")

# Settings for IPC
dbLoadRecords("$(VA_PACKAGE)/db/evencell-ip-download.template","Sys=$(SYS)")

# Database for average pressure
dbLoadRecords("$(VA_PACKAGE)/db/evencell-avg-pressure.template","Sys=$(SYS)")



