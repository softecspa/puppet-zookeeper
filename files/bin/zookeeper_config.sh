#!/bin/bash

#!/bin/bash

LOGLEVEL=$LOGLEVEL_DEBUG

. $(dirname $(readlink -f $0))/../lib/bash/softec-common.sh || exit

#echo -e "\nSome info based on my default variables:\n"
#echo -e "Hello I'm '$SCRIPTNAME' running from '$SCRIPTPATH'\n, you can call me shortly '$SHORTNAME'\n"
#echo -e "I can log in '$LOGFILE', I have a cache dir in '$CACHEDIR', if needed\n"
#echo -e "My config come from '$CONFDIR/$CONFFILENAME'\n"
#echo -e "If I send mail, the sender is '$MAILFROM' and I write to '$MAILTO'\n"
#
#echo -e "The default LOGLEVEL is normal ($LOGLEVEL_NORMAL), but I set it to "
#echo -e "debug ($LOGLEVEL_DEBUG) to be more verbose\n"

# Load configuration from default path
# call with a parameter to get a specific config file
include_conf

# set a lockfile... at the end of the script call unlock
get_lock

# Questa funzione viene chiamata in caso di CTRL-C
# Viene inoltre chiamata esplicitamente nella quit
# per fare la stessa pulizia in caso di uscita normale
# 
function clean()
{
    rm -f $CACHEDIR/*
}

# Classica funzione che spiega la sintassi
function help()
{
    echo -e "\n\nSYNTAX:\n\n\tExplain command syntax here...\n\n"
}

# Funzione chiamata alla fine dello script
# restituisce 0 a meno che non gli si passi
# un valore come primo parametro
function clean()
{
    unlock
}

# i : all'inizio della stringa di options servono
#     a gestire l'errore esplicitamente in caso di
#     invio di parametri non previsti, infatti
#     il valore di OPT diventa ? e OPTARG prende
#     il valore del parametro non previsto
# i : DOPO un parametro previsto significano invece
#     che il parametro richiede un argomento



TEMP=`getopt -o :a:w:c:s:d --long action:,confname:,confdir:,debug -n "$0" -- "$@"`
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

while true; do
  case "$1" in
    -d | --debug )
        DEBUG=1
        setloglevel 3
        shift 1
        ;;
    -a | --action )
        if [ $2 != 'upconfig' ] && [ $2 != 'delete' ] && [ $2 != 'check' ] && [ $2 != 'checkconfigs' ]; then
            log_error "Error: undefined action $2"
            exit 1
        else
            ACTION=$2
        fi
        shift 2
        ;;
    --confname )
        CONFNAME=$2
        shift 2
        ;;
    --confdir )
        CONFDIR=$2
        shift 2
        ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

case $ACTION in
    check )
        ${ZKCLI} -z ${ZOOKEEPER_ADDRESS}/configs/${CONFNAME} -cmd list > /dev/null 2>&1
        exit $?
        ;;
    checkconfigs)
        tmp_confdir=`mktemp -d`
        log_debug "download ${CONFNAME} in $tmp_confdir"
        ${ZKCLI} -z ${ZOOKEEPER_ADDRESS} -confname ${CONFNAME} -confdir $tmp_confdir -cmd downconfig 2> /dev/null
        diff=`diff -r -q -x '.svn' -x '.git' $tmp_confdir $CONFDIR`
        exit_status=$?
        if [ $exit_status -eq 0 ]; then
            log "configs are equal"
        else
            log "configs are different"
        fi
        exit $exit_status
        ;;
    upconfig)
        log_debug "upload di $CONFIDIR per conf $CONFNAME"
        $ZKCLI -z ${ZOOKEEPER_ADDRESS} -confdir $CONFDIR -confname $CONFNAME -cmd upconfig 2> /dev/null
        if [ $? -eq 0 ]; then
            log "config uploaded successfully to zookeeper"
            log_debug "config in $CONFDIR successfully uploaded to ${ZOOKEEPER_ADDRESS}/configs/${CONFNAME}"
            exit 0
        else
            log_error "error uploading config $CONFDIR to ${ZOOKEEPER_ADDRESS}/configs/${CONFNAME}.\n$ZKCLI -z ${ZOOKEEPER_ADDRESS} -confdir $CONFDIR -confname $CONFNAME -cmd upconfig"
            exit 1
        fi
        ;;
    * ) break;;
esac
