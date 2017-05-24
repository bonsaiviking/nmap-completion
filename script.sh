# Script which helps to complete --script-args option based on --script

# Setting the main path to $NMAPDIR
if [ -z "$NMAPDIR" ]; then
    [ -d "/usr/share/nmap" ] && NMAPDIR="/usr/share/nmap"
    [ -d "/usr/local/share/nmap" ] && NMAPDIR="/usr/local/share/nmap"
fi

if [ -d "$NMAPDIR"]; then

    # Creating a new folder called script-args
    # inside scripts folder
    cd "$NMAPDIR/scripts/"
    # If already folder exists, an error is thrown
    # and its handled appropriately.
    mkdir "script-args" 2>/dev/null
    cd "script-args"

    # Iterating through all the lines and processing the data
    while IFS='' read -r line || [[ -n "$line" ]]; do
        
    	# Working of this script.

        # Format in the script-args file.
        # <scriptname>: <arg1> <arg2> <arg3> ....
        # first_name extracts the scriptname
        # params extracts the available options
        # opts extracts all the available options

        # Next we create a directory with a particular
        # scriptname and then we create empty files
        # indside that directory with their names equivalent
        # to the available options.

        # The first two lines in the db file are
        # acarsd-info: acarsd-info.timeout acarsd-info.bytes
    	# ajp-auth: ajp-auth.path
    	# After executing this script, the newly added changes
    	# in the directory structure would be like this
    	# 
    	# |- acarsd-info/
    	# 		|- acarsd-info.timeout
    	# 		|- acarsd-info.bytes
    	# |- ajp-auth/
    	# 		|- ajp-auth.path
    	#

        scriptname=${line%:*} # Extracts the scriptname from the db file
        mkdir $scriptname 	  # Creating a directory with the respective script name
        cd $scriptname		  # Moving into the newly created directory	

        sp=$scriptname": "	# Creating a regex, to extract the available options
        opts=${line#*$sp}	# Fetching all the available options of the script

        for param in ${opts[@]}; do # Traversing all the available options
             touch ${param}			# Creating an empty file with the available option name
        done

        cd ..				 # Moving back to the previous folder.

    done < "$NMAPDIR/scripts/script-args/script-args.db"	 # Taking the input from the db file. 
fi