# everything-claude-code — full inventory

Descriptions are copied verbatim from each component's frontmatter in [`affaan-m/everything-claude-code`](https://github.com/affaan-m/everything-claude-code). This is the optional larger layer above `superpowers` — install it if you want the full buffet rather than just this kit's 9 curated skills and 2 agents.

**Totals:** 48 agents · 183 skills.

---

## Agents (48)

Grouped by domain. Names are unchanged; descriptions are the one-line frontmatter `description:` fields.

### Per-language code reviewers (10)

| Agent | Description |
|---|---|
| `cpp-reviewer` | Expert C++ code reviewer specializing in memory safety, modern C++ idioms, concurrency, and performance. Use for all C++ code changes. MUST BE USED for C++ projects. |
| `csharp-reviewer` | Expert C# code reviewer specializing in .NET conventions, async patterns, security, nullable reference types, and performance. Use for all C# code changes. MUST BE USED for C# projects. |
| `flutter-reviewer` | Flutter and Dart code reviewer. Reviews Flutter code for widget best practices, state management patterns, Dart idioms, performance pitfalls, accessibility, and clean architecture violations. Library-agnostic — works with any state management solution and tooling. |
| `go-reviewer` | Expert Go code reviewer specializing in idiomatic Go, concurrency patterns, error handling, and performance. Use for all Go code changes. MUST BE USED for Go projects. |
| `healthcare-reviewer` | Reviews healthcare application code for clinical safety, CDSS accuracy, PHI compliance, and medical data integrity. Specialized for EMR/EHR, clinical decision support, and health information systems. |
| `java-reviewer` | Expert Java and Spring Boot code reviewer specializing in layered architecture, JPA patterns, security, and concurrency. Use for all Java code changes. MUST BE USED for Spring Boot projects. |
| `kotlin-reviewer` | Kotlin and Android/KMP code reviewer. Reviews Kotlin code for idiomatic patterns, coroutine safety, Compose best practices, clean architecture violations, and common Android pitfalls. |
| `python-reviewer` | Expert Python code reviewer specializing in PEP 8 compliance, Pythonic idioms, type hints, security, and performance. Use for all Python code changes. MUST BE USED for Python projects. |
| `rust-reviewer` | Expert Rust code reviewer specializing in ownership, lifetimes, error handling, unsafe usage, and idiomatic patterns. Use for all Rust code changes. MUST BE USED for Rust projects. |
| `typescript-reviewer` | Expert TypeScript/JavaScript code reviewer specializing in type safety, async correctness, Node/web security, and idiomatic patterns. Use for all TypeScript and JavaScript code changes. MUST BE USED for TypeScript/JavaScript projects. |

### Build & dependency resolvers (8)

| Agent | Description |
|---|---|
| `build-error-resolver` | Build and TypeScript error resolution specialist. Use PROACTIVELY when build fails or type errors occur. Fixes build/type errors only with minimal diffs, no architectural edits. Focuses on getting the build green quickly. |
| `cpp-build-resolver` | C++ build, CMake, and compilation error resolution specialist. Fixes build errors, linker issues, and template errors with minimal changes. Use when C++ builds fail. |
| `dart-build-resolver` | Dart/Flutter build, analysis, and dependency error resolution specialist. Fixes `dart analyze` errors, Flutter compilation failures, pub dependency conflicts, and build_runner issues with minimal, surgical changes. Use when Dart/Flutter builds fail. |
| `go-build-resolver` | Go build, vet, and compilation error resolution specialist. Fixes build errors, go vet issues, and linter warnings with minimal changes. Use when Go builds fail. |
| `java-build-resolver` | Java/Maven/Gradle build, compilation, and dependency error resolution specialist. Fixes build errors, Java compiler errors, and Maven/Gradle issues with minimal changes. Use when Java or Spring Boot builds fail. |
| `kotlin-build-resolver` | Kotlin/Gradle build, compilation, and dependency error resolution specialist. Fixes build errors, Kotlin compiler errors, and Gradle issues with minimal changes. Use when Kotlin builds fail. |
| `pytorch-build-resolver` | PyTorch runtime, CUDA, and training error resolution specialist. Fixes tensor shape mismatches, device errors, gradient issues, DataLoader problems, and mixed precision failures with minimal changes. Use when PyTorch training or inference crashes. |
| `rust-build-resolver` | Rust build, compilation, and dependency error resolution specialist. Fixes cargo build errors, borrow checker issues, and Cargo.toml problems with minimal changes. Use when Rust builds fail. |

### General quality (10)

| Agent | Description |
|---|---|
| `code-reviewer` | Expert code review specialist. Proactively reviews code for quality, security, and maintainability. Use immediately after writing or modifying code. MUST BE USED for all code changes. |
| `code-simplifier` | Simplifies and refines code for clarity, consistency, and maintainability while preserving behavior. Focus on recently modified code unless instructed otherwise. |
| `comment-analyzer` | Analyze code comments for accuracy, completeness, maintainability, and comment rot risk. |
| `performance-optimizer` | Performance analysis and optimization specialist. Use PROACTIVELY for identifying bottlenecks, optimizing slow code, reducing bundle sizes, and improving runtime performance. Profiling, memory leaks, render optimization, and algorithmic improvements. |
| `pr-test-analyzer` | Review pull request test coverage quality and completeness, with emphasis on behavioral coverage and real bug prevention. |
| `refactor-cleaner` | Dead code cleanup and consolidation specialist. Use PROACTIVELY for removing unused code, duplicates, and refactoring. Runs analysis tools (knip, depcheck, ts-prune) to identify dead code and safely removes it. |
| `security-reviewer` | Security vulnerability detection and remediation specialist. Use PROACTIVELY after writing code that handles user input, authentication, API endpoints, or sensitive data. Flags secrets, SSRF, injection, unsafe crypto, and OWASP Top 10 vulnerabilities. |
| `silent-failure-hunter` | Review code for silent failures, swallowed errors, bad fallbacks, and missing error propagation. |
| `tdd-guide` | Test-Driven Development specialist enforcing write-tests-first methodology. Use PROACTIVELY when writing new features, fixing bugs, or refactoring code. Ensures 80%+ test coverage. |
| `type-design-analyzer` | Analyze type design for encapsulation, invariant expression, usefulness, and enforcement. |

### Architecture & planning (5)

| Agent | Description |
|---|---|
| `architect` | Software architecture specialist for system design, scalability, and technical decision-making. Use PROACTIVELY when planning new features, refactoring large systems, or making architectural decisions. |
| `code-architect` | Designs feature architectures by analyzing existing codebase patterns and conventions, then providing implementation blueprints with concrete files, interfaces, data flow, and build order. |
| `code-explorer` | Deeply analyzes existing codebase features by tracing execution paths, mapping architecture layers, and documenting dependencies to inform new development. |
| `database-reviewer` | PostgreSQL database specialist for query optimization, schema design, security, and performance. Use PROACTIVELY when writing SQL, creating migrations, designing schemas, or troubleshooting database performance. Incorporates Supabase best practices. |
| `planner` | Expert planning specialist for complex features and refactoring. Use PROACTIVELY when users request feature implementation, architectural changes, or complex refactoring. Automatically activated for planning tasks. |

### Accessibility & SEO (2)

| Agent | Description |
|---|---|
| `a11y-architect` | Accessibility Architect specializing in WCAG 2.2 compliance for Web and Native platforms. Use PROACTIVELY when designing UI components, establishing design systems, or auditing code for inclusive user experiences. |
| `seo-specialist` | SEO specialist for technical SEO audits, on-page optimization, structured data, Core Web Vitals, and content/keyword mapping. Use for site audits, meta tag reviews, schema markup, sitemap and robots issues, and SEO remediation plans. |

### Docs & discovery (2)

| Agent | Description |
|---|---|
| `doc-updater` | Documentation and codemap specialist. Use PROACTIVELY for updating codemaps and documentation. Runs /update-codemaps and /update-docs, generates docs/CODEMAPS/*, updates READMEs and guides. |
| `docs-lookup` | When the user asks how to use a library, framework, or API or needs up-to-date code examples, use Context7 MCP to fetch current documentation and return answers with examples. Invoke for docs/API/setup questions. |

### Autonomous / agent ops (8)

| Agent | Description |
|---|---|
| `chief-of-staff` | Personal communication chief of staff that triages email, Slack, LINE, and Messenger. Classifies messages into 4 tiers (skip/info_only/meeting_info/action_required), generates draft replies, and enforces post-send follow-through via hooks. Use when managing multi-channel communication workflows. |
| `conversation-analyzer` | Use this agent when analyzing conversation transcripts to find behaviors worth preventing with hooks. Triggered by /hookify without arguments. |
| `e2e-runner` | End-to-end testing specialist using Vercel Agent Browser (preferred) with Playwright fallback. Use PROACTIVELY for generating, maintaining, and running E2E tests. Manages test journeys, quarantines flaky tests, uploads artifacts (screenshots, videos, traces), and ensures critical user flows work. |
| `gan-evaluator` | GAN Harness — Evaluator agent. Tests the live running application via Playwright, scores against rubric, and provides actionable feedback to the Generator. |
| `gan-generator` | GAN Harness — Generator agent. Implements features according to the spec, reads evaluator feedback, and iterates until quality threshold is met. |
| `gan-planner` | GAN Harness — Planner agent. Expands a one-line prompt into a full product specification with features, sprints, evaluation criteria, and design direction. |
| `harness-optimizer` | Analyze and improve the local agent harness configuration for reliability, cost, and throughput. |
| `loop-operator` | Operate autonomous agent loops, monitor progress, and intervene safely when loops stall. |

### Open-source pipeline (3)

| Agent | Description |
|---|---|
| `opensource-forker` | Fork any project for open-sourcing. Copies files, strips secrets and credentials (20+ patterns), replaces internal references with placeholders, generates .env.example, and cleans git history. First stage of the opensource-pipeline skill. |
| `opensource-packager` | Generate complete open-source packaging for a sanitized project. Produces CLAUDE.md, setup.sh, README.md, LICENSE, CONTRIBUTING.md, and GitHub issue templates. Makes any repo immediately usable with Claude Code. Third stage of the opensource-pipeline skill. |
| `opensource-sanitizer` | Verify an open-source fork is fully sanitized before release. Scans for leaked secrets, PII, internal references, and dangerous files using 20+ regex patterns. Generates a PASS/FAIL/PASS-WITH-WARNINGS report. Second stage of the opensource-pipeline skill. Use PROACTIVELY before any public release. |

---

## Skills (183)

Listed alphabetically. One table — at this volume, categorization is noisier than it's worth.

| Skill | Description |
|---|---|
| `accessibility` | Design, implement, and audit inclusive digital products using WCAG 2.2 Level AA |
| `agent-eval` | Head-to-head comparison of coding agents (Claude Code, Aider, Codex, etc.) on custom tasks with pass rate, cost, time, and consistency metrics |
| `agent-harness-construction` | Design and optimize AI agent action spaces, tool definitions, and observation formatting for higher completion rates. |
| `agent-introspection-debugging` | Structured self-debugging workflow for AI agent failures using capture, diagnosis, contained recovery, and introspection reports. |
| `agent-payment-x402` | Add x402 payment execution to AI agents — per-task budgets, spending controls, and non-custodial wallets via MCP tools. Use when agents need to pay for APIs, services, or other agents. |
| `agent-sort` | Build an evidence-backed ECC install plan for a specific repo by sorting skills, commands, rules, hooks, and extras into DAILY vs LIBRARY buckets using parallel repo-aware review passes. Use when ECC should be trimmed to what a project actually needs instead of loading the full bundle. |
| `agentic-engineering` | Operate as an agentic engineer using eval-first execution, decomposition, and cost-aware model routing. |
| `ai-first-engineering` | Engineering operating model for teams where AI agents generate a large share of implementation output. |
| `ai-regression-testing` | Regression testing strategies for AI-assisted development. Sandbox-mode API testing without database dependencies, automated bug-check workflows, and patterns to catch AI blind spots where the same model writes and reviews code. |
| `android-clean-architecture` | Clean Architecture patterns for Android and Kotlin Multiplatform projects — module structure, dependency rules, UseCases, Repositories, and data layer patterns. |
| `api-connector-builder` | Build a new API connector or provider by matching the target repo's existing integration pattern exactly. Use when adding one more integration without inventing a second architecture. |
| `api-design` | REST API design patterns including resource naming, status codes, pagination, filtering, error responses, versioning, and rate limiting for production APIs. |
| `architecture-decision-records` | Capture architectural decisions made during Claude Code sessions as structured ADRs. Auto-detects decision moments, records context, alternatives considered, and rationale. Maintains an ADR log so future developers understand why the codebase is shaped the way it is. |
| `article-writing` | Write articles, guides, blog posts, tutorials, newsletter issues, and other long-form content in a distinctive voice derived from supplied examples or brand guidance. Use when the user wants polished written content longer than a paragraph, especially when voice consistency, structure, and credibility matter. |
| `automation-audit-ops` | Evidence-first automation inventory and overlap audit workflow for ECC. Use when the user wants to know which jobs, hooks, connectors, MCP servers, or wrappers are live, broken, redundant, or missing before fixing anything. |
| `autonomous-agent-harness` | Transform Claude Code into a fully autonomous agent system with persistent memory, scheduled operations, computer use, and task queuing. Replaces standalone agent frameworks (Hermes, AutoGPT) by leveraging Claude Code's native crons, dispatch, MCP tools, and memory. Use when the user wants continuous autonomous operation, scheduled tasks, or a self-directing agent loop. |
| `autonomous-loops` | Patterns and architectures for autonomous Claude Code loops — from simple sequential pipelines to RFC-driven multi-agent DAG systems. |
| `backend-patterns` | Backend architecture patterns, API design, database optimization, and server-side best practices for Node.js, Express, and Next.js API routes. |
| `benchmark` | Use this skill to measure performance baselines, detect regressions before/after PRs, and compare stack alternatives. |
| `blueprint` | Turn a one-line objective into a step-by-step construction plan for multi-session, multi-agent engineering projects. Each step has a self-contained context brief so a fresh agent can execute it cold. Includes adversarial review gate, dependency graph, parallel step detection, anti-pattern catalog, and plan mutation protocol. TRIGGER when: user requests a plan, blueprint, or roadmap for a complex multi-PR task, or describes work that needs multiple sessions. DO NOT TRIGGER when: task is completable in a single PR or fewer than 3 tool calls, or user says "just do it". |
| `brand-voice` | Build a source-derived writing style profile from real posts, essays, launch notes, docs, or site copy, then reuse that profile across content, outreach, and social workflows. Use when the user wants voice consistency without generic AI writing tropes. |
| `browser-qa` | Use this skill to automate visual testing and UI interaction verification using browser automation after deploying features. |
| `bun-runtime` | Bun as runtime, package manager, bundler, and test runner. When to choose Bun vs Node, migration notes, and Vercel support. |
| `canary-watch` | Use this skill to monitor a deployed URL for regressions after deploys, merges, or dependency upgrades. |
| `carrier-relationship-management` | Codified expertise for managing carrier portfolios, negotiating freight rates, tracking carrier performance, allocating freight, and maintaining strategic carrier relationships. Informed by transportation managers with 15+ years experience. Includes scorecarding frameworks, RFP processes, market intelligence, and compliance vetting. Use when managing carriers, negotiating rates, evaluating carrier performance, or building freight strategies. |
| `ck` | Persistent per-project memory for Claude Code. Auto-loads project context on session start, tracks sessions with git activity, and writes to native memory. Commands run deterministic Node.js scripts — behavior is consistent across model versions. |
| `claude-api` | Anthropic Claude API patterns for Python and TypeScript. Covers Messages API, streaming, tool use, vision, extended thinking, batches, prompt caching, and Claude Agent SDK. Use when building applications with the Claude API or Anthropic SDKs. |
| `claude-devfleet` | Orchestrate multi-agent coding tasks via Claude DevFleet — plan projects, dispatch parallel agents in isolated worktrees, monitor progress, and read structured reports. |
| `click-path-audit` | Trace every user-facing button/touchpoint through its full state change sequence to find bugs where functions individually work but cancel each other out, produce wrong final state, or leave the UI in an inconsistent state. Use when: systematic debugging found no bugs but users report broken buttons, or after any major refactor touching shared state stores. |
| `clickhouse-io` | ClickHouse database patterns, query optimization, analytics, and data engineering best practices for high-performance analytical workloads. |
| `code-tour` | Create CodeTour `.tour` files — persona-targeted, step-by-step walkthroughs with real file and line anchors. Use for onboarding tours, architecture walkthroughs, PR tours, RCA tours, and structured "explain how this works" requests. |
| `codebase-onboarding` | Analyze an unfamiliar codebase and generate a structured onboarding guide with architecture map, key entry points, conventions, and a starter CLAUDE.md. Use when joining a new project or setting up Claude Code for the first time in a repo. |
| `coding-standards` | Baseline cross-project coding conventions for naming, readability, immutability, and code-quality review. Use detailed frontend or backend skills for framework-specific patterns. |
| `compose-multiplatform-patterns` | Compose Multiplatform and Jetpack Compose patterns for KMP projects — state management, navigation, theming, performance, and platform-specific UI. |
| `configure-ecc` | Interactive installer for Everything Claude Code — guides users through selecting and installing skills and rules to user-level or project-level directories, verifies paths, and optionally optimizes installed files. |
| `connections-optimizer` | Reorganize the user's X and LinkedIn network with review-first pruning, add/follow recommendations, and channel-specific warm outreach drafted in the user's real voice. Use when the user wants to clean up following lists, grow toward current priorities, or rebalance a social graph around higher-signal relationships. |
| `content-engine` | Create platform-native content systems for X, LinkedIn, TikTok, YouTube, newsletters, and repurposed multi-platform campaigns. Use when the user wants social posts, threads, scripts, content calendars, or one source asset adapted cleanly across platforms. |
| `content-hash-cache-pattern` | Cache expensive file processing results using SHA-256 content hashes — path-independent, auto-invalidating, with service layer separation. |
| `context-budget` | Audits Claude Code context window consumption across agents, skills, MCP servers, and rules. Identifies bloat, redundant components, and produces prioritized token-savings recommendations. |
| `continuous-agent-loop` | Patterns for continuous autonomous agent loops with quality gates, evals, and recovery controls. |
| `continuous-learning` | Automatically extract reusable patterns from Claude Code sessions and save them as learned skills for future use. |
| `continuous-learning-v2` | Instinct-based learning system that observes sessions via hooks, creates atomic instincts with confidence scoring, and evolves them into skills/commands/agents. v2.1 adds project-scoped instincts to prevent cross-project contamination. |
| `cost-aware-llm-pipeline` | Cost optimization patterns for LLM API usage — model routing by task complexity, budget tracking, retry logic, and prompt caching. |
| `council` | Convene a four-voice council for ambiguous decisions, tradeoffs, and go/no-go calls. Use when multiple valid paths exist and you need structured disagreement before choosing. |
| `cpp-coding-standards` | C++ coding standards based on the C++ Core Guidelines (isocpp.github.io). Use when writing, reviewing, or refactoring C++ code to enforce modern, safe, and idiomatic practices. |
| `cpp-testing` | Use only when writing/updating/fixing C++ tests, configuring GoogleTest/CTest, diagnosing failing or flaky tests, or adding coverage/sanitizers. |
| `crosspost` | Multi-platform content distribution across X, LinkedIn, Threads, and Bluesky. Adapts content per platform using content-engine patterns. Never posts identical content cross-platform. Use when the user wants to distribute content across social platforms. |
| `csharp-testing` | C# and .NET testing patterns with xUnit, FluentAssertions, mocking, integration tests, and test organization best practices. |
| `customer-billing-ops` | Operate customer billing workflows such as subscriptions, refunds, churn triage, billing-portal recovery, and plan analysis using connected billing tools like Stripe. Use when the user needs to help a customer, inspect subscription state, or manage revenue-impacting billing operations. |
| `customs-trade-compliance` | Codified expertise for customs documentation, tariff classification, duty optimization, restricted party screening, and regulatory compliance across multiple jurisdictions. Informed by trade compliance specialists with 15+ years experience. Includes HS classification logic, Incoterms application, FTA utilization, and penalty mitigation. Use when handling customs clearance, tariff classification, trade compliance, import/export documentation, or duty optimization. |
| `dart-flutter-patterns` | Production-ready Dart and Flutter patterns covering null safety, immutable state, async composition, widget architecture, popular state management frameworks (BLoC, Riverpod, Provider), GoRouter navigation, Dio networking, Freezed code generation, and clean architecture. |
| `dashboard-builder` | Build monitoring dashboards that answer real operator questions for Grafana, SigNoz, and similar platforms. Use when turning metrics into a working dashboard instead of a vanity board. |
| `data-scraper-agent` | Build a fully automated AI-powered data collection agent for any public source — job boards, prices, news, GitHub, sports, anything. Scrapes on a schedule, enriches data with a free LLM (Gemini Flash), stores results in Notion/Sheets/Supabase, and learns from user feedback. Runs 100% free on GitHub Actions. Use when the user wants to monitor, collect, or track any public data automatically. |
| `database-migrations` | Database migration best practices for schema changes, data migrations, rollbacks, and zero-downtime deployments across PostgreSQL, MySQL, and common ORMs (Prisma, Drizzle, Kysely, Django, TypeORM, golang-migrate). |
| `deep-research` | Multi-source deep research using firecrawl and exa MCPs. Searches the web, synthesizes findings, and delivers cited reports with source attribution. Use when the user wants thorough research on any topic with evidence and citations. |
| `defi-amm-security` | Security checklist for Solidity AMM contracts, liquidity pools, and swap flows. Covers reentrancy, CEI ordering, donation or inflation attacks, oracle manipulation, slippage, admin controls, and integer math. |
| `deployment-patterns` | Deployment workflows, CI/CD pipeline patterns, Docker containerization, health checks, rollback strategies, and production readiness checklists for web applications. |
| `design-system` | Use this skill to generate or audit design systems, check visual consistency, and review PRs that touch styling. |
| `django-patterns` | Django architecture patterns, REST API design with DRF, ORM best practices, caching, signals, middleware, and production-grade Django apps. |
| `django-security` | Django security best practices, authentication, authorization, CSRF protection, SQL injection prevention, XSS prevention, and secure deployment configurations. |
| `django-tdd` | Django testing strategies with pytest-django, TDD methodology, factory_boy, mocking, coverage, and testing Django REST Framework APIs. |
| `django-verification` | Verification loop for Django projects: migrations, linting, tests with coverage, security scans, and deployment readiness checks before release or PR. |
| `dmux-workflows` | Multi-agent orchestration using dmux (tmux pane manager for AI agents). Patterns for parallel agent workflows across Claude Code, Codex, OpenCode, and other harnesses. Use when running multiple agent sessions in parallel or coordinating multi-agent development workflows. |
| `docker-patterns` | Docker and Docker Compose patterns for local development, container security, networking, volume strategies, and multi-service orchestration. |
| `documentation-lookup` | Use up-to-date library and framework docs via Context7 MCP instead of training data. Activates for setup questions, API references, code examples, or when the user names a framework (e.g. React, Next.js, Prisma). |
| `dotnet-patterns` | Idiomatic C# and .NET patterns, conventions, dependency injection, async/await, and best practices for building robust, maintainable .NET applications. |
| `e2e-testing` | Playwright E2E testing patterns, Page Object Model, configuration, CI/CD integration, artifact management, and flaky test strategies. |
| `ecc-tools-cost-audit` | Evidence-first ECC Tools burn and billing audit workflow. Use when investigating runaway PR creation, quota bypass, premium-model leakage, duplicate jobs, or GitHub App cost spikes in the ECC Tools repo. |
| `email-ops` | Evidence-first mailbox triage, drafting, send verification, and sent-mail-safe follow-up workflow for ECC. Use when the user wants to organize email, draft or send through the real mail surface, or prove what landed in Sent. |
| `energy-procurement` | Codified expertise for electricity and gas procurement, tariff optimization, demand charge management, renewable PPA evaluation, and multi-facility energy cost management. Informed by energy procurement managers with 15+ years experience at large commercial and industrial consumers. Includes market structure analysis, hedging strategies, load profiling, and sustainability reporting frameworks. Use when procuring energy, optimizing tariffs, managing demand charges, evaluating PPAs, or developing energy strategies. |
| `enterprise-agent-ops` | Operate long-lived agent workloads with observability, security boundaries, and lifecycle management. |
| `eval-harness` | Formal evaluation framework for Claude Code sessions implementing eval-driven development (EDD) principles |
| `evm-token-decimals` | Prevent silent decimal mismatch bugs across EVM chains. Covers runtime decimal lookup, chain-aware caching, bridged-token precision drift, and safe normalization for bots, dashboards, and DeFi tools. |
| `exa-search` | Neural search via Exa MCP for web, code, and company research. Use when the user needs web search, code examples, company intel, people lookup, or AI-powered deep research with Exa's neural search engine. |
| `fal-ai-media` | Unified media generation via fal.ai MCP — image, video, and audio. Covers text-to-image (Nano Banana), text/image-to-video (Seedance, Kling, Veo 3), text-to-speech (CSM-1B), and video-to-audio (ThinkSound). Use when the user wants to generate images, videos, or audio with AI. |
| `finance-billing-ops` | Evidence-first revenue, pricing, refunds, team-billing, and billing-model truth workflow for ECC. Use when the user wants a sales snapshot, pricing comparison, duplicate-charge diagnosis, or code-backed billing reality instead of generic payments advice. |
| `flutter-dart-code-review` | Library-agnostic Flutter/Dart code review checklist covering widget best practices, state management patterns (BLoC, Riverpod, Provider, GetX, MobX, Signals), Dart idioms, performance, accessibility, security, and clean architecture. |
| `foundation-models-on-device` | Apple FoundationModels framework for on-device LLM — text generation, guided generation with @Generable, tool calling, and snapshot streaming in iOS 26+. |
| `frontend-design` | Create distinctive, production-grade frontend interfaces with high design quality. Use when the user asks to build web components, pages, or applications and the visual direction matters as much as the code quality. |
| `frontend-patterns` | Frontend development patterns for React, Next.js, state management, performance optimization, and UI best practices. |
| `frontend-slides` | Create stunning, animation-rich HTML presentations from scratch or by converting PowerPoint files. Use when the user wants to build a presentation, convert a PPT/PPTX to web, or create slides for a talk/pitch. Helps non-designers discover their aesthetic through visual exploration rather than abstract choices. |
| `gan-style-harness` | GAN-inspired Generator-Evaluator agent harness for building high-quality applications autonomously. Based on Anthropic's March 2026 harness design paper. |
| `gateguard` | Fact-forcing gate that blocks Edit/Write/Bash (including MultiEdit) and demands concrete investigation (importers, data schemas, user instruction) before allowing the action. Measurably improves output quality by +2.25 points vs ungated agents. |
| `git-workflow` | Git workflow patterns including branching strategies, commit conventions, merge vs rebase, conflict resolution, and collaborative development best practices for teams of all sizes. |
| `github-ops` | GitHub repository operations, automation, and management. Issue triage, PR management, CI/CD operations, release management, and security monitoring using the gh CLI. Use when the user wants to manage GitHub issues, PRs, CI status, releases, contributors, stale items, or any GitHub operational task beyond simple git commands. |
| `golang-patterns` | Idiomatic Go patterns, best practices, and conventions for building robust, efficient, and maintainable Go applications. |
| `golang-testing` | Go testing patterns including table-driven tests, subtests, benchmarks, fuzzing, and test coverage. Follows TDD methodology with idiomatic Go practices. |
| `google-workspace-ops` | Operate across Google Drive, Docs, Sheets, and Slides as one workflow surface for plans, trackers, decks, and shared documents. Use when the user needs to find, summarize, edit, migrate, or clean up Google Workspace assets without dropping to raw tool calls. |
| `healthcare-cdss-patterns` | Clinical Decision Support System (CDSS) development patterns. Drug interaction checking, dose validation, clinical scoring (NEWS2, qSOFA), alert severity classification, and integration into EMR workflows. |
| `healthcare-emr-patterns` | EMR/EHR development patterns for healthcare applications. Clinical safety, encounter workflows, prescription generation, clinical decision support integration, and accessibility-first UI for medical data entry. |
| `healthcare-eval-harness` | Patient safety evaluation harness for healthcare application deployments. Automated test suites for CDSS accuracy, PHI exposure, clinical workflow integrity, and integration compliance. Blocks deployments on safety failures. |
| `healthcare-phi-compliance` | Protected Health Information (PHI) and Personally Identifiable Information (PII) compliance patterns for healthcare applications. Covers data classification, access control, audit trails, encryption, and common leak vectors. |
| `hexagonal-architecture` | Design, implement, and refactor Ports & Adapters systems with clear domain boundaries, dependency inversion, and testable use-case orchestration across TypeScript, Java, Kotlin, and Go services. |
| `hipaa-compliance` | HIPAA-specific entrypoint for healthcare privacy and security work. Use when a task is explicitly framed around HIPAA, PHI handling, covered entities, BAAs, breach posture, or US healthcare compliance requirements. |
| `hookify-rules` | This skill should be used when the user asks to create a hookify rule, write a hook rule, configure hookify, add a hookify rule, or needs guidance on hookify rule syntax and patterns. |
| `inventory-demand-planning` | Codified expertise for demand forecasting, safety stock optimization, replenishment planning, and promotional lift estimation at multi-location retailers. Informed by demand planners with 15+ years experience managing hundreds of SKUs. Includes forecasting method selection, ABC/XYZ analysis, seasonal transition management, and vendor negotiation frameworks. Use when forecasting demand, setting safety stock, planning replenishment, managing promotions, or optimizing inventory levels. |
| `investor-materials` | Create and update pitch decks, one-pagers, investor memos, accelerator applications, financial models, and fundraising materials. Use when the user needs investor-facing documents, projections, use-of-funds tables, milestone plans, or materials that must stay internally consistent across multiple fundraising assets. |
| `investor-outreach` | Draft cold emails, warm intro blurbs, follow-ups, update emails, and investor communications for fundraising. Use when the user wants outreach to angels, VCs, strategic investors, or accelerators and needs concise, personalized, investor-facing messaging. |
| `iterative-retrieval` | Pattern for progressively refining context retrieval to solve the subagent context problem |
| `java-coding-standards` | Java coding standards for Spring Boot services: naming, immutability, Optional usage, streams, exceptions, generics, and project layout. |
| `jira-integration` | Use this skill when retrieving Jira tickets, analyzing requirements, updating ticket status, adding comments, or transitioning issues. Provides Jira API patterns via MCP or direct REST calls. |
| `jpa-patterns` | JPA/Hibernate patterns for entity design, relationships, query optimization, transactions, auditing, indexing, pagination, and pooling in Spring Boot. |
| `knowledge-ops` | Knowledge base management, ingestion, sync, and retrieval across multiple storage layers (local files, MCP memory, vector stores, Git repos). Use when the user wants to save, organize, sync, deduplicate, or search across their knowledge systems. |
| `kotlin-coroutines-flows` | Kotlin Coroutines and Flow patterns for Android and KMP — structured concurrency, Flow operators, StateFlow, error handling, and testing. |
| `kotlin-exposed-patterns` | JetBrains Exposed ORM patterns including DSL queries, DAO pattern, transactions, HikariCP connection pooling, Flyway migrations, and repository pattern. |
| `kotlin-ktor-patterns` | Ktor server patterns including routing DSL, plugins, authentication, Koin DI, kotlinx.serialization, WebSockets, and testApplication testing. |
| `kotlin-patterns` | Idiomatic Kotlin patterns, best practices, and conventions for building robust, efficient, and maintainable Kotlin applications with coroutines, null safety, and DSL builders. |
| `kotlin-testing` | Kotlin testing patterns with Kotest, MockK, coroutine testing, property-based testing, and Kover coverage. Follows TDD methodology with idiomatic Kotlin practices. |
| `laravel-patterns` | Laravel architecture patterns, routing/controllers, Eloquent ORM, service layers, queues, events, caching, and API resources for production apps. |
| `laravel-plugin-discovery` | Discover and evaluate Laravel packages via LaraPlugins.io MCP. Use when the user wants to find plugins, check package health, or assess Laravel/PHP compatibility. |
| `laravel-security` | Laravel security best practices for authn/authz, validation, CSRF, mass assignment, file uploads, secrets, rate limiting, and secure deployment. |
| `laravel-tdd` | Test-driven development for Laravel with PHPUnit and Pest, factories, database testing, fakes, and coverage targets. |
| `laravel-verification` | Verification loop for Laravel projects: env checks, linting, static analysis, tests with coverage, security scans, and deployment readiness. |
| `lead-intelligence` | AI-native lead intelligence and outreach pipeline. Replaces Apollo, Clay, and ZoomInfo with agent-powered signal scoring, mutual ranking, warm path discovery, source-derived voice modeling, and channel-specific outreach across email, LinkedIn, and X. Use when the user wants to find, qualify, and reach high-value contacts. |
| `liquid-glass-design` | iOS 26 Liquid Glass design system — dynamic glass material with blur, reflection, and interactive morphing for SwiftUI, UIKit, and WidgetKit. |
| `llm-trading-agent-security` | Security patterns for autonomous trading agents with wallet or transaction authority. Covers prompt injection, spend limits, pre-send simulation, circuit breakers, MEV protection, and key handling. |
| `logistics-exception-management` | Codified expertise for handling freight exceptions, shipment delays, damages, losses, and carrier disputes. Informed by logistics professionals with 15+ years operational experience. Includes escalation protocols, carrier-specific behaviors, claims procedures, and judgment frameworks. Use when handling shipping exceptions, freight claims, delivery issues, or carrier disputes. |
| `manim-video` | Build reusable Manim explainers for technical concepts, graphs, system diagrams, and product walkthroughs, then hand off to the wider ECC video stack if needed. Use when the user wants a clean animated explainer rather than a generic talking-head script. |
| `market-research` | Conduct market research, competitive analysis, investor due diligence, and industry intelligence with source attribution and decision-oriented summaries. Use when the user wants market sizing, competitor comparisons, fund research, technology scans, or research that informs business decisions. |
| `mcp-server-patterns` | Build MCP servers with Node/TypeScript SDK — tools, resources, prompts, Zod validation, stdio vs Streamable HTTP. Use Context7 or official MCP docs for latest API. |
| `messages-ops` | Evidence-first live messaging workflow for ECC. Use when the user wants to read texts or DMs, recover a recent one-time code, inspect a thread before replying, or prove which message source was actually checked. |
| `nanoclaw-repl` | Operate and extend NanoClaw v2, ECC's zero-dependency session-aware REPL built on claude -p. |
| `nestjs-patterns` | NestJS architecture patterns for modules, controllers, providers, DTO validation, guards, interceptors, config, and production-grade TypeScript backends. |
| `nextjs-turbopack` | Next.js 16+ and Turbopack — incremental bundling, FS caching, dev speed, and when to use Turbopack vs webpack. |
| `nodejs-keccak256` | Prevent Ethereum hashing bugs in JavaScript and TypeScript. Node's sha3-256 is NIST SHA3, not Ethereum Keccak-256, and silently breaks selectors, signatures, storage slots, and address derivation. |
| `nutrient-document-processing` | Process, convert, OCR, extract, redact, sign, and fill documents using the Nutrient DWS API. Works with PDFs, DOCX, XLSX, PPTX, HTML, and images. |
| `nuxt4-patterns` | Nuxt 4 app patterns for hydration safety, performance, route rules, lazy loading, and SSR-safe data fetching with useFetch and useAsyncData. |
| `openclaw-persona-forge` | 为 OpenClaw AI Agent 锻造完整的龙虾灵魂方案。根据用户偏好或随机抽卡， 输出身份定位、灵魂描述(SOUL.md)、角色化底线规则、名字和头像生图提示词。 如当前环境提供已审核的生图 skill，可自动生成统一风格头像图片。 当用户需要创建、设计或定制 OpenClaw 龙虾灵魂时使用。 不适用于：微调已有 SOUL.md、非 OpenClaw 平台的角色设计、纯工具型无性格 Agent。 触发词：龙虾灵魂、虾魂、OpenClaw 灵魂、养虾灵魂、龙虾角色、龙虾定位、 龙虾剧本杀角色、龙虾游戏角色、龙虾 NPC、龙虾性格、龙虾背景故事、 lobster soul、lobster character、抽卡、随机龙虾、龙虾 SOUL、gacha。 |
| `opensource-pipeline` | Open-source pipeline: fork, sanitize, and package private projects for safe public release. Chains 3 agents (forker, sanitizer, packager). Triggers: '/opensource', 'open source this', 'make this public', 'prepare for open source'. |
| `perl-patterns` | Modern Perl 5.36+ idioms, best practices, and conventions for building robust, maintainable Perl applications. |
| `perl-security` | Comprehensive Perl security covering taint mode, input validation, safe process execution, DBI parameterized queries, web security (XSS/SQLi/CSRF), and perlcritic security policies. |
| `perl-testing` | Perl testing patterns using Test2::V0, Test::More, prove runner, mocking, coverage with Devel::Cover, and TDD methodology. |
| `plankton-code-quality` | Write-time code quality enforcement using Plankton — auto-formatting, linting, and Claude-powered fixes on every file edit via hooks. |
| `postgres-patterns` | PostgreSQL database patterns for query optimization, schema design, indexing, and security. Based on Supabase best practices. |
| `product-capability` | Translate PRD intent, roadmap asks, or product discussions into an implementation-ready capability plan that exposes constraints, invariants, interfaces, and unresolved decisions before multi-service work starts. Use when the user needs an ECC-native PRD-to-SRS lane instead of vague planning prose. |
| `product-lens` | Use this skill to validate the "why" before building, run product diagnostics, and pressure-test product direction before the request becomes an implementation contract. |
| `production-scheduling` | Codified expertise for production scheduling, job sequencing, line balancing, changeover optimization, and bottleneck resolution in discrete and batch manufacturing. Informed by production schedulers with 15+ years experience. Includes TOC/drum-buffer-rope, SMED, OEE analysis, disruption response frameworks, and ERP/MES interaction patterns. Use when scheduling production, resolving bottlenecks, optimizing changeovers, responding to disruptions, or balancing manufacturing lines. |
| `project-flow-ops` | Operate execution flow across GitHub and Linear by triaging issues and pull requests, linking active work, and keeping GitHub public-facing while Linear remains the internal execution layer. Use when the user wants backlog control, PR triage, or GitHub-to-Linear coordination. |
| `prompt-optimizer` | Analyze raw prompts, identify intent and gaps, match ECC components (skills/commands/agents/hooks), and output a ready-to-paste optimized prompt. Advisory role only — never executes the task itself. TRIGGER when: user says "optimize prompt", "improve my prompt", "how to write a prompt for", "help me prompt", "rewrite this prompt", or explicitly asks to enhance prompt quality. Also triggers on Chinese equivalents: "优化prompt", "改进prompt", "怎么写prompt", "帮我优化这个指令". DO NOT TRIGGER when: user wants the task executed directly, or says "just do it" / "直接做". DO NOT TRIGGER when user says "优化代码", "优化性能", "optimize performance", "optimize this code" — those are refactoring/performance tasks, not prompt optimization. |
| `python-patterns` | Pythonic idioms, PEP 8 standards, type hints, and best practices for building robust, efficient, and maintainable Python applications. |
| `python-testing` | Python testing strategies using pytest, TDD methodology, fixtures, mocking, parametrization, and coverage requirements. |
| `pytorch-patterns` | PyTorch deep learning patterns and best practices for building robust, efficient, and reproducible training pipelines, model architectures, and data loading. |
| `quality-nonconformance` | Codified expertise for quality control, non-conformance investigation, root cause analysis, corrective action, and supplier quality management in regulated manufacturing. Informed by quality engineers with 15+ years experience across FDA, IATF 16949, and AS9100 environments. Includes NCR lifecycle management, CAPA systems, SPC interpretation, and audit methodology. Use when investigating non-conformances, performing root cause analysis, managing CAPAs, interpreting SPC data, or handling supplier quality issues. |
| `ralphinho-rfc-pipeline` | RFC-driven multi-agent DAG execution pattern with quality gates, merge queues, and work unit orchestration. |
| `regex-vs-llm-structured-text` | Decision framework for choosing between regex and LLM when parsing structured text — start with regex, add LLM only for low-confidence edge cases. |
| `remotion-video-creation` | Best practices for Remotion - Video creation in React. 29 domain-specific rules covering 3D, animations, audio, captions, charts, transitions, and more. |
| `repo-scan` | Cross-stack source code asset audit — classifies every file, detects embedded third-party libraries, and delivers actionable four-level verdicts per module with interactive HTML reports. |
| `research-ops` | Evidence-first current-state research workflow for ECC. Use when the user wants fresh facts, comparisons, enrichment, or a recommendation built from current public evidence and any supplied local context. |
| `returns-reverse-logistics` | Codified expertise for returns authorization, receipt and inspection, disposition decisions, refund processing, fraud detection, and warranty claims management. Informed by returns operations managers with 15+ years experience. Includes grading frameworks, disposition economics, fraud pattern recognition, and vendor recovery processes. Use when handling product returns, reverse logistics, refund decisions, return fraud detection, or warranty claims. |
| `rules-distill` | Scan skills to extract cross-cutting principles and distill them into rules — append, revise, or create new rule files |
| `rust-patterns` | Idiomatic Rust patterns, ownership, error handling, traits, concurrency, and best practices for building safe, performant applications. |
| `rust-testing` | Rust testing patterns including unit tests, integration tests, async testing, property-based testing, mocking, and coverage. Follows TDD methodology. |
| `safety-guard` | Use this skill to prevent destructive operations when working on production systems or running agents autonomously. |
| `santa-method` | Multi-agent adversarial verification with convergence loop. Two independent review agents must both pass before output ships. |
| `search-first` | Research-before-coding workflow. Search for existing tools, libraries, and patterns before writing custom code. Invokes the researcher agent. |
| `security-bounty-hunter` | Hunt for exploitable, bounty-worthy security issues in repositories. Focuses on remotely reachable vulnerabilities that qualify for real reports instead of noisy local-only findings. |
| `security-review` | Use this skill when adding authentication, handling user input, working with secrets, creating API endpoints, or implementing payment/sensitive features. Provides comprehensive security checklist and patterns. |
| `security-scan` | Scan your Claude Code configuration (.claude/ directory) for security vulnerabilities, misconfigurations, and injection risks using AgentShield. Checks CLAUDE.md, settings.json, MCP servers, hooks, and agent definitions. |
| `seo` | Audit, plan, and implement SEO improvements across technical SEO, on-page optimization, structured data, Core Web Vitals, and content strategy. Use when the user wants better search visibility, SEO remediation, schema markup, sitemap/robots work, or keyword mapping. |
| `skill-comply` | Visualize whether skills, rules, and agent definitions are actually followed — auto-generates scenarios at 3 prompt strictness levels, runs agents, classifies behavioral sequences, and reports compliance rates with full tool call timelines |
| `skill-stocktake` | Use when auditing Claude skills and commands for quality. Supports Quick Scan (changed skills only) and Full Stocktake modes with sequential subagent batch evaluation. |
| `social-graph-ranker` | Weighted social-graph ranking for warm intro discovery, bridge scoring, and network gap analysis across X and LinkedIn. Use when the user wants the reusable graph-ranking engine itself, not the broader outreach or network-maintenance workflow layered on top of it. |
| `springboot-patterns` | Spring Boot architecture patterns, REST API design, layered services, data access, caching, async processing, and logging. Use for Java Spring Boot backend work. |
| `springboot-security` | Spring Security best practices for authn/authz, validation, CSRF, secrets, headers, rate limiting, and dependency security in Java Spring Boot services. |
| `springboot-tdd` | Test-driven development for Spring Boot using JUnit 5, Mockito, MockMvc, Testcontainers, and JaCoCo. Use when adding features, fixing bugs, or refactoring. |
| `springboot-verification` | Verification loop for Spring Boot projects: build, static analysis, tests with coverage, security scans, and diff review before release or PR. |
| `strategic-compact` | Suggests manual context compaction at logical intervals to preserve context through task phases rather than arbitrary auto-compaction. |
| `swift-actor-persistence` | Thread-safe data persistence in Swift using actors — in-memory cache with file-backed storage, eliminating data races by design. |
| `swift-concurrency-6-2` | Swift 6.2 Approachable Concurrency — single-threaded by default, @concurrent for explicit background offloading, isolated conformances for main actor types. |
| `swift-protocol-di-testing` | Protocol-based dependency injection for testable Swift code — mock file system, network, and external APIs using focused protocols and Swift Testing. |
| `swiftui-patterns` | SwiftUI architecture patterns, state management with @Observable, view composition, navigation, performance optimization, and modern iOS/macOS UI best practices. |
| `tdd-workflow` | Use this skill when writing new features, fixing bugs, or refactoring code. Enforces test-driven development with 80%+ coverage including unit, integration, and E2E tests. |
| `team-builder` | Interactive agent picker for composing and dispatching parallel teams |
| `terminal-ops` | Evidence-first repo execution workflow for ECC. Use when the user wants a command run, a repo checked, a CI failure debugged, or a narrow fix pushed with exact proof of what was executed and verified. |
| `token-budget-advisor` | Offers the user an informed choice about how much response depth to consume before answering. Use this skill when the user explicitly wants to control response length, depth, or token budget. TRIGGER when: "token budget", "token count", "token usage", "token limit", "response length", "answer depth", "short version", "brief answer", "detailed answer", "exhaustive answer", "respuesta corta vs larga", "cuántos tokens", "ahorrar tokens", "responde al 50%", "dame la versión corta", "quiero controlar cuánto usas", or clear variants where the user is explicitly asking to control answer size or depth. DO NOT TRIGGER when: user has already specified a level in the current session (maintain it), the request is clearly a one-word answer, or "token" refers to auth/session/payment tokens rather than response size. |
| `ui-demo` | Record polished UI demo videos using Playwright. Use when the user asks to create a demo, walkthrough, screen recording, or tutorial video of a web application. Produces WebM videos with visible cursor, natural pacing, and professional feel. |
| `unified-notifications-ops` | Operate notifications as one ECC-native workflow across GitHub, Linear, desktop alerts, hooks, and connected communication surfaces. Use when the real problem is alert routing, deduplication, escalation, or inbox collapse. |
| `verification-loop` | A comprehensive verification system for Claude Code sessions. |
| `video-editing` | AI-assisted video editing workflows for cutting, structuring, and augmenting real footage. Covers the full pipeline from raw capture through FFmpeg, Remotion, ElevenLabs, fal.ai, and final polish in Descript or CapCut. Use when the user wants to edit video, cut footage, create vlogs, or build video content. |
| `videodb` | See, Understand, Act on video and audio. See- ingest from local files, URLs, RTSP/live feeds, or live record desktop; return realtime context and playable stream links. Understand- extract frames, build visual/semantic/temporal indexes, and search moments with timestamps and auto-clips. Act- transcode and normalize (codec, fps, resolution, aspect ratio), perform timeline edits (subtitles, text/image overlays, branding, audio overlays, dubbing, translation), generate media assets (image, audio, video), and create real time alerts for events from live streams or desktop capture. |
| `visa-doc-translate` | Translate visa application documents (images) to English and create a bilingual PDF with original and translation |
| `workspace-surface-audit` | Audit the active repo, MCP servers, plugins, connectors, env surfaces, and harness setup, then recommend the highest-value ECC-native skills, hooks, agents, and operator workflows. Use when the user wants help setting up Claude Code or understanding what capabilities are actually available in their environment. |
| `x-api` | X/Twitter API integration for posting tweets, threads, reading timelines, search, and analytics. Covers OAuth auth patterns, rate limits, and platform-native content posting. Use when the user wants to interact with X programmatically. |

---

## How this layer composes with the rest of the kit

- **Below:** everything-claude-code sits on top of `superpowers`. Its skills frequently reference superpowers workflow skills (brainstorming, systematic-debugging, TDD, writing-plans, etc.) — do not install this layer without superpowers first.
- **Above:** this kit's `gstack` skills and `gsd` agents are curated and adapted with inspiration from this library — `codebase-mapper` is the `codebase-onboarding` role reframed for per-project repo audits; `pattern-mapper` is an `api-connector-builder`-flavored pre-implementation step. See the [README](../README.md) for the composition diagrams.

If you only want the opinionated subset, skip this layer and install just `superpowers` + `claude-code-kit`. If you want the full buffet, install all three.
