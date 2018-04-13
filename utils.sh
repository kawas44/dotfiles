# Utils for SHELL scripts

has_cmd () {
    command -v "$1" 2>&1 1>/dev/null
}

safe_source () {
    [ -r "$1" ] && source "$1"
}

on_osx () {
    test -n "$OSTYPE" -a "${OSTYPE#darwin}" != "$OSTYPE"
}
