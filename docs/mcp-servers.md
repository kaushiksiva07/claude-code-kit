# MCP Servers

This kit does not bundle any MCP servers — they're optional and often personal infrastructure. The section below documents the setup the kit was extracted from, so you have a reference if you want to wire similar servers yourself.

## Reference setup

The author's `~/.claude/settings.json` originally included:

```json
"mcpServers": {
  "codebase-memory-mcp": {
    "type": "stdio",
    "command": "C:\\Users\\...\\codebase-memory-mcp.exe"
  }
}
```

That's a local-only binary that gives Claude a persistent, file-backed memory keyed by project directory. It's not public; it's not part of this kit; the path is skipped from the template on purpose.

## What MCP does

MCP (Model Context Protocol) servers let Claude Code call into external tools at runtime — databases, file stores, SaaS APIs, custom LLMs. Each server registers in `mcpServers`, and its tools appear to Claude as regular tool calls.

## Adding an MCP server

Edit `~/.claude/settings.json` and add an entry under `mcpServers`. Two common shapes:

```json
"mcpServers": {
  "my-local-tool": {
    "type": "stdio",
    "command": "/usr/local/bin/my-mcp-server",
    "args": ["--config", "/path/to/config.json"]
  },
  "my-http-service": {
    "type": "http",
    "url": "http://localhost:4000/mcp"
  }
}
```

Restart Claude Code. Run `/mcp` to confirm the server's tools are discovered.

## Public MCP servers worth trying

- [`@modelcontextprotocol/server-filesystem`](https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem)
- [`@modelcontextprotocol/server-github`](https://github.com/modelcontextprotocol/servers/tree/main/src/github)
- [`@modelcontextprotocol/server-postgres`](https://github.com/modelcontextprotocol/servers/tree/main/src/postgres)

The official marketplace and many community directories list more. None of them are required by this kit.
