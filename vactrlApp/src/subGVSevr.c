#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include <dbAccess.h>
#include <dbDefs.h>
#include <dbFldTypes.h>
#include <registryFunction.h>
#include <subRecord.h>
#include <epicsExport.h>
#include <recGbl.h>
#include <epicsTime.h>
#include <alarm.h>
#include <errlog.h>
#include <dbScan.h>

static long subGVSevrCalc(subRecord *prec) 
{
	int noAlarmCount = 0;
	int minorAlarmCount = 0;
	int majorAlarmCount = 0;
	int invalidAlarmCount = 0;
	double* pvalue = &prec->a;
	DBLINK* plink = &prec->inpa;

	int i = 0, n = 0;

	for (i = 0; i < 12; i++, pvalue++, plink++) 
	{
		if(DB_LINK == plink->type || CA_LINK == plink->type)
		{
/*			printf("index is %d\t", n);*/
			n++;
	        	if(*pvalue == 0)
        	    		noAlarmCount += 1;
	        	else if(*pvalue == 1)
        			minorAlarmCount += 1;
			else if(*pvalue == 2)
        	    		majorAlarmCount += 1;
			else if(*pvalue == 3)
            			invalidAlarmCount += 1;
		}
	}
		
        if(majorAlarmCount >= 1)
                prec->val = 2;
        else if(minorAlarmCount >= 1)
                prec->val = 1;
        else if(invalidAlarmCount >=1)
                prec->val = 3;  
        else if(noAlarmCount >= n)
                prec->val = 0;

/*	printf("\n value is %d\n", prec->val);*/
	return 0;
}

/* Register these symbols for use by IOC code: */
epicsRegisterFunction(subGVSevrCalc);


