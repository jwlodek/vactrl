/*Huijuan: 03-09-2011*/

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include <dbAccess.h>
#include <dbDefs.h>
#include <dbFldTypes.h>
#include <registryFunction.h>
#include <aSubRecord.h>
#include <waveformRecord.h>
#include <epicsExport.h>
#include <epicsTime.h>

#define MASS_STRING	10
#define VAL_STRING	20
#define MASS_TOTAL	5000
#define MEAS_STRING	10000


int rga_subDebug = 0;

static long asubMeasInit(aSubRecord* pasub) 
{
	if (rga_subDebug)
        	printf("Record %s called asubInit(%p)\n",pasub->name, (void*) pasub);

	return 0; 
}

static long asubMeasBar(aSubRecord *pasub)
{
	char *aptr, *bptr;
	char massStr[MASS_STRING] = {0}, valStr[VAL_STRING] = {0}, timeStr[MASS_STRING] ={0};
	double massDbl[MASS_TOTAL] = {0.0}, valDbl[MASS_TOTAL] = {0.0};
	int measIndex = 0;
	long timeInt = 0;
	int stopInt = 0;
	int len, lenNext, i, j;	
	int arrayRst = 0, arrayProc = 0;
	static char measNext[MEAS_STRING];
	static char measEnd[50];
	char measStr[MEAS_STRING] = {0};
	static long n=1;
	
	if (rga_subDebug)
	{
		printf("Record %s called measBar(%p)\n",pasub->name, (void*) pasub);
	}

	/* Reset all buffers */
	memset(massDbl, 0, pasub->novd*sizeof(double));
	memset(valDbl, 0, pasub->nove*sizeof(double));
	memset(measStr, 0, MEAS_STRING*sizeof(char));

	/* Clear stop signal for new cycle */
	memcpy((int *)pasub->vala, &arrayRst, pasub->nova*sizeof(int));
	memcpy((int *)pasub->valb, &stopInt, pasub->novb*sizeof(int));
	memcpy((int *)pasub->valc, &arrayProc, pasub->novc*sizeof(int));	
	memcpy((long *)pasub->valf, &timeInt, pasub->nova*sizeof(long));
	
	/* Get the response with one data command */
	aptr = (char *)pasub->a;
	bptr = (char *)pasub->b;

	/* Check if there's value of last cycle */
	if(strcmp(measNext, "\0") != 0)
	{
		arrayRst = 1;
		lenNext = strlen(measNext);
		if(rga_subDebug)
		{
			printf("Measurements from last cycle is %s", measNext);
			printf("Measurements in current cycle is %s", aptr);
		}

		strcpy(aptr, strcat(measNext, aptr));
		
		if (rga_subDebug)
			printf("Measurements from start mass is %s \n", aptr);
		memset(measNext, 0, MEAS_STRING*sizeof(char));
	}

        /* Check if the end of the measurement is returned with data stop command */
        if(strcmp(bptr, "\0") != 0 && strcmp(measEnd, bptr) != 0)
	{
		strcpy(measEnd, bptr);
		len = strlen(bptr);

       	        if (bptr[len-1] == '!')
               	        strcat(aptr, measEnd);
                else
       	                strcat(aptr, "!");

		memset(bptr, 0, len*sizeof(char));
		if(rga_subDebug)
			printf("Response of data stop is %s, end of the measurements is %s\n", measEnd, aptr);
	}

	/* Ignore the following processing if no data returned */	
	if(strcmp(aptr, "\0")== 0)
	{
		arrayProc = 1;
		memcpy((int *)pasub->valc, &arrayProc, pasub->novc*sizeof(int));	
		return (0);
	}
	else
	{
		len = strlen(aptr);	
		if (rga_subDebug)
			printf("Measurements from start mass is %s \n", aptr);
	}

	/* The first response of data command is as [/ 0/{\r\n */
	/* The format of measurement is as 92.00: 3.18468E-7,93.00: 3.16447E-7,94.00: 3.23166E-7,95.00: 3.20478E-7,96.00: 3.16447E-7,\r\n*/
	for( i = 0; i < len; i++ )
	{
		/* Check if it's the end of the cycle */	
		if(aptr[i] == '!')
		{
			stopInt = 1;
			n = 1;
			if (rga_subDebug)
				printf("stopInt is %d\n",  stopInt);
			break;
		}
        	
		if(aptr[i] == '}' && aptr[i+1] == ']')
		{

			/* Check if it's the end of whole scan cycle */
			/* If yes, stop data polling and end the process */
			if(aptr[i+2] == '!')
			{
				stopInt = 1;
				n = 1;
				if (rga_subDebug)
					printf("stopInt is %d\n",  stopInt);

				if(rga_subDebug)
					printf("This is the last cycle\n");
				break;
			}
			else
			{
				strncpy(measNext, &aptr[i+2], len-i-3);    
				if(rga_subDebug)
					printf("End of this cycle, next measure is %s", measNext);

				n++;
				if(rga_subDebug)	
					printf("This is the %ld cycle\n", n);
				break;
			}
		}

		/* Check if it's the separation for each mass use, measurement group */
		if(aptr[i] == ',' || aptr[i] == '{' || aptr[i] == '\r' || aptr[i] == '\n')
			continue;
	
		/* Check if it's the measurement time for each scan */
		if(aptr[i] == '[' && aptr[i+1] == '/')
		{
			j = 0;
			while( aptr[i+2+j] != '/')
				j++;
			
			strncpy(timeStr, &aptr[i+2], j);
			timeStr[j] = '\0';
			timeInt = atoi(timeStr);
			i = i+2+j;
			if (rga_subDebug)
			{
				printf("Time end is %c, j= %d, time string is %s ", aptr[i], j, timeStr); 
				printf("Time is %ld\n", timeInt);
			}
		}
				
		/* Check if it's the mass use */	
		/* Check if the mass is single figure */
		if(aptr[i] >= '0' && aptr[i] <= '9' && aptr[i+1] == '.' && aptr[i+4] == ':')	
		{
			strncpy(massStr, &aptr[i], 4);
			massStr[5] = '\0';
			massDbl[measIndex] = atof(massStr);
			i = i+5;
			if (rga_subDebug)
			{
				printf("Mass end is %c, mass string is %s ", aptr[i], massStr); 
				printf("Index is %d, mass is %f\t", measIndex, massDbl[measIndex]);
			}		
		}

		/* Check if the mass is double figure */
		if(aptr[i] >= '0' && aptr[i] <= '9' && aptr[i+2] == '.' && aptr[i+5] == ':') 
		{
			strncpy(massStr, &aptr[i], 5);
			massStr[6] = '\0';
			massDbl[measIndex] = atof(massStr);
			i = i+6;
			
			if (rga_subDebug)
			{
				printf("Mass end is %c, mass string is %s ", aptr[i], massStr); 
				printf("Index is %d, mass is %f\t", measIndex, massDbl[measIndex]);
			}		
		}

		/* Check if the mass is three figures */
		if(aptr[i] == '1' && aptr[i+3] == '.' && aptr[i+6] == ':')
		{
			strncpy(massStr, &aptr[i], 6);
			massStr[7] = '\0';
			massDbl[measIndex] = atof(massStr);
			i = i+7;
			if (rga_subDebug)
			{
				printf("Mass end is %c, mass string is %s ", aptr[i], massStr); 
				printf("Index is %d, mass is %f\t", measIndex, massDbl[measIndex]);
			}		
		}
		
		/* Check if it's the measured value */	
        	if((aptr[i] == ' '||aptr[i] == '-') && (aptr[i+1] >= '0' && aptr[i+1] <= '9' ))
		{
			j = 1;
			while(aptr[i+j] != ',')
				j++;
			strncpy(valStr, &aptr[i], j);
			valStr[j] = '\0';
			valDbl[measIndex] = atof(valStr);
			i = i+j;
			if (rga_subDebug)
			{
				printf("Measurement end is %c, j is %d, val string is %s ", aptr[i], j, valStr); 
				printf("The val is %e\n", valDbl[measIndex]);
			}
			measIndex++;	
		}
		
	}

	memcpy((int *)pasub->vala, &arrayRst, pasub->nova*sizeof(int));
	memcpy((int *)pasub->valb, &stopInt, pasub->novb*sizeof(int));
	memcpy((int *)pasub->valc, &arrayProc, pasub->novc*sizeof(int));
	memcpy((double *)pasub->vald, massDbl, pasub->novd*sizeof(double));
	memcpy((double *)pasub->vale, valDbl, pasub->nove*sizeof(double));
	memcpy((long *)pasub->valf, &timeInt, pasub->novf*sizeof(long));
	memcpy((int *)pasub->valg, &measIndex, pasub->novg*sizeof(int));
	memcpy((int *)pasub->valh, &measIndex, pasub->novh*sizeof(int));
	memcpy((int *)pasub->vali, &n, pasub->novi*sizeof(int));

	/* Reset all buffers */
	memset(aptr, 0, len*sizeof(char));
	memset(massDbl, 0, pasub->novd*sizeof(double));
	memset(valDbl, 0, pasub->nove*sizeof(double));

	pasub->pact = FALSE;

	return(0);
}

static long asubMeasMID(aSubRecord *pasub)
{
	char *aptr;
	char massStr[MASS_STRING] = {0}, valStr[VAL_STRING] = {0};
	int mass1, mass2, mass3, mass4, mass5, mass;
	int *masstemp;
	double mass1Val = 0.0, mass2Val = 0.0, mass3Val = 0.0, mass4Val = 0.0, mass5Val = 0.0, massVal = 0.0;
	int stopInt = 0;
	int len, i, j;	
	int mass1Proc = 0, mass2Proc = 0, mass3Proc = 0, mass4Proc = 0, mass5Proc = 0;

	if (rga_subDebug)
	{
		printf("Record %s called measMID(%p)\n",pasub->name, (void*) pasub);
	}

	/* Clear stop signal for new cycle */
	memcpy((int *)pasub->vala, &stopInt, pasub->nova*sizeof(int));
	memcpy((int *)pasub->valb, &mass1Proc, pasub->novb*sizeof(int));
	memcpy((int *)pasub->valc, &mass2Proc, pasub->novc*sizeof(int));
	memcpy((int *)pasub->vald, &mass3Proc, pasub->novd*sizeof(int));
	memcpy((int *)pasub->vale, &mass4Proc, pasub->nove*sizeof(int));
	memcpy((int *)pasub->valf, &mass5Proc, pasub->novf*sizeof(int));

	/* Get the response with one data command */
	aptr = (char *)pasub->a;
	if (rga_subDebug)
		printf("Measurements is %s \n", aptr);
	
	masstemp = (int *)pasub->b;
	if (masstemp[0] != 0)
		mass1 = masstemp[0];
	masstemp = (int *)pasub->c;
	if (masstemp[0] != 0)
               	mass2 = masstemp[0];
	masstemp = (int *)pasub->d;
       	if (masstemp[0] != 0)
		mass3 = masstemp[0];
	masstemp = (int *)pasub->e;
        if (masstemp[0] != 0)
                mass4 = masstemp[0];
	masstemp = (int *)pasub->f;
        if (masstemp[0] != 0)
                mass5 = masstemp[0];

	/* Ignore the following processing if no data returned */	
	len = strlen(aptr);
	if(strcmp(aptr, "\0")== 0)
	{
		return (0);
	}

	if (rga_subDebug)
		printf(" string = %s \n", aptr);

	/* The format of measurement is as [2.00: 3.18468E-7,18.00: 3.16447E-7,28.00: 3.23166E-7,]\r\n */
	/* The end of scan cycle is as !\r\n */
	for( i = 0; i < len; i++ )
	{
		/* Check if it's the end of the cycle */	
		if(aptr[i] == '!' )
		{
			stopInt = 1;
			if (rga_subDebug)
				printf("stopInt is %d\n",  stopInt);
			break;
		}
        	

		/* Check if it's the separation for each mass use, measurement group */
		if(aptr[i] == ','|| aptr[i] == '\r' || aptr[i] == '\n' || aptr[i] == ']')
			continue;
	
		/* Check if it's the start or end of each scan*/
		if(aptr[i] == '[' )
			i = i+1;

		/* Check if it's the mass use */	
		/* Check if the mass is single figure */
		if(aptr[i] >= '0' && aptr[i] <= '9' && aptr[i+1] == '.' && aptr[i+4] == ':')	
		{
			strncpy(massStr, &aptr[i], 4);
			massStr[5] = '\0';
			mass = atof(massStr);
			i = i+5;
		}
		
		/* Check if the mass is double figure */
		else if(aptr[i] >= '0' && aptr[i] <= '9' && aptr[i+2] == '.' && aptr[i+5] == ':') 
		{
			strncpy(massStr, &aptr[i], 5);
			massStr[6] = '\0';
			mass = atoi(massStr);
			i = i+6;
		}

		/* Check if the mass is three figures */
		else if(aptr[i] == '1' && aptr[i+3] == '.' && aptr[i+6] == ':')
		{
			strncpy(massStr, &aptr[i], 6);
			massStr[7] = '\0';
			mass = atof(massStr);
			i = i+7;
		}

		/* Check if it's the measured value */	
        	if((aptr[i] == ' '||aptr[i] == '-') && (aptr[i+1] >= '0' && aptr[i+1] <= '9' ))
		{
			j = 1;
			while(aptr[i+j] != ',')
				j++;
			strncpy(valStr, &aptr[i], j);
			valStr[j] = '\0';
			massVal = atof(valStr);
			i = i+j;
			if (rga_subDebug)
			{
				printf("The mass and val is %d:%e\n", mass, massVal);
			}
		}
		
		if(mass == mass1)
		{
			mass1Proc = 1;
			mass1Val = massVal;
		}
		else if (mass == mass2)
		{
			mass2Proc = 1;
			mass2Val = massVal;
		}
		else if (mass == mass3)
		{
			mass3Proc = 1;
        	        mass3Val = massVal;
		}
		else if (mass == mass4)
		{
			mass4Proc = 1;
        	        mass4Val = massVal;
		}
		else if (mass == mass5)
		{
			mass5Proc = 1;
        	        mass5Val = massVal;
		}
	}
 
	memcpy((int *)pasub->vala, &stopInt, pasub->nova*sizeof(int));
	memcpy((int *)pasub->valb, &mass1Proc, pasub->novb*sizeof(int));
	memcpy((int *)pasub->valc, &mass2Proc, pasub->novc*sizeof(int));
	memcpy((int *)pasub->vald, &mass3Proc, pasub->novd*sizeof(int));
	memcpy((int *)pasub->vale, &mass4Proc, pasub->nove*sizeof(int));
	memcpy((int *)pasub->valf, &mass5Proc, pasub->novf*sizeof(int));	
	memcpy((double *)pasub->valg, &mass1Val, pasub->novg*sizeof(double));
        memcpy((double *)pasub->valh, &mass2Val, pasub->novh*sizeof(double));
        memcpy((double *)pasub->vali, &mass3Val, pasub->novi*sizeof(double));
        memcpy((double *)pasub->valj, &mass4Val, pasub->novj*sizeof(double));
        memcpy((double *)pasub->valk, &mass5Val, pasub->novk*sizeof(double));
			
	/* Reset all buffers */
	memset(aptr, 0, len*sizeof(char));

	return(0);
}

static long asubMeasProc(aSubRecord *pasub)
{
	DBLINK *plink = NULL;
	DBADDR *paddr = NULL;
	waveformRecord *pwf = NULL;
	double tempMass[MASS_TOTAL], tempVal[MASS_TOTAL];
	int i, nPoints;

	nPoints = pasub->nea;
	if(rga_subDebug)
		printf("nea is %d\n", pasub->nea);
	
	/* Reset all buffers */
	memset(tempMass, 0, nPoints*sizeof(double));
	memset(tempVal, 0, nPoints*sizeof(double));

	memcpy(tempMass, (double *)pasub->a, nPoints*sizeof(double));
	memcpy(tempVal, (double *)pasub->b, nPoints*sizeof(double));

	if(rga_subDebug)
	{
		for( i=0; i < nPoints; i++)
        	{
                	printf("%f:%e\t",tempMass[i], tempVal[i]);
		
		}
        }

	plink = &pasub->outa;
	if(DB_LINK != plink->type)
		return -1;
	paddr = (DBADDR *)plink->value.pv_link.pvt;
	pwf = (waveformRecord *)paddr->precord;
	pwf->nelm = nPoints;
	pwf->nord = nPoints;
	memcpy((double *)pasub->vala, tempMass, nPoints*sizeof(double));
	
	
	plink = &pasub->outb;
	if(DB_LINK != plink->type)
		return -1;
	paddr = (DBADDR *)plink->value.pv_link.pvt;
	pwf = (waveformRecord *)paddr->precord;
	pwf->nelm = nPoints;
	pwf->nord = nPoints;
	memcpy((double *)pasub->valb, tempVal, nPoints*sizeof(double));
	
	return (0);
	
}

static long asubPrflDispInit(aSubRecord* pasub) 
{
	if (rga_subDebug)
        	printf("Record %s called asubPrflDispInit(%p)\n",pasub->name, (void*) pasub);

	return 0; 
}

static long asubPrflDispProc(aSubRecord *pasub)
{
	int nPos, nNORD, nPoints;
	double massDisp[MASS_TOTAL], valDisp[MASS_TOTAL];
	double massWf[MASS_TOTAL], massBuf[MASS_TOTAL];
	double valWf[MASS_TOTAL], valBuf[MASS_TOTAL];
	double posDisp[MASS_TOTAL];
	int i, *temp;
	DBLINK *plink = NULL;
	DBADDR *paddr = NULL;
	waveformRecord *pwf = NULL;

	if (rga_subDebug)
        	printf("Record %s called asubPrflDispProc(%p)\n",pasub->name, (void*) pasub);

	nNORD = pasub->nea;
	nPos = pasub->neb;
	temp = (int *)pasub->e;
	nPoints = temp[0];
/*	memcpy(&nPoints, (double *)pasub->e, sizeof(double));*/

	if(rga_subDebug)
		printf("NORD, nPos, nPoints are %d, %d, %d\n", nNORD, nPos, nPoints);

	/* Reset all buffers */
	memset(massDisp, 0, nPoints*sizeof(double));
      memset(valDisp, 0, nPoints*sizeof(double));
	memset(massWf, 0, nPoints*sizeof(double));
      memset(valWf, 0, nPoints*sizeof(double));
	memset(massBuf, 0, nPoints*sizeof(double));
      memset(valBuf, 0, nPoints*sizeof(double));
	memset(posDisp, 0, nPoints*sizeof(double));

	memcpy(massWf, (double *)pasub->a, nNORD*sizeof(double));
	memcpy(massBuf, (double *)pasub->b, nPos*sizeof(double));
	memcpy(valWf, (double *)pasub->c, nNORD*sizeof(double));
	memcpy(valBuf, (double *)pasub->d, nPos*sizeof(double));

	if(nNORD == nPoints)
	{
		memcpy(massDisp, (double *)pasub->a, nPoints*sizeof(double));
		for(i=0; i<nPos; i++)
			valDisp[i] = valBuf[i];
		for(i=nPos; i<nPoints; i++)
			valDisp[i] = valWf[i];		
	}
	else 
	{
		memcpy(massDisp, (double *)pasub->b, nPos*sizeof(double));
		memcpy(valDisp, (double *)pasub->d, nPos*sizeof(double));
        }

	posDisp[nPos-1] = 1e-8;

	plink = &pasub->outa;
	if(DB_LINK != plink->type)
		return -1;
	paddr = (DBADDR *)plink->value.pv_link.pvt;
	pwf = (waveformRecord *)paddr->precord;
	pwf->nelm = nPoints;
	pwf->nord = nPoints;
	memcpy((double *)pasub->vala, massDisp, nPoints*sizeof(double));

	plink = &pasub->outb;
      if(DB_LINK != plink->type)
        	return -1;
	paddr = (DBADDR *)plink->value.pv_link.pvt;
	pwf = (waveformRecord *)paddr->precord;
	pwf->nelm = nPoints;
	pwf->nord = nPoints;
	memcpy((double *)pasub->valb, valDisp, nPoints*sizeof(double));

	plink = &pasub->outc;
      if(DB_LINK != plink->type)
        	return -1;
	paddr = (DBADDR *)plink->value.pv_link.pvt;
	pwf = (waveformRecord *)paddr->precord;
	pwf->nelm = nPoints;
	pwf->nord = nPoints;
	memcpy((double *)pasub->valc, posDisp, nPoints*sizeof(double));
	
	return (0);
}

/* Register these symbols for use by IOC code: */
epicsExportAddress(int, rga_subDebug);
epicsRegisterFunction(asubMeasInit);
epicsRegisterFunction(asubMeasBar);
epicsRegisterFunction(asubMeasMID);
epicsRegisterFunction(asubMeasProc);
epicsRegisterFunction(asubPrflDispInit);
epicsRegisterFunction(asubPrflDispProc);

