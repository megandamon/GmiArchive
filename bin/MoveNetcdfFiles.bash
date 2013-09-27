#!/bin/bash

export workflowConfig=$NED_WORKING_DIR/WorkflowConfigs.bash
echo $workflowConfig
. $workflowConfig

echo "------------------------"
echo "NED_USER: $NED_USER"
echo "NED_WORKING_DIR: $NED_WORKING_DIR"
echo "------------------------"
echo ""

export yearDirectory=$WORK_DIR/completed/$YEAR
echo "----------------------------"
echo "Move station files to: $yearDirectory"
echo "------------------------"
echo ""



echo "ssh $NED_USER@$MACH mv $WORK_DIR/*.nc $yearDirectory"
ssh $NED_USER@$MACH mv $WORK_DIR/*.nc $yearDirectory
export outputCode=$?
echo "output:  $outputCode"

if [ "$outputCode" == "0" ]; then
	echo "Netcdf files moved to $yearDirectory"
elif [ "$outputCode" == "1" ]; then	
	echo "Netcdf NOT files moved to $yearDirectory"
else
	echo "Don't understand this code:  $outputCode"
	exit -1
fi

echo "ssh $NED_USER@$MACH ls $yearDirectory/*nc | wc -l"
numNetcdfFiles=`ssh $NED_USER@$MACH ls $yearDirectory/*nc | wc -l`
echo "num netcdf files: $numNetcdfFiles"
echo "export numNetcdfFiles=$numNetcdfFiles" >> $workflowConfig

	
echo "Success. Exiting"
exit 0