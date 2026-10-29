# Scripts do Emacs

Este diretório contém scripts para abrir frames do Emacs e usar o Emacs
Everywhere. O servidor do Emacs deve ser iniciado pelo `systemd` como serviço
do usuário.

## Problema original

Os scripts usavam `emacsclient` sem garantir que o servidor do Emacs estivesse
ativo:

- `open_emacs.sh` abria um novo frame;
- `with_emacs.sh` abria um arquivo em um novo frame;
- `with_emacs_everywhere.sh` executava `(emacs-everywhere)`.

Os dois primeiros scripts usavam `-a ''`. Esse argumento permite que o
`emacsclient` inicie um Emacs alternativo quando não encontra o servidor. Isso
pode criar uma segunda instância independente e esconder uma falha na
inicialização do servidor. O `with_emacs_everywhere.sh` não tinha esse
fallback e falhava diretamente quando o servidor não estava disponível.

## Solução adotada

O sistema possui a unidade oficial:

```text
/usr/lib/systemd/user/emacs.service
```

Ela executa:

```text
/usr/bin/emacs --fg-daemon
```

O serviço é gerenciado pelo `systemd` do usuário e deve ser habilitado com:

```bash
systemctl --user enable --now emacs.service
```

Isso faz o servidor iniciar automaticamente ao entrar na sessão do usuário e
inicia-o imediatamente na primeira configuração.

Para verificar o serviço:

```bash
systemctl --user status emacs.service
systemctl --user is-enabled emacs.service
```

Para verificar diretamente o servidor do Emacs:

```bash
emacsclient -e '(emacs-pid)'
```

Se o servidor não estiver disponível, o comando exibirá um erro informando
que o socket não foi encontrado.

## Scripts atuais

### `open_emacs.sh`

Abre um novo frame no servidor existente:

```bash
emacsclient -n -c &
```

Depois, aguarda a janela aparecer no desktop atual e a focaliza usando
`wmctrl`.

### `with_emacs.sh`

Abre o caminho recebido como primeiro argumento em um novo frame:

```bash
emacsclient -n -c "$1" &
```

Exemplo:

```bash
./with_emacs.sh ~/projeto/arquivo.txt
```

Assim como `open_emacs.sh`, o script aguarda e focaliza a nova janela.

### `with_emacs_everywhere.sh`

Executa o Emacs Everywhere no servidor existente:

```bash
emacsclient --eval '(emacs-everywhere)'
```

O script também tenta focalizar a janela criada no desktop atual.

## Reimplementação futura

1. Confirme que `emacs`, `emacsclient` e `wmctrl` estão instalados:

   ```bash
   command -v emacs
   command -v emacsclient
   command -v wmctrl
   ```

2. Confirme que existe a unidade do usuário:

   ```bash
   systemctl --user cat emacs.service
   ```

3. Habilite e inicie o servidor:

   ```bash
   systemctl --user enable --now emacs.service
   ```

4. Teste o socket do Emacs:

   ```bash
   emacsclient -e '(emacs-pid)'
   ```

5. Teste os scripts:

   ```bash
   ./open_emacs.sh
   ./with_emacs.sh /caminho/para/um/arquivo
   ./with_emacs_everywhere.sh
   ```

6. Valide a sintaxe dos scripts:

   ```bash
   bash -n open_emacs.sh with_emacs.sh with_emacs_everywhere.sh
   ```

## Inicialização antes do login

Por padrão, um serviço do usuário é iniciado quando o usuário entra na sessão.
Isso é suficiente para uso em uma sessão gráfica, que também é necessária
para os comandos `wmctrl` dos scripts.

Se for realmente necessário iniciar o servidor antes do login, habilite o
`linger` para o usuário:

```bash
loginctl enable-linger "$USER"
```

Essa opção mantém o gerenciador de serviços do usuário ativo mesmo sem uma
sessão aberta e não é necessária para o funcionamento normal dos scripts.

## Diagnóstico

Se `emacsclient` informar que não encontrou o socket:

```bash
systemctl --user status emacs.service
journalctl --user -u emacs.service --no-pager
```

Se o serviço estiver inativo, reinicie-o com:

```bash
systemctl --user restart emacs.service
```

Os scripts foram ajustados intencionalmente para não usar `-a ''`. Portanto,
uma falha do servidor aparece imediatamente, em vez de iniciar uma segunda
instância do Emacs.
