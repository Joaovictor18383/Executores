# Madium_update

Repositório público que mantém o script central do Madium Manager e um carregador para Windows.

## Como funciona

O arquivo [`Madium_Manager_Loader.bat`](./Madium_Manager_Loader.bat) baixa, a cada execução, a versão atual de [`GITHUB_SCRIPT.txt`](./GITHUB_SCRIPT.txt) usando o endereço bruto do branch `main` e executa o conteúdo baixado.

Para atualizar o comportamento do carregador, edite somente `GITHUB_SCRIPT.txt`, faça commit e envie a alteração para o GitHub. Não é necessário editar o carregador novamente.

## Endereço usado pelo carregador

```text
https://raw.githubusercontent.com/Joaovictor18383/Madium_update/main/GITHUB_SCRIPT.txt
```

## Uso

Baixe o arquivo `Madium_Manager_Loader.bat` e execute-o no Windows. O computador precisa ter conexão com a internet e o comando `curl`, normalmente incluído nas versões atuais do Windows.

O carregador valida se o download foi concluído, se o arquivo não está vazio e se começa com `@echo off`. Depois da execução, o arquivo temporário é apagado.

## Atenção de segurança

O carregador executa o código publicado em `GITHUB_SCRIPT.txt` com as permissões do usuário. Revise o arquivo antes de executar o carregador e mantenha o repositório protegido contra alterações não autorizadas. Como o repositório é público, qualquer pessoa pode ler o conteúdo, mas somente colaboradores autorizados devem poder alterá-lo.

Não coloque senhas, tokens, chaves de API ou outros dados pessoais neste repositório.
