pkgs:
{
  service,
  expo ? 3,
  maxWaitSec ? 3600,
  resetSec ? 60,
  resetCheckInterval ? 10
}:
let
  inherit (builtins) readFile toString;
  expowait = pkgs.writeShellApplication {
    name = "expowait"; text = readFile ./expowait.sh;
  };
  resetfailed = pkgs.writeShellApplication {
    name = "resetfailed"; text = readFile ./resetfailed.sh;
  };
  resetWrap = pkgs.writeShellApplication {  # Cannot use & directly in ExecStartPost
    name = "resetwrap"; text = ''${resetfailed}/bin/resetfailed "$1" "$2" "$3" &'';
  };

in
{
  serviceConfig = {
    ExecStartPre = "${expowait}/bin/expowait ${service} ${toString expo} ${toString maxWaitSec}";
    ExecStartPost = "${resetWrap}/bin/resetwrap ${service} ${toString resetSec} ${toString resetCheckInterval}";
    Restart = "always";
    TimeoutStartSec = (maxWaitSec + 10);
  };
  unitConfig.StartLimitIntervalSec = 0;
}


