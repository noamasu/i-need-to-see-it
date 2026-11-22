# Detailed mode (`--detailed`)

A detailed page adds three things to a plain one, built from the same facts:

1. **An "API surface" view**, the last tab: everything the subject adds to or touches
   in the API, object by object, with a "step N →" button on each entry that jumps to
   the step where it first appears.
2. **"In the API", folded under every step**: a one-line row in the narration that
   opens into the list of what changes in the API at that step, each line linking to
   its entry on the surface view. Closed, it costs one line, so the walkthrough looks
   as before; opened once, it stays open while stepping.
3. **The YAML drawer**, a panel at the bottom of the window opened with Y: the
   objects at the current step as `kubectl get -o yaml` would show them, cut down to
   the fields that matter, with the step's changes marked (added, changed with the
   old value struck through, removed, read) and who made each change. It tracks the
   step while presenting, and resizes by dragging its top edge.

Use it when the ask says so (`--detailed`, "detailed", "with all the fields", "what
can I observe"), when the audience is QE or API reviewers, or when the subject is a
new API. `references/snapshot-flows-detailed.html` is the worked example.

## 1. Collect the surface

For every object kind the flow touches, at the pinned ref, copying names exactly:

| What | Where to find it |
|---|---|
| spec fields that select or shape the path, with defaults and validation | `types.go` of the API group; CEL markers (`+kubebuilder:validation:XValidation`, `x-kubernetes-validations`); webhook admitters |
| status fields written during the flow | `types.go`; the `UpdateStatus` and `Patch` calls in the controller |
| conditions: type, status, reason, message | the condition type and reason constants; the code that sets them |
| phases and printable statuses | the phase constants; `setPrintableStatus` or its equivalent |
| annotations, labels, finalizers, owner references | the constants file of the feature; `Finalizers:` and `OwnerReferences:` in the create calls |
| events: reason, type, which object they land on | `Recorder.Event`, `Eventf`; the reason constants |
| what is refused while the flow runs | admitters and webhooks; subresource handlers; their messages |
| feature gates | the gate registry |
| constants: timeouts, sizes, thresholds, retry intervals | `const (` blocks near the controller; each with its file:line |
| internal state a developer can inspect | domain XML metadata, files on disk, sockets, local caches |
| metrics and log lines worth grepping | `prometheus.New…`, the log messages at the decisive points |

Outside Kubernetes the surface is the equivalent: routes and status codes, request
and response fields, rows and columns, files, configuration keys, metrics, log lines.

Drop what the flow never touches. A field listed on the surface must appear in some
step's lines, and every line must point at an entry.

## 2. Build the `SURFACE` view

```js
const SURFACE = {
  label: "API surface",                       // the tab
  title: "Everything the feature adds, object by object",
  lede: "What you can see with `kubectl get -o yaml` and `kubectl get events` while it runs. The step buttons jump to where each one appears.",
  foot: "Names and messages follow <repo> at `<sha>`: <the files>.",
  cards: [
    { title: "VirtualMachineInstance", kind: "kubevirt.io/v1", entries: [
      { id: "api-vmi-cond", name: "condition `OverlaySnapshotActive`", text: "Projected by virt-handler from the launcher's metadata. Absent means no transaction since this VMI started.", go: "external/4" },
      { label: "reasons", chain: [["OverlayPreparing", "accent"], ["OverlaysReady", "accent"], ["OverlayCommitting", "accent"], ["OverlayCommitted", "ok"]], failures: [["OverlayCommitFailed", "bug"], ["OverlaySnapshotFailed", "ok"]] },
      { sub: "VirtualMachineSnapshotContent" },
      { id: "api-content-creationtime", name: "`status.creationTime`", text: "Written once every VolumeSnapshot is ready.", go: "external/8" }
    ] },
    { title: "What is refused while overlays are active", kind: "admission and subresources", wide: true, entries: [
      { id: "api-guard-hotplug", name: "disk and volume changes", text: "\"Cannot change disks or volumes while snapshot overlays are prepared or active\" (hotplug admitter)." }
    ] }
  ],
  back: [["compare/1", "← Side by side"], ["external/1", "External flow"]]
};
```

- One card per object kind, in the order they enter the flow: the triggering object
  first, then the others, then a card for events, then a wide card for what is
  refused. A secondary kind that belongs with another (a content under its snapshot)
  goes under a `{ sub }` heading in the same card.
- A subject with two parts gets two groups instead of one list of cards:
  `groups: [{ id: "surface-feature", title: "The snapshot: what External mode adds", short: "The snapshot", lede, cards }, { id: "surface-recovery", title: "Crash recovery: what it adds, and what it reads", short: "Crash recovery", lede, cards }]`.
  The second group holds what the second part adds and, in read-only cards, what it
  checks before acting (the content's UIDs, the volumes, the backups). Each group gets
  a heading with buttons to the others; an entry's `go` and a step line's anchor work
  the same in both.
- An entry's `id` is `api-<object>-<field>`; it is what the step lines link to. Its
  `name` is the field, condition, annotation or event, with code in backticks. Its
  `text` is one or two sentences: what it means and when it is set. Its `go` is the
  first step where it appears.
- A state machine's reasons or phases go in a `chain`: `accent` for in-progress
  states, `ok` for the terminal success, `bug` for failures, `held` for waiting.
- `kind` under the title is the API group and version, the command that shows it, or
  the name pattern (`snap-scratch-<content UID>`).

## 3. Write the `API` lines per step

```js
const API = {
  tones: { event: "data", launcher: "accent" },   // an object's tag color; others stay neutral
  external: [
    [["VMI", "condition AgentConnected", "True, required by External mode"]],                               // step 1
    [["VMSnapshot", "status.phase", "InProgress"],
     ["PVC", "snap-scratch-<uid>", "created, with the overlay-protection finalizer", "api-pvc-finalizer"],
     ["event", "SuccessfulOverlayScratchVolumeCreate", "on the VMSnapshot", "api-ev-create"]],              // step 2
    [["launcher", "<snapshotOverlay> phase", "OverlayPreparing", "api-launcher-meta"],
     ["VMI", "condition OverlaySnapshotActive", "True · OverlayPreparing", "api-vmi-cond"],
     ["event", "OverlayCommitFailed", "if the commit fails, then it is retried", "api-ev-commitfailed", "dim"]],
    []                                                                                                    // a step where nothing changes
  ]
};
```

- One array per step, in step order, one line per change:
  `[object, name, value, anchor, "dim"]`. The object is the short kind name as it
  should print (`VMI`, `VM`, `PVC`, `Pod`, `event`, `launcher`, `kubelet`); the anchor
  is an entry id on the surface, or omitted for existing API the surface doesn't list.
- Only what changes at this step. A field that stays as it was is not repeated. A
  step with nothing new gets `[]` and renders "Nothing changes at this step"; when the
  engine does something that leaves no trace in the API, say so in the body ("libvirt
  reports the job READY, nothing changes in the API").
- The value is the new value, with a reason after a middle dot (`True ·
  OverlayPreparing`), or a verb for a lifecycle change (`created, …`, `removed`,
  `moved to the new VMI`).
- `"dim"` marks a branch taken only on failure ("if the commit fails …"). `"read"`
  marks a field the step only checks ("checked: PVC rootdisk still has this UID").
  Neither is counted as a change.
- The lines, the facts rows and the surface must agree: a reason that appears in a
  line is in the chain, every anchor exists, the first step a surface entry links to
  is the first step whose lines mention it.

## 4. Write the `YAML` drawer

```js
const LISTS = { conditions: "type", utilityVolumes: "name", volumeStatus: "name", ownerReferences: "kind", volumes: "name", finalizers: null, indications: null };
const YAML = {
  external: [
    { kind: "VirtualMachineSnapshot", name: "my-vm-snap", api: "snapshot.kubevirt.io/v1beta1", card: "api-vms-mode", steps: {
      2: [{ by: "you", set: { "spec.source.kind": "VirtualMachine", "spec.source.name": "my-vm", "spec.snapshotMode": "External" } },
          { by: "virt-controller", set: { "status.phase": "InProgress", "status.indications[Online]": "" } }],
      7: { by: "virt-controller", set: { "status.phase": "Succeeded", "status.readyToUse": "true" } }
    } },
    { kind: "VirtualMachineInstance", name: "my-vm", api: "kubevirt.io/v1", card: "api-vmi-cond", steps: {
      1: { by: "virt-handler", set: { "status.phase": "Running", "status.conditions[AgentConnected].status": "\"True\"" } },
      3: [{ by: "virt-controller", set: { "metadata.annotations[snapshot.kubevirt.io/overlay-reference]": "'{\"contentUID\":\"<content uid>\",…}'" } },
          { by: "virt-handler", set: { "status.conditions[OverlaySnapshotActive].status": "\"True\"", "status.conditions[OverlaySnapshotActive].reason": "OverlayPreparing" } }],
      5: { by: "virt-handler", set: { "status.conditions[OverlaySnapshotActive].reason": "OverlaysReady" } },
      10: { by: "virt-controller", del: ["metadata.annotations[snapshot.kubevirt.io/overlay-reference]"] }
    } },
    { kind: "PersistentVolumeClaim", name: "snap-scratch-<uid>", api: "v1 · the scratch volume", card: "api-pvc-finalizer", gone: 10, steps: {
      2: { by: "virt-controller", set: { "metadata.finalizers[snapshot.kubevirt.io/overlay-protection]": "", "metadata.ownerReferences[VirtualMachineSnapshotContent].name": "vmsnapshot-content-<uid>" } }
    } }
  ],
  recovery: [
    { kind: "VirtualMachineInstance", name: "my-vm", note: "the crashed VMI · uid <vmi uid>", api: "kubevirt.io/v1", gone: 3, steps: {
      1: { by: "virt-handler", set: { "status.phase": "Running" } },
      2: { by: "virt-controller", set: { "status.phase": "Failed" }, read: { "status.conditions[OverlaySnapshotActive].reason": "not OverlayCommitted: the overlay still holds writes" } }
    } }
  ]
};
```

- One entry per object the flow touches, in the order they matter: the triggering
  object, the workload, the new objects, the storage. The same name may appear twice
  when an object is replaced (the crashed VMI, the replacement); tell them apart with
  `note`. `api` is the group and version, or a short label; `card` is the surface
  entry the card's "API surface →" button jumps to.
- Write each field once, at the step it changes, as a delta: `by` is who writes it,
  in the words the scene uses (`you`, `virt-controller`, `virt-handler`, `CSI`);
  `set` the fields and their new values; `del` the fields removed; `read` the fields
  the step only checks, with why, in a few words. A step with several writers takes
  an array of deltas. `gone` is the step the object is deleted at: every line is
  shown removed, tagged with `goneBy` (who deletes it), then the object disappears.
- Paths are dotted. `[key]` names a map key that contains dots
  (`metadata.annotations[snapshot.kubevirt.io/overlay-reference]`) or one item of a
  list named in `LISTS`, which prints `- <keyField>: <key>` and the item's fields
  under it; a list with a `null` key field (`finalizers`, `indications`) prints
  `- <key>` and ignores the value. Add a list to `LISTS` when the subject has one the
  default set lacks.
- Only the fields that matter: what the user sets, what the controllers write, what
  the next step reads. Not `apiVersion`, `kind`, `resourceVersion`, timestamps or
  managed fields. Values as the API shows them: quote condition statuses
  (`"\"True\""`), use the example's real names, and `<uid>`, `<time>` placeholders
  for what differs per run.
- The drawer computes the diff against the previous step, so the deltas, the `API`
  lines and the facts must agree: a line in `API` that says a field changed is a
  `set` here, a removal is a `del`, a check is a `read`. Step 1 is the baseline and
  shows no marks.
- At a step whose `API` lines say nothing changes, nothing changes in the drawer
  either; it says so and lists the objects present.

## 5. Check it

- Every anchor exists:

  ```bash
  node -e '
  const s=require("fs").readFileSync(process.argv[1],"utf8");
  const ids=new Set([...s.matchAll(/id: "([^"]+)"/g)].map(m=>m[1]));
  const used=new Set([...s.matchAll(/, "(api-[^"]+)"/g)].map(m=>m[1]));
  console.log("missing:", [...used].filter(a=>!ids.has(a)));' page.html
  ```
- The tabs read: the flows, Side by side, API surface. Next on Side by side goes on
  to the surface; keys 1 to n select the tabs.
- Shoot `#surface` at desktop and phone width, and a busy step with the block open:
  `sed 's/apiOpen = false/apiOpen = true/' page.html > open.html` and shoot that copy.
- Shoot a step with the drawer open, in both modes, and once at phone width:
  `sed 's/yamlOpen = false, yamlMode = "changes"/yamlOpen = true, yamlMode = "changes"/' page.html > drawer.html`
  (and `"all"` for the second). Read every changed line: the old value must be the
  one the previous step set, a removed object must be the one the step deletes, and
  no line may say more than the step's text and `API` lines say.
- With the block open on a busy step, the narration column scrolls; the facts stay at
  its end. That is expected.
