#!/bin/bash

export workflowConfig=$NED_WORKING_DIR/WorkflowConfigs.bash
echo $workflowConfig
. $workflowConfig

echo "------------------------"
echo "NED_USER: $NED_USER"
echo "NED_WORKING_DIR: $NED_WORKING_DIR"
echo "------------------------"
echo ""

export stationDirectory=$WORK_DIR/completed/$YEAR/stations
echo "----------------------------"
echo "Move station files to: $stationDirectory"
echo "------------------------"
echo ""



echo "ssh $NED_USER@$MACH mv $WORK_DIR/*profile.nc $stationDirectory"
ssh $NED_USER@$MACH mv $WORK_DIR/*profile.nc $stationDirectory
export outputCode=$?
echo "output:  $outputCode"


if [ "$outputCode" == "0" ]; then
	echo "Stations moved to $stationDirectory"
elif [ "$outputCode" == "1" ]; then	
	echo "Stations NOT moved to $stationDirectory"
else
	echo "Don't understand this code:  $outputCode"
	exit -1
fi

echo "----------------------------"
echo "Getting file count from: $stationDirectory"
echo "------------------------"
echo ""

echo "ssh $NED_USER@$MACH ls $stationDirectory/*nc | wc -l"
numStationFiles=`ssh $NED_USER@$MACH ls $stationDirectory/*nc | wc -l`
echo "num stations: $numStationFiles"
echo "export numStationFiles=$numStationFiles" >> $workflowConfig
	
echo "Success. Exiting"
exit 0