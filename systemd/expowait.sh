# Wait exponentially with systemd service restart counter
# Example:
#     ./expowait.sh cool.service 4 3600
#     Will wait 4**NRestarts sec until reaching a max wait of 3600 sec.
#
# Recommended use is to put this in ExecStopPost, set Restart=always and
# StartLimitIntervalSec=0. Then we will restart on all exit statuses forever.
# Service will be in deactivating state while waiting for a new restart.
# On more complicated use one should be mindful of the service restart config.

service=$1
wait_sec=$2
max_wait_sec=$3
n_restart=$(systemctl show "$service" -p NRestarts --value)

echo "Exponentially waiting $service($n_restart) $wait_sec -> $max_wait_sec seconds"

wait_sec=$((wait_sec**n_restart))

if  [[ $wait_sec -gt $max_wait_sec ]]; then
    wait_sec=$max_wait_sec
fi

echo "Restarting in $wait_sec"
sleep "$wait_sec"
