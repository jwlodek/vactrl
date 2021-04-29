TOP=../..

include $(TOP)/configure/CONFIG

#=============================
# Build the IOC application

PROD_IOC = vactrl
# vactrl.dbd will be created and installed
DBD += vactrl.dbd

# vactrl.dbd will be made up from these files:
vactrl_DBD += base.dbd
vactrl_DBD += asyn.dbd
vactrl_DBD += calc.dbd
vactrl_DBD += stream.dbd
vactrl_DBD += drvAsynIPPort.dbd
vactrl_DBD += aSubRecord.dbd
vactrl_DBD += system.dbd
vactrl_DBD += devIocStats.dbd
vactrl_DBD += asSupport.dbd
vactrl_DBD += ether_ip.dbd
vactrl_DBD += pressure.dbd
vactrl_DBD += devtimediff.dbd
vactrl_DBD += measValue.dbd
vactrl_DBD += ipParamSet.dbd
vactrl_DBD += subGVSevr.dbd
vactrl_DBD += caPutLog.dbd

# vactrl_registerRecordDeviceDriver.cpp derives from vactrl.dbd
vactrl_SRCS += vactrl_registerRecordDeviceDriver.cpp

vactrl_SRCS += pressure.c
vactrl_SRCS += devtimediff.c
vactrl_SRCS += measValue.c
vactrl_SRCS += ipParamSet.c
vactrl_SRCS += subGVSevr.c

# Build the main IOC entry point on workstation OSs.
vactrl_SRCS_DEFAULT += vactrlMain.cpp
vactrl_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#vactrl_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Link in the code from the support library
vactrl_LIBS += asyn calc stream sscan
vactrl_LIBS += devIocStats autosave ether_ip caPutLog

# NOTE: To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file

ifneq ($(SNCSEQ),)
    # Build sncExample into vactrlSupport
    vactrl_SNCFLAGS += +d
    vactrl_DBD += sncHidenRGA.dbd
    vactrl_DBD += sncTSP.dbd
    vactrl_SRCS += sncDegas.stt
    vactrl_SRCS += sncTSP.stt
    vactrl_LIBS += seq pv
    # The following builds sncProgram as a standalone application
    PROD_HOST += sncProgram
    sncProgram_SNCFLAGS += +m
    sncProgram_SRCS += sncProgram.st
    sncProgram_LIBS += seq pv
    sncProgram_LIBS += $(EPICS_BASE_HOST_LIBS)
endif

# Finally link to the EPICS Base libraries
vactrl_LIBS += $(EPICS_BASE_IOC_LIBS)

#=============================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

