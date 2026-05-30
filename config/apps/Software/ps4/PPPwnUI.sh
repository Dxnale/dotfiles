#!/usr/bin/env bash

SCRIPT_PATH="$(readlink -f -- "${BASH_SOURCE[0]}")"
BASE_DIR="$(dirname -- "$SCRIPT_PATH")"
APP_DIR="$BASE_DIR/PPPwnUI"
VENV_DIR="$APP_DIR/venv"
PYTHON_BIN="$VENV_DIR/bin/python3"
REQ_FILE="$APP_DIR/requirements.txt"

ensure_venv() {
  local recreate=0

  if [[ ! -x "$PYTHON_BIN" ]]; then
    recreate=1
  elif ! "$PYTHON_BIN" -c 'import sys' >/dev/null 2>&1; then
    recreate=1
  fi

  if [[ "$recreate" -eq 1 ]]; then
    rm -rf -- "$VENV_DIR"
    python3 -m venv "$VENV_DIR"
  fi

  if ! "$PYTHON_BIN" -c 'import scapy, psutil' >/dev/null 2>&1; then
    "$PYTHON_BIN" -m pip install -r "$REQ_FILE"
  fi
}

if [[ ! -d "$APP_DIR" ]]; then
  echo "No se encontró el directorio de PPPwnUI: $APP_DIR" >&2
  exit 1
fi

if [[ ! -f "$REQ_FILE" ]]; then
  echo "No se encontró requirements.txt: $REQ_FILE" >&2
  exit 1
fi

ensure_venv

cd "$APP_DIR" || exit 1
xhost +local:root >/dev/null 2>&1 || true

if [[ "$EUID" -eq 0 ]]; then
  exec env "VIRTUAL_ENV=$VENV_DIR" "PATH=$VENV_DIR/bin:$PATH" \
    "$PYTHON_BIN" "$APP_DIR/PPPwnUI.py"
fi

exec sudo --preserve-env=DISPLAY,XAUTHORITY,WAYLAND_DISPLAY,XDG_RUNTIME_DIR \
  env "VIRTUAL_ENV=$VENV_DIR" "PATH=$VENV_DIR/bin:$PATH" \
  "$PYTHON_BIN" "$APP_DIR/PPPwnUI.py"
