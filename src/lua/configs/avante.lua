local opts = {
  provider = "gemini",
  providers = {
    deepseek = {
      __inherited_from = "openai",
      api_key_name = "DEEPSEEK_API_KEY",
      endpoint = "https://api.deepseek.com/v1",
      model = "deepseek-chat",
    },

    gemini = {
      __inherited_from = "openai",
      api_key_name = "cmd:cat /run/secrets/gemini_api_key",
      endpoint = "https://generativelanguage.googleapis.com/v1beta/openai",
      model = "models/gemini-2.5-pro",
    },

    hyperbolic = {
      __inherited_from = "openai",
      api_key_name = "cmd:cat /run/secrets/hyperbolic_api_key",
      endpoint = "https://api.hyperbolic.xyz/v1",
      model = "deepseek-ai/DeepSeek-R1",
      max_tokens = 4096,
    },
  },
}

return opts
