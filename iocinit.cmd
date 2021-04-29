# Database for control
dbLoadRecords("$(VA_PACKAGE)/db/iocAdminSoft.db", "IOC=$(CTSYS){IOC:VA}")
dbLoadRecords("$(VA_PACKAGE)/db/save_restoreStatus.db", "P=$(CTSYS){IOC:VA}")
save_restoreSet_status_prefix("$(CTSYS){IOC:VA}")

set_savefile_path("${PWD}/as","/save")
set_requestfile_path("${PWD}/as","/req")
set_pass0_restoreFile("ioc_values.sav")

# Access control
asSetFilename("/cf-update/acf/default.acf")
caPutLogInit("ioclog.cs.nsls2.local:7004",1)

iocInit
dbl > records.dbl
system "cp records.dbl /cf-update/$HOSTNAME.$IOCNAME.dbl"

makeAutosaveFileFromDbInfo("as/req/ioc_values.req","autosaveFields_pass0")
create_monitor_set("ioc_values.req",5,"")




