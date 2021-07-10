{ config, pkgs, ... }:

{

  networking.firewall = {
    allowedTCPPorts = [
      22
      8080
      8009
    ];
    allowedUDPPorts = [
    ];
  };

  systemd.services.PlutusPlaygroundServer = {
     wantedBy = [ "multi-user.target" ];
     after = [ "network.target" ];
     path = [ pkgs.coreutils pkgs.nix pkgs.git pkgs.bash ];
     description = "Plutus Playground Server.";
     serviceConfig = {
       Type = "simple";
       User = "vagrant";
       WorkingDirectory = "/opt/plutus";
       ExecStart = ''${pkgs.nix}/bin/nix-shell --run ''\"cd /opt/plutus/plutus-playground-server && plutus-playground-server 2>&1''\" '';
       #ExecStop = ''/run/current-system/sw/bin/kill -- -$MAINPID'';
     };
  };

  systemd.services.PlutusPlaygroundClient = {
     wantedBy = [ "multi-user.target" ];
     after = [ "network.target" ];
     path = [ pkgs.coreutils pkgs.nix pkgs.git pkgs.bash ];
     description = "Plutus Playground Client.";
     serviceConfig = {
       Type = "simple";
       User = "vagrant";
       WorkingDirectory = "/opt/plutus";
       ExecStart = ''${pkgs.nix}/bin/nix-shell --run ''\"cd /opt/plutus/plutus-playground-client && npm run start 2>&1''\" '';
       #ExecStop = ''/run/current-system/sw/bin/kill -- -$MAINPID'';
     };
  };

}
