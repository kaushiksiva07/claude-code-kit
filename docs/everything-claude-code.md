# everything-claude-code — the subset this kit uses

[`affaan-m/everything-claude-code`](https://github.com/affaan-m/everything-claude-code) is a large community library (48 agents, 183 skills) that layers on top of superpowers. This kit does **not** install the whole thing — a lot of it overlaps with what `superpowers` already provides (brainstorming, debugging, TDD, planning, verification, review) or targets stacks this setup doesn't touch.

The tables below are **only the components actually pulled in** by this kit's general `~/.claude/` setup. Descriptions are verbatim from each component's frontmatter.

**Totals used:** 13 agents · 4 skills.

If you want more, head upstream and cherry-pick from the full catalog yourself.

---

## Agents (13)

### Per-language code reviewers (6)

| Agent | Description |
|---|---|
| `go-reviewer` | Expert Go code reviewer specializing in idiomatic Go, concurrency patterns, error handling, and performance. Use for all Go code changes. MUST BE USED for Go projects. |
| `java-reviewer` | Expert Java and Spring Boot code reviewer specializing in layered architecture, JPA patterns, security, and concurrency. Use for all Java code changes. MUST BE USED for Spring Boot projects. |
| `kotlin-reviewer` | Kotlin and Android/KMP code reviewer. Reviews Kotlin code for idiomatic patterns, coroutine safety, Compose best practices, clean architecture violations, and common Android pitfalls. |
| `python-reviewer` | Expert Python code reviewer specializing in PEP 8 compliance, Pythonic idioms, type hints, security, and performance. Use for all Python code changes. MUST BE USED for Python projects. |
| `rust-reviewer` | Expert Rust code reviewer specializing in ownership, lifetimes, error handling, unsafe usage, and idiomatic patterns. Use for all Rust code changes. MUST BE USED for Rust projects. |
| `typescript-reviewer` | Expert TypeScript/JavaScript code reviewer specializing in type safety, async correctness, Node/web security, and idiomatic patterns. Use for all TypeScript and JavaScript code changes. MUST BE USED for TypeScript/JavaScript projects. |

### Build & dependency resolvers (4)

| Agent | Description |
|---|---|
| `go-build-resolver` | Go build, vet, and compilation error resolution specialist. Fixes build errors, go vet issues, and linter warnings with minimal changes. Use when Go builds fail. |
| `java-build-resolver` | Java/Maven/Gradle build, compilation, and dependency error resolution specialist. Fixes build errors, Java compiler errors, and Maven/Gradle issues with minimal changes. Use when Java or Spring Boot builds fail. |
| `kotlin-build-resolver` | Kotlin/Gradle build, compilation, and dependency error resolution specialist. Fixes build errors, Kotlin compiler errors, and Gradle issues with minimal changes. Use when Kotlin builds fail. |
| `rust-build-resolver` | Rust build, compilation, and dependency error resolution specialist. Fixes cargo build errors, borrow checker issues, and Cargo.toml problems with minimal changes. Use when Rust builds fail. |

### General quality (3)

| Agent | Description |
|---|---|
| `performance-optimizer` | Performance analysis and optimization specialist. Use PROACTIVELY for identifying bottlenecks, optimizing slow code, reducing bundle sizes, and improving runtime performance. Profiling, memory leaks, render optimization, and algorithmic improvements. |
| `security-reviewer` | Security vulnerability detection and remediation specialist. Use PROACTIVELY after writing code that handles user input, authentication, API endpoints, or sensitive data. Flags secrets, SSRF, injection, unsafe crypto, and OWASP Top 10 vulnerabilities. |
| `silent-failure-hunter` | Review code for silent failures, swallowed errors, bad fallbacks, and missing error propagation. |

---

## Skills (4)

| Skill | Description |
|---|---|
| `continuous-learning` | Automatically extract reusable patterns from Claude Code sessions and save them as learned skills for future use. |
| `kotlin-coroutines-flows` | Kotlin Coroutines and Flow patterns for Android and KMP — structured concurrency, Flow operators, StateFlow, error handling, and testing. |
| `kotlin-patterns` | Idiomatic Kotlin patterns, best practices, and conventions for building robust, efficient, and maintainable Kotlin applications with coroutines, null safety, and DSL builders. |
| `kotlin-testing` | Kotlin testing patterns with Kotest, MockK, coroutine testing, property-based testing, and Kover coverage. Follows TDD methodology with idiomatic Kotlin practices. |

---

## Why this subset (and not the rest)

Two filters were applied when picking from the upstream buffet:

1. **Skip overlap with superpowers.** Anything the base layer already provides well — general code review, brainstorming, debugging, TDD, planning, verification, git workflows, codebase onboarding — is not pulled in a second time. Layering duplicates confuses which skill actually fires.
2. **Keep only what matches the target stack.** The kit's active targets are Kotlin/Android and cloud-Lambda Python, with Go/Java/Rust/TypeScript showing up as neighboring systems. Languages and frameworks outside that footprint (Swift, Flutter, Laravel, Django, NestJS, C++, Perl, .NET, etc.) are skipped even if their ECC components are excellent.

The result is a review-heavy slice: per-language reviewers, build-failure resolvers, and a few cross-cutting quality agents (`performance-optimizer`, `security-reviewer`, `silent-failure-hunter`). The four skills are the Kotlin language references plus the `continuous-learning` meta-skill that feeds the memory system.

If your footprint is different, the full inventory is [upstream](https://github.com/affaan-m/everything-claude-code) — clone it, browse the `agents/` and `skills/` directories, and copy what fits.
