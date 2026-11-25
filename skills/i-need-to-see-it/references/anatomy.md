# Anatomy of an explainer page

How `assets/template.html` works. A new page changes the drawing and the data, not
the engine. `snapshot-flows.html` was written before the template and shows the same
ideas with an engine written for that page alone; `snapshot-flows-detailed.html`
shows the detailed mode.

1. Layout
2. The step engine
3. Scene flags
4. Scene vocabulary, and what each piece can stand for
5. Tones and the style
6. Side-by-side view
7. Presenting and deep links
8. Text in SVG
9. Checking the page, and traps
10. Detailed mode: `API`, `SURFACE` and `YAML`

## 1. Layout

- **Header**: eyebrow, h1, lede; tabs built from `FLOWS` (plus, in learning mode, a
  Background tab first; the side-by-side tab; and, in detailed mode, the API surface
  tab); Present (full screen). At the top right of the page, above Present: the Dark
  switch, a round on/off switch for the style's dark set, off by default.
- **Background view** (learning mode, `INTRO` set): a reading page before the
  walkthrough: the problem, the catch and the trick, the one idea as a statement and a
  chain, the pieces, a vocabulary table, what to watch per tab. `references/modes.md`.
- **Walk view**: the stage (the SVG scene, viewBox 960×560) beside the narration
  column (flow chip, "Step N of M", tag chip, the "takes" chip when the step has a
  `time`, title, body, note, code links, the folded "In the API" block in detailed
  mode, facts); under them the rail (Back, step buttons, Next), the thin dark "Takes"
  line and the timeline lanes. The scene's height follows its viewBox
  (`height: auto`), capped by the viewport so the rail stays on screen; it sets the
  row's height and the narration scrolls inside `.narr-in`, so the rail never moves
  between steps. Never give the scene a fixed height: on a wide screen the SVG is
  letterboxed and the drawing floats between grey bands.
- **Side-by-side view**: heading, chart, legend, "How to ask for it" with copyable
  YAML, takeaway, differences table, buttons back to the flows.
- **API surface view** (detailed mode): heading, cards per object in one or more
  groups, footer, buttons.
- **YAML drawer** (detailed mode): a panel fixed to the bottom of the window, opened
  with Y or the YAML button, that tracks the step: one card per object with its YAML
  cut down to the fields that matter, the step's changes marked. Drag its top edge,
  double-click it or press Shift with ↑ ↓ to resize; the height is kept per browser.
- **Footer**: the repo, SHA and date the page follows, the releases it applies to,
  the main files, the design doc, PRs or ticket.

## 2. The step engine

Everything to fill in is at the top of the script.

| Name | What it holds |
|---|---|
| `REPO` | GitHub blob URL at the pinned SHA; step code refs resolve against it |
| `BASE` | every scene state key with its default; written as `data-<key>` on `#scene` at each step |
| `TEXT` | default text per scene element id; a value can be a function of the state, e.g. `(st) => BADGE[st.guest]` |
| `LINES` | default lines for each group of `<text data-line="name">` |
| `TAGS` | narration labels for step tags (`bug`, `fix`) |
| `FLOWS` | one entry per flow, in presentation order: `{ label, sub, tone, steps }` |
| `MODE` | `"learning"` or `"presentation"`; set as `data-mode` on the page |
| `INTRO` | the Background tab label in learning mode, `null` otherwise (the section is removed) |
| `COMPARE` | the side-by-side tab label, or `null` for a page without it (delete the section) |
| `API` | detailed mode: per flow, per step, what changes in the API; `null` otherwise |
| `SURFACE` | detailed mode: the API surface view; `null` otherwise |
| `YAML` | detailed mode: per flow, the objects and how their fields change step by step, for the drawer; `null` otherwise |
| `LISTS` | which YAML keys print as lists, and the field that names an item (`conditions: "type"`), `null` for a list of scalars |
| `FACTS` | facts rows: `[label, (st, t, s) => [value, tone]]` |
| `LANES` | timeline lanes: `[label, (st, s, i, prev) => [classes, label]]` |

A step:

| Field | Meaning |
|---|---|
| `short` | 1 or 2 words, shown on the rail |
| `w` | relative width in the timeline lanes, by rough duration |
| `title` | the action, 3 to 7 words |
| `body` | 2 to 4 sentences; text in backticks becomes code |
| `note` | numbers, limits, edge cases, failure branches (optional) |
| `code` | `["pkg/path/file.go:120-134"]` or full URLs for other repos (optional) |
| `tag` | `"bug"` or `"fix"` (optional): colors the rail button, adds a narration chip |
| `time` | `[text, tone, short]` (optional): how long the step runs and what bounds it; the text goes in the "takes" chip, the short form on the "Takes" line, the tone colours the chip (`held` a wait, `ice` guest frozen, `ext` scales with data, `accent` a limit or interval in the code). Only on steps where time says something |
| `s` | the state keys that differ from `BASE` |
| `text` | the element texts that differ from `TEXT` |
| `lines` | the line groups that differ from `LINES` |

Each step is complete on its own (defaults plus its overrides). Nothing carries over
from the step before, so jumping straight to any step renders it correctly.

Line groups: leading spaces indent a line, so a call chain reads as nested
(`"virDomainFSFreeze", "  → guest agent", "    guest-fsfreeze-freeze"`). `data-cw`
on the text element is the character width used for the indent: 7.2 for 12px mono
(the default), 6.6 for 12.5px sans.

## 3. Scene flags

Any element in the scene can carry these; the engine evaluates them at each step.

| Attribute | Effect when the expression holds |
|---|---|
| `data-on` | visible (fades in and out); hidden otherwise |
| `data-active` | `.active`: a lit control arrow, a highlighted component |
| `data-dim` | `.dim`: half opacity; a data arrow becomes a gray dotted path without a head, the path being left |
| `data-ghost` | `.ghost`: a dashed, faded card, for something not created yet or already removed |

Expressions: `key=value`, alternatives `key=a|b`, negation `key!=value`, AND with
spaces, OR with commas: `data-on="writes=base, switch=extra"`.

For anything else, style on the scene's state attributes, as the template does for
the guest: `.scene[data-guest="frozen"] .guest { … }`.

## 4. Scene vocabulary, and what each piece can stand for

The template's scene draws a VM and its storage, because that is where the first
pages lived. The pieces are roles, and a page about a pod, a queue or a service
reuses them with other names:

| Classes | Role | Also stands for |
|---|---|---|
| `card` `kicker` `title` `line` `mono-line` `hair` `k` `v` | a component box: kicker = where it runs, title = its name, lines = what it is doing at this step, k/v = its key status | any controller, agent, service, object |
| `pod` `pod-label` | a container frame | a node, a process, a namespace, anything with an inside |
| `vm` `vm-title` `vm-sub` | the workload inside the frame | a container, a job, a request handler |
| `guest` `badge` `badge-text` `ic-run` `ic-ice` `ic-pause` `ic-off` | the thing whose state matters, with its state badge; `guest=off` is a stopped workload, drawn dashed, and the pod around it can be ghosted with `data-ghost="guest=off"` | a pod's phase, a job's status, a connection |
| `app` `doc` `doc-lines` `app-sub` | the application producing the data | a client, a writer, a producer |
| `agent` `agent-box` `agent-text` | a helper lit when used | a sidecar, a plugin, a hook |
| `disk` `disk-label` `disk-uses` `disk-verb` | a strip that reads "vda uses `<file>`" | any binding: "web-0 claims data", "route uses backend-b" |
| `band` `band-label` | a horizontal zone | storage, network, a cloud API, a database tier |
| `chip` `chip-text` `chip-tag` | a file or volume inside a card | a row, a key, a message, a device |
| `obj-card` `obj-chip` `obj-chip-text` `obj-chip-sub` `check` `pulse` | an object of an external system (a VolumeSnapshot): purple; `pulse` while in progress, `check` when ready | a cloud volume, a job in another system, an external request |
| `extra-card` `extra-chip` `extra-chip-text` `empty-chip` `empty-text` | the object the new mechanism adds: accent | the fix's new object, a cache, a staging area |
| `io-g` + `data` / `ext` / `accent` / `bug` / `relation`, with `io-track` and `io-dots` | an arrow along which something moves, with moving dots; `relation` is a dashed line without a head (a backing file) | writes, copies, replication, a stream, a reference |
| `io-label` `w-label` (`.wait`) | labels on arrows, with a halo | |
| `plug-line` (`.marching` while it is being set up) | a mount or attachment that exists without moving data: a thick headless line between the volume and the pod | a hot-plugged PVC, a bind mount, a socket shared through a volume |
| `title-sm`, `.sm` on `mono-line`, `chip-text`, `v` | smaller text for a narrow card | |
| `ctrl-path` `ctrl-label` | a control arrow (who asks whom); the label is the step's verb | any call across components |
| `switch-g` `switch-line` `switch-head` `switch-dot` `switch-pill` `switch-text` | a named transition, drawn in during its step only; the line runs from the box that acts to the box it changes, and the pill's box is sized from its text at render time (`fitPills`), so keep the rect right before its text | pivot, failover, cutover, rebind, promote |
| `bug-mark` `bug-label` | the point where it goes wrong | |

Arrowheads: `#m-data`, `#m-held`, `#m-ext`, `#m-accent`, `#m-bug`, `#m-ctrl`,
`#m-ctrl-on`.

To draw a new kind of thing, start from the closest role above and keep its classes,
so the tones and the flags keep working. When another page in the pool already draws
the same components, reuse that drawing so the series looks like one family.

## 5. Tones and the style

| Tone | Default color | Meaning |
|---|---|---|
| `ok` | green | running, healthy, succeeded |
| `ice` | blue | frozen, blocked |
| `held` | gray | waiting, paused |
| `data` | red | the data path, the bytes |
| `ext` | purple | storage and other external systems |
| `accent` | teal | the new mechanism, the fix |
| `bug` | orange | what goes wrong |

One vocabulary colors facts (`data-tone`), timeline lanes, chart segments and legend
swatches (as classes), the flow chip (`tone` on the flow) and step tags. Each tone sets
a wash (`--tw`), a stroke (`--tc`) and a text color (`--tt`), the way a status chip
pairs a light fill with dark text. Add `hatch` for a transition or a job in progress,
and `outline` for something that exists without doing work (a PVC attached for the
whole flow). Keep each meaning the same across the pool, so a color reads the same on
every page.

The colors, fonts and corner radius come from the `:root` token block, which is the
style. The default is plain, `styles/plain.md`: system fonts, slate emphasis, soft
corners. `styles/redhat.md` is Red Hat's expressive slide template without the
logo. `styles/README.md` says how to apply another style or learn one
from a file the user brings. Under every style: pages open light and carry a dark set behind the Dark switch
(key D, `:root[data-dark]`, off by default, kept per browser), the emphasis
color never means "bad", and the tones keep their meanings.

## 6. Side-by-side view

Static HTML. Each `.cs` segment is placed with `left` and `width` in percent of the
time axis. `cmp-track thin` holds secondary lanes (a storage job, an extra object).
A `callout` labels a segment too small for its text. The axis says "schematic, not
to scale" unless the widths are measured. "How to ask for it" sits above the takeaway.
Keep the chart, the legend, the takeaway and the table in line with the steps. For a
bug, the table rows are: trigger, what goes wrong, what the user sees, the fix, fixed
in, workaround. For a flow with no comparison, the view becomes the phases and what a
user sees in each, the limits, and how to ask for it.

## 7. Presenting and deep links

- Keys: → / Page Down / Space for next, ← / Page Up for back (presenter clickers send
  Page Up and Page Down), F for full screen, D for dark mode, 1 to n to switch view. In detailed mode
  Y opens or closes the YAML drawer, M switches it between changes and everything,
  Shift ↑ ↓ resize it, Esc closes it.
- The hash is `#<flow>/<step>` (1-based), `#compare` or `#surface`. The page keeps
  it current, so a copied link opens on the same step.
- Next on a flow's last step goes on to the next view; Next on Side by side goes on
  to the surface.

## 8. Text in SVG

SVG text doesn't wrap. Count about 7.2 px per character for 12px mono, 6.6 px for
12.5px sans, and 8.5 px for 14px mono chip text, and keep box text short: long
explanations belong in the narration, not on the scene. Labels on or next to arrows
get a halo (`paint-order: stroke` in the background color), as `io-label` and
`w-label` do.

## 9. Checking the page, and traps

- `scripts/shoot.sh <page.html> <flow/step> [out.png]` renders the page as the
  Artifact host serves it: it wraps the fragment in a document skeleton, opens the
  hash and saves a PNG. Add `SIZE=390,1800` for phone width and `DARK=1` for dark
  mode. Look at each PNG with
  Read.
- `scripts/standalone.sh <page.html> <out.html>` makes the file that opens from disk.
  The page itself stays a fragment (what the Artifact tool publishes); the template's
  own `[hidden]` rule keeps the views from stacking when the fragment is opened
  directly.
- Markers and the grid pattern live in a separate hidden `<svg>`, so selectors scoped
  to `.scene` don't reach them and they render black. Keep `.mk-*` and `.grid-line`
  unscoped.
- SVG paints in document order. An arrow that ends in the storage band must come
  after the band and its cards, or the band hides its end and arrowhead.
- `switch-line` draws in with `stroke-dasharray: 400`. A path longer than 400 px
  needs a larger value.
- A line that starts at a dot in empty space, or ends in empty space, is wrong: every
  arrow and every transition starts on one box and ends on another.
- Pill text is measured with `getBBox()`, so the walk view must be visible when it
  renders; `render()` and `document.fonts.ready` both call `fitPills()`. Keep pill
  labels short anyway: a wide pill hides what it crosses.
- Text that overflows the narration on a busy step: trim the body, not the facts.
- After changing an element, check a step where it is visible, not only step 1.
- `grep -n TODO` must come back empty before publishing.

## 10. Detailed mode: `API`, `SURFACE` and `YAML`

`detailed.md` says what to collect and how to write all three. The formats:

- `API = { tones: { <object>: <tone> }, <flow>: [ [line, …], … ] }`, one array per
  step, a line being `[object, name, value, anchor, "dim"]`, or `"read"` for a field
  the step only checks. The narration's `#ph-api` block renders them; it stays hidden
  while `API` is `null`. The open state is kept across steps; dim and read lines are
  not counted as changes.
- `SURFACE = { label, title, lede, foot, cards: [ { title, kind, wide, entries } ],
  back: [ ["flow/step", "label"] ] }`, an entry being `{ id, name, text, go }`,
  `{ label, chain: [[text, tone]], failures: [[text, tone]] }` or `{ sub }`. A subject
  with two parts (a feature, then what its crash recovery adds) uses
  `groups: [ { id, title, short, lede, cards } ]` instead of `cards`; each group gets
  a heading and buttons to the other groups, labelled with their `short`. The view is
  built once at load; `showOnSurface(anchor)` opens it, scrolls to the entry and
  flashes it.
- `YAML = { <flow>: [ { kind, name, note, api, card, gone, goneBy, full, steps: { <n>: delta | [delta, …] } } ] }`,
  a delta being `{ by, set: { path: value }, del: [path], read: { path: why }, rest }`,
  steps 1-based, `gone` the step the object is deleted at, `card` the surface entry
  its header button jumps to. Paths are dotted, with `[key]` for a map key that
  contains dots or for one item of a list named in `LISTS`. The drawer derives each
  step's state from the deltas, so a field is written once and the diff against the
  previous step is computed: added, changed (old value struck through before the new),
  removed, read. Step 1 is the baseline and shows no marks. Everything prints each
  object whole: the header from the entry, then the `rest: true` deltas that Changes
  hides, or the entry's `full` text. `renderDrawer()` runs with every
  `render()`; the drawer is hidden on the static views.
- `STATIC` lists the views that are not flows (`compare`, `surface`); `VIEWS` is the
  tab order.
