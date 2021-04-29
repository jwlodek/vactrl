#to suppress annoying CA beacon (send to "10.0.134.63:5065") error 
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST", "10.0.153.255")

## Register all support components
dbLoadDatabase("$(VA_PACKAGE)/dbd/vaCtrlPkg.dbd"
vaCtrlPkg_registerRecordDeviceDriver(pdbbase)

## Configure serial port for Hiden RGA
drvAsynIPPortConfigure("$(SYSPORT)_G3RGAC1","$(SYSG3RGAC1):5025")
drvAsynIPPortConfigure("$(SYSPORT)_G1RGAC1","$(SYSG1RGAC1):5025")

# Database for asynRecord
dbLoadRecords("$(VA_PACKAGE)/db/asynRecord.template","P=$(SYS),R=:G3{RGAC:1},PORT=$(SYSPORT)_G3RGAC1,ADDR=0,OMAX=0,IMAX=0")

# Database for G3 RGA
dbLoadRecords("$(VA_PACKAGE)/db/hiden_rga_global.template","Sys=$(SYS),Dev=:G3{RGA:1},PORT=$(SYSPORT)_G3RGAC1")
dbLoadRecords("$(VA_PACKAGE)/db/hiden_rga_bar.template","Sys=$(SYS),Dev=:G3{RGA:1},PORT=$(SYSPORT)_G3RGAC1")
dbLoadRecords("$(VA_PACKAGE)/db/hiden_rga_prfl.template","Sys=$(SYS),Dev=:G3{RGA:1},PORT=$(SYSPORT)_G3RGAC1")
dbLoadRecords("$(VA_PACKAGE)/db/hiden_rga_mid.template","Sys=$(SYS),Dev=:G3{RGA:1},PORT=$(SYSPORT)_G3RGAC1")
dbLoadRecords("$(VA_PACKAGE)/db/hiden_rga_degas.template","Sys=$(SYS),Dev=:G3{RGA:1},PORT=$(SYSPORT)_G3RGAC1")

# Database for control
dbLoadRecords("$(VA_PACKAGE)/db/iocAdminSoft.db", "IOC=$(CTSYS){IOC:VA_RGA}")
dbLoadRecords("$(VA_PACKAGE)/db/save_restoreStatus.db", "P=$(CTSYS){IOC:VA_RGA}")
save_restoreSet_status_prefix("$(CTSYS){IOC:VA_RGA}")

set_savefile_path("${PWD}/as","/save")
set_requestfile_path("${PWD}/as","/req")
set_pass0_restoreFile("ioc_values.sav")

# Access control
asSetFilename("/epics/iocs/CtrSwitch.acf")
asSetSubstitutions("P=CtrlSwitch:")




