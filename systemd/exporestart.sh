# Restart systemd services with exponential waiting times
# Example:
#     ./retry.sh cool.service 4 3600 10
#     Will wait 4**NRestarts sec before restarting until reaching a
#     3600 sec long wait before restarting, for a total of 10 restarts.
#
# NOTE: This can be used in ExecStopPost.
#       It may be wise to check exit code and status before executing.
#       ??Does successful start reset NRestart??

service=$1
wait_sec=$2
max_wait_sec=$3
max_restarts=$4
n_restart=$(systemctl show "$service" -p NRestarts --value)
systemctl set-property "$service" NRestarts="$n_restart"+1

echo "Exponentially restarting $service $n_restart/$max_restarts (wait $wait_sec -> $max_wait_sec seconds)"

if  [[ $n_restart -gt 0 ]]; then
    wait_sec=$(("$wait_sec**$n_restart"))
fi

if  [[ $wait_sec -gt $max_wait_sec ]]; then
    wait_sec=$max_wait_sec
fi

if [[ $n_restart -gt $max_restarts ]]; then
    echo "Restarting in $wait_sec"
    sleep "$wait_sec"
    echo "Restarting"
    systemctl restart "$service"
fi
