#!/bin/bash
# Use udclient to add properties to a component version
#
# The following environment variables are REQUIRED to be set prior to invocation of the script:
# JAVA_HOME
# DS_AUTH_TOKEN or DS_USERNAME/DS_PASSWORD
# DS_WEB_URL
# VERSION_PROPERTIES_CMD
# VERSION_PROPERTIES_COMPONENTNAME
# VERSION_PROPERTIES_VERSIONNAME
# VERSION_PROPERTIES

#set -x
base_cmd=""

# Create the command to execute
if [ -z $VERSION_PROPERTIES_CMD ]
then
  echo "udclient command not specified.  Exiting."
  exit 1
else
  base_cmd="\"$VERSION_PROPERTIES_CMD\" setVersionProperty"
fi

# Specify component name
if [ -z $VERSION_PROPERTIES_COMPONENTNAME ]
then
  echo "Component name not specified.  Exiting."
  exit 1
else
  base_cmd+=" -component \"$VERSION_PROPERTIES_COMPONENTNAME\""
fi

# Specify component version name
if [ -z "$VERSION_PROPERTIES_VERSIONNAME" ]
then
  echo "Version name not specified.  Exiting."
  exit 1
else
  base_cmd+=" -version \"$VERSION_PROPERTIES_VERSIONNAME\""
fi

# Check to make sure that at least 1 version property was specified
if [ -z "$VERSION_PROPERTIES" ]
then
  echo "version properties not specified.  Exiting."
  exit 1
fi

# Loop through new-line delineated component version properties and invoke CLI for each property definition.
# Make sure that property name, property value, and property secure setting are all provided.
while IFS=":" read key value secure remainder
do
    if [ -z $"$key" ]
    then
      echo "Property name not specified.  Exiting."
      exit 1
    fi
    if [ -z "$value" ]
    then
      echo "Property value not specified.  Exiting."
      exit 1
    fi
    if [ -z "$secure" ]
    then
      echo "Property secure setting not specified.  Exiting."
      exit 1
    fi
    property_cmd="$base_cmd -name \"$key\" -value \"$value\" -isSecure $secure"
    eval $property_cmd
done <<< $VERSION_PROPERTIES

