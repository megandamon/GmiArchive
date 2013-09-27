#!/bin/bash

export workflowConfig=$NED_WORKING_DIR/WorkflowConfigs.bash
echo $workflowConfig
. $workflowConfig

echo "------------------------"
echo "NED_USER: $NED_USER"
echo "NED_WORKING_DIR: $NED_WORKING_DIR"
echo "------------------------"
echo ""

export archiveDirectory=$ARCHIVE_DIR/$YEAR
echo "----------------------------"
echo "Checking files in : $archiveDirectory"
echo "------------------------"
echo ""

export diagDirectory=$archiveDirectory/diagnostics
export stationDirectory=$archiveDirectory/stations


echo "ssh $NED_USER@$MACH ls $diagDirectory/*$YEAR*nc"
numArchiveDiagFiles=`ssh $NED_USER@$MACH ls $diagDirectory/*$YEAR*nc`
echo $numArchiveDiagFiles
echo "check with: $numDiagFiles"

echo "ssh $NED_USER@$MACH ls $stationDirectory/*$YEAR*nc"
numArchiveStationFiles=`ssh $NED_USER@$MACH ls $stationDirectory/*$YEAR*nc`
echo $numArchiveStationFiles
echo "check with: $numStationFiles"

echo "ssh $NED_USER@$MACH ls $archiveDirectory/*$YEAR*nc"
numArchiveDirectoryFiles=`ssh $NED_USER@$MACH ls $archiveDirectory/*$YEAR*nc`
echo $numArchiveDirectoryFiles
echo "check with: $numNetcdfFiles"
 
echo "Success. Exiting"
exit 0