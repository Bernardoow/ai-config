#!/usr/bin/env bash
set -e

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
tmp=$(mktemp -d "${TMPDIR:-/tmp}/ai-config-test.XXXXXX")
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/repo/scripts" "$tmp/repo/code-conventions" "$tmp/home"
cp "$root/scripts/install.sh" "$tmp/repo/scripts/"
cp "$root/AGENTS.md" "$tmp/repo/"
cp "$root"/code-conventions/*.md "$tmp/repo/code-conventions/"
installer=$tmp/repo/scripts/install.sh
destination=$tmp/home/codex

if printf '2\n' | HOME="$tmp/home" CODEX_HOME="$destination" bash "$installer" > "$tmp/output" 2>&1; then
    printf 'Uma ferramenta inválida não deveria ser aceita.\n' >&2; exit 1
fi
test ! -e "$destination"
printf '1\n' | HOME="$tmp/home" CODEX_HOME= bash "$installer" > "$tmp/output"
cmp "$tmp/repo/AGENTS.md" "$tmp/home/.codex/AGENTS.md"

printf '1\n' | HOME="$tmp/home" CODEX_HOME="$destination" bash "$installer" > "$tmp/output"
cmp "$tmp/repo/AGENTS.md" "$destination/AGENTS.md"
cmp "$tmp/repo/code-conventions/python.md" "$destination/code-conventions/python.md"
cmp "$tmp/repo/code-conventions/react.md" "$destination/code-conventions/react.md"
cmp "$tmp/repo/code-conventions/typescript.md" "$destination/code-conventions/typescript.md"

printf 'original\n' > "$destination/AGENTS.md"
printf '1\nn\n' | HOME="$tmp/home" CODEX_HOME="$destination" bash "$installer" > "$tmp/output"
test "$(cat "$destination/AGENTS.md")" = original
test ! -d "$tmp/repo/backups"
printf '1\ns\n' | HOME="$tmp/home" CODEX_HOME="$destination" bash "$installer" > "$tmp/output"
cmp "$tmp/repo/AGENTS.md" "$destination/AGENTS.md"
backup=$(find "$tmp/repo/backups" -name AGENTS.md.backup -print)
test "$(cat "$backup")" = original
test -f "$(dirname "$backup")/code-conventions/python.md.backup"

printf 'override\n' > "$destination/AGENTS.override.md"
if printf '1\n' | HOME="$tmp/home" CODEX_HOME="$destination" bash "$installer" > "$tmp/output" 2>&1; then
    printf 'Override deveria impedir a instalação.\n' >&2; exit 1
fi
rm "$destination/AGENTS.override.md"

# Fail only when installing the second file; restoration copies from the backup.
mkdir "$tmp/bin"
cat > "$tmp/bin/cp" <<'EOF'
#!/usr/bin/env bash
case "$2" in */repo/code-conventions/python.md) exit 1 ;; esac
exec /bin/cp "$@"
EOF
chmod +x "$tmp/bin/cp"
printf 'antes\n' > "$destination/AGENTS.md"
if printf '1\ns\n' | HOME="$tmp/home" CODEX_HOME="$destination" PATH="$tmp/bin:$PATH" bash "$installer" > "$tmp/output" 2>&1; then
    printf 'A cópia deveria ter falhado.\n' >&2; exit 1
fi
test "$(cat "$destination/AGENTS.md")" = antes
cmp "$tmp/repo/code-conventions/python.md" "$destination/code-conventions/python.md"

printf 'Testes do instalador passaram.\n'
