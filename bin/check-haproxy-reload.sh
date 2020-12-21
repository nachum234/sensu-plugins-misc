#!/usr/bin/env bash

#Set script name
SCRIPT=`basename ${BASH_SOURCE[0]}`

#Set default values
CRITICAL=2
WARNING=2

# help function
function printHelp {
  echo -e \\n"Help for $SCRIPT"\\n
  echo -e "Basic usage: $SCRIPT [-w warning -c critical]"\\n
  echo "Command that check reload of haproxy"
  echo "-w - warning threshold."
  echo "-c - critical threshold."
  echo -e "-h  - Displays this help message"\\n
  echo -e "Example: $SCRIPT -c 2"\\n
  echo -e \\n\\n"Author: Yossi Nachum, nachum234@gmail.com"
  exit 1
}

# regex to check is OPTARG an integer
re='^[0-9]+$'

while getopts :c:w: FLAG; do
  case ${FLAG} in
    c)
      if ! [[ ${OPTARG} =~ $re ]] ; then
        echo "error: Not a number" >&2; exit 1
      else
        CRITICAL=${OPTARG}
      fi
      ;;
    w)
      WARNING=${OPTARG}
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

HAPROXY_CMD=$(pgrep -P 1 haproxy -a | cut -d' ' -f2- | grep -v haproxy_exporter)
HAPROXY_CMD_COUNT=$(ps -ef | grep "${HAPROXY_CMD}" | grep -v grep | wc -l)
if [ ${HAPROXY_CMD_COUNT} -lt ${CRITICAL} ]
then
  echo -e "CRITICAL: haproxy cmd count ${HAPROXY_CMD_COUNT} < ${CRITICAL}"
  exit 2
elif [ ${HAPROXY_CMD_COUNT} -lt ${WARNING} ]
then
  echo -e "WARNING: haproxy cmd count ${HAPROXY_CMD_COUNT} < ${WARNING}"
  exit 1
else
  echo -e "OK: haproxy reload successfull"
  exit 0
fi
