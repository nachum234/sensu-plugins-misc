#!/usr/bin/env bash

#Set script name
SCRIPT=`basename ${BASH_SOURCE[0]}`

#Set default values
TIMESTAMP_DELTA=900

# help function
function printHelp {
  echo -e \\n"Help for $SCRIPT"\\n
  echo -e "Basic usage: $SCRIPT -f filename [-d timestamp_delta]"\\n
  echo "Command that check status file"
  echo "-f - File name to check."
  echo "-d - Max time that file to check did not have any update."
  echo -e "-h  - Displays this help message"\\n
  echo -e "Example: $SCRIPT -f /opt/bis/etl.status -d 900"\\n
  echo -e \\n\\n"Author: Yossi Nachum, nachum234@gmail.com"
  exit 1
}

# regex to check is OPTARG an integer
re='^[0-9]+$'

while getopts :f:d FLAG; do
  case ${FLAG} in
    d)
      if ! [[ ${OPTARG} =~ $re ]] ; then
        echo "error: Not a number" >&2; exit 1
      else
        TIMESTAMP_DELTA=${OPTARG}
      fi
      ;;
    f)
      STATUS_FILE=${OPTARG}
      ;;
    h)
      printHelp
      ;;
    \?)
      echo -e \\n"Option - ${OPTARG} not allowed."
      printHelp
      exit 2
      ;;
  esac
done
shift $((OPTIND-1))
if [ "x${STATUS_FILE}" = "x" ]
then
  printHelp
fi

if [ -r ${STATUS_FILE}]
then
  FILE_TIMESTAMP=$(grep TIMESTAMP ${STATUS_FILE} | awk -F"=" '{print $2}')
  FILE_STATUS=$(grep STATUS ${STATUS_FILE} | awk -F"=" '{print $2}')
  FILE_OUTPUT=$(grep OUTPUT ${STATUS_FILE} | awk -F"=" '{print $2}')
else
  echo -e "CRITICAL: can't ready ${STATUS_FILE}"
  exit 2
fi

if [ $( ${FILE_TIMESTAMP} + ${TIMESTAMP_DELTA} ) -le $(date +%s) ]
then
  echo -e "CRITICAL: ${STATUS_FILE} didn't get update in the last ${TIMESTAMP_DELTA} seconds"
  exit 2
elif [ ${FILE_STATUS} -ne 0 ]
then
  echo -e "CRITICAL: ${STATUS_FILE} status is ${FILE_STATUS}: ${FILE_OUTPUT}"
  exit 1
else
  echo -e "OK: ${FILE_OUTPUT}"
  exit 0
fi
