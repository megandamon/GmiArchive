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
echo "Copying $yearDirectory to $ARCHIVE_DIR"
echo "------------------------"
echo ""


# check if year directory already exists in archive
echo "ssh $NED_USER@$MACH ls $ARCHIVE_DIR/$YEAR"
ssh $NED_USER@$MACH ls $ARCHIVE_DIR/$YEAR
export outputCode=$?

args = ""
if [ "$TRANSFER_CMD" == "cp" ]; then
	args = "-r"
fi

# if the archive year directory exists, then traverse each directory in $WORK_DIR/$YEAR
if [ "$outputCode" == "0" ]; then
	echo "archive directory exists: $outputCode"
	
	# first handle each sub-directory
	directories=( diagnostics run_info stations )
	for directory in "${directories[@]}"
	do
		
		echo "ssh $NED_USER@$MACH ls $ARCHIVE_DIR/$YEAR/$directory"
		ssh $NED_USER@$MACH ls $ARCHIVE_DIR/$YEAR/$directory
		export outputCode=$?
		
		# if the sub-directory already exists, copy the files over
		echo "$ARCHIVE_DIR/$YEAR/$directory exists? $outputCode"
		if [ "$outputCode" == "0" ]; then
			echo "Copying $directory files to existing archive directory."
			
			echo "ssh $NED_USER@$MACH $TRANSFER_CMD $yearDirectory/$directory/* $ARCHIVE_DIR/$YEAR/$directory"
			ssh $NED_USER@$MACH $TRANSFER_CMD $yearDirectory/$directory/* $ARCHIVE_DIR/$YEAR/$directory
			export outputCode=$?
			if [ "$outputCode" == "0" ]; then
				echo "Success copying files to existing directory"
			else
				echo "Error copying $directory files to existing directory"
				exit -1
			fi
		
		# if the sub-directory doesn't exist, then copy the whole sub-directory over	
		else			
			echo "Copying $directory to $ARCHIVE_DIR/$YEAR"
			
			echo "ssh $NED_USER@$MACH $TRANSFER_CMD $args $yearDirectory/$directory $ARCHIVE_DIR/$YEAR/"
			ssh $NED_USER@$MACH $TRANSFER_CMD $args $yearDirectory/$directory $ARCHIVE_DIR/$YEAR/
			export outputCode=$?
			if [ "$outputCode" == "0" ]; then
				echo "Success copying the entire directory"
			else
				echo "Error copying the directory $directory"
				exit -1
			fi
		fi	
		
		done	
		
		echo "Now copying netcdf files from $yearDirectory to $ARCHIVE_DIR/$YEAR"
		echo "ssh $NED_USER@$MACH $TRANSFER_CMD $yearDirectory/*.nc $ARCHIVE_DIR/$YEAR/"
		ssh $NED_USER@$MACH $TRANSFER_CMD $yearDirectory/*.nc $ARCHIVE_DIR/$YEAR/
		export outputCode=$?
		if [ "$outputCode" == "0" ]; then
			echo "Success copying the netcdf files in $WORK_DIR/$YEAR"
		else
			echo "Error copying the netcdf files in $WORK_DIR/$YEAR"
			exit -1
		fi
		

	
	



# if the year directory does not exist, then copy the entire thing
elif [ "$outputCode" == "2" ]; then	
	echo "$ARCHIVE_DIR/$YEAR does not exist: $outputCode"
	
	echo "ssh $NED_USER@$MACH $TRANSFER_CMD $yearDirectory $ARCHIVE_DIR."
	ssh $NED_USER@$MACH $TRANSFER_CMD $yearDirectory $ARCHIVE_DIR/
	export outputCode=$?
	
	if [ "$outputCode" == "0" ]; then
		echo "Success copying $yearDirectory to $ARCHIVE_DIR"
	else
		echo "Failed copying $yearDirectory to $ARCHIVE_DIR!!!"
		exit -1
	fi		
	
		
				
			
else
	echo "Don't understand this code:  $outputCode"
	exit -1
fi



echo "Success. Exiting"
exit 0

# now write task to see if file numbers match
echo "Remove: $yearDirectory"