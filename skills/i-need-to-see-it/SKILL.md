---
name: i-need-to-see-it
description: Use when the user invokes i-need-to-see-it or wants to see how something works rather than read about it. Trigger on present, demo, visualize, draw, animate, "show me the flow", "walk me through", "make an explainer", "what talks to what", "what happens when", for a feature, a flow, a design, a resource creation, a bug or its fix, a race, a ticket, even when the word "visual" is missing. Takes anything after the name as the ask, in words, one or more YAML or JSON manifests, a branch or PR, a VEP or KEP, a Jira or GitHub link, a pasted log, or the conversation so far. Reads the real code at a pinned ref, finds the components (the boxes), the steps and the arrows, and builds one interactive page, what talks to what, stepped through over time, with notes, numbers and code links, a side-by-side view, and in --detailed mode the full API surface with what changes at every step and a YAML drawer with the objects' fields as they change. Publishes a private Artifact and always writes a standalone local HTML file. --style picks the look, plain by default, Red Hat's built in, or one learned from a file the user brings. On first use it asks where to keep the generated files. For a slide deck use the Slides type. On request it gives the same subject as an explanation in chat or a saved Markdown story instead of a page.
---

# I need to see it

Invoking this skill means: **"Show me how this works. I want to see it."** The result
is one interactive page, published as a private Artifact and written to a local HTML
file, built from the real code. Whatever follows the name is the ask: a few words, a
manifest, a branch, a ticket, a log, or nothing but the conversation so far.

The page always shows three things at once, because understanding code is
understanding what talks to what, in what order, with what effect:

1. **What talks to what.** A scene of the real components where they really live,
   with control arrows (who asks whom) and data arrows (where the bytes actually go).
2. **What happens over time.** Flows the viewer steps through. Each step changes
   the scene: a component lights up, an arrow switches, a state badge changes, an
   object appears. A rail and timeline lanes under the scene show every step at once,
   sized by rough duration, so the audience always knows where they are.
3. **Everything around it.** For each step: what happens and why, in plain words; a
   note with the numbers and limits; code links; a few facts that track the state
   that matters. Then a side-by-side view: both flows on one schematic timeline, the
   one sentence to remember, a table of differences, how to ask for it.

`references/snapshot-flows.html` is the bar: its density, wording and look are the
standard. `references/snapshot-flows-detailed.html` is the same subject in detailed
mode. Read the first in full before designing a new page.

Flags, anywhere in the ask:

| Flag | Effect |
|---|---|
| `--detailed` | adds the API surface view, the folded "In the API" block under every step, and the YAML drawer (key Y) with the objects at each step and what changes in them (`references/detailed.md`) |
| `--plain` | steps only: no API surface, no "In the API" block, no drawer |
| `--style <name or file>` | the look: `plain` (default), `redhat`, a saved style, or a PDF, PPTX, HTML, CSS or image to learn a style from (`references/styles/README.md`) |
| `--repo <path or URL>` | where the code is, when it is not the current repo |
| `--ref <sha, tag or branch>` | the ref to read at |
| `--for qe` / `--for dev` | the audience; QE pages name what to observe and assert at each step |
| `--learning` / `--presentation` | the mode (`references/modes.md`): learning opens on a Background tab and keeps full texts; presentation drops it and trims every step to what fits a projector |

## 1. Read the ask

`references/casting.md` section 1 has the full table. In short:

- **Words** name the subject and the world it lives in.
- **Manifests** fix the kinds, the fields and the example's names. The flow follows
  the branches these values take; other values go in a note. Unset fields take their
  defaults from the defaulting code or the CRD.
- **A feature** (branch, PR, VEP, KEP) gives the old path and the new one, and the
  field or object that selects the new path.
- **A bug** (ticket, description, log, the chat) gives the symptom, the trigger and
  the versions. A claim in a ticket is not a cause: confirm it in the code or label it
  "as reported".
- **The conversation** supplies the subject when the ask is "this"; reuse what it
  verified, verify the rest.

Settle, before reading code: the subject in one sentence; the one concrete example
with real names; the world and the repo; the audience; the mode and the style.

When the ask is for words rather than a page (an explanation in chat, a write-up to
read later), go to "Words instead of a page" near the end; the questions below are
for pages.

**Ask before building, every time.** Three choices change the page, none of them has
a default, and the ask rarely names them all; on first use there is a fourth, where
to keep the files. Before reading code, ask about every one of them the ask or the
conversation has not settled explicitly, in one message, each option with a one-line
meaning and none of the three marked as the default. Use the host's question widget
when there is one (in Claude Code, `AskUserQuestion` with one question per choice);
otherwise a short numbered list. One round only.

| Choice | Ask it as | Settled by |
|---|---|---|
| where to keep the files (first use only) | **Where should I keep the pages?** Every page is also written as a standalone HTML file into one folder, the pool, with a README that lists them. Suggest `~/explainers`; any typed path works | `scripts/pool.sh` printing a path (the saved choice, or `$EXPLAINER_POOL`). When it prints nothing this is the first use: ask, then run `scripts/pool.sh set <path>` |
| mode | **Learning**: opens on a Background tab that explains the problem, the pieces and the one idea; full notes. **Presentation**: no Background tab, every step trimmed to what fits a projector, larger text | `--learning`, `--presentation`, or words like "to learn", "onboarding", "for the meeting", "to present" |
| audience | **Developers**: who calls what and why, code links. **QE**: at each step, the command that shows it and what to assert | `--for dev`, `--for qe`, or the audience named ("for the testers") |
| detail | **Detailed**: an API surface tab listing every field, condition, event and file the subject adds, a folded "In the API" line under each step saying what changed, and a YAML drawer (Y) showing each object's fields as they change step by step. **Plain**: steps only | `--detailed`, `--plain`, "with all the fields", "what can I observe", "steps only" |

Add another question only when the subject itself is ambiguous, or no repo can be
found. A choice is settled only by a flag or by words that clearly make it; a guess
from the subject ("it adds API, so detailed") is not. When the user answers "you
choose", pick what fits the ask and name the choice in the reply. In a run where
nobody can answer, build nothing and reply with the open questions. Never ask what
the ask already says, and never ask about what the page settles for itself: the
cast, the steps, the style.

## 2. Pick the story

| Subject | Flows | Side-by-side view |
|---|---|---|
| A feature that changes an existing path (External vs Direct snapshots) | the old flow, then the new one | both on one timeline, a differences table, how to ask for it |
| A feature on its own (hotplug) | the main flow. Add a second only when it teaches something: unplug, a failure path, or the way it replaced | the phases and what a user sees in each, the limits, how to ask for it |
| A resource or a manifest ("what happens when this PVC is created") | creation, from the manifest to the end state. Add deletion or an update when the ask implies it | the phases on one timeline, what `kubectl get` shows in each, the fields that change the path |
| Two or more manifests that interact (a pod and its PVC) | the interaction: scheduling, attach, mount, use | a lane per object over time, the objects and calls in between, the limits |
| "How X works" with no object to create (a reconcile loop, a protocol, a scheduler) | one pass of X with one concrete input; a second flow for the case that makes X interesting | the pass as phases, the decisions and their inputs, the knobs |
| A bug and its fix | "Today": the normal path up to where it goes wrong, and the symptom. "With the fix": the same start, the fixed step, the right end | where the paths split; trigger, what goes wrong, symptom, fix, fixed in, workaround |
| A bug without a fix yet | "Today" alone, with the bug step | trigger, what goes wrong, symptom, affected versions, workaround |
| A race | one flow per ordering of the actors | a lane per actor over time, showing the ordering that breaks |

For a bug: tag the step where reality leaves the intended path (`tag: "bug"`), draw
it on the scene (the wrong arrow, the stuck state, the bug mark), and tag the step the
fix changes (`tag: "fix"`).

## 3. Find the code and pin a ref

The page will be presented as how the system works. Every arrow, state, name and
number on it must be true of the code at one ref.

- **Which repo.** The current repo when the subject lives in it; else a local clone
  (look next to the current repo and under the user's usual roots; ask once when
  nothing turns up); else a shallow clone into the scratchpad, said out loud:
  `git clone --depth 1 --filter=blob:none [-b <tag>] https://github.com/<org>/<repo>`.
  A subject can span repos; pin each one the page follows. `references/casting.md`
  section 7 lists where the code of the common worlds lives.
- **Read at the ref, not the working tree.** `git -C <repo> show <ref>:<path>` and
  `git -C <repo> grep <pattern> <ref> -- <path>`. Checkouts move between branches
  mid-task. For a VEP, only vep.md in the enhancements repo counts.
- **Which releases.** `scripts/versions.sh <repo> contains <sha>` lists the releases
  that have a commit; `since <ref> <path> [<text>]` finds the release that introduced a
  file or a string. Put the answer in the footer ("in releases v1.4 and later",
  "fixed in v1.6.2", "not released yet, branch `feature/x`") and, for a bug, in the
  side-by-side table. New work on a branch is pinned to the branch head.
- **GitHub and Jira are read-only.** `gh pr view`, `gh pr diff`, `gh api` and
  getJiraIssue are fine. Never comment, review, edit or transition.

## 4. Gather the facts

Walk the one concrete example through the code and write an event list, one line per
moment: who acts and the call it makes; what changes in the cluster, on the node, in
the storage; what a user could observe (phase, condition, event, file); every number
with its file:line. `references/casting.md` section 3 says where to look: the
trigger, admission and defaulting, the watchers and their reconcile, the node agents,
the calls across processes, the data, the waits, the failure branches.

Reason from what one reconcile pass can observe; absence is never proof. A retry
loop is one step with the backoff in the note. When the code surprises you or looks
wrong, tell the user rather than smoothing it over, and draw today's behavior: the
snapshot page found a real gap in the freeze budget this way.

## 5. Design before drawing

Settle these in a few lines before writing the page (`references/casting.md`
sections 4 to 6 have the rules and the idioms):

- **The cast**, about 5 to 9 boxes, each earning its place by acting, holding state
  or holding data in at least one step; named as the code names them; placed by the
  pool's geography: control plane left, the node right with the workload inside its
  pod frame, storage and external systems along the bottom, the user at the top left.
- **The scene's state** and its values: the workload's state, where the data goes,
  which objects exist.
- **The steps**, one line each, 4 to 12 per flow: one action with one visible
  consequence; split hidden moments (freeze, switch, thaw; schedule, attach, mount);
  merge look-alikes; separate a transition from its state when its length matters;
  name key transitions on the picture with the code's words; data arrows follow the
  real path at every step; an arrow means something moves, a relation is words; ghost
  what doesn't exist yet; no shorthand; the API's own names.
- **The idiom for each moment**, from the table in casting.md section 6: a move is a
  data arrow to the real destination; a switch (pivot, failover, cutover) is a named
  transition with the old path dimmed; a long job in another system is a pulsing
  object card and a wide hatched step; a wait is the `held` tone with a "wait" label;
  a state machine is a badge and a facts row; a rejected check is a bug mark on the
  element that failed.

## 6. Build from the template

Call Artifact `quickstart` with intent `other` before writing the page: the Artifact
tool asks for it once per new artifact. The template already meets the page contract.

Copy `assets/template.html` into the scratchpad as `<slug>.html`.
- **What it gives you:** the look and a generic, data-driven engine. The scene's
  pieces are roles (a frame, a workload, a state badge, a "uses" strip, a band, an
  external object, the new object, data and control arrows, a named transition, a bug
  mark), and `references/anatomy.md` section 4 says what each can stand for.
- **What you replace:** the scene drawing; the data (state, steps, facts, lanes, the
  side-by-side content); every TODO.
- **Before editing,** read `references/anatomy.md`: the engine, the scene vocabulary,
  the tones and the traps.
- **Reuse earlier drawings.** When a page in the pool already draws the same
  components, reuse that drawing so the series looks like one family.
- **Detailed mode:** fill `API`, `SURFACE` and `YAML` as `references/detailed.md`
  says, from the same event list: every field, condition, reason, annotation,
  finalizer, event, guard and constant the flow touches, per step only what changes,
  and per object the fields that matter as deltas, so the drawer can show the old
  value next to the new one. A subject with two parts gets two groups on the surface.
- **Style:** the default is plain, as the template ships. For `--style redhat` or a
  saved style, replace the `:root` block, add the font links and adjust `rx` as the
  style file says. For a file the user
  brings, learn the style first (`references/styles/README.md`), save it under
  `references/styles/<name>.md`, then apply it and say it was saved.
- **Dark mode:** every page keeps the template's Dark switch (key D), the round on/off
  switch at the top right above Present, and its style's dark set, whatever the mode or
  style. Pages open light and the viewer switches, so a page looks the same on every
  projector until someone flips it.

Write for a teammate, a developer or a tester, who knows the platform's main
components but not this subject, and may open the page alone weeks later. So each
step stands on its own:

- **title**: the action, 3 to 7 words ("Freeze the guest", "Bind the claim").
- **short**: 1 or 2 words for the rail.
- **body**: who does what and why, 2 to 4 sentences, real names in backticks.
- **note**: the numbers, limits, edge cases and failure branches, with their source
  ("In one of our test runs, …", "kubelet retries every 10 s, up to …"). For a QE
  audience, the command that shows it and the pass criterion.
- **code**: file:line links for the step, at the same pinned SHA as the footer.

The bodies and the Background tab are explanations, and `references/explaining.md`
has the method: start where the reader is, introduce each actor by its job before
its name, and tie each step to the next by its cause.

The rest of the page:
- **Header:** an eyebrow (`<project> · <area> · <API field or object>`); a title that
  names the comparison or the flow; a lede that gives the example and says what to
  watch.
- **`<title>`:** a name of 2 to 4 words.
- **Footer:** the repo, SHA and date the page follows, the releases it applies to,
  the main files, the design doc, PRs or ticket.

## 7. Look at it

Render it with `scripts/shoot.sh`, and look at each PNG with Read.

Render at least:
- the busiest steps of every flow;
- the side-by-side view, and `#surface` in detailed mode, plus one busy step with
  the YAML drawer open;
- one step at phone width (`SIZE=390,1800`);
- one busy step in dark (`DARK=1`).

Look for:
- clipped or overlapping text;
- an arrow that points at the wrong box, or starts or ends in empty space;
- a dark pill narrower than its label;
- grey bands above and below the drawing in Present mode;
- markers that render black;
- a missing Dark switch, or in dark a surface that stays white or text that fades
  into its background;
- an empty narration column, which means a script error;
- a scene that disagrees with the step's text;
- a step whose "In the API" lines disagree with its facts;
- a drawer line whose old value is not what the previous step set.

`grep -n TODO` must come back empty.

## 8. Deliver

1. Publish the scratchpad file with Artifact (icon `diagram`, a one-sentence
   description). The artifact is private until the user shares it; never share or
   pin it unasked. Without an Artifact tool, the local file is the deliverable.
2. Always write the standalone local file, whether or not the Artifact was published:
   `scripts/standalone.sh <slug>.html "$(scripts/pool.sh)/visual/YYYY-MM-DD-<slug>.html"`.
   The pool is the folder the user chose on first use (section 1); `pool.sh set`
   created it with a README.md holding a "## Visual explainers" section.
3. Add a line to that section, newest first:

   ```
   - YYYY-MM-DD · [Title](artifact URL) · subject (ticket, PR, VEP) · checked on <repo> <short sha>, <releases> · source: `visual/<file>.html`
   ```

To change an existing page:
1. Find its URL in that list, or ask.
2. Read it with Artifact `read`, which saves the live page to a file.
3. Edit that file and publish it with `url`.
4. Rewrite the local file with `scripts/standalone.sh` from the edited source.

Don't make a second page for the same subject. If asked for one page that lists the
pool, build it from that list in the same look, and put its link at the top of the
section.

## 9. Reply

Include:
- the artifact link and the local file's absolute path;
- each flow's steps, one line each, so the user can redirect quickly;
- the ref the page was checked against and the releases it applies to;
- any finding from the code;
- in detailed mode, the objects the surface view covers, and that Y opens the YAML
  drawer;
- the mode the page was built in, and which choices came from the question;
- that the page stays private until the user shares it from its Share menu, and the
  style's name when one was learned and saved.

## Words instead of a page

The facts gathered in sections 3 and 4 serve two other outputs. Give one when the
user asks for it on the subject at hand, before, after or instead of a page:

- **An explanation in chat** ("just explain it", "why is it built this way"): follow
  `references/explaining.md`. A short version, then the long one, from the real
  problem to the mechanism, in cause-and-effect order.
- **A saved write-up** ("write this up", "the story of this fix"): follow
  `references/story.md`. A Markdown story with a guided code walkthrough and pinned
  permalinks, saved under `<pool>/stories/` and listed in the pool's README.

Neither needs the three questions of section 1; the write-up needs the pool. The
same rules hold: code read at a pinned ref, nothing invented, external systems
read-only.

## Self-check

- Did the ask, in whatever form, become one subject sentence and one concrete example?
- At every step, does each arrow on the scene match what the code does at that
  moment, at the pinned ref?
- Can a teammate who wasn't in the room follow each step from the page alone?
- Can every number be traced to a file:line at the pinned ref, or to a named
  measurement?
- Do the timeline, the side-by-side chart, the table, and in detailed mode the API
  lines, the surface and the drawer, agree with the steps?
- Does the footer say which releases the page applies to?
- Is the takeaway the sentence you'd want the audience to repeat?
- Does the page have its Dark switch, and does a step read well with dark on?
- Is there a local HTML path in the reply?
