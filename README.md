# AD Manager

Ferramenta desktop para Windows que consulta e desbloqueia contas de usuários do **Active Directory** em poucos segundos, feita em **PowerShell** com interface **WPF**.

[English summary below](#english-summary)

## O problema

No service desk, desbloquear a conta de um usuário era uma das solicitações mais frequentes, e o caminho padrão era lento: abrir o console do Active Directory, localizar o usuário pelo nome certo, conferir o estado da conta e da senha e só então desbloquear. Com fila de chamados, isso se repetia muitas vezes por dia para toda a equipe.

O AD Manager junta tudo isso numa tela: busca o usuário do jeito que o atendente souber o nome, mostra o que importa para o atendimento e desbloqueia com um clique. A ferramenta foi distribuída para a equipe de service desk (13 pessoas) e evoluiu em cinco versões a partir do uso no dia a dia.

## Funcionalidades

- **Busca flexível:** por login, e-mail ou nome completo ou parcial. Se mais de um usuário corresponde, uma janela lista os resultados para escolher.
- **Situação da conta:** bloqueada ou não, ativa ou desativada, último logon, cargo, departamento e grupos.
- **Validade da senha:** última troca, data de expiração (calculada pelo atributo `msDS-UserPasswordExpiryTimeComputed`), senha que nunca expira, senha vencida e aviso destacado quando o usuário não vai conseguir entrar.
- **Desbloqueio com um clique** (`Unlock-ADAccount`), seguido de uma nova consulta para confirmar o resultado.
- **Histórico das últimas 15 consultas**, salvo localmente em JSON e reabrível com um clique.
- **Print da janela para a área de transferência**, para colar direto no chamado.
- **Interface no estilo Windows 11:** tema escuro, cores de status e ícones do sistema.

## Como funciona

| Parte | Detalhe |
|---|---|
| Interface | XAML carregado pelo PowerShell (`PresentationFramework`), sem dependências externas |
| Active Directory | Módulo `ActiveDirectory` do RSAT (`Get-ADUser`, `Unlock-ADAccount`) |
| Busca | Primeiro tenta o login exato; se não achar, monta um filtro por nome, login, e-mail e nome + sobrenome, com escape de aspas |
| Elevação | O script e o launcher `.bat` pedem elevação pelo UAC e rodam sem janela de console |
| Histórico | `%APPDATA%\AD_Manager`, em JSON, só na máquina do atendente |
| Distribuição | Empacotado como `.exe` com [ps2exe](https://github.com/MScholtes/PS2EXE) |

## Requisitos

- Windows 10 ou 11
- PowerShell 5.1
- **RSAT: Active Directory Domain Services Tools** instalado
- Conta com permissão delegada para ler usuários e desbloquear contas no domínio

Sem o módulo do AD, o programa abre e avisa o que falta instalar.

## Como usar

Opção 1, pelo launcher:

```
AD_Manager.bat
```

Opção 2, direto pelo PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\AD_Manager.ps1
```

### Gerar o executável

```powershell
Install-Module ps2exe -Scope CurrentUser
ps2exe -inputFile "AD_Manager.ps1" -outputFile "AD_Manager.exe" -iconFile "icone_ad.ico" -noConsole -title "AD Manager" -description "Gerenciador de Active Directory" -version "5.0.0.0"
```

## Segurança e privacidade

- O programa usa as credenciais de quem está logado; não guarda senha nem pede credencial.
- Nenhum dado sai da máquina: as consultas vão direto ao controlador de domínio e o histórico fica no `%APPDATA%` do atendente.
- O código não tem domínio, servidor ou dado de organização fixo: funciona em qualquer domínio onde o usuário tenha permissão.

## Estrutura

```
AD_Manager.ps1   aplicação (interface WPF + lógica)
AD_Manager.bat   launcher com elevação pelo UAC
icone_ad.ico     ícone do executável
```

## Licença

[MIT](LICENSE)

---

## English summary

**AD Manager** is a Windows desktop tool, written in PowerShell with a WPF interface, that looks up and unlocks Active Directory user accounts in a few seconds. I built it while working on a 13-person service desk team, where account unlocks were one of the most frequent requests, and distributed it to my colleagues; it went through five versions based on daily use.

Features: search by username, e-mail or full/partial name (with a picker when several users match); account status, last logon, title, department and groups; password expiry computed from `msDS-UserPasswordExpiryTimeComputed`, with a warning when the password has expired; one-click unlock with automatic re-check; local JSON history of the last 15 lookups; and a button that copies a screenshot of the window to paste into the ticket.

Requirements: Windows 10/11, PowerShell 5.1, RSAT Active Directory tools, and an account with delegated permission to unlock users.
