---
description: Generate a solution design document from customer artifacts (PDFs, Word docs, images) with C4 architecture diagrams and feature traceability.
handoffs: 
  - label: Create Feature Spec
    agent: speckit.specify
    prompt: Create a specification for [feature-name]
    send: true
scripts:
  sh: scripts/bash/setup-imagine.sh --json
  ps: scripts/powershell/setup-imagine.ps1 -Json
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The `/speckit.imagine` command generates solution design documents from customer artifacts (PDFs, DOCX, TXT, MD, images) placed in `./solution-artifacts/`. It asks clarifying questions for missing information and produces a markdown document with executive summary, C4 Context/Container diagrams (Mermaid), and features with complete traceability.

**Execution Flow**:

1. **Setup and Validation**:
   - Run `{SCRIPT}` from repo root to initialize environment and get artifact paths
   - Parse JSON output for `ARTIFACTS_DIR`, `ARTIFACT_FILES[]`, `OUTPUT_FILE`
   - If `./solution-artifacts/` doesn't exist or is empty, create folder and instruct user:

     ```text
     Created ./solution-artifacts/ folder. Please add your customer artifacts (PDF, DOCX, TXT, MD, images) and run /speckit.imagine again.
     ```

   - For single quotes in args, use escape syntax: e.g., 'I'\''m Groot' (or double-quote: "I'm Groot")

2. **Artifact Processing Loop**:
   - For each file in `./solution-artifacts/`:
     - Display progress: "Processing [filename]..."
     - Detect file type by extension:
       - **PDF**: Extract text using agent file reading capabilities
       - **DOCX**: Extract text from Word document
       - **TXT/MD**: Read directly as plain text
       - **Images** (PNG, JPG, JPEG): Attempt OCR/vision if available, otherwise skip with warning:

         ```text
         ⚠️ Image file [filename] skipped - OCR not available
         ```

     - Handle errors gracefully:
       - Corrupted files: Log error, continue with other files
       - Password-protected: Log "Unable to access password-protected file", continue
       - Unsupported format: Skip with warning listing supported formats
     - Track processing status for summary report
   - After all files processed, display summary:

     ```text
     Processed: 8/10 files successfully
     Failed: 2 files (see details above)
     ```

3. **Content Analysis**:
   - Analyze extracted text from all artifacts to identify:
     - **Business Requirements**: Problems, goals, success criteria
     - **Actors**: Users, administrators, external systems
     - **Integrations**: Third-party services, APIs, existing systems
     - **Entities**: Data models, domain objects
     - **Technical Constraints**: Performance, security, scalability requirements
   - Extract solution name/title (or use "Unnamed Solution" if not found)
   - Identify information gaps for clarification questions

4. **Interactive Clarification** (if gaps detected):
   - Perform gap analysis - scan for missing critical information in priority order:
     1. Security/Authentication
     2. Integration points
     3. Data requirements
     4. Performance expectations
     5. User experience flow
   - Generate up to 20 prioritized clarifying questions following these rules:
     - **One question at a time** - wait for answer before next question
     - **Multiple-choice format** with 2-5 options plus short answer option
     - **Include recommendation** based on context (1-2 sentence rationale)
     - **Accept answer formats**: Option letter (A/B/C/D), "recommended", "suggested", or short answer (≤5 words)
     - **Sequential flow**: Present question, wait for response, validate answer, move to next
     - **Stop conditions**: After 20 questions OR user says "done"/"stop"/"skip"
   - Track Q&A pairs with timestamps for traceability
   - **Question Example**:

     ```text
     Question 1 of 5: How should users authenticate?
     
     A) Username/password with optional MFA
     B) SSO integration (SAML/OAuth)
     C) API key-based authentication
     D) Social login (Google, Microsoft, GitHub)
     E) Other (describe in 5 words or less)
     
     Recommended: B - SSO integration (SAML/OAuth)
     Rationale: Modern enterprise solutions typically integrate with existing identity providers for centralized user management.
     
     Your answer:
     ```

5. **Executive Summary Generation**:
   - Create 2-4 paragraph summary (300-600 words) including:
     1. **Problem Statement**: Business need or pain point from artifacts
     2. **Solution Approach**: High-level description of proposed solution
     3. **Key Capabilities**: 3-5 primary features identified
     4. **Stakeholders**: Users, beneficiaries, maintainers
   - Use business-focused language suitable for non-technical stakeholders
   - No implementation details or technology specifics in summary

6. **C4 Context Diagram Generation**:
   - Generate Mermaid C4Context diagram code:
     - Include actors (Person/Person_Ext)
     - Include systems (System/System_Ext)
     - Define relationships showing interactions
     - Use Enterprise_Boundary if multiple systems within organization
   - **Validate diagram** using `mermaid-diagram-validator` before writing
   - If validation fails, use placeholder with TODO note:

     ```markdown
     ⚠️ **Note**: Diagram validation failed. This is a placeholder - please review and complete manually.
     ```

   - Add description listing key elements, system boundary, external integrations

7. **C4 Container Diagram Generation**:
   - Generate Mermaid C4Container diagram code:
     - Include containers with technology stack (3rd parameter)
     - Use appropriate container types: Container, ContainerDb, ContainerQueue
     - Use Container_Boundary for solution boundary
     - Include external systems referenced
   - **Validate diagram** using `mermaid-diagram-validator` before writing
   - If validation fails, use placeholder with TODO note
   - Add description with:
     - Key components list (name, technology, purpose)
     - Technology stack breakdown (frontend, backend, data, infrastructure)

8. **Feature Extraction with Traceability**:
   - Generate features needed to deliver the solution approach and can be tied back to the generated Container diagram. Use the artifacts and clarifications. If the solution design calls for multiple phases, group the features by phase. 
     - **Title**: Noun phrase (e.g., "User Authentication", "Real-time Analytics")
     - **Description**: 1-3 sentences, 50-300 characters, focus on user value. Identify which diagram container(s) are impactecd.
     - **Source**: MUST be one of:
       - Artifact: `[filename](solution-artifacts/filename.ext) - See page X, section "Name"`
       - Clarification: `Agent Clarification - YYYY-MM-DD - Question: "[question text]"`
     - **Assumptions** (if applicable): List assumptions made about feature
   - **Validation**: Every feature must have exactly one source (artifact OR clarification, not both, not neither)
   - Track feature → source mapping throughout extraction
   - Capture location details (page numbers, section headings) from artifacts

9. **Assumptions & Open Questions** (if applicable):
   - Document general assumptions made during design
   - List open questions if information missing after 20 clarifications
   - Note areas requiring stakeholder validation

10. **Auto-Versioning**:
    - Check for existing `solution-design.md` in project root
    - If exists, determine next version:
      - `solution-design.md` exists → create `solution-design-v2.md`
      - `solution-design-v2.md` exists → create `solution-design-v3.md`
      - Continue incrementing (v4, v5, ...)
    - Update frontmatter `version` field to match filename version
    - **No prompting** - automatically version without asking user

11. **Document Generation**:
    - Load `templates/solution-design-template.md`
    - Populate all sections with generated content:
      - Frontmatter: title, created (today's date), version, artifact_count, last_updated
      - Executive Summary
      - C4Context diagram with description
      - C4Container diagram with description
      - Features with sources
      - Assumptions & Open Questions (if any)
      - Next Steps (include /speckit.specify recommendations)
    - Write to project root as `solution-design.md` or versioned filename
    - Ensure all markdown formatting is valid

12. **Completion Report**:
    - Display summary:

      ```text
      ✅ Solution design generated: solution-design.md
      
      📊 Summary:
      - Artifacts processed: 8/10
      - Features identified: 12
      - Clarifications answered: 3/5
      
      📋 Next Steps:
      1. Review solution-design.md for accuracy
      2. Run /speckit.specify [feature-name] to create detailed specifications
      3. Share with stakeholders for validation
      ```

## Error Handling

- **Empty artifacts folder**: Create folder, provide instructions, exit
- **No processable files**: List supported formats, exit with error
- **All extractions fail**: Report error, suggest checking file formats
- **Diagram validation fails**: Use placeholder diagram with TODO notes
- **No features extracted**: Create minimal design with recommendations
- **File write fails**: Report error with path, suggest permissions check

## Notes

- Refer to full workflow instructions in `.github/prompts/speckit.imagine.prompt.md`
- No external dependencies required - uses only agent capabilities
- Cross-platform support via bash and PowerShell scripts
- All generated files are plain markdown for version control
- Features can be passed to `/speckit.specify` for detailed specification
