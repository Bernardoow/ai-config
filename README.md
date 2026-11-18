# Instalação das instruções

Clone ou copie este repositório, entre em sua pasta e execute `make install`.
São necessários `make`, Bash e os utilitários usuais do sistema. O instalador
suporta Linux e macOS; atualmente, a única ferramenta disponível é o Codex.

Selecione Codex no menu. As instruções são copiadas para `$CODEX_HOME` ou,
quando essa variável não estiver definida, para `~/.codex`. Inicie uma nova
sessão do Codex para carregá-las. As instruções específicas de cada projeto
continuam sendo aplicadas, e podem prevalecer sobre as instruções globais.

Execute `make install` novamente após atualizar este repositório. Se algum dos
arquivos de destino já existir, o instalador lista todos os conflitos e pede uma
única confirmação para substituí-los. A resposta padrão cancela a operação.
Um `AGENTS.override.md` global não vazio impede a instalação, pois tem
prioridade sobre `AGENTS.md`; remova ou renomeie esse override manualmente se
quiser usar as instruções instaladas.

Antes de substituir arquivos, o instalador cria um backup em `backups/`, ao
lado do Makefile, em uma pasta identificada pela data e hora. Essa pasta não é
incluída no Git. Os arquivos têm o sufixo `.backup` para não serem carregados
automaticamente como instruções. Guarde o repositório enquanto precisar dos
backups: apagar ou mover sua cópia também afeta esses arquivos.

Para restaurar um backup, escolha a pasta da execução desejada e copie cada
arquivo para o mesmo caminho relativo em `$CODEX_HOME` (ou `~/.codex`),
removendo o sufixo `.backup`. Por exemplo, `AGENTS.md.backup` deve ser
restaurado como `AGENTS.md` e `code-conventions/python.md.backup` como
`code-conventions/python.md`. A restauração substitui os arquivos atuais.

Execute `make test` para verificar o instalador em diretórios temporários.
