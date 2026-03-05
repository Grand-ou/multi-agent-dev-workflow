# Development Best Practices

## Quick Reference

### Branch Naming
- `feature/<name>` — new features
- `fix/<name>` — bug fixes
- `refactor/<name>` — restructuring
- `docs/<name>` — documentation
- No Chinese or special characters

### Commit Convention
- `feat(<scope>): <description>` — new feature
- `fix(<scope>): <description>` — bug fix
- `docs:` documentation, `style:` formatting
- `refactor:` restructuring, `test:` testing, `chore:` maintenance

### Status Codes
- `pending` → `running` → `completed` / `failed` / `paused` / `blocked`

---

## Conventional Commits

Follow [Conventional Commits](https://www.conventionalcommits.org/) for all commits:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types**:

| Type | When to use |
|------|------------|
| `feat` | New feature or functionality |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no logic change |
| `refactor` | Code restructuring, no feature change |
| `test` | Adding or updating tests |
| `chore` | Build, CI, dependencies |

**Examples**:
```bash
git commit -m "feat(auth): implement Google OAuth login"
git commit -m "fix(chat): resolve SSE streaming disconnect"
git commit -m "docs(api): add endpoint documentation"
git commit -m "refactor(db): migrate to connection pooling"
```

---

## Branch Strategy

### Naming Convention

| Pattern | Use case | Example |
|---------|----------|---------|
| `feature/<name>` | New feature | `feature/auth-system` |
| `fix/<name>` | Bug fix | `fix/login-redirect` |
| `refactor/<name>` | Code restructuring | `refactor/db-layer` |
| `docs/<name>` | Documentation | `docs/api-reference` |

**Rules**:
- Lowercase only, hyphens for spaces
- No Chinese characters or special symbols
- Keep names short but descriptive
- Branch from `main`, merge back to `main`

### Branch Lifecycle

```
main ─── feature/auth ─── commit ─── commit ─── merge ─── main
              │                                      │
              └── created from main            merged back
```

---

## Conflict Resolution

### Prevention (Best)
- Design tasks to avoid modifying the same files
- Each Sub-Agent owns specific directories/files
- Shared utilities should be completed first (P0 tasks)

### Detection (Early)
```bash
# Regularly sync feature branch with main
git checkout feature/<task>
git pull origin main
```

### Resolution (When Needed)
- Main Agent is responsible for resolving conflicts
- Consult relevant Sub-Agent if domain knowledge needed
- After resolving:
  ```bash
  git add .
  git commit -m "merge: resolve conflicts from feature/<task>"
  ```

---

## Sub-Agent Communication

### Monitoring Commands

```bash
# List all active Sub-Agents
sessions_list(kinds=["isolated"])

# View Sub-Agent history
sessions_history(sessionKey="agent:main:isolated:<label>")

# Send instruction to Sub-Agent
sessions_send(
  sessionKey="agent:main:isolated:<label>",
  message="Your message here"
)
```

### Communication Patterns

**Status Check**:
```
sessions_send(sessionKey="...", message="Progress report?")
```

**Course Correction**:
```
sessions_send(sessionKey="...", message="Stop. The API should use /api/v2, not /api/v1.")
```

**Coordination** (when two agents need to align):
```
sessions_send(sessionKey="...:auth", message="Share your AuthContext interface for chat-ui integration.")
```

### Communication Record

Track all significant communications in AGENTS_STATUS.md:
```markdown
### 2026-03-02 12:00 - auth-system
- Main → Sub: "Confirm Google OAuth redirect URI"
- Sub → Main: "Confirmed: https://example.com/auth/callback"
```

---

## Code Review Checklist

Before merging any feature branch:

### Functionality
- [ ] Code follows the approved plan
- [ ] All plan items are marked `[x]`
- [ ] No unauthorized additions ("freelancing")
- [ ] Edge cases handled

### Quality
- [ ] Code follows project conventions
- [ ] No duplicated code
- [ ] Comments and documentation adequate
- [ ] Error handling is proper

### Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] No regression in existing features

### Security
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] No SQL injection risks
- [ ] Dependencies are trusted

### Performance
- [ ] No obvious N+1 queries
- [ ] Appropriate indexing
- [ ] No memory leaks
- [ ] Reasonable response times

---

## File Structure Convention

Recommended project structure during multi-agent development:

```
project-root/
├── research.md              # AI's understanding of the system
├── PLAN.md                  # Overall development plan
├── plan-<task-1>.md         # Task 1 detailed plan
├── plan-<task-2>.md         # Task 2 detailed plan
├── AGENTS_STATUS.md         # Sub-Agent status tracking
├── issues.md                # Issues encountered during execution
├── INTEGRATION_REPORT.md    # Post-merge integration report
├── .gitignore
└── (project files)
```

**Important**: `research.md` and `plan-*.md` files should be committed to the repo — they serve as documentation of design decisions.
