# The written story

Use this when the user asks for a write-up to read later, instead of a page or next
to one: "write this up", "write the story of", "I want to read this properly", "a
write-up the team can read later". The ask is: **"Write me the story of this, and
walk me through the code."** The result is a saved explainer: a story shape with a
guided code walkthrough added. It is written for a developer who knows the platform's
main components in general, but not this particular feature or path. Give the code
enough context that it can be followed, and no more detail than that.

The subject comes from the ask or from the current conversation (a ticket, PR,
design doc, bug, test or mechanism just discussed, or the page just built). Ask one
short question only when two different subjects are genuinely plausible.

## Gather the evidence first

- **Read the real sources before writing:** the PR or design doc body and diff, the
  ticket's description and comments (read-only), the test, and the code at a known
  ref. Facts already gathered for a page on the same subject are reused.
- **Reading code:** the current repo when the subject lives in it; otherwise a local
  clone (look next to the current repo, ask once for a path); otherwise `gh api` or a
  shallow clone, `git clone --depth 1 --filter=blob:none [-b <tag>] <url>`, said out
  loud. Read without touching the working tree: `git -C <repo> show <ref>:<path>`,
  `git -C <repo> grep <pattern> <ref>`, `git -C <repo> log`.
- **Pin every reference** to a commit SHA or a tag, and say which one: write
  "at main a1b2c3d, Oct 27", never just "main". Turn references into permalinks,
  `https://github.com/<org>/<repo>/blob/<sha>/pkg/.../file.go#L120-L134`.
- **External systems are read-only:** never comment, review, push, transition or
  send anything.
- **No invented facts:** if a fact can't be verified, say it is unknown. Never
  invent a line number, a function name or a motive.

## The story shape

Use these sections, adapting the headings to the subject. Every step must earn
its place, so drop a section that has nothing to say.

1. **Title and one-line subtitle.** The title is a short, concrete hook with no
   em-dashes. Put the subtitle in italics under the title.
2. **Short version (the TL;DR).** One or two paragraphs that work on their own:
   what the thing is for, the key mechanism, why it matters and where it stands.
   No function names here.
3. **The moment.** Something the reader can picture: a user's symptom, a red
   test, a surprising number, a backup that took four hours instead of four
   minutes.
4. **What we wanted and why it's hard.** The goal, the naive approach, and
   exactly where that approach breaks. Introduce each actor (the controller, the
   node agent, the storage driver, the hypervisor, the scheduler...) by its job
   before using its name.
5. **The walkthrough.** This is the core: follow one concrete example through
   the system in order, step by step. Each step says:
   - **who** acts (component),
   - **what** it does, and **why** this step is needed,
   - **where** in the code: a `file:line` permalink and, only when it adds
     understanding, a short excerpt.

   Write it as a numbered path, for example: "1. The user creates X → 2. the
   controller notices it in `pkg/.../vm.go:812` and ... → 3. ...". When it helps,
   add a small text diagram of the flow; plain Markdown renders everywhere.
6. **The tricky part.** The non-obvious design choice, race, edge case or bug,
   and why the code handles it the way it does. Separate what the PR or design doc
   documents from your own inference, and label the inference.
7. **What changes for users.** What users, admins or testers can now do (or what
   breaks if this regresses).
8. **Where it stands.** Be honest: merged or in review, feature gate, the releases
   it ships in (upstream, and the product release that carries it when there is
   one), verified by whom and when. Note open questions.
9. **Learn from it.** One or two transferable lessons, then who to ask, when the PR
   or the ticket names the people. Credit both development and testing work.
10. **References.** PRs, design docs, tickets, and the commit the code links are
    pinned to.

## The technicality dial

The default is medium: enough code to follow the path, not a code review.

- Show **3 to 6 excerpts** in total. Keep each excerpt under about 15 lines,
  trimmed with `// ...`. Every excerpt is preceded by a sentence saying what to
  look at in it.
- **Introduce code after its role is clear.** Never open a section with code.
- Prefer component roles over identifiers. Name a function only when the reader
  will click it or meet it again.
- Use one concrete running example throughout (a named VM, a disk, a pod, a
  request). Give placeholders a meaning: say what the thing is, not just "A/B".
- **Explain jargon on first use** (qcow2 overlay, dirty bitmap, finalizer,
  admission webhook, and so on), in plain words.
- If the user asks for "more code" or "less code", move the dial and keep the
  shape.

## Tone

- **A story, not a report:** conversational adult prose that is technical but
  easy to get into.
- **Show the causality:** connect each step to the next with "because", "so"
  and "which means". Never just list facts.
- **No theatrics, no ranking people.**
- **No invented thoughts:** present people's reasoning only as documented, or
  clearly mark it as a reconstruction.
- **UTC times. No em-dashes in titles or headings.**

## Where it goes

The story goes to the pool, next to the pages, with one README listing both.

- `scripts/pool.sh` prints the pool. When it prints nothing, this is the first use:
  ask the user where to keep the files, suggest `~/explainers`, accept any typed
  path, then run `scripts/pool.sh set <path>`. It creates the folder, `visual/`,
  `stories/` and a README.md with a "## Stories" section. `$EXPLAINER_POOL`, when set,
  overrides the saved choice.
- **Save to** `<pool>/stories/YYYY-MM-DD-<short-slug>.md`, where the date is today.
  Start the file with this front matter:

  ```
  ---
  title: <title>
  date: <YYYY-MM-DD>
  subject: <ticket / PR / design doc / topic>
  people: <who was involved, from the PR or ticket, or none>
  code-ref: <repo@sha, ...>
  ---
  ```

  After it come the `# Title` and the subtitle line.
- **Update an existing explainer** rather than duplicating it: append an
  `## Update · <date>` section instead of rewriting.
- **Add a line** under "## Stories" in `<pool>/README.md`, newest first:

  ```
  - YYYY-MM-DD · [Title](stories/<file>.md) · subject · checked on <repo> <short sha>
  ```
- **In chat, reply with** the short version plus the file's absolute path. Do not
  paste the whole document.

## Self-check before saving

- Can the short version be understood alone?
- Does every component and term have a role before it is used?
- Can the reader follow the numbered path and land on the right line of code
  from each step?
- Is every code link pinned and verified, i.e. you actually read that line at
  that ref?
- Are documented facts, inference and unknowns clearly separated?
- Is the status honest, and is the "learn from it" lesson transferable?
