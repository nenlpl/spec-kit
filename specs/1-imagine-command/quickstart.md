# Quickstart: Using /speckit.imagine

**Feature**: Imagine Command for Solution Design  
**Purpose**: Generate solution design documents from customer artifacts  
**Time**: ~10 minutes (excluding artifact gathering)

---

## Prerequisites

1. **Spec-kit initialized** in your project
   ```bash
   specify init
   ```

2. **GitHub Copilot** or compatible AI agent enabled in VS Code

3. **Customer artifacts collected**:
   - PDFs (requirements documents, RFPs, technical specs)
   - Word documents (DOCX)
   - Text files (TXT, Markdown)
   - Images (diagrams, screenshots) - if agent supports OCR

---

## Quick Start (5 Steps)

### 1. Create Artifacts Folder

```bash
mkdir -p ./solution-artifacts
```

If folder already exists, that's fine - skip this step.

### 2. Add Your Artifacts

Copy all customer requirements documents into `./solution-artifacts/`:

```bash
# Example: Copy files from your downloads folder
cp ~/Downloads/customer-rfp.pdf ./solution-artifacts/
cp ~/Downloads/technical-requirements.docx ./solution-artifacts/
cp ~/Downloads/architecture-diagram.png ./solution-artifacts/
```

**Supported formats**:
- ✅ PDF (`.pdf`)
- ✅ Word documents (`.docx`)
- ✅ Plain text (`.txt`)
- ✅ Markdown (`.md`)
- ✅ Images (`.png`, `.jpg`, `.jpeg`) - if agent has OCR capability

**No file size or count limits** - add as many artifacts as needed.

### 3. Run the Imagine Command

In VS Code, open GitHub Copilot Chat and run:

```
/speckit.imagine
```

You'll see progress as files are processed:
```
Processing artifacts...
✓ customer-rfp.pdf (124 KB)
✓ technical-requirements.docx (89 KB)
⚠ architecture-diagram.png - OCR not available, skipped
✓ notes.txt (12 KB)

Processed 3 of 4 files. 1 file skipped.
```

### 4. Answer Clarifying Questions

The agent will ask up to **5 questions** about missing information:

**Example questions**:
- What authentication approach should the solution use?
- What integration patterns are required?
- What are the data storage requirements?
- What performance/scalability targets apply?
- What are the primary user interfaces?

**How to answer**:
- **Multiple choice**: Reply with letter (A, B, C, D) or say "recommended"
- **Short answer**: Provide answer in 5 words or less, or say "suggested"

**Early exit**: Say "done" or "stop" if you've answered enough

### 5. Review Generated Design

Open the generated file in your project root:

```bash
# First time running imagine
cat solution-design.md

# If you've run imagine before, check versioned file
cat solution-design-v2.md  # or v3, v4, etc.
```

The document includes:
- ✅ Executive summary (2-4 paragraphs)
- ✅ C4 Context diagram (actors and systems)
- ✅ C4 Container diagram (components and technologies)
- ✅ Feature list with traceability to source artifacts
- ✅ Next steps and recommendations

---

## Full Example Walkthrough

### Scenario: Customer Portal Modernization

**Starting state**: You have customer artifacts ready

```bash
$ ls ./solution-artifacts/
customer-rfp.pdf
technical-requirements.docx
current-architecture.png
user-feedback.txt
```

**Step 1**: Run imagine command

```
/speckit.imagine
```

**Step 2**: Watch progress

```
Scanning artifacts...
Found 4 files in ./solution-artifacts/

Processing artifacts...
✓ customer-rfp.pdf (245 KB) - extracted 12,450 characters
✓ technical-requirements.docx (156 KB) - extracted 8,234 characters
⚠ current-architecture.png (789 KB) - OCR not available, skipped
✓ user-feedback.txt (23 KB) - extracted 3,456 characters

Processed 3 of 4 files successfully. 1 file skipped.
```

**Step 3**: Answer questions

```
Question 1 of 5

Recommended: Option B - SSO provides enterprise-grade security

What authentication approach should the solution use?

| Option | Description |
|--------|-------------|
| A | Username/password with optional MFA |
| B | Single Sign-On (SSO) via SAML or OAuth |
| C | API key based (machine-to-machine) |
| Short | Provide different answer (≤5 words) |

You: B
```

```
Question 2 of 5

Recommended: Option A - REST APIs are widely supported

What integration patterns are required?

| Option | Description |
|--------|-------------|
| A | REST APIs (synchronous) |
| B | Message queues (asynchronous) |
| C | Event-driven (pub/sub) |
| D | Mix of REST and async messaging |
| Short | Provide different answer (≤5 words) |

You: recommended
```

*(Continue for up to 3 more questions)*

**Step 4**: Review output

```bash
$ cat solution-design.md
```

```markdown
---
title: Customer Portal Modernization
created: 2026-02-03
version: v1
artifact_count: 4
---

# Customer Portal Modernization - Solution Design

## 1. Executive Summary

The current customer portal suffers from poor mobile responsiveness and slow 
performance (8 second page loads). Customer satisfaction has declined from 
4.2/5 to 3.1/5. This solution delivers a modern, mobile-first web application...

[... rest of document]

## 3. Features

### Feature 1: User Authentication via SSO

**Description**: Enterprise users can log in using their corporate credentials 
via SAML 2.0 or OAuth 2.0. Session management handles automatic renewal and 
secure logout across all devices.

**Source**: [customer-rfp.pdf](solution-artifacts/customer-rfp.pdf) - See page 8, 
section "Security Requirements"

**Assumptions**:
- Microsoft Azure AD will be primary identity provider
- Social login (Google, Facebook) deferred to Phase 2

---

### Feature 2: Real-Time Order Tracking

**Description**: Customers receive live updates as orders move through 
fulfillment and shipping. Push notifications alert users of status changes 
via email and in-app messaging.

**Source**: [user-feedback.txt](solution-artifacts/user-feedback.txt) - See 
line 45-62, "Top 10 Requested Features"

[... more features]
```

---

## Common Workflows

### Iterate on Design

Run `/speckit.imagine` again with updated artifacts or different answers:

```bash
# Add more artifacts
cp ~/Downloads/additional-requirements.pdf ./solution-artifacts/

# Run imagine again (creates v2)
/speckit.imagine
```

Result: `solution-design-v2.md` is created, original `solution-design.md` is preserved.

### Create Detailed Specs from Features

Take a feature from solution design and create detailed specification:

```
/speckit.specify "User Authentication via SSO"
```

This creates a new feature branch and spec with:
- Feature description pre-populated from solution design
- Source artifact references preserved
- Assumptions carried forward

### Export for Stakeholders

Share the solution design with stakeholders:

```bash
# Convert to PDF (requires pandoc or similar)
pandoc solution-design.md -o solution-design.pdf

# Or share markdown directly (renders in GitHub, GitLab, etc.)
git add solution-design.md
git commit -m "Add solution design for customer portal modernization"
git push
```

---

## Tips & Best Practices

### Artifact Preparation

✅ **DO**:
- Include PDFs with searchable text (not scanned images)
- Name files descriptively (`requirements-v2.pdf` not `Document1.pdf`)
- Organize artifacts in subdirectories if many files (`./solution-artifacts/requirements/`, `./solution-artifacts/diagrams/`)
- Include architecture diagrams (if agent supports OCR) or describe them in text files

❌ **DON'T**:
- Include password-protected files (will be skipped with error)
- Mix artifacts from different projects in same folder
- Rely solely on images without text-based artifacts

### Clarification Questions

✅ **DO**:
- Accept recommendations unless you have specific requirements
- Provide concise answers (follow the ≤5 words guideline for short answers)
- Say "done" if remaining questions aren't relevant to your solution

❌ **DON'T**:
- Overthink answers - you can iterate by running imagine again
- Provide long, detailed answers (save those for artifact documents)

### Generated Design Review

✅ **DO**:
- Review for **sensitive information** before sharing (credentials, API keys, PII)
- Validate that features match your understanding of requirements
- Check that C4 diagrams render correctly (they should display automatically in markdown viewers)
- Verify artifact links point to correct files and locations

❌ **DON'T**:
- Share solution design externally without removing sensitive data
- Assume all features are perfectly prioritized (you may need to reorder)
- Expect implementation-level details (that's what `/speckit.specify` is for)

### Version Management

✅ **DO**:
- Keep all versions in git history (v1, v2, v3...)
- Note major changes between versions in commit messages
- Use versions to show design evolution to stakeholders

❌ **DON'T**:
- Manually rename files (versioning is automatic)
- Delete old versions (they show evolution of thinking)

---

## Troubleshooting

### No Artifacts Folder

**Error**: `./solution-artifacts/ directory does not exist`

**Solution**:
```bash
mkdir -p ./solution-artifacts
# Add your files
cp ~/path/to/requirements.pdf ./solution-artifacts/
```

### All Files Skipped

**Issue**: "Processed 0 of 5 files. 5 files skipped."

**Causes**:
- All files are unsupported formats (check for `.pdf`, `.docx`, `.txt`, `.md`)
- Files are corrupted or password-protected
- Files are empty

**Solution**:
```bash
# Check file types
ls -lh ./solution-artifacts/

# Verify files aren't empty
wc -c ./solution-artifacts/*

# Try with a simple text file first
echo "Test requirement: Users need authentication" > ./solution-artifacts/test.txt
/speckit.imagine
```

### OCR Not Available Warning

**Issue**: Images are skipped with "OCR not available"

**Explanation**: Your AI agent doesn't support image text extraction (this is normal for some agents)

**Workaround**:
1. Manually transcribe key information from images into a text file
2. Or use a different agent that supports vision/OCR (e.g., GitHub Copilot with GPT-4 Vision)

### Diagram Doesn't Render

**Issue**: Mermaid diagram shows as code block instead of rendered diagram

**Causes**:
- Viewing in editor that doesn't support Mermaid
- Syntax error in diagram (shouldn't happen - diagrams are validated)

**Solution**:
```bash
# Preview in VS Code (supports Mermaid)
code solution-design.md

# Or use GitHub (renders Mermaid automatically)
git add solution-design.md && git commit -m "Add design" && git push
# View on GitHub web interface
```

### Feature Has No Source

**Issue**: Feature shows "Source: UNKNOWN"

**Explanation**: Agent couldn't determine which artifact contained this feature information

**Solution**:
1. Check "Assumptions & Open Questions" section for details
2. Run `/speckit.imagine` again with more specific artifacts
3. Or manually update the source reference in the markdown file

---

## Next Steps

After generating your solution design:

1. **Stakeholder Review**: Share `solution-design.md` with team for feedback

2. **Create Detailed Specs**: For priority features, run:
   ```
   /speckit.specify "Feature 1 Name"
   /speckit.specify "Feature 2 Name"
   ```

3. **Technical Planning**: Use `/speckit.plan` on feature specs to create implementation plans

4. **Effort Estimation**: Use features and specs for story pointing or T-shirt sizing

5. **Iterate**: Add more artifacts and run `/speckit.imagine` again to refine (creates v2)

---

## Keyboard Shortcuts (VS Code)

- **Open Copilot Chat**: `Cmd+I` (Mac) or `Ctrl+I` (Windows/Linux)
- **Run Command**: Type `/speckit.imagine` and press `Enter`
- **View Markdown Preview**: `Cmd+Shift+V` (Mac) or `Ctrl+Shift+V` (Windows/Linux)

---

## Support

- **Documentation**: See [spec-driven.md](../../../spec-driven.md) for methodology overview
- **Issues**: Report problems via GitHub issues
- **Examples**: Check `./templates/solution-design-template.md` for document structure

---

## Appendix: Command Reference

### /speckit.imagine

**Purpose**: Generate solution design from artifacts  
**Prerequisites**: Artifacts in `./solution-artifacts/`  
**Output**: `solution-design.md` (or versioned: `solution-design-v2.md`, etc.)  
**Duration**: ~10 minutes (excluding artifact collection)  
**Max Questions**: 5 clarifying questions  
**Versioning**: Automatic (non-destructive)

### Related Commands

- `/speckit.specify [feature]` - Create detailed spec from solution design feature
- `/speckit.clarify` - Add clarifications to existing spec
- `/speckit.plan` - Create implementation plan from spec
- `/speckit.tasks` - Break plan into implementation tasks

---

**Quick Reference Card**:

```
┌─────────────────────────────────────────────┐
│ /speckit.imagine Workflow                   │
├─────────────────────────────────────────────┤
│ 1. mkdir ./solution-artifacts               │
│ 2. Copy PDFs/DOCX/TXT/images to folder      │
│ 3. /speckit.imagine                         │
│ 4. Answer up to 5 questions                 │
│ 5. Review solution-design.md                │
├─────────────────────────────────────────────┤
│ Versioning: Automatic (v1, v2, v3...)       │
│ Max Questions: 5                            │
│ Time: ~10 minutes                           │
│ Next: /speckit.specify [feature-name]       │
└─────────────────────────────────────────────┘
```
