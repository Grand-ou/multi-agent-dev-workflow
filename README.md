# Multi-Agent Development Workflow

Standardized multi-agent collaborative development workflow for large projects with Git Feature Branch integration.

## Core Philosophy

Based on [Boris Tane's three-step method](https://www.threads.com/@ad.life_engineer/post/DVQz_pPkWcc):

1. **Understand** → AI produces `research.md`, human verifies understanding
2. **Plan** → AI produces `plan.md`, human annotates, iterate 1-6 times
3. **Execute** → Strictly follow the plan, no freelancing

> **AI's value is alignment, not generation speed. Slow down to align — that's the fastest path.**

## Structure

```
multi-agent-dev-workflow/
├── SKILL.md                          # Main skill document (4-phase workflow)
├── README.md                         # This file
├── reference/
│   ├── boris_tane_method.md          # Complete three-step methodology
│   ├── dev_best_practices.md         # Commits, branches, review, communication
│   └── example_plan.md              # Real project development plan example
├── templates/
│   ├── PLAN_TEMPLATE.md             # Task decomposition template
│   └── AGENTS_STATUS_TEMPLATE.md    # Sub-Agent status tracking
└── scripts/
    ├── start-task.sh                # Create branch + setup
    └── merge-task.sh                # Test + merge + cleanup
```

## Quick Start

```bash
# 1. Read SKILL.md to understand the workflow
cat SKILL.md

# 2. Copy templates to your project
cp templates/PLAN_TEMPLATE.md /path/to/project/PLAN.md
cp templates/AGENTS_STATUS_TEMPLATE.md /path/to/project/AGENTS_STATUS.md

# 3. Start a task
chmod +x scripts/*.sh
scripts/start-task.sh auth-system feature/auth-system "Implement OAuth"

# 4. Merge when done
scripts/merge-task.sh feature/auth-system
```

## Workflow Phases

| Phase | What | Who |
|-------|------|-----|
| 1. Research & Planning | Analyze project, decompose tasks, create plans | Main Agent + Human |
| 2. Implementation | Sub-Agents execute plans on feature branches | Sub-Agents |
| 3. Review & Merge | Code review, testing, merge to main | Main Agent |
| 4. Integration & Eval | Full test suite, cross-feature verification | Main Agent |

## Design Inspiration

Skill structure inspired by [anthropics/skills](https://github.com/anthropics/skills) (mcp-builder pattern):
- Progressive disclosure: core workflow in SKILL.md, details in reference/
- Scripts as black boxes: run with `--help`, don't read source
- Templates for quick setup

## License

MIT License

## Contributing

Issues and Pull Requests welcome!
