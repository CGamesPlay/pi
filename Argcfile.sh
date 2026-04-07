#!/usr/bin/env bash
# @describe Scripts to manage this fork

set -eu

# @cmd Automatically sync and rebase.
rebase() {
	jj git fetch
	latest_tag=$(jj tag list --sort committer-date- -T 'name ++ "\n"' | head -1)
	jj rebase -o "$latest_tag"
	if [[ -n "$(jj log --ignore-working-copy --no-graph -r 'conflicts() & mutable()' -T '"C"')" ]]; then
		echo "Conflicts!" >&2
		exit 1
	fi
	./test.sh
}

if ! command -v argc >/dev/null; then
	echo "This command requires argc. Install from https://github.com/sigoden/argc" >&2
	exit 100
fi
eval "$(argc --argc-eval "$0" "$@")"
