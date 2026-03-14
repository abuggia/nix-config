{ pkgs }:

let
  inputLcars5 = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/heidilux/openpeon-lcars/v1.0.0/sounds/input_lcars_5.wav";
    hash = "sha256-QxEsrDSFkwGcGb9EAlV3QFVpjWaE775BeoDkIBc8GcQ=";
  };
in
pkgs.writeShellApplication {
  name = "agent-waiting-notify";
  runtimeInputs = [ pkgs.jq ];
  text = ''
    set -euo pipefail

    if [ "''${1:-}" = "--test" ]; then
      exec /usr/bin/afplay "${inputLcars5}"
    fi

    payload="''${1:-}"
    if [ -z "$payload" ] && [ ! -t 0 ]; then
      payload="$(cat)"
    fi

    [ -n "$payload" ] || exit 0

    event_type="$(
      printf '%s' "$payload" | jq -r '.type // .event.type // empty' 2>/dev/null || true
    )"
    [ "$event_type" = "agent-turn-complete" ] || exit 0

    /usr/bin/afplay "${inputLcars5}" >/dev/null 2>&1 &
  '';
}
