{ pkgs }:

pkgs.writeShellApplication {
  name = "docseq";
  runtimeInputs = [ pkgs.git pkgs.coreutils ];
  text = builtins.readFile ./docseq.sh;
}
