#!/usr/bin/env bash
set -e

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
destination=${CODEX_HOME:-"$HOME/.codex"}
files=(AGENTS.md code-conventions/python.md code-conventions/react.md code-conventions/typescript.md)

printf 'Atualmente, somente o Codex está disponível.\n'
printf 'Escolha a ferramenta:\n  1) Codex\n> '
IFS= read -r choice || exit 1
case $choice in
    1) ;;
    *) printf 'Opção inválida. Instalação cancelada.\n' >&2; exit 1 ;;
esac

if [ -s "$destination/AGENTS.override.md" ]; then
    printf 'Instalação cancelada: %s tem prioridade sobre AGENTS.md.\n' "$destination/AGENTS.override.md" >&2
    exit 1
fi

# Reject symlinks and non-regular files so replacement and recovery cannot affect
# paths outside the selected destination or destroy unexpected directory contents.
for directory in "$destination" "$destination/code-conventions"; do
    if [ -L "$directory" ] || { [ -e "$directory" ] && [ ! -d "$directory" ]; }; then
        printf 'Destino inválido: %s\n' "$directory" >&2
        exit 1
    fi
done

conflicts=()
for file in "${files[@]}"; do
    if [ ! -f "$root/$file" ]; then
        printf 'Arquivo de origem ausente: %s\n' "$root/$file" >&2
        exit 1
    fi
    target=$destination/$file
    if [ -L "$target" ] || { [ -e "$target" ] && [ ! -f "$target" ]; }; then
        printf 'Destino inválido: %s\n' "$target" >&2
        exit 1
    fi
    if [ -e "$target" ]; then
        if [ "$root/$file" -ef "$target" ]; then
            printf 'Origem e destino são o mesmo arquivo: %s\n' "$target" >&2
            exit 1
        fi
        conflicts+=("$file")
    fi
done

if [ "${#conflicts[@]}" -gt 0 ]; then
    printf 'Os seguintes arquivos já existem:\n'
    for file in "${conflicts[@]}"; do printf '  %s\n' "$destination/$file"; done
    printf 'Substituir todos? [s/N] '
    IFS= read -r answer || answer=
    case $answer in
        s|S|sim|SIM) ;;
        *) printf 'Instalação cancelada; nenhum arquivo foi copiado.\n'; exit 0 ;;
    esac
fi

backup=
if [ "${#conflicts[@]}" -gt 0 ]; then
    umask 077
    mkdir -p "$root/backups"
    backup=$(mktemp -d "$root/backups/$(date +%Y%m%d-%H%M%S)-XXXXXX")
    for file in "${conflicts[@]}"; do
        mkdir -p "$backup/$(dirname -- "$file")"
        cp -p "$destination/$file" "$backup/$file.backup"
    done
    printf 'Backup criado em: %s\n' "$backup"
fi

changed=()
created_destination=0
created_conventions=0
committed=0
rollback() {
    status=$?
    trap - EXIT
    if [ "$committed" -eq 0 ]; then
        printf 'Falha na instalação; tentando restaurar os arquivos.\n' >&2
        recovery_failed=0
        for file in "${changed[@]}"; do
            if [ -n "$backup" ] && [ -f "$backup/$file.backup" ]; then
                cp -p "$backup/$file.backup" "$destination/$file" || recovery_failed=1
            else
                rm -f "$destination/$file" || recovery_failed=1
            fi
        done
        if [ "$created_conventions" -eq 1 ]; then rmdir "$destination/code-conventions" 2>/dev/null || recovery_failed=1; fi
        if [ "$created_destination" -eq 1 ]; then rmdir "$destination" 2>/dev/null || recovery_failed=1; fi
        if [ "$recovery_failed" -eq 1 ]; then
            printf 'Não foi possível concluir a restauração automática. Backup: %s\n' "${backup:-nenhum}" >&2
        else
            printf 'Alterações revertidas.\n' >&2
        fi
    fi
    exit "$status"
}
trap rollback EXIT

if [ ! -d "$destination" ]; then created_destination=1; mkdir -p "$destination"; fi
if [ ! -d "$destination/code-conventions" ]; then created_conventions=1; mkdir "$destination/code-conventions"; fi
for file in "${files[@]}"; do
    changed+=("$file")
    cp -p "$root/$file" "$destination/$file"
done
committed=1
printf 'Instruções instaladas em: %s\n' "$destination"
printf 'Inicie uma nova sessão do Codex para carregá-las.\n'
