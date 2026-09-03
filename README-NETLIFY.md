# Trinkets — Netlify

## Deploy pelo GitHub
1. Crie um repositório no GitHub e envie todos os arquivos deste projeto.
2. No Netlify: Add new project → Import an existing project → GitHub.
3. Selecione o repositório.
4. O `netlify.toml` já configura:
   - Build command: `npm run build`
   - Publish directory: `dist`
   - Node: 20
   - SPA fallback para o React Router
5. Clique em Deploy.

## Rodar localmente
npm install
npm run dev

## Build de produção
npm run build
