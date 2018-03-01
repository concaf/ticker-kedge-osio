#!/bin/sh
set -e

webdis_config="/tmp/webdis.json"

eexit() {
  echo 'quitting..' >&2
  killall redis-server
  killall webdis
  exit
}

# I don't think it does what I think it does.. 
trap eexit SIGINT SIGQUIT SIGKILL SIGTERM SIGHUP

install_redis() {
  if [ -n "$LOCAL_REDIS" ] || [ -n "$INSTALL_REDIS" ]; then
    REDIS_HOST="127.0.0.1"
    echo "starting redis-server.." >&2
    redis-server >/tmp/redis-server.log 2>&1 &
  fi
}

write_config() {
ACL_DISABLED=${ACL_DISABLED:-\"DEBUG\", \"FLUSHDB\", \"FLUSHALL\"}
ACL_HTTP_BASIC_AUTH_ENABLED=${ACL_HTTP_BASIC_AUTH_ENABLED:-\"DEBUG\"}
[ -n "$REDIS_PORT" ] && REDIS_PORT=${REDIS_PORT##*:}
cat - <<EOF
{
  "redis_host": "${REDIS_HOST:-redis}",

  "redis_port": ${REDIS_PORT:-6379},
  "redis_auth": ${REDIS_AUTH:-null},

  "http_host": "${HTTP_HOST:-0.0.0.0}",
  "http_port": ${HTTP_PORT:-7379},

  "threads": ${THREADS:-5},
  "pool_size": ${POOL_SIZE:-10},

  "daemonize": false,
  "websockets": ${WEBSOCKETS:-true},

  "database": ${DATABASE:-0},

  "acl": [
    {
      "disabled": [${ACL_DISABLED}]
    },

    {
      "http_basic_auth": "${ACL_HTTP_BASIC_AUTH:-user:password}",
      "enabled":  [${ACL_HTTP_BASIC_AUTH_ENABLED}]
    }
  ],

  "verbosity": ${VERBOSITY:-99},
  "logfile": "${LOGFILE:-/tmp/webdis.log}"
}
EOF
}

if [ $# -eq 0 ]; then
  install_redis

  echo "writing config.." >&2
  write_config > ${webdis_config}

  echo "taking a 3 second nap.." >&2
  for i in 3 2 1; do echo -n "$i " >&2; sleep 1; done
  echo

  tail -F ${LOGFILE:-/tmp/webdis.log} &
  echo "starting webdis.." >&2
  redis-cli config set stop-writes-on-bgsave-error no
  webdis ${webdis_config}

fi

exec "$@"
