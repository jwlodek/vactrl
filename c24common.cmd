#to suppress annoying CA beacon (send to "10.0.134.63:5065") error 
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST", "10.0.153.255")

## Register all support components
dbLoadDatabase("$(VA_PACKAGE)/dbd/vaCtrlPkg.dbd"
vaCtrlPkg_registerRecordDeviceDriver(pdbbase)

## Configure serial port for MKS937B gauge controller
drvAsynIPPortConfigure("$(SYSPORT)_VGC1","$(TSADR):4001")
drvAsynIPPortConfigure("$(SYSPORT)_VGC3","$(TSADR):4002")

## Configure serial port for Varian Dual Ion Pump Controller
drvAsynIPPortConfigure("$(SYSPORT)_IPC1","$(TSADR):4003")
drvAsynIPPortConfigure("$(SYSPORT)_IPC2","$(TSADR):4004")
drvAsynIPPortConfigure("$(SYSPORT)_IPC4","$(TSADR):4005")
drvAsynIPPortConfigure("$(SYSPORT)_IPC5","$(TSADR):4006")

## Configure serial port for Hiden RGA
drvAsynIPPortConfigure("$(SYSPORT)_G3RGAC1","$(G3RGAC1):5025")
drvAsynIPPortConfigure("$(SYSPORT)_G1RGAC1","$(G1RGAC1):5025")

# PLC initialization
EIP_buffer_limit(500)
drvEtherIP_init()
drvEtherIP_define_PLC("$(SYSPORT)_PLC","$(PLCADR)",0)
EIP_verbosity(6)

# Database for asynRecord
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={VGC:1},PORT=$(SYSPORT)_VGC1,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={VGC:3},PORT=$(SYSPORT)_VGC3,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={IPC:1},PORT=$(SYSPORT)_IPC1,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={IPC:2},PORT=$(SYSPORT)_IPC2,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={IPC:4},PORT=$(SYSPORT)_IPC4,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R={IPC:5},PORT=$(SYSPORT)_IPC5,ADDR=0,OMAX=0,IMAX=0")
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R=:G3{RGAC:1},PORT=$(SYSPORT)_G3RGAC1,ADDR=0,OMAX=0,IMAX=0")

# Database for VGC1
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_controller.template","Sys=$(SYS),Cntl={VGC:1},PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_ccg.template","Sys=$(SYS),Cntl={VGC:1},Dev=:G1{CCG:1},CHAN=1,SPNUM=1,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_ccg.template","Sys=$(SYS),Cntl={VGC:1},Dev=:G1{CCG:2},CHAN=3,SPNUM=5,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_pirg.template","Sys=$(SYS),Cntl={VGC:1},Dev=:G1{TCG:1},CHAN=5,SPNUM1=9,SPNUM2=10,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_ccg.template","Sys=$(SYS),Cntl={VGC:1},Dev=:G1{CCG:1},SPNUM=1,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_ccg.template","Sys=$(SYS),Cntl={VGC:1},Dev=:G1{CCG:2},SPNUM=5,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_pirg.template","Sys=$(SYS),Cntl={VGC:1},Dev=:G1{TCG:1},SPNUM=9,PORT=$(SYSPORT)_VGC1,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_pirg.template","Sys=$(SYS),Cntl={VGC:1},Dev=:G1{TCG:1},SPNUM=10,PORT=$(SYSPORT)_VGC1,ADR=253")

# Database for VGC3 
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_controller.template","Sys=$(SYS),Cntl={VGC:3},PORT=$(SYSPORT)_VGC3,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_ccg.template","Sys=$(SYS),Cntl={VGC:3},Dev=:G3{CCG:1},CHAN=1,SPNUM=1,PORT=$(SYSPORT)_VGC3,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_ccg.template","Sys=$(SYS),Cntl={VGC:3},Dev=:G5{CCG:1},CHAN=3,SPNUM=5,PORT=$(SYSPORT)_VGC3,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_pirg.template","Sys=$(SYS),Cntl={VGC:3},Dev=:G5{TCG:1},CHAN=5,SPNUM1=9,SPNUM2=10,PORT=$(SYSPORT)_VGC3,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_ccg.template","Sys=$(SYS),Cntl={VGC:3},Dev=:G3{CCG:1},SPNUM=1,PORT=$(SYSPORT)_VGC3,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_ccg.template","Sys=$(SYS),Cntl={VGC:3},Dev=:G5{CCG:1},SPNUM=5,PORT=$(SYSPORT)_VGC3,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_pirg.template","Sys=$(SYS),Cntl={VGC:3},Dev=:G5{TCG:1},SPNUM=9,PORT=$(SYSPORT)_VGC3,ADR=253")
dbLoadRecords("$(VA_PACKAGE)/db/mks937b_relay_pirg.template","Sys=$(SYS),Cntl={VGC:3},Dev=:G5{TCG:1},SPNUM=10,PORT=$(SYSPORT)_VGC3,ADR=253")

# Settings for VGC
dbLoadRecords("$(VA_PACKAGE)/db/cell-ccg-download.template","Sys=$(SYS)")
dbLoadRecords("$(VA_PACKAGE)/db/cell-tcg-download.template","Sys=$(SYS)")

# Database for IPC1
dbLoadRecords("$(VA_PACKAGE)/db/variandual_controller.template","Sys=$(SYS),Cntl={IPC:1},PORT=$(SYSPORT)_IPC1")
dbLoadRecords("$(VA_PACKAGE)/db/variandual_ip.template","Sys=$(SYS),Cntl={IPC:1},Dev=:G1{IP:1},CHAN=1,PORT=$(SYSPORT)_IPC1")

# Database for IPC2
dbLoadRecords("$(VA_PACKAGE)/db/variandual_controller.template","Sys=$(SYS),Cntl={IPC:2},PORT=$(SYSPORT)_IPC2")
dbLoadRecords("$(VA_PACKAGE)/db/variandual_ip.template","Sys=$(SYS),Cntl={IPC:2},Dev=:G2{IP:1},CHAN=1,PORT=$(SYSPORT)_IPC2")
dbLoadRecords("$(VA_PACKAGE)/db/variandual_ip.template","Sys=$(SYS),Cntl={IPC:2},Dev=:G3{IP:1},CHAN=2,PORT=$(SYSPORT)_IPC2")

# Database for IPC4
dbLoadRecords("$(VA_PACKAGE)/db/variandual_controller.template","Sys=$(SYS),Cntl={IPC:4},PORT=$(SYSPORT)_IPC4")
dbLoadRecords("$(VA_PACKAGE)/db/variandual_ip.template","Sys=$(SYS),Cntl={IPC:4},Dev=:G4{IP:1},CHAN=1,PORT=$(SYSPORT)_IPC4")
dbLoadRecords("$(VA_PACKAGE)/db/variandual_ip.template","Sys=$(SYS),Cntl={IPC:4},Dev=:G4{IP:2},CHAN=2,PORT=$(SYSPORT)_IPC4")

# Database for IPC5
dbLoadRecords("$(VA_PACKAGE)/db/variandual_controller.template","Sys=$(SYS),Cntl={IPC:5},PORT=$(SYSPORT)_IPC5")
dbLoadRecords("$(VA_PACKAGE)/db/variandual_ip.template","Sys=$(SYS),Cntl={IPC:5},Dev=:G5{IP:1},CHAN=1,PORT=$(SYSPORT)_IPC5")
dbLoadRecords("$(VA_PACKAGE)/db/variandual_ip.template","Sys=$(SYS),Cntl={IPC:5},Dev=:G6{IP:1},CHAN=2,PORT=$(SYSPORT)_IPC5")

# Database for G3 RGA
dbLoadRecords("$(VA_PACKAGE)/db/hiden_rga_global.template","Sys=$(SYS),Dev=:G3{RGA:1},PORT=$(SYSPORT)_G3RGAC1")
dbLoadRecords("$(VA_PACKAGE)/db/hiden_rga_bar.template","Sys=$(SYS),Dev=:G3{RGA:1},PORT=$(SYSPORT)_G3RGAC1")
dbLoadRecords("$(VA_PACKAGE)/db/hiden_rga_prfl.template","Sys=$(SYS),Dev=:G3{RGA:1},PORT=$(SYSPORT)_G3RGAC1")
dbLoadRecords("$(VA_PACKAGE)/db/hiden_rga_mid.template","Sys=$(SYS),Dev=:G3{RGA:1},PORT=$(SYSPORT)_G3RGAC1")
dbLoadRecords("$(VA_PACKAGE)/db/hiden_rga_degas.template","Sys=$(SYS),Dev=:G3{RGA:1},PORT=$(SYSPORT)_G3RGAC1")



