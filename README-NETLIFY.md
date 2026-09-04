# Trinkets — Netlify

## Deploy pelo GitHub
1. Crie/atualize um repositório no GitHub com os arquivos deste projeto.
2. No Netlify: Add new project → Import an existing project → GitHub.
3. Selecione o repositório.
4. O `netlify.toml` configura:
   - Build command: `npm run build`
   - Publish directory: `dist`
   - Node: 20
   - Netlify Functions em `netlify/functions`
   - SPA fallback para o React Router
5. Em Project configuration → Environment variables, adicione:
   - `OPENAI_API_KEY` = sua chave secreta da API
   - `OPENAI_MODEL` = opcional; se não informar, o projeto usa `gpt-5`
6. Garanta que `OPENAI_API_KEY` esteja disponível para Functions. Não coloque a chave no código do React, HTML, CSS ou `netlify.toml`.
7. Faça um novo deploy após criar/alterar as variáveis.

## Rodar localmente
npm install
npm run dev

Para testar a Function localmente com Netlify CLI, configure as variáveis no ambiente local (por exemplo, com `.env`) sem versionar segredos no Git.

## Build de produção
npm run build


## Nuvem de Arquivos
A ferramenta usa Supabase Auth + Storage. Adicione no Netlify as variáveis `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY`. Crie um bucket PRIVADO chamado `trinkets-files`, execute `supabase-schema.sql` no SQL Editor e configure as políticas do Storage para limitar cada usuário ao caminho `auth.uid()/...`. A chave anon é própria para frontend quando protegida por RLS; nunca use a service_role no frontend.

O limite visual padrão da interface é 10 GB por usuário e 1 GB por arquivo. Para impor limites reais de armazenamento, configure-os também no provedor.
