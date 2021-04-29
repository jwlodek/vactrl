#to suppress annoying CA beacon (send to "10.0.134.63:5065") error 
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST", "10.0.153.255")

## Register all support components
dbLoadDatabase("$(VA_PACKAGE)/dbd/vaCtrlPkg.dbd"
vaCtrlPkg_registerRecordDeviceDriver(pdbbase)

