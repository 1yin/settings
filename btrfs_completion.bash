_btrfs()
{
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    option_pattern="^-.*"
    isOption=0

    if [[ "$cur" =~ ${option_pattern} || "$prev" =~ ${option_pattern} ]] || ! _subcommands ; then
        _options
    fi

    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

_subcommands()
{
    local cmd="$(echo ${COMP_WORDS[*]::${COMP_CWORD}})"
    local index=$((COMP_CWORD+1))

    opts="$($cmd --help \
          | grep -E "^[[:space:]]+${cmd##*/}" \
          | awk -v i=${index} '{ print $i }' \
          | uniq)"

    if [ -n "$opts" ]; then
        return 0
    else
        return 1
    fi
}

_options()
{
    local cmd="$(echo ${COMP_WORDS[*]%%-*})"
    opts="$($cmd --help \
          | grep -E "^[[:space:]]+-{1,2}[a-zA-Z]+" \
          | awk '{ print $1 }' \
          | tr '|' '\n')
          --help"
}

complete -F _btrfs btrfs
