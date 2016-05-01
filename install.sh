#!/bin/bash
# Add a new host to the SentientHome Master
# Oliver Ratzesberger
# MIT License

# Provide self contained module name since we might get pulled via curl
THIS="SentientHome.install"

# Setup logger limit to last 10 runs
LOGDIR=/tmp
LOGFILE="$LOGDIR/"$THIS".`date +%Y%m%d%H%M%S`.log"
exec &> >(tee -a $LOGFILE)
( cd /tmp && rm -f $(ls -1t "$LOGDIR"/"$THIS"* | tail -n +10) )

SENTIENTHOME_PREFIX='/usr/local'
SENTIENTHOME_REPO='https://github.com/SentientHome/deploy'

# Default settings
DEBUG=0
FORCE=0

usage()
{
  cat << EOF

usage: $0 [options]

Initial install of the SentientHome Master

OPTIONS:
  --help|-h         Show this message
  --debug|-d        Debug mode

EOF
  exit 1
}

log()
{
  # Common logging format use in place of echo when possible
  echo `date +%Y%m%d%H%M%S%3N` "("$THIS")" "$1" "$2" "$3" "$4" "$5"
}

header()
{
  log SentientHome
  log
  log "Module:         " $THIS
  log "Path:           " "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  log "Logfile:        " $LOGFILE
  log "Host:           " `uname -n`
  log "OS:             " `uname -o`
  log "Kernel-Name:    " `uname -s`
  log "Kernel-Release: " `uname -r`
  log "Kernel-Version: " `uname -v`
  log "Machine:        " `uname -m`
  log "Processor:      " `uname -p`
  log "Platform:       " `uname -i`
  log
  log "git:            " `git --version`
  log "python:         " $( python --version 2>&1 )
  log
}

# translate long options to short
for arg
do
  delim=""
  case "${arg}" in
    --help) args="${args}-h ";;
    --force) args="${args}-f ";;
    --debug) args="${args}-d ";;
    # pass through anything else
    *) [[ "${arg:0:1}" == "-" ]] || delim="\""
      args="${args}${delim}${arg}${delim} ";;
  esac
done
# reset the translated args
eval set -- "$args"
# now we can process with getopt
while getopts "hd" opt; do
  case $opt in
    h)  usage ;;
    d)  DEBUG=1 ;;
    \?) usage ;;
    :)
      echo "Option -$OPTARG requires an argument\n"
      usage
    ;;
  esac
done
shift $((OPTIND -1))

# Start by logging environment info
header

if [ $DEBUG -eq 1 ]; then
  set -x
  OPT_OUTPUT="/dev/stdout"
else
  OPT_OUTPUT="/dev/null"
fi

# Install SentientHome deployment repo
mkdir -p "$SENTIENTHOME_PREFIX"/SentientHome &>$OPT_OUTPUT
pushd &>$OPT_OUTPUT
cd "$SENTIENTHOME_PREFIX"/SentientHome

git status &>$OPT_OUTPUT
if [ $? -eq 0 ]; then
  log "SentientHome already installed - Updating ..."
  git pull &>$OPT_OUTPUT
else
  log "Installing SentientHome ..."
  git clone "$SENTIENTHOME_REPO" "$SENTIENTHOME_PREFIX"/SentientHome &>$OPT_OUTPUT
fi

EXITCODE=$?
popd &>$OPT_OUTPUT

if [ $EXITCODE -ne 0 ]; then
  log "👎  Fatal error installing SentientHome."
  exit 3
fi

# Run Setup
"$SENTIENTHOME_PREFIX"/SentientHome/setup
