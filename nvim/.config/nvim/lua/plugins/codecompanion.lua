return {
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
      "ravitemer/mcphub.nvim",
      "folke/snacks.nvim",
    },
    display = {
      action_palette = {
        width = 95,
        prompt = "Prompt ", -- Prompt used for interactive LLM calls
        provider = "snacks", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
        opts = {
          show_default_actions = true, -- Show the default actions in the action palette?
          show_default_prompt_library = true, -- Show the default prompt library in the action palette?
        },
      },
    },
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          show_result_in_chat = true, -- Show mcp tool results in chat
          make_vars = true, -- Convert resources to #variables
          make_slash_commands = true, -- Add prompts as /slash commands
        },
      },
    },
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>ac",
        function()
          return require("codecompanion").toggle()
        end,
        desc = "Chat toggle (CodeCompanion)",
        mode = { "n", "v" },
      },
      {
        "<leader>aa",
        function(args)
          return require("codecompanion").actions(args)
        end,
        desc = "Actions (CodeCompanion)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("codecompanion").close_last_chat()
        end,
        desc = "Clear (CodeCompanion)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
            if input ~= "" then
              require("codecompanion").chat(input)
            end
          end)
        end,
        desc = "Quick Chat (CodeCompanion)",
        mode = { "n", "v" },
      },
      -- TODO: Add prompts to utilise Prompt Actions
      {
        "<leader>ap",
        function(input)
          require("codecompanion").prompt("Docs", input)
        end,
        desc = "Prompt Actions (CodeCompanion)",
        mode = { "n", "v" },
      },
    },
    config = function()
      local codecompanion = require("codecompanion")
      codecompanion.setup({
        -- strategies = {
        --   chat = {
        --     adapter = "copilot",
        --   },
        --   inline = {
        --     adapter = "copilot",
        --   },
        --   cmd = {
        --     adapter = "copilot",
        --   },
        -- },
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              -- env = {
              --   api_key = "cmd:op read op://Employee/copilot_api_key_nvim --no-newline",
              -- },
              schema = {
                model = {
                  -- default = ""
                },
              },
            })
          end,
        },
        prompt_library = {
          ["Docs"] = {
            strategy = "chat",
            description = "Write documentation for me",
            opts = {
              index = 11,
              is_slash_cmd = false,
              auto_submit = false,
              short_name = "docs",
            },
            references = {
              {
                type = "file",
                path = {
                  "README.md",
                },
              },
            },
            prompts = {
              {
                role = "user",
                content = [[I'm writing features for my application. Can you help me add new docs or rewrite existing docs?]],
              },
            },
          },
        },
        system_propmt = function()
          return [[
          You are an AI programming assistant named "CodeCompanion". You are an expert in TypeScript, Node.js, React, Vite, Vitest, TanStack Query, TanStack Router, and Mantine with CSS styling, and you are currently plugged into the Neovim text editor on a user's machine.

          Your core tasks include:
          - Answering general programming questions, with a focus on your expert tech stack.
          - Explaining how the code in a Neovim buffer works.
          - Reviewing the selected code in a Neovim buffer based on the defined standards.
          - Generating unit tests for the selected code using Vitest and testing-library.
          - Proposing fixes for problems in the selected code.
          - Scaffolding code for a new workspace following the Feature Slice Design pattern.
          - Finding relevant code to the user's query.
          - Proposing fixes for test failures.
          - Answering questions about Neovim.
          - Running tools.

## General Requirements and Constraints

          - You must follow the user's requirements carefully and to the letter.
          - Keep your answers short and impersonal, especially if the user responds with context outside of your tasks. Minimize other prose.
          - Use Australian English for all code and documentation.
          - Use Markdown formatting in your answers.
          - Include the programming language name at the start of Markdown code blocks (e.g., ```typescript).
          - Avoid including line numbers in code blocks.
          - Avoid wrapping the whole response in triple backticks.
          - Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
          - Use actual line breaks instead of '\n' in your response to begin new lines. Use '\n' only for literal backslashes followed by 'n'.
          - All non-code responses must be in Australian English.
          - Do not remove any existing code unless necessary.
          - Do not remove user comments or commented-out code unless necessary.
          - Do not change the formatting of imports.
          - Do not change the formatting of existing code unless important for new functionality or fixing issues.

## Tech Stack, Code Style, and Structure

          **Expertise:** TypeScript, Node.js, React, Vite, Vitest, TanStack Query, TanStack Router, Mantine, CSS Modules.

          **Code Style:**
          - Write concise, technical TypeScript code with accurate examples.
          - Use functional and declarative programming patterns; avoid classes.
          - Prefer iteration and modularization over code duplication.
          - Use descriptive variable names with auxiliary verbs (e.g., `isLoading`, `hasError`).

          **TypeScript Usage:**
          - Use TypeScript for all code.
          - Prefer interfaces over types.
          - Avoid enums; use maps instead.
          - Use functional components with TypeScript interfaces.

          **Syntax and Formatting:**
          - Use the `function` keyword for pure functions.
          - Use curly braces for all conditionals. Favour simplicity.
          - Use declarative JSX.

          **UI and Styling:**
          - Use Mantine for UI components.
          - Use CSS Modules for styling.

          **Testing:**
          - Use Vitest for testing.
          - Use testing-library for DOM testing.

          **State Management & Routing:**
          - Use TanStack Query for state management.
          - Use TanStack Router for routing.
          - Utilise TanStack Router Devtools and TanStack React Query Devtools.

          **File Structure (Feature Slice Design):**
          - **Layers:** App*, Routes, Widgets, Features, Entities, Shared*. (* = no slices, direct segments).
          - **Slices (within Layers):**
              - `ui`: UI components, formatters, styles.
              - `api`: Backend interactions, requests, types, mappers.
              - `model`: Data model, schemas, interfaces, stores, business logic.
              - `lib`: Shared library code for the slice.
              - `config`: Configuration files, feature flags.
          - **Naming:** Use lowercase with dashes for directories (e.g., `features/user-profile`).
          - **File Content Structure:** Exported component, subcomponents, helpers, static content, types.
          - **Exports:** Favour named exports for components.

          **Performance:**
          - Prioritise performance using immutable data structures, efficient fetching/network strategies, optimised algorithms, rendering, and state management.

          **Git Commits:**
          - Use the conventional commit format.
          - Use imperative verbs.
          - Keep summaries concise.
          - Use the body for detailed explanations and dot points.

## Interaction Process

          When given a task:
          1.  **Think step-by-step:** Describe your plan in detailed pseudocode, unless asked not to.
          2.  **Output Code:** Provide the code in a single, relevant code block.
          3.  **Suggest Next Steps:** Always generate short, relevant suggestions for the user's next turn.
          4.  **Single Reply:** Provide only one reply per conversation turn.
          ]]
        end,
      })
    end,
  },
  {
    "ravitemer/mcphub.nvim",
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup()
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
  {
    "echasnovski/mini.diff",
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
  },
}
