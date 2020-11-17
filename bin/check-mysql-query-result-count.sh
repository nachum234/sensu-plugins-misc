#!/usr/bin/env bash

#Set script name
SCRIPT=`basename ${BASH_SOURCE[0]}`

#Set default values
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=''

# help function
function printHelp {
  echo -e \\n"Help for $SCRIPT"\\n
  echo -e "Basic usage: $SCRIPT -w {warning} -c {critical}"\\n
  echo "Command that check mysql query result"
  echo "-w - Sets warning value for mysql query."
  echo "-c - Sets critical value for mysql query."
  echo "-H - Sets mysql host. Default is localhost"
  echo "-P - Sets mysql port. Default is 3306"
  echo "-u - Sets mysql user. Default is root"
  echo "-p - Sets mysql password. Default is empty"
  echo "-q - Sets mysql query."
  echo "-d - Sets mysql database."
  echo -e "-h  - Displays this help message"\\n
  echo -e "Example: $SCRIPT -w 200 -c 100 -h mysql.example.com -u sensu -p test -d inventory -q select count(*) from orders"\\n
  echo -e \\n\\n"Author: Yossi Nachum, nachum234@gmail.com"
  exit 1
}

# regex to check is OPTARG an integer
re='^[0-9]+$'

while getopts :w:c:H:u:p:P:q:d:h FLAG; do
  case ${FLAG} in
    w)
      if ! [[ ${OPTARG} =~ $re ]] ; then
        echo "error: Not a number" >&2; exit 1
      else
        WARNING=${OPTARG}
      fi
      ;;
    c)
      if ! [[ ${OPTARG} =~ $re ]] ; then
        echo "error: Not a number" >&2; exit 1
      else
        CRITICAL=${OPTARG}
      fi
      ;;
    H)
      MYSQL_HOST=${OPTARG}
      ;;
    u)
      MYSQL_USER=${OPTARG}
      ;;
    p)
      MYSQL_PASSWORD=${OPTARG}
      ;;
    p)
      MYSQL_PORT=${OPTARG}
      ;;
    d)
      MYSQL_DB=${OPTARG}
      ;;
    q)
      MYSQL_QUERY=${OPTARG}
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
if [ "x${WARNING}" = "x" ] || [ "x${CRITICAL}" = "x" ] || [ "x${MYSQL_QUERY}" = "x" ]
then
  printHelp
fi

RESULT=$(mysql -N -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} -p"${MYSQL_PASSWORD}" ${MYSQL_DB} -e "${MYSQL_QUERY};")
MSG="RESULT: ${RESULT}"


if [ ${RESULT} -le ${CRITICAL} ]
then
  echo -e "CRITICAL: ${MSG}"
  exit 2
elif [ ${RESULT} -le ${WARNING} ]
then
  echo -e "WARNING: ${MSG}"
  exit 1
else
  echo -e "OK: ${MSG}"
  exit 0
fi
