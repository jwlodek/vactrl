TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

#----------------------------------------------------
#  Optimization of db files using dbst (DEFAULT: NO)
#DB_OPT = YES

#----------------------------------------------------
# Create and install (or just install)
# databases, templates, substitutions like this

#----------------------------------------------------
# If <anyname>.db template is not named <anyname>*.template add
# <anyname>_TEMPLATE = <templatename>
DB += mks937b_controller.db
DB += mks937b_ccg.db
DB += mks937b_pirg.db
DB += mks937b_relay_ccg.db
DB += mks937b_relay_pirg.db

DB += gammampc_controller.db
DB += gammampc_ip.db
DB += gammampc_setpoint.db

DB += hiden_rga_global.db
DB += hiden_rga_bar.db
DB += hiden_rga_prfl.db
DB += hiden_rga_mid.db
DB += hiden_rga_degas.db

DB += cn7500_controller.db
DB += cn7500_set.db

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

