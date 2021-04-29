# Database for control
dbLoadRecords("$(VA_PACKAGE)/db/iocAdminSoft.db", "IOC=$(CTSYS){IOC:VA_TSP}")
dbLoadRecords("$(VA_PACKAGE)/db/save_restoreStatus.db", "P=$(CTSYS){IOC:VA_TSP}")
save_restoreSet_status_prefix("$(CTSYS){IOC:VA_TSP}")

set_savefile_path("${PWD}/as","/save")
set_requestfile_path("${PWD}/as","/req")
set_pass0_restoreFile("ioc_values.sav")

# Access control
asSetFilename("/epics/iocs/CtrSwitch.acf")
asSetSubstitutions("P=CtrlSwitch:")

iocInit

dbl > records.dbl
system "cp records.dbl /cf-update/$HOSTNAME.$IOCNAME.dbl"

makeAutosaveFileFromDbInfo("as/req/ioc_values.req","autosaveFields_pass0")
create_monitor_set("ioc_values.req",5,"")

