# Duo Finn · Finanças em casal

Site de uma página só (`index.html`), com login e dados na nuvem (Supabase), hospedado no Cloudflare Pages.
Vocês dois entram com e-mail e senha e veem os mesmos dados, atualizados a cada ~15 segundos.

## Passo a passo (uma vez só)

### 1. Banco de dados (Supabase, gratuito)
1. Crie uma conta em supabase.com e um projeto novo (região São Paulo). Guarde a senha do banco.
2. Abra `supabase/schema.sql`, troque os dois e-mails pelos de vocês, cole no **SQL Editor** e clique em **Run**.
3. **Authentication > Users > Add user**: crie os dois usuários (mesmos e-mails do passo 2), com senha, marcando "Auto Confirm User".
4. **Authentication > Sign In / Providers**: desligue **Allow new users to sign up**. Isso impede que estranhos criem conta.
5. **Project Settings > API**: copie a **Project URL** e a chave **anon / publishable** para o arquivo `config.js`.
   (A chave anon é pública por desenho. A proteção real são o login e as regras do `schema.sql`.)

### 2. Git (repositório privado)
```
git remote add origin https://github.com/SEU_USUARIO/duo-finn.git
git push -u origin main
```
Crie o repositório antes, no GitHub, como **Private**.

### 3. Site no ar (Cloudflare Pages, gratuito)
1. dash.cloudflare.com > **Workers & Pages > Create > Pages > Connect to Git**, escolha o repositório.
2. **Build command**: vazio. **Build output directory**: `/` (raiz). Clique em **Save and Deploy**.
3. O endereço fixo (`algo.pages.dev`) é o que vocês dois usam, no celular ou no computador.

### 4. Primeiro acesso: levar os dados atuais
1. No arquivo antigo (`duo-finn.html`): menu do James (canto inferior esquerdo) > **Exportar dados (backup)**.
2. No site novo: entre com e-mail e senha > menu > **Importar dados** e escolha o arquivo.
3. Pronto: os dados sobem para a nuvem e a Bruna já os vê ao entrar.

## Dia a dia
- O indicador no rodapé do menu mostra o estado: *Sincronizado*, *Salvando…* ou *Sem conexão*. Sem internet o app continua funcionando e envia depois.
- Se os dois editarem ao mesmo tempo, o app avisa e pergunta qual versão manter.
- O que é só do aparelho (tema, tela aberta, mês em foco) não é sincronizado.
- Backup extra: use **Exportar dados** de vez em quando. O banco também guarda um histórico (`app_state_hist`, uma cópia a cada 6 h por 60 dias), visível no painel do Supabase.

## Alterar o app
Edite `src/template.html`, rode `python3 src/build.py` (gera o `index.html`), faça commit e push. O Cloudflare publica sozinho.
O backup pessoal usado nos testes **não** vai para o site publicado: o `build.py` troca por dados vazios.
