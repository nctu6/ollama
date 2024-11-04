<div align="center">
 <img alt="unieai" height="200px" src="https://github.com/nctu6/unieai/assets/3325447/0d0b44e2-8f4a-4e99-9b52-a5c1c741c8f7">
</div>

# Unieai

[![Discord](https://dcbadge.vercel.app/api/server/unieai?style=flat&compact=true)](https://discord.gg/unieai)

Get up and running with large language models.

### macOS

[Download](https://unieai.com/download/Unieai-darwin.zip)

### Windows

[Download](https://unieai.com/download/UnieaiSetup.exe)

### Linux

```
curl -fsSL https://unieai.com/install.sh | sh
```

[Manual install instructions](https://github.com/nctu6/unieai/blob/main/docs/linux.md)

### Docker

The official [Unieai Docker image](https://hub.docker.com/r/unieai/unieai) `unieai/unieai` is available on Docker Hub.

### Libraries

- [unieai-python](https://github.com/nctu6/unieai-python)
- [unieai-js](https://github.com/nctu6/unieai-js)

## Quickstart

To run and chat with [Llama 3.2](https://unieai.com/library/llama3.2):

```
unieai run llama3.2
```

## Model library

Unieai supports a list of models available on [unieai.com/library](https://unieai.com/library 'unieai model library')

Here are some example models that can be downloaded:

| Model              | Parameters | Size  | Download                       |
| ------------------ | ---------- | ----- | ------------------------------ |
| Llama 3.2          | 3B         | 2.0GB | `unieai run llama3.2`          |
| Llama 3.2          | 1B         | 1.3GB | `unieai run llama3.2:1b`       |
| Llama 3.1          | 8B         | 4.7GB | `unieai run llama3.1`          |
| Llama 3.1          | 70B        | 40GB  | `unieai run llama3.1:70b`      |
| Llama 3.1          | 405B       | 231GB | `unieai run llama3.1:405b`     |
| Phi 3 Mini         | 3.8B       | 2.3GB | `unieai run phi3`              |
| Phi 3 Medium       | 14B        | 7.9GB | `unieai run phi3:medium`       |
| Gemma 2            | 2B         | 1.6GB | `unieai run gemma2:2b`         |
| Gemma 2            | 9B         | 5.5GB | `unieai run gemma2`            |
| Gemma 2            | 27B        | 16GB  | `unieai run gemma2:27b`        |
| Mistral            | 7B         | 4.1GB | `unieai run mistral`           |
| Moondream 2        | 1.4B       | 829MB | `unieai run moondream`         |
| Neural Chat        | 7B         | 4.1GB | `unieai run neural-chat`       |
| Starling           | 7B         | 4.1GB | `unieai run starling-lm`       |
| Code Llama         | 7B         | 3.8GB | `unieai run codellama`         |
| Llama 2 Uncensored | 7B         | 3.8GB | `unieai run llama2-uncensored` |
| LLaVA              | 7B         | 4.5GB | `unieai run llava`             |
| Solar              | 10.7B      | 6.1GB | `unieai run solar`             |

> [!NOTE]
> You should have at least 8 GB of RAM available to run the 7B models, 16 GB to run the 13B models, and 32 GB to run the 33B models.

## Customize a model

### Import from GGUF

Unieai supports importing GGUF models in the Modelfile:

1. Create a file named `Modelfile`, with a `FROM` instruction with the local filepath to the model you want to import.

   ```
   FROM ./vicuna-33b.Q4_0.gguf
   ```

2. Create the model in Unieai

   ```
   unieai create example -f Modelfile
   ```

3. Run the model

   ```
   unieai run example
   ```

### Import from PyTorch or Safetensors

See the [guide](docs/import.md) on importing models for more information.

### Customize a prompt

Models from the Unieai library can be customized with a prompt. For example, to customize the `llama3.2` model:

```
unieai pull llama3.2
```

Create a `Modelfile`:

```
FROM llama3.2

# set the temperature to 1 [higher is more creative, lower is more coherent]
PARAMETER temperature 1

# set the system message
SYSTEM """
You are Mario from Super Mario Bros. Answer as Mario, the assistant, only.
"""
```

Next, create and run the model:

```
unieai create mario -f ./Modelfile
unieai run mario
>>> hi
Hello! It's your friend Mario.
```

For more examples, see the [examples](examples) directory. For more information on working with a Modelfile, see the [Modelfile](docs/modelfile.md) documentation.

## CLI Reference

### Create a model

`unieai create` is used to create a model from a Modelfile.

```
unieai create mymodel -f ./Modelfile
```

### Pull a model

```
unieai pull llama3.2
```

> This command can also be used to update a local model. Only the diff will be pulled.

### Remove a model

```
unieai rm llama3.2
```

### Copy a model

```
unieai cp llama3.2 my-model
```

### Multiline input

For multiline input, you can wrap text with `"""`:

```
>>> """Hello,
... world!
... """
I'm a basic program that prints the famous "Hello, world!" message to the console.
```

### Multimodal models

```
unieai run llava "What's in this image? /Users/jmorgan/Desktop/smile.png"
The image features a yellow smiley face, which is likely the central focus of the picture.
```

### Pass the prompt as an argument

```
$ unieai run llama3.2 "Summarize this file: $(cat README.md)"
 Unieai is a lightweight, extensible framework for building and running language models on the local machine. It provides a simple API for creating, running, and managing models, as well as a library of pre-built models that can be easily used in a variety of applications.
```

### Show model information

```
unieai show llama3.2
```

### List models on your computer

```
unieai list
```

### List which models are currently loaded

```
unieai ps
```

### Stop a model which is currently running

```
unieai stop llama3.2
```

### Start Unieai

`unieai serve` is used when you want to start unieai without running the desktop application.

## Building

See the [developer guide](https://github.com/nctu6/unieai/blob/main/docs/development.md)

### Running local builds

Next, start the server:

```
./unieai serve
```

Finally, in a separate shell, run a model:

```
./unieai run llama3.2
```

## REST API

Unieai has a REST API for running and managing models.

### Generate a response

```
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt":"Why is the sky blue?"
}'
```

### Chat with a model

```
curl http://localhost:11434/api/chat -d '{
  "model": "llama3.2",
  "messages": [
    { "role": "user", "content": "why is the sky blue?" }
  ]
}'
```

See the [API documentation](./docs/api.md) for all endpoints.

## Community Integrations

### Web & Desktop

- [Open WebUI](https://github.com/open-webui/open-webui)
- [Enchanted (macOS native)](https://github.com/AugustDev/enchanted)
- [Hollama](https://github.com/fmaclen/hollama)
- [Lollms-Webui](https://github.com/ParisNeo/lollms-webui)
- [LibreChat](https://github.com/danny-avila/LibreChat)
- [Bionic GPT](https://github.com/bionic-gpt/bionic-gpt)
- [HTML UI](https://github.com/rtcfirefly/unieai-ui)
- [Saddle](https://github.com/jikkuatwork/saddle)
- [Chatbot UI](https://github.com/ivanfioravanti/chatbot-unieai)
- [Chatbot UI v2](https://github.com/mckaywrigley/chatbot-ui)
- [Typescript UI](https://github.com/unieai-interface/Unieai-Gui?tab=readme-ov-file)
- [Minimalistic React UI for Unieai Models](https://github.com/richawo/minimal-llm-ui)
- [Ollamac](https://github.com/kevinhermawan/Ollamac)
- [big-AGI](https://github.com/enricoros/big-AGI/blob/main/docs/config-local-unieai.md)
- [Cheshire Cat assistant framework](https://github.com/cheshire-cat-ai/core)
- [Amica](https://github.com/semperai/amica)
- [chatd](https://github.com/BruceMacD/chatd)
- [Unieai-SwiftUI](https://github.com/kghandour/Unieai-SwiftUI)
- [Dify.AI](https://github.com/langgenius/dify)
- [MindMac](https://mindmac.app)
- [NextJS Web Interface for Unieai](https://github.com/jakobhoeg/nextjs-unieai-llm-ui)
- [Msty](https://msty.app)
- [Chatbox](https://github.com/Bin-Huang/Chatbox)
- [WinForm Unieai Copilot](https://github.com/tgraupmann/WinForm_unieai_Copilot)
- [NextChat](https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web) with [Get Started Doc](https://docs.nextchat.dev/models/unieai)
- [Alpaca WebUI](https://github.com/mmo80/alpaca-webui)
- [OllamaGUI](https://github.com/enoch1118/ollamaGUI)
- [OpenAOE](https://github.com/InternLM/OpenAOE)
- [Odin Runes](https://github.com/leonid20000/OdinRunes)
- [LLM-X](https://github.com/mrdjohnson/llm-x) (Progressive Web App)
- [AnythingLLM (Docker + MacOs/Windows/Linux native app)](https://github.com/Mintplex-Labs/anything-llm)
- [Unieai Basic Chat: Uses HyperDiv Reactive UI](https://github.com/rapidarchitect/unieai_basic_chat)
- [Unieai-chats RPG](https://github.com/drazdra/unieai-chats)
- [QA-Pilot](https://github.com/reid41/QA-Pilot) (Chat with Code Repository)
- [ChatOllama](https://github.com/sugarforever/chat-unieai) (Open Source Chatbot based on Unieai with Knowledge Bases)
- [CRAG Unieai Chat](https://github.com/Nagi-ovo/CRAG-Unieai-Chat) (Simple Web Search with Corrective RAG)
- [RAGFlow](https://github.com/infiniflow/ragflow) (Open-source Retrieval-Augmented Generation engine based on deep document understanding)
- [StreamDeploy](https://github.com/StreamDeploy-DevRel/streamdeploy-llm-app-scaffold) (LLM Application Scaffold)
- [chat](https://github.com/swuecho/chat) (chat web app for teams)
- [Lobe Chat](https://github.com/lobehub/lobe-chat) with [Integrating Doc](https://lobehub.com/docs/self-hosting/examples/unieai)
- [Unieai RAG Chatbot](https://github.com/datvodinh/rag-chatbot.git) (Local Chat with multiple PDFs using Unieai and RAG)
- [BrainSoup](https://www.nurgo-software.com/products/brainsoup) (Flexible native client with RAG & multi-agent automation)
- [macai](https://github.com/Renset/macai) (macOS client for Unieai, ChatGPT, and other compatible API back-ends)
- [Olpaka](https://github.com/Otacon/olpaka) (User-friendly Flutter Web App for Unieai)
- [OllamaSpring](https://github.com/CrazyNeil/OllamaSpring) (Unieai Client for macOS)
- [LLocal.in](https://github.com/kartikm7/llocal) (Easy to use Electron Desktop Client for Unieai)
- [AiLama](https://github.com/zeyoyt/ailama) (A Discord User App that allows you to interact with Unieai anywhere in discord )
- [Unieai with Google Mesop](https://github.com/rapidarchitect/unieai_mesop/) (Mesop Chat Client implementation with Unieai)
- [Painting Droid](https://github.com/mateuszmigas/painting-droid) (Painting app with AI integrations)
- [Kerlig AI](https://www.kerlig.com/) (AI writing assistant for macOS)
- [AI Studio](https://github.com/MindWorkAI/AI-Studio)
- [Sidellama](https://github.com/gyopak/sidellama) (browser-based LLM client)
- [LLMStack](https://github.com/trypromptly/LLMStack) (No-code multi-agent framework to build LLM agents and workflows)
- [BoltAI for Mac](https://boltai.com) (AI Chat Client for Mac)
- [Harbor](https://github.com/av/harbor) (Containerized LLM Toolkit with Unieai as default backend)
- [Go-CREW](https://www.jonathanhecl.com/go-crew/) (Powerful Offline RAG in Golang)
- [PartCAD](https://github.com/openvmp/partcad/) (CAD model generation with OpenSCAD and CadQuery)
- [Ollama4j Web UI](https://github.com/ollama4j/ollama4j-web-ui) - Java-based Web UI for Unieai built with Vaadin, Spring Boot and Ollama4j
- [PyOllaMx](https://github.com/kspviswa/pyOllaMx) - macOS application capable of chatting with both Unieai and Apple MLX models.
- [Claude Dev](https://github.com/saoudrizwan/claude-dev) - VSCode extension for multi-file/whole-repo coding
- [Cherry Studio](https://github.com/kangfenmao/cherry-studio) (Desktop client with Unieai support)
- [ConfiChat](https://github.com/1runeberg/confichat) (Lightweight, standalone, multi-platform, and privacy focused LLM chat interface with optional encryption)
- [Archyve](https://github.com/nickthecook/archyve) (RAG-enabling document library)
- [crewAI with Mesop](https://github.com/rapidarchitect/unieai-crew-mesop) (Mesop Web Interface to run crewAI with Unieai)
- [LLMChat](https://github.com/trendy-design/llmchat) (Privacy focused, 100% local, intuitive all-in-one chat interface)
- [ARGO](https://github.com/xark-argo/argo) (Locally download and run Unieai and Huggingface models with RAG on Mac/Windows/Linux)
- [G1](https://github.com/bklieger-groq/g1) (Prototype of using prompting strategies to improve the LLM's reasoning through o1-like reasoning chains.)
- [Unieai App](https://github.com/JHubi1/unieai-app) (Modern and easy-to-use multi-platform client for Unieai)

### Terminal

- [oterm](https://github.com/ggozad/oterm)
- [Ellama Emacs client](https://github.com/s-kostyaev/ellama)
- [Emacs client](https://github.com/zweifisch/unieai)
- [gen.nvim](https://github.com/David-Kunz/gen.nvim)
- [unieai.nvim](https://github.com/nomnivore/unieai.nvim)
- [ollero.nvim](https://github.com/marco-souza/ollero.nvim)
- [unieai-chat.nvim](https://github.com/gerazov/unieai-chat.nvim)
- [ogpt.nvim](https://github.com/huynle/ogpt.nvim)
- [gptel Emacs client](https://github.com/karthink/gptel)
- [Oatmeal](https://github.com/dustinblackman/oatmeal)
- [cmdh](https://github.com/pgibler/cmdh)
- [ooo](https://github.com/npahlfer/ooo)
- [shell-pilot](https://github.com/reid41/shell-pilot)
- [tenere](https://github.com/pythops/tenere)
- [llm-unieai](https://github.com/taketwo/llm-unieai) for [Datasette's LLM CLI](https://llm.datasette.io/en/stable/).
- [typechat-cli](https://github.com/anaisbetts/typechat-cli)
- [ShellOracle](https://github.com/djcopley/ShellOracle)
- [tlm](https://github.com/yusufcanb/tlm)
- [podman-unieai](https://github.com/ericcurtin/podman-unieai)
- [gollama](https://github.com/sammcj/gollama)
- [Unieai eBook Summary](https://github.com/cognitivetech/unieai-ebook-summary/)
- [Unieai Mixture of Experts (MOE) in 50 lines of code](https://github.com/rapidarchitect/unieai_moe)
- [vim-intelligence-bridge](https://github.com/pepo-ec/vim-intelligence-bridge) Simple interaction of "Unieai" with the Vim editor

### Apple Vision Pro
- [Enchanted](https://github.com/AugustDev/enchanted)

### Database

- [MindsDB](https://github.com/mindsdb/mindsdb/blob/staging/mindsdb/integrations/handlers/unieai_handler/README.md) (Connects Unieai models with nearly 200 data platforms and apps)
- [chromem-go](https://github.com/philippgille/chromem-go/blob/v0.5.0/embed_ollama.go) with [example](https://github.com/philippgille/chromem-go/tree/v0.5.0/examples/rag-wikipedia-unieai)

### Package managers

- [Pacman](https://archlinux.org/packages/extra/x86_64/unieai/)
- [Gentoo](https://github.com/gentoo/guru/tree/master/app-misc/unieai)
- [Helm Chart](https://artifacthub.io/packages/helm/unieai-helm/unieai)
- [Guix channel](https://codeberg.org/tusharhero/unieai-guix)
- [Nix package](https://search.nixos.org/packages?channel=24.05&show=unieai&from=0&size=50&sort=relevance&type=packages&query=unieai)
- [Flox](https://flox.dev/blog/unieai-part-one)

### Libraries

- [LangChain](https://python.langchain.com/docs/integrations/llms/unieai) and [LangChain.js](https://js.langchain.com/docs/integrations/chat/unieai/) with [example](https://js.langchain.com/docs/tutorials/local_rag/)
- [Firebase Genkit](https://firebase.google.com/docs/genkit/plugins/unieai)
- [crewAI](https://github.com/crewAIInc/crewAI)
- [LangChainGo](https://github.com/tmc/langchaingo/) with [example](https://github.com/tmc/langchaingo/tree/main/examples/unieai-completion-example)
- [LangChain4j](https://github.com/langchain4j/langchain4j) with [example](https://github.com/langchain4j/langchain4j-examples/tree/main/unieai-examples/src/main/java)
- [LangChainRust](https://github.com/Abraxas-365/langchain-rust) with [example](https://github.com/Abraxas-365/langchain-rust/blob/main/examples/llm_ollama.rs)
- [LlamaIndex](https://docs.llamaindex.ai/en/stable/examples/llm/unieai/) and [LlamaIndexTS](https://ts.llamaindex.ai/modules/llms/available_llms/unieai)
- [LiteLLM](https://github.com/BerriAI/litellm)
- [OllamaFarm for Go](https://github.com/presbrey/ollamafarm)
- [OllamaSharp for .NET](https://github.com/awaescher/OllamaSharp)
- [Unieai for Ruby](https://github.com/gbaptista/unieai-ai)
- [Unieai-rs for Rust](https://github.com/pepperoni21/unieai-rs)
- [Unieai-hpp for C++](https://github.com/jmont-dev/unieai-hpp)
- [Ollama4j for Java](https://github.com/ollama4j/ollama4j)
- [ModelFusion Typescript Library](https://modelfusion.dev/integration/model-provider/unieai)
- [OllamaKit for Swift](https://github.com/kevinhermawan/OllamaKit)
- [Unieai for Dart](https://github.com/breitburg/dart-unieai)
- [Unieai for Laravel](https://github.com/cloudstudio/unieai-laravel)
- [LangChainDart](https://github.com/davidmigloz/langchain_dart)
- [Semantic Kernel - Python](https://github.com/microsoft/semantic-kernel/tree/main/python/semantic_kernel/connectors/ai/unieai)
- [Haystack](https://github.com/deepset-ai/haystack-integrations/blob/main/integrations/unieai.md)
- [Elixir LangChain](https://github.com/brainlid/langchain)
- [Unieai for R - rollama](https://github.com/JBGruber/rollama)
- [Unieai for R - unieai-r](https://github.com/hauselin/unieai-r)
- [Unieai-ex for Elixir](https://github.com/lebrunel/unieai-ex)
- [Unieai Connector for SAP ABAP](https://github.com/b-tocs/abap_btocs_ollama)
- [Testcontainers](https://testcontainers.com/modules/unieai/)
- [Portkey](https://portkey.ai/docs/welcome/integration-guides/unieai)
- [PromptingTools.jl](https://github.com/svilupp/PromptingTools.jl) with an [example](https://svilupp.github.io/PromptingTools.jl/dev/examples/working_with_ollama)
- [LlamaScript](https://github.com/Project-Llama/llamascript)
- [Gollm](https://docs.gollm.co/examples/unieai-example)
- [Ollamaclient for Golang](https://github.com/xyproto/ollamaclient)
- [High-level function abstraction in Go](https://gitlab.com/tozd/go/fun)
- [Unieai PHP](https://github.com/ArdaGnsrn/unieai-php)
- [Agents-Flex for Java](https://github.com/agents-flex/agents-flex) with [example](https://github.com/agents-flex/agents-flex/tree/main/agents-flex-llm/agents-flex-llm-unieai/src/test/java/com/agentsflex/llm/unieai)
- [Unieai for Swift](https://github.com/mattt/unieai-swift)

### Mobile

- [Enchanted](https://github.com/AugustDev/enchanted)
- [Maid](https://github.com/Mobile-Artificial-Intelligence/maid)
- [Unieai App](https://github.com/JHubi1/unieai-app) (Modern and easy-to-use multi-platform client for Unieai)
- [ConfiChat](https://github.com/1runeberg/confichat) (Lightweight, standalone, multi-platform, and privacy focused LLM chat interface with optional encryption)

### Extensions & Plugins

- [Raycast extension](https://github.com/MassimilianoPasquini97/raycast_ollama)
- [Discollama](https://github.com/mxyng/discollama) (Discord bot inside the Unieai discord channel)
- [Continue](https://github.com/continuedev/continue)
- [Obsidian Unieai plugin](https://github.com/hinterdupfinger/obsidian-unieai)
- [Logseq Unieai plugin](https://github.com/omagdy7/unieai-logseq)
- [NotesOllama](https://github.com/andersrex/notesollama) (Apple Notes Unieai plugin)
- [Dagger Chatbot](https://github.com/samalba/dagger-chatbot)
- [Discord AI Bot](https://github.com/mekb-turtle/discord-ai-bot)
- [Unieai Telegram Bot](https://github.com/ruecat/unieai-telegram)
- [Hass Unieai Conversation](https://github.com/ej52/hass-unieai-conversation)
- [Rivet plugin](https://github.com/abrenneke/rivet-plugin-unieai)
- [Obsidian BMO Chatbot plugin](https://github.com/longy2k/obsidian-bmo-chatbot)
- [Cliobot](https://github.com/herval/cliobot) (Telegram bot with Unieai support)
- [Copilot for Obsidian plugin](https://github.com/logancyang/obsidian-copilot)
- [Obsidian Local GPT plugin](https://github.com/pfrankov/obsidian-local-gpt)
- [Open Interpreter](https://docs.openinterpreter.com/language-model-setup/local-models/unieai)
- [Llama Coder](https://github.com/ex3ndr/llama-coder) (Copilot alternative using Unieai)
- [Unieai Copilot](https://github.com/bernardo-bruning/unieai-copilot) (Proxy that allows you to use unieai as a copilot like Github copilot)
- [twinny](https://github.com/rjmacarthy/twinny) (Copilot and Copilot chat alternative using Unieai)
- [Wingman-AI](https://github.com/RussellCanfield/wingman-ai) (Copilot code and chat alternative using Unieai and Hugging Face)
- [Page Assist](https://github.com/n4ze3m/page-assist) (Chrome Extension)
- [Plasmoid Unieai Control](https://github.com/imoize/plasmoid-ollamacontrol) (KDE Plasma extension that allows you to quickly manage/control Unieai model)
- [AI Telegram Bot](https://github.com/tusharhero/aitelegrambot) (Telegram bot using Unieai in backend)
- [AI ST Completion](https://github.com/yaroslavyaroslav/OpenAI-sublime-text) (Sublime Text 4 AI assistant plugin with Unieai support)
- [Discord-Unieai Chat Bot](https://github.com/kevinthedang/discord-unieai) (Generalized TypeScript Discord Bot w/ Tuning Documentation)
- [Discord AI chat/moderation bot](https://github.com/rapmd73/Companion) Chat/moderation bot written in python. Uses Unieai to create personalities.
- [Headless Unieai](https://github.com/nischalj10/headless-unieai) (Scripts to automatically install unieai client & models on any OS for apps that depends on unieai server)
- [vnc-lm](https://github.com/jk011ru/vnc-lm) (A containerized Discord bot with support for attachments and web links)
- [LSP-AI](https://github.com/SilasMarvin/lsp-ai) (Open-source language server for AI-powered functionality)
- [QodeAssist](https://github.com/Palm1r/QodeAssist) (AI-powered coding assistant plugin for Qt Creator)
- [Obsidian Quiz Generator plugin](https://github.com/ECuiDev/obsidian-quiz-generator)
- [TextCraft](https://github.com/suncloudsmoon/TextCraft) (Copilot in Word alternative using Unieai)

### Supported backends

- [llama.cpp](https://github.com/ggerganov/llama.cpp) project founded by Georgi Gerganov.

