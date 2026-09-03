export default async (req) => {
  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({ error: "Método não permitido." }),
      {
        status: 405,
        headers: { "Content-Type": "application/json" }
      }
    );
  }

  try {
    const body = await req.json();
    const messages = Array.isArray(body.messages) ? body.messages : [];

    if (!messages.length) {
      return new Response(
        JSON.stringify({ error: "Nenhuma mensagem enviada." }),
        {
          status: 400,
          headers: { "Content-Type": "application/json" }
        }
      );
    }

    const apiKey = process.env.OPENAI_API_KEY;
    const model = process.env.OPENAI_MODEL || "gpt-5-mini";

    if (!apiKey) {
      return new Response(
        JSON.stringify({
          error: "OPENAI_API_KEY não configurada no Netlify."
        }),
        {
          status: 500,
          headers: { "Content-Type": "application/json" }
        }
      );
    }

    const system = `
Você é o Assistente IA oficial do Trinkets.

Responda sempre em português brasileiro.

Você ajuda o usuário a utilizar as ferramentas do Trinkets,
explica funcionalidades e ajuda a diagnosticar problemas comuns.

Você também pode explicar a Central de Segurança.

Quando analisar conteúdos suspeitos, faça SOMENTE análise defensiva.

Você NÃO deve ensinar:
- invasão;
- exploração de vulnerabilidades;
- roubo de credenciais;
- bypass de autenticação;
- malware;
- ataques;
- phishing;
- técnicas para prejudicar sistemas ou pessoas.

Nunca peça ao usuário:
- senhas;
- tokens;
- chaves de API;
- dados bancários;
- credenciais.

Se o usuário enviar informações sensíveis, recomende removê-las.
`;

    const input = [
      {
        role: "system",
        content: system
      },
      ...messages.slice(-20).map((message) => ({
        role: message.role === "assistant" ? "assistant" : "user",
        content: String(message.content || "")
      }))
    ];

    const response = await fetch(
      "https://api.openai.com/v1/responses",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${apiKey}`
        },
        body: JSON.stringify({
          model,
          input
        })
      }
    );

    const data = await response.json();

    if (!response.ok) {
      return new Response(
        JSON.stringify({
          error:
            data?.error?.message ||
            "Não foi possível obter uma resposta da IA."
        }),
        {
          status: response.status,
          headers: { "Content-Type": "application/json" }
        }
      );
    }

    return new Response(
      JSON.stringify({
        answer:
          data.output_text ||
          "Não consegui gerar uma resposta."
      }),
      {
        status: 200,
        headers: { "Content-Type": "application/json" }
      }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({
        error: "Erro interno ao processar a solicitação."
      }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" }
      }
    );
  }
};
