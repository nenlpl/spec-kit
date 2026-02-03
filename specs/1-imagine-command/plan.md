# Implementation Plan: Imagine Command for Solution Design

**Branch**: `1-imagine-command` | **Date**: 2026-02-03 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/1-imagine-command/spec.md`

## Summary

Add `/speckit.imagine` command to generate solution design documents from customer artifacts (PDFs, Word docs, images). The command analyzes artifacts in `./solution-artifacts/`, asks up to 5 clarifying questions for missing information, and produces a markdown document with solution summary, C4 Context/Container diagrams (Mermaid), and feature list with traceability. Features can then be passed to `/speckit.specify` for detailed specification.

## Technical Context

**Language/Version**: Templates/Commands only (Markdown), supporting scripts in Bash + PowerShell  
**Primary Dependencies**: Existing spec-kit infrastructure (templates/, scripts/, .github/prompts/)  
**Storage**: File system - templates in `./templates/`, commands in `./templates/commands/`, scripts in `./scripts/bash/` and `./scripts/powershell/`, generated output in project root as `solution-design.md`  
**Testing**: Manual validation with sample artifacts (PDF, DOCX, TXT, MD, images)  
**Target Platform**: Cross-platform (macOS, Linux, Windows) via GitHub Copilot agents  
**Project Type**: Extension to existing spec-kit framework (template-driven)  
**Performance Goals**: Generate complete solution design in under 10 minutes from artifacts  
**Constraints**: 
- No limits on artifact volume/size (Q1 clarification)
- Ask clarifying questions until there is no more ambiguity or the user says to stop (priority: security > integration > data > performance > UX)
- 100% feature traceability (artifact or clarification source)
- Mermaid C4Context and C4Container diagrams must validate and render correctly and represent the solution design 
**Scale/Scope**: Small addition to spec-kit - 1 template, 1 command file, 2 scripts (bash/PS), integration with existing agents

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Note**: The spec-kit project constitution is a template and not populated. For this feature:

✅ **No constitution violations expected** - This feature adds templates, commands, and scripts following established spec-kit patterns. No new architectural complexity introduced.

**Alignment with spec-kit patterns:**
- ✅ Follows existing command structure (analyze, clarify, plan, specify, implement)
- ✅ Uses template-driven approach consistent with spec-template.md, plan-template.md
- ✅ Provides cross-platform support (bash + PowerShell) like existing scripts
- ✅ Integrates with agent infrastructure (.github/prompts/)
- ✅ Maintains file-based workflow (no new dependencies)

**Complexity Assessment**: LOW - Extends existing patterns without introducing new paradigms

## Project Structure

### Documentation (this feature)

```text
specs/1-imagine-command/
├── plan.md              # This file (Phase 0 complete)
├── research.md          # Phase 0 output (to be created)
├── data-model.md        # Phase 1 output (to be created)
├── quickstart.md        # Phase 1 output (to be created)
├── contracts/           # Phase 1 output (to be created)
│   └── solution-design-schema.md
├── spec.md              # Feature specification (exists)
└── checklists/
    └── requirements.md  # Quality checklist (exists)
```

### Source Code (repository root)

```text
# Spec-kit structure (existing + new files marked with *)

templates/
├── solution-design-template.md *       # NEW: Template for generated solution designs
├── spec-template.md                     # Existing
├── plan-template.md                     # Existing
├── [other templates...]
└── commands/
    ├── imagine.md *                     # NEW: Command definition for /speckit.imagine
    ├── specify.md                       # Existing
    ├── clarify.md                       # Reference for question patterns
    └── [other commands...]

scripts/
├── bash/
│   ├── setup-imagine.sh *              # NEW: Bash script for imagine workflow
│   ├── setup-plan.sh                   # Existing (reference)
│   └── [other scripts...]
└── powershell/
    ├── setup-imagine.ps1 *             # NEW: PowerShell script for imagine workflow
    ├── setup-plan.ps1                  # Existing (reference)
    └── [other scripts...]

# Runtime artifacts (user's project, not spec-kit repo)
./solution-artifacts/                   # User places artifacts here
./solution-design.md                    # Generated output (v2, v3 if run multiple times)
```

**Structure Decision**: This feature only adds template files and scripts to existing spec-kit structure. No source code directories needed since this is a template/command/script-based feature extending the agent workflow.

## Complexity Tracking

> No violations - table not needed.

This feature has no constitution violations to justify. It follows established spec-kit patterns for adding new commands.

---

## Phase 0: Research & Outline

**Goal**: Resolve all technical unknowns and establish technology choices

### Research Tasks

1. **Mermaid C4 Diagram Syntax** - Document correct syntax for C4Context and C4Container diagrams, validation approach, common pitfalls
2. **Artifact Processing Patterns** - Survey how other agent commands handle file reading (PDF, DOCX extraction), identify agent capabilities and limitations
3. **Agent Question Patterns** - Analyze clarify.md command structure, extract reusable patterns for solution design context
4. **Solution Design Best Practices** - Research industry standards for solution design documents (structure, level of detail, diagram types)
5. **Script Integration Points** - Identify how setup scripts interact with agent prompts, determine parameter passing patterns

### Research Output: research.md

Will contain:
- Mermaid C4 syntax reference with examples
- Agent file reading capabilities per agent type (Copilot, Claude, etc.)
- Question pattern templates from clarify.md
- Solution design document structure standards
- Script-to-agent integration patterns

---

## Phase 1: Design & Contracts

**Goal**: Define data structures, file schemas, and agent workflows

### 1.1 Data Model (data-model.md)

**Entities to document:**

1. **Solution Design Document**
   - Structure: Frontmatter (metadata), Summary (2-4 paragraphs), C4 Diagrams (Context, Container), Features (with sources)
   - Metadata fields: Title, Created date, Version, Artifact count
   - Diagram sections: Mermaid code blocks with proper C4 syntax
   - Feature format: Title, Description (1-3 sentences), Source (artifact link or clarification reference), Assumptions (if any)

2. **Artifact Metadata**
   - Tracked during processing: filename, file type, size, processing status, error message (if failed)
   - Used for: Progress reporting, error summary, traceability links

3. **Clarification Question**
   - Structure: Question text, Options (A/B/C/D/Short), Recommended option, Rationale
   - Categories: Security, Integration, Data, Performance, UX (priority ordered)
   - Response: Selected option, Answer text, Timestamp

4. **Feature Entry**
   - Components: Title, Description, Source reference, Assumptions list
   - Source types: Artifact (with file path + location) or Clarification (with date + question)
   - Validation: Must have exactly one source type

### 1.2 Contracts (contracts/)

**File: solution-design-schema.md**

Schema defining the structure of generated `solution-design.md` files:

```markdown
# Solution Design Schema

## Document Structure

1. **Frontmatter** (optional YAML)
   - title: string
   - created: date
   - version: string (v1, v2, etc.)
   - artifact_count: integer
   - feature_count: integer

2. **Solution Summary** (required)
   - 2-4 paragraphs
   - Content: Purpose, scope, key capabilities, stakeholders

3. **Architecture Diagrams** (required)
   - C4 Context Diagram (Mermaid C4Context)
   - C4 Container Diagram (Mermaid C4Container)

4. **Features** (required)
   - Array of feature entries
   - Each with: title, description (1-3 sentences), source, feature specific assumptions

5. **Overall Solution Assumptions** (conditional)
   - Generated when clarifications were insufficient
   - Lists assumptions made by system
   - Lists assumptions made by the user's clarification responses

## Validation Rules

- C4 diagrams must pass Mermaid syntax validation
- Each feature must have documented source
- Feature descriptions must be 1-3 sentences
- Source must be either artifact link AND OR clarification reference (cannot be not neither)
```

### 1.3 Quickstart (quickstart.md)

**Content:**

```markdown
# Quickstart: Using /speckit.imagine

## Prerequisites

1. GitHub Copilot agent enabled in VS Code
2. Spec-kit initialized in project (`specify init`)
3. Customer requirements artifacts collected

## Steps

1. **Create artifacts folder** (if not exists):
   ```bash
   mkdir -p ./solution-artifacts
   ```

2. **Add artifacts**: Place PDFs, Word docs, images, text files in `./solution-artifacts/`

3. **Run imagine command**: 
   ```
   /speckit.imagine
   ```

4. **Answer clarifying questions**: System asks up to 5 questions about missing information

5. **Review output**: Open generated `solution-design.md` in project root

6. **Iterate if needed**: Run `/speckit.imagine` again to create versioned copy (v2, v3...)

7. **Create detailed specs**: Pass features to `/speckit.specify [feature-name]` for implementation planning

## Example Workflow

```bash
# 1. Setup
cd my-project
specify init

# 2. Add artifacts
cp ~/customer-rfp.pdf ./solution-artifacts/
cp ~/architecture-diagram.png ./solution-artifacts/

# 3. Generate design
/speckit.imagine
# (Answer questions interactively)

# 4. Review
cat solution-design.md

# 5. Create spec from feature
/speckit.specify "User Authentication Feature"
```

## Tips

- Include diagrams (PNG/JPG) - agent will attempt OCR if capable
- PDFs with text layers work better than scanned images
- More artifacts = better feature extraction
- Review generated design for sensitive data before sharing
- Use versioned files (v2, v3) to track design evolution
```

## Phase 2: Task Breakdown

**NOT COVERED BY /speckit.plan** - Use `/speckit.tasks` command to generate detailed implementation tasks.

Expected task categories:
1. Create solution-design-template.md
2. Create imagine.md command file
3. Create setup-imagine.sh (bash)
4. Create setup-imagine.ps1 (PowerShell)
5. Create speckit.imagine.prompt.md
6. Update agent context files
7. Manual testing with sample artifacts
8. Documentation updates

---

## Next Steps

1. ✅ Phase 0: Generate `research.md` (resolving all technical unknowns)
2. ✅ Phase 1: Generate `data-model.md`, `contracts/`, `quickstart.md`
3. ⏭️ Phase 2: Run `/speckit.tasks` to create `tasks.md` with detailed implementation steps
4. ⏭️ Implementation: Use `/speckit.implement` to execute tasks

**Status**: Planning complete - ready for research phase
