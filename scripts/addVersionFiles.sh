#!/bin/bash
# Use udclient to add files to a component version
#
# The following environment variables are REQUIRED to be set prior to invocation of the script:
# JAVA_HOME
# DS_AUTH_TOKEN
# DS_WEB_URL
# FILES_CMD
# FILES_COMPONENTNAME
# FILES_VERSIONNAME
# FILES_BASE
#
# The following environment variables can be OPTIONALLY set prior to invocation of the script:
# FILES_OFFSET: "${{ inputs.offset }}"
# FILES_INCLUDE: "${{ inputs.include }}"
# FILES_EXCLUDE: "${{ inputs.exclude }}"
# FILES_SAVEEXECUTEBITS: ${{ inputs.saveExecuteBits }}

#set -x
base_cmd=""

# Create the command to execute
if [ -z $FILES_CMD ]
then
  echo "udclient command not specified.  Exiting."
  exit 1
else
  base_cmd="\"$FILES_CMD\" addVersionFiles"
fi

# Specify component name
if [ -z $FILES_COMPONENTNAME ]
then
  echo "Component name not specified.  Exiting."
  exit 1
else
  base_cmd+=" -component \"$FILES_COMPONENTNAME\""
fi

# Specify component version name
if [ -z "$FILES_VERSIONNAME" ]
then
  echo "Version name not specified.  Exiting."
  exit 1
else
  base_cmd+=" -version \"$FILES_VERSIONNAME\""
fi

# Specify local path
if [ -z $FILES_BASE ]
then
  echo "No base files specified. Exiting."
  exit 1
else
  base_cmd+=" -base \"$FILES_BASE\""
fi

# Specify target path
if [ ! -z "$FILES_OFFSET" ]
then
  base_cmd+=" -offset \"$FILES_OFFSET\""
fi

# Specify include pattern(s)
if [ ! -z $FILES_INCLUDE ]
then
  base_cmd+=" -include \"$FILES_INCLUDE\""
fi

# Specify exclude pattern(s)
if [ ! -z $FILES_EXCLUDE ]
then
  base_cmd+=" -exclude \"$FILES_EXCLUDE\""
fi

# Specify whether or not to save execute bits on the files
if [ ! -z $FILES_SAVEEXECUTEBITS ]
then
  base_cmd+=" -saveExecuteBits \"$FILES_SAVEEXECUTEBITS\""
fi

# Invoke the udclient to add version files to the component version
eval $base_cmd
