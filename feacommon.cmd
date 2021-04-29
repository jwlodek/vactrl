#to suppress annoying CA beacon (send to "10.0.134.63:5065") error 
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST", "10.0.153.255")

## Register all support components
dbLoadDatabase("$(VA_PACKAGE)/dbd/vaCtrlPkg.dbd"
vaCtrlPkg_registerRecordDeviceDriver(pdbbase)

## Configure serial port for MKS937B gauge controller
drvAsynIPPortConfigure("$(SYSPORT)_VGC1","$(TSADR):4001")
drvAsynIPPortConfigure("$(SYSPORT)_VGC2","$(TSADR):4002")

## Configure serial port for Varian Dual Ion Pump Controller
drvAsynIPPortConfigure("$(SYSPORT)_IPC1","$(TSADR):4003")
drvAsynIPPortConfigure("$(SYSPORT)_IPC2","$(TSADR):4004")

# PLC initialization
EIP_buffer_limit(500)
drvEtherIP_init()
drvEtherIP_define_PLC("$(SYSPORT)_PLC","$(PLCADR)",0)
EIP_verbosity(6)

# Database for asynRecord
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={VGC:1},PORT=$(SYSPORT)_VGC1,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={VGC:2},PORT=$(SYSPORT)_VGC2,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={IPC:1},PORT=$(SYSPORT)_IPC1,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={IPC:2},PORT=$(SYSPORT)_IPC2,ADDR=0,OMAX=0,IMAX=0")

# Database for VGC1
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_controller.template","Sys=$(SYS),Cntl={VGC:1},PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_ccg.template","Sys=$(SYS),Cntl={VGC:1},Dev={CCG:1},CHAN=1,SPNUM=1,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_ccg.template","Sys=$(SYS),Cntl={VGC:1},Dev={CCG:4},CHAN=3,SPNUM=5,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_pirg.template","Sys=$(SYS),Cntl={VGC:1},Dev={TCG:1},CHAN=5,SPNUM1=9,SPNUM2=10,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_pirg.template","Sys=$(SYS),Cntl={VGC:1},Dev={TCG:3},CHAN=6,SPNUM1=11,SPNUM2=12,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_ccg.template","Sys=$(SYS),Cntl={VGC:1},Dev={CCG:1},SPNUM=1,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_ccg.template","Sys=$(SYS),Cntl={VGC:1},Dev={CCG:4},SPNUM=5,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_pirg.template","Sys=$(SYS),Cntl={VGC:1},Dev={TCG:1},SPNUM=9,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_pirg.template","Sys=$(SYS),Cntl={VGC:1},Dev={TCG:1},SPNUM=10,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_pirg.template","Sys=$(SYS),Cntl={VGC:1},Dev={TCG:3},SPNUM=11,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_pirg.template","Sys=$(SYS),Cntl={VGC:1},Dev={TCG:3},SPNUM=12,PORT=$(SYSPORT)_VGC1,ADR=253")

# Database for VGC2 
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_controller.template","Sys=$(SYS),Cntl={VGC:2},PORT=$(SYSPORT)_VGC2,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_ccg.template","Sys=$(SYS),Cntl={VGC:2},Dev={CCG:2},CHAN=1,SPNUM=1,PORT=$(SYSPORT)_VGC2,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_ccg.template","Sys=$(SYS),Cntl={VGC:2},Dev={CCG:3},CHAN=3,SPNUM=5,PORT=$(SYSPORT)_VGC2,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_pirg.template","Sys=$(SYS),Cntl={VGC:2},Dev={TCG:2},CHAN=5,SPNUM1=9,SPNUM2=10,PORT=$(SYSPORT)_VGC2,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_ccg.template","Sys=$(SYS),Cntl={VGC:2},Dev={CCG:2},SPNUM=1,PORT=$(SYSPORT)_VGC2,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_ccg.template","Sys=$(SYS),Cntl={VGC:2},Dev={CCG:3},SPNUM=5,PORT=$(SYSPORT)_VGC2,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_pirg.template","Sys=$(SYS),Cntl={VGC:2},Dev={TCG:2},SPNUM=9,PORT=$(SYSPORT)_VGC2,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_pirg.template","Sys=$(SYS),Cntl={VGC:2},Dev={TCG:2},SPNUM=10,PORT=$(SYSPORT)_VGC2,ADR=253")

# Database for IPC1
dbLoadRecords("$(VA_PACKAGE)/db/variandual_controller.template","Sys=$(SYS),Cntl={IPC:1},PORT=$(SYSPORT)_IPC1")
dbLoadRecords("$(VA_PACKAGE)/db/variandual_ip.template","Sys=$(SYS),Cntl={IPC:1},Dev={IP:1},CHAN=1,PORT=$(SYSPORT)_IPC1")
dbLoadRecords("$(VA_PACKAGE)/db/variandual_ip.template","Sys=$(SYS),Cntl={IPC:1},Dev={IP:2},CHAN=2,PORT=$(SYSPORT)_IPC1")

# Database for IPC2
dbLoadRecords("$(VA_PACKAGE)/db/variandual_controller.template","Sys=$(SYS),Cntl={IPC:2},PORT=$(SYSPORT)_IPC2")
dbLoadRecords("$(VA_PACKAGE)/db/variandual_ip.template","Sys=$(SYS),Cntl={IPC:2},Dev={IP:3},CHAN=1,PORT=$(SYSPORT)_IPC2")
dbLoadRecords("$(VA_PACKAGE)/db/variandual_ip.template","Sys=$(SYS),Cntl={IPC:2},Dev={IP:4},CHAN=2,PORT=$(SYSPORT)_IPC2")

# Database for PLC
dbLoadRecords("$(VA_PACKAGE)/db/fea-plc.template","Sys=$(SYS),Dev={PLC},PLC=$(SYSPORT)_PLC")

# Average pressure
dbLoadRecords("$(VA_PACKAGE)/db/fea-avg-pressure.template","Sys=$(SYS)")

