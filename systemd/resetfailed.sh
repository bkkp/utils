# Check process regularly and reset systemd restart counter when successful
# Example:
#   ./resetfailed.sh cool.service 2 10
#   Will check MAINPID of cool.service every 2 seconds for 10 seconds.
#   If MAINPID process is still running after that, we reset NRestart.
#
# Recommended use is to fork this process in ExecStartPost

service=$1
condition=$2
interval=$3

echo "expowait($service): Checking $condition sec for success"
for i in $(seq 1 "$interval" "$condition")
do
  if [ -d "/proc/$MAINPID" ]; then
    echo "expowait($service): Still running after $i sec"
    sleep "$interval"
  else
    echo "expowait($service): Service failed, not resetting NRestarts"
    exit 0
  fi
done

echo "expowait($service): Service success, resetting NRestarts for $service"
systemctl reset-failed "$service"
