---
description: Research assistant chatbot - web search & file reading, no code changes
mode: primary
temperature: 0.6
prompt: "{file:~/.config/opencode/prompts/assistant.txt}"
tools:
  webfetch: true
  read: true
  glob: true
  grep: true
  write: false
  edit: false
  bash: false
permission:
  edit: deny
  bash: deny
---
