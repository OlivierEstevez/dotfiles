## Conventions
- Use the package manager the project's lockfile points to. Use pnpm for new projects
- Don't add dependencies until they're necessary

## Performance and Technical Decisions
- Don't guess performance, bundle size, or load times: measure
- If something seems slow, add instrumentation before optimizing
- Validate on a small scale first before rolling changes out to the whole project

## Commits and Pull Requests
- Never add a `Co-Authored-By: Claude` line (or any Claude attribution) to commits or PRs
- Never push unless I explicitly ask
- PR title: [<project_name>] Clear and concise description.
- Small, focused PRs.
- Before committing, run the project's lint and test scripts if they exist (e.g. `pnpm lint`, `pnpm test`)
- Explain what changed, why, and how it was verified
- If a new constraint is introduced ("never X", "always Y"), document it in this file

## Agent Behavior
- If a request is unclear, ask specific questions before executing
- Simple, well-defined tasks are executed directly
- Complex changes (refactors, new features, architecture decisions) require confirming understanding before acting
- Don't assume implicit requirements. If information is missing, ask for it
- Don't invent work. If an analysis or review finds nothing worth changing, say so
- Verify visual and behavioral changes yourself (run it, take screenshots) before reporting them as done
- Always use the /i-have-adhd skill to give answers that are as direct as possible

## Writing (READMEs, release notes, PR descriptions, docs)
- Direct and concrete. No filler or vague wording
- Avoid AI tells: no em dashes, no hype words, no stacked hyphenated phrases
- Keep the focus on the project, not on me

## Creative Tools and Sketches
- Persist settings and user content in localStorage between sessions

## Web / React Projects

### Organization
- Small components with a single responsibility
- Prefer composition over complex configurations
- Avoid premature abstractions
- Shared code should live in clear folders like `components`, `layouts`, `lib`, or `utils`

### TypeScript Rules
- Avoid `any`
- Use `unknown` only at boundaries (parsed JSON, `catch` errors, external data) and narrow it right away. Don't cast with `as` to escape it
- Always prefer inference when possible
- If types are unclear, stop and clarify before continuing

### UI and Styles
- Tailwind is preferred, though plain CSS can be used for smaller projects
- Don't duplicate classes if a component can be extracted
- Prioritize readability over visual micro-optimizations
- Accessibility is not optional: semantic HTML, ARIA roles when applicable, and managed focus

### Skills
- When working with React, use /vercel-react-best-practices
