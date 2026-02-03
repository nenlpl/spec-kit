# Tasks: Imagine Command for Solution Design

**Input**: Design documents from `/specs/1-imagine-command/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: No tests requested - this feature adds templates, commands, and scripts without code requiring unit/integration tests

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

This feature extends the spec-kit framework with:
- `templates/solution-design-template.md` - Template for generated solution designs
- `templates/commands/imagine.md` - Command definition
- `scripts/bash/setup-imagine.sh` - Bash workflow script
- `scripts/powershell/setup-imagine.ps1` - PowerShell workflow script
- `.github/prompts/speckit.imagine.prompt.md` - Agent prompt instructions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Review existing spec-kit patterns and establish file locations

- [X] T001 Review existing command templates (specify.md, clarify.md, plan.md) to understand command structure patterns
- [X] T002 Review existing setup scripts (setup-plan.sh, setup-plan.ps1) to understand script patterns and JSON output format
- [X] T003 Review solution-design-schema.md contract in specs/1-imagine-command/contracts/ for document structure requirements

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core template and command files that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T004 Create solution-design-template.md in templates/ directory following the structure defined in contracts/solution-design-schema.md
- [X] T005 Create imagine.md command file in templates/commands/ following existing command template patterns (reference clarify.md for question flow)
- [X] T006 [P] Create setup-imagine.sh in scripts/bash/ following setup-plan.sh pattern with JSON output for artifact paths
- [X] T007 [P] Create setup-imagine.ps1 in scripts/powershell/ following setup-plan.ps1 pattern (cross-platform equivalent)
- [X] T008 Create speckit.imagine.prompt.md in .github/prompts/ with agent instructions for workflow execution

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Generate Solution Design from Artifacts (Priority: P1) 🎯 MVP

**Goal**: Enable users to generate solution-design.md from artifacts in ./solution-artifacts/ with summary, C4 diagrams, and features

**Independent Test**: Place PDF/DOCX/TXT files in ./solution-artifacts/, run /speckit.imagine, verify solution-design.md is created with all required sections (summary, C4Context diagram, C4Container diagram, features with sources)

### Implementation for User Story 1

- [X] T009 [P] [US1] Implement artifact scanning logic in speckit.imagine.prompt.md - detect and list all files in ./solution-artifacts/
- [X] T010 [P] [US1] Implement file type detection in speckit.imagine.prompt.md - identify PDF, DOCX, TXT, MD, images based on extensions
- [X] T011 [US1] Implement artifact processing loop in speckit.imagine.prompt.md - extract text from each supported file format using agent capabilities
- [X] T012 [US1] Implement progress reporting in speckit.imagine.prompt.md - display "Processing [filename]..." for each file with success/failure status
- [X] T013 [US1] Implement error collection in speckit.imagine.prompt.md - track failed extractions and compile summary
- [X] T014 [US1] Implement content analysis in speckit.imagine.prompt.md - identify business requirements, actors, integrations, entities from extracted text
- [X] T015 [US1] Implement executive summary generation in speckit.imagine.prompt.md - create 2-4 paragraph summary (300-600 words) following contract structure
- [X] T016 [US1] Implement C4 Context diagram generation in speckit.imagine.prompt.md - create Mermaid C4Context code with 3-7 actors, 5-10 systems
- [X] T017 [US1] Implement C4 Container diagram generation in speckit.imagine.prompt.md - create Mermaid C4Container code with 5-15 containers including technology stack
- [X] T018 [US1] Implement Mermaid diagram validation in speckit.imagine.prompt.md - call mermaid-diagram-validator before writing diagrams, fall back to placeholder on error
- [X] T019 [US1] Implement feature extraction in speckit.imagine.prompt.md - generate 1-3 sentence descriptions with user value statements
- [X] T020 [US1] Implement artifact traceability in speckit.imagine.prompt.md - link each feature to source artifact with file path and page/section reference
- [X] T021 [US1] Implement auto-versioning logic in speckit.imagine.prompt.md - detect existing solution-design.md and create v2, v3, etc. without prompting
- [X] T022 [US1] Implement solution design file write in speckit.imagine.prompt.md - populate solution-design-template.md with generated content and write to project root
- [X] T023 [US1] Add completion report in speckit.imagine.prompt.md - display output file path, artifact summary (X/Y processed), and next steps

**Checkpoint**: At this point, users can generate solution designs from artifacts without clarifications (assumes artifacts are complete)

---

## Phase 4: User Story 2 - Interactive Clarification for Missing Information (Priority: P1)

**Goal**: Ask up to 5 structured clarifying questions when artifacts lack critical information (security, integration, data, performance, UX)

**Independent Test**: Provide incomplete artifacts (no authentication mentioned), run /speckit.imagine, verify system asks clarifying questions with multiple-choice options before generating final document

### Implementation for User Story 2

- [X] T024 [US2] Implement gap analysis in speckit.imagine.prompt.md - scan extracted content for missing critical information (auth, integration, data, performance, UX)
- [X] T025 [US2] Implement question prioritization in speckit.imagine.prompt.md - order questions by: security > integration > data > performance > UX
- [X] T026 [US2] Implement question generation in speckit.imagine.prompt.md - create multiple-choice questions with 2-5 options plus short answer option
- [X] T027 [US2] Implement recommendation logic in speckit.imagine.prompt.md - analyze context and recommend best option with 1-2 sentence rationale
- [X] T028 [US2] Implement sequential question flow in speckit.imagine.prompt.md - present exactly one question at a time, wait for answer
- [X] T029 [US2] Implement answer validation in speckit.imagine.prompt.md - accept option letter (A/B/C/D), "recommended", "suggested", or short answer (≤5 words)
- [X] T030 [US2] Implement question limit enforcement in speckit.imagine.prompt.md - stop after 5 questions or when user says "done"/"stop"
- [X] T031 [US2] Implement clarification recording in speckit.imagine.prompt.md - track Q&A pairs with timestamps
- [X] T032 [US2] Implement clarification-based features in speckit.imagine.prompt.md - generate features from answers marked as "Source: Agent Clarification - [date]"
- [X] T033 [US2] Implement assumptions documentation in speckit.imagine.prompt.md - if information still missing after 5 questions, document assumptions in solution design

**Checkpoint**: At this point, users receive interactive clarifications for incomplete artifacts and features are marked with clarification sources

---

## Phase 5: User Story 3 - Feature Extraction with Traceability (Priority: P2)

**Goal**: Ensure 100% of features have documented sources (artifact link or clarification reference) with location details

**Independent Test**: Generate solution design, verify every feature has either artifact link with page/section OR clarification reference with date/question

### Implementation for User Story 3

- [X] T034 [P] [US3] Implement source tracking in speckit.imagine.prompt.md - maintain mapping of feature → artifact file + location during extraction
- [X] T035 [P] [US3] Implement location extraction in speckit.imagine.prompt.md - capture page numbers, section headings, line numbers from artifacts where features are found
- [X] T036 [US3] Implement markdown link generation in speckit.imagine.prompt.md - create [filename](path/to/file) links for artifact references
- [X] T037 [US3] Implement clarification source formatting in speckit.imagine.prompt.md - format as "Agent Clarification - YYYY-MM-DD - Question: '...'"
- [X] T038 [US3] Implement assumption extraction in speckit.imagine.prompt.md - identify when information is inferred vs. explicitly stated, document as assumptions
- [X] T039 [US3] Implement source validation in speckit.imagine.prompt.md - verify every feature has exactly one source type (artifact OR clarification, not both, not neither)
- [X] T040 [US3] Implement traceability report in speckit.imagine.prompt.md - validate 100% feature sourcing before writing solution design file

**Checkpoint**: All features now have complete traceability to sources with specific location references

---

## Phase 6: User Story 4 - Solution Design to Feature Specification Workflow (Priority: P3)

**Goal**: Enable users to pass features from solution-design.md to /speckit.specify for detailed specification

**Independent Test**: Select feature from solution-design.md, run /speckit.specify [feature-name], verify new spec is created with feature description, assumptions, and artifact references pre-populated

### Implementation for User Story 4

- [X] T041 [US4] Update speckit.specify.prompt.md to detect when input matches a feature from solution-design.md (check for existing solution-design files in project root)
- [X] T042 [US4] Implement solution design parsing in speckit.specify.prompt.md - extract feature sections from solution-design*.md files
- [X] T043 [US4] Implement feature matching in speckit.specify.prompt.md - find feature by name (case-insensitive) in solution design
- [X] T044 [US4] Implement context extraction in speckit.specify.prompt.md - extract description, source, assumptions from matched feature
- [X] T045 [US4] Implement spec pre-population in speckit.specify.prompt.md - add "Background" section with feature context, "Assumptions" section with carried-forward assumptions
- [X] T046 [US4] Implement artifact reference preservation in speckit.specify.prompt.md - include artifact links in spec "References" section for traceability
- [X] T047 [US4] Implement clarification context preservation in speckit.specify.prompt.md - include original clarification question/answer in spec to maintain rationale

**Checkpoint**: Complete workflow from artifacts → solution design → detailed specification is now functional

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final touches, documentation, and validation

- [X] T048 [P] Add error handling for empty ./solution-artifacts/ folder in speckit.imagine.prompt.md - create folder and provide user instructions
- [X] T049 [P] Add error handling for unsupported file formats in speckit.imagine.prompt.md - list supported formats and skip with warning
- [X] T050 [P] Add error handling for corrupted/password-protected files in speckit.imagine.prompt.md - log error, continue processing other files
- [X] T051 [P] Add error handling for OCR unavailable in speckit.imagine.prompt.md - skip images with clear warning when agent doesn't support OCR/vision
- [X] T052 [P] Add error handling for diagram validation failure in speckit.imagine.prompt.md - use placeholder diagram with TODO notes
- [X] T053 [P] Add error handling for no features extracted in speckit.imagine.prompt.md - create minimal design with "No features identified" section and recommendations
- [X] T054 Update README.md with imagine command documentation - add to command list, link to quickstart.md
- [X] T055 Update CHANGELOG.md with imagine command feature addition
- [ ] T056 [P] Test imagine command with sample artifacts (PDF, DOCX, TXT) - validate end-to-end workflow
- [ ] T057 [P] Test imagine command with incomplete artifacts - validate clarification flow
- [ ] T058 [P] Test imagine command versioning - run multiple times, verify v2, v3 files created
- [ ] T059 [P] Test imagine → specify workflow - verify feature context carries forward

---

## Dependencies

### User Story Completion Order

User stories have the following dependencies:

```
Phase 2 (Foundation)
    ↓
Phase 3 (US1) ←─── MVP: Can generate solution designs
    ↓
Phase 4 (US2) ←─── Enhanced: Adds clarifications for incomplete artifacts
    ↓
Phase 5 (US3) ←─── Improved: Adds full traceability
    ↓
Phase 6 (US4) ←─── Complete: Enables workflow to /speckit.specify
    ↓
Phase 7 (Polish)
```

**MVP Scope** (Minimum Viable Product): Phase 2 + Phase 3 (US1)
- Users can generate solution designs from complete artifacts
- No clarification support yet, but core value delivered

**Recommended First Release**: Phase 2 + Phase 3 + Phase 4 (US1 + US2)
- Includes clarification flow for incomplete artifacts
- Covers both P1 user stories

### Parallel Execution Opportunities

#### Phase 1 (All Independent)
- T001, T002, T003 can be done in parallel (different documentation reviews)

#### Phase 2 (Foundational - Some Parallel)
- T004, T005, T008 are sequential (template → command → prompt instructions)
- T006 and T007 (bash + PowerShell scripts) can be done in parallel

#### Phase 3 (US1 - Some Parallel)
- T009, T010 (scanning + file detection) can be done in parallel
- T016, T017 (C4 diagrams) can be done in parallel after T015 complete
- T019, T020 (feature extraction + traceability) can be done together

#### Phase 4 (US2 - Mostly Sequential)
- Question flow is inherently sequential
- T024-T025 (gap analysis + prioritization) can be done together
- T031-T033 (recording + features + assumptions) can be done together

#### Phase 5 (US3 - Mostly Parallel)
- T034, T035, T036 (tracking + location + links) can be done in parallel
- T037, T038, T039 (clarification format + assumptions + validation) can be done together

#### Phase 6 (US4 - Mostly Sequential)
- Integration with existing /speckit.specify command requires sequential updates

#### Phase 7 (Polish - All Parallel)
- All error handling tasks (T048-T053) can be done in parallel
- All testing tasks (T056-T059) can be done in parallel
- T054, T055 (documentation) can be done in parallel

---

## Implementation Strategy

### MVP-First Approach

**Sprint 1** (Foundation + US1): Tasks T001-T023
- Delivers core value: artifact → solution design
- Users with complete artifacts can use immediately
- ~40% of total work

**Sprint 2** (US2): Tasks T024-T033
- Adds clarification flow
- Makes feature useful for incomplete artifacts
- ~25% of total work

**Sprint 3** (US3): Tasks T034-T040
- Enhances traceability
- Improves auditability and validation
- ~15% of total work

**Sprint 4** (US4 + Polish): Tasks T041-T059
- Completes workflow integration
- Final polish and error handling
- ~20% of total work

### Risk Mitigation

- **Mermaid diagram generation** (T016-T018): Test early with mermaid-diagram-validator, have placeholder fallback ready
- **Artifact extraction** (T011): Agent capabilities vary - implement graceful degradation from start
- **Question flow** (T024-T030): Follow clarify.md pattern closely to avoid UX issues
- **Source tracking** (T034-T040): Critical for value prop - include validation in every feature extraction

---

## Task Summary

**Total Tasks**: 59
- Phase 1 (Setup): 3 tasks
- Phase 2 (Foundation): 5 tasks
- Phase 3 (US1): 15 tasks
- Phase 4 (US2): 10 tasks  
- Phase 5 (US3): 7 tasks
- Phase 6 (US4): 7 tasks
- Phase 7 (Polish): 12 tasks

**Parallel Opportunities**: 24 tasks marked with [P] can be executed in parallel with other tasks in their phase

**MVP Scope**: 23 tasks (Phase 1 + Phase 2 + Phase 3)

**User Story Breakdown**:
- US1 (P1): 15 implementation tasks
- US2 (P1): 10 implementation tasks  
- US3 (P2): 7 implementation tasks
- US4 (P3): 7 implementation tasks

---

## Next Steps

1. **Begin Implementation**: Start with T001 (review existing patterns)
2. **MVP Focus**: Complete Phases 1-3 first for earliest value delivery
3. **Use /speckit.implement**: For each task, provide task ID and file path for implementation
4. **Validate Incrementally**: Test US1 independently before moving to US2
5. **Iterate**: Each user story should be demonstrable independently

**Suggested MVP Demo**: After Phase 3 complete
- Create ./solution-artifacts/ with sample PDF
- Run /speckit.imagine (without clarifications - use default assumptions)
- Show generated solution-design.md with C4 diagrams and features
