# Casting: from any ask to boxes, flows and steps

The page is always the same three things: components that talk to each other
(boxes and arrows), what happens over time (steps), and the facts around each step.
This file is how to get from any input to those three, truthfully.

1. Read the ask
2. Find the code and pin a ref
3. Walk one concrete example through the code
4. Cast the boxes
5. Script the steps
6. Idioms: what the code does, how to draw it
7. Casts for common worlds, and where their code lives
8. Writing for QE

## 1. Read the ask

Whatever follows the skill's name is the ask. Take it in any form:

| Input | What to extract |
|---|---|
| Words ("pvc attachment to a pod", "how does hotplug work") | the subject; the kinds or components named; the world (Kubernetes, KubeVirt, a service); the repo it implies |
| One or more manifests (YAML or JSON of a resource, a CR, a CRD) | the kinds; every field that is set and its value; the relations between the given objects (a pod's `claimName`, a VM's `dataVolumeTemplates`, an owner); the names, which become the example's names |
| A feature: a branch, a PR, a VEP or KEP, a design doc | the old path and the new one; the API field or object that selects the new path; the gate; the commits to read |
| A bug: a ticket link, a description, a pasted log, the chat so far | the symptom as reported; the trigger; the versions named; the fix PR if any; what is a claim and what is confirmed |
| A race or an incident | the actors; the shared resource; the ordering that breaks |
| "This", with a conversation behind it | the subject the conversation established; reuse its verified facts, verify its unverified ones |

For a manifest, the flow is the one these values take. `volumeMode: Block` and
`WaitForFirstConsumer` each change the path; draw only the branch the manifest takes,
and say in a note what another value would do. For fields the manifest leaves out,
find the default in the defaulting code or the CRD, and use it. A CRD, the definition
itself, means "what happens when one of these is created": find its controller.

For a ticket, a claim is not a cause. Confirm the cause in the code, or label it "as
reported". Read Jira and GitHub only; never write to them.

Flags, anywhere in the ask:

| Flag | Effect |
|---|---|
| `--detailed` | the API surface view and the folded "In the API" block under every step (detailed.md) |
| `--style <name or file>` | the look (styles/README.md); the default is `plain` |
| `--repo <path or URL>` | where the code is, when it is not the current repo |
| `--ref <sha, tag or branch>` | the ref to read at, when it is not the branch head or the default branch |
| `--for qe` / `--for dev` | the audience; QE pages name what to observe and assert at each step (section 8) |
| `--learning` / `--presentation` | the mode; modes.md says what each changes and how to ask when neither is given |

## 2. Find the code and pin a ref

The page will be presented as how the system works, so every arrow, state, name and
number must come from the code at one ref.

- **Which repo.** The current repo, when the subject lives in it (`git grep` the kind,
  the function or the message). Otherwise a local clone: look next to the current repo
  and under the user's usual roots, and ask once for a path when nothing turns up.
  Otherwise clone shallow into the scratchpad and say so:
  `git clone --depth 1 --filter=blob:none [-b <tag>] https://github.com/<org>/<repo>`.
  A subject can span repos (Kubernetes plus CSI sidecars plus a driver; KubeVirt plus
  libvirt plus QEMU): pin each one the page follows.
- **Which ref.** New work: the branch head. A version the user named: that tag. Else
  the default branch head. Read at the ref with `git show <ref>:<path>` and
  `git grep <pattern> <ref> -- <path>`, never the working tree: checkouts move.
- **Which releases.** `scripts/versions.sh` answers it: `contains <sha>` lists the
  releases that have a commit; `since <ref> <path> [<text>]` finds the release that
  introduced a file or a string; `latest` lists the newest final tags. Put the answer
  in the footer ("in releases v1.4 and later", "fixed in v1.6.2", "not released yet,
  branch `feature/x`") and, for a bug, in the side-by-side table.

## 3. Walk one concrete example through the code

Pick one example with real names: one pod `web-0`, one PVC `data`, one disk
`rootdisk`. Walk it from the trigger to the end state and write an event list, one
line per moment: who acts, the call it makes, what changes (in the cluster, on the
node, in the storage), what a user could observe, and every number with its file:line.

Where to look:

- **The trigger.** Who creates or changes the object: a user, a controller, an
  operator. The first step's state is the world just before it.
- **Admission and defaulting.** Webhooks, CEL rules (`+kubebuilder:validation:XValidation`,
  `x-kubernetes-validations`), defaulting functions. They become the first step's note
  and, in detailed mode, the "what is refused" card.
- **Watchers.** Who reacts to the object: `Informer`, `AddEventHandler`, `Watches(`,
  `For(&`, `Owns(`, `enqueue`. Then their reconcile: `Reconcile(`, `sync`, `execute`,
  `updateStatus`. In it: what is read, what is created (`Create(`), patched (`Patch(`,
  `UpdateStatus`), which conditions are set, which events are recorded
  (`Recorder.Event`), and the requeues (`RequeueAfter`, `AddAfter`).
- **Node agents.** kubelet, virt-handler, a CSI node plugin: what they do once the
  object lands on their node, and the local effects (a mount, a device, a file, a
  process).
- **Calls across processes.** gRPC, REST, CRI, CSI, libvirt, QMP: name the call. It
  becomes the arrow's label and the component's status line.
- **Data.** Where the bytes are at every moment: a file, a device, a PVC, a bucket,
  memory. The data arrow must point there at that step.
- **Waits.** What each actor waits for (a condition, a status field, a file, a job),
  and the timeouts and limits, each with its file:line.
- **Failure branches.** Errors returned, conditions set to False, Warning events,
  retries and backoff. They become notes, or a `bug` step when the ask is a bug.

Reason from what one reconcile pass can observe: it sees the objects as they are at
that moment, and absence is never proof. A retry loop is one step with the backoff in
the note, never one step per attempt.

When the code surprises you or looks wrong, say so to the user instead of smoothing
it over, and draw today's behavior. The snapshot page found a real gap this way.

## 4. Cast the boxes

The boxes are the components that talk to each other. From the event list:

- A box earns its place by doing something distinct in at least one step: it acts, it
  holds state the audience watches, or it holds data. Merge boxes that always act
  together. Drop a box that only forwards, unless its boundary matters (an admission
  webhook that can reject stays; one that only defaults folds into the API server).
- About 5 to 9 boxes. Fewer than 5 means moments were hidden; more than 9 means two
  pages.
- Name boxes as the code and the docs do: `kube-apiserver`, `virt-controller`,
  `external-provisioner`, not "the controller".
- Each box carries: a kicker saying where it runs (CONTROL PLANE, NODE, VIRT-LAUNCHER
  POD, PVC, STORAGE · CSI DRIVER), its name, two to four lines saying what it is doing
  at this step, and a key status (phase, condition) as `k`/`v`.
- The object the ask is about (the PVC, the VM, the snapshot) is a box too, drawn
  where it lives, with its phase as the status.

Geography, kept across the pool so a new page reads at a glance:

- the control plane on the left;
- the node on the right, with the workload inside its pod frame and node agents
  beside it;
- storage, devices and external systems along the bottom band;
- the user or client enters at the top left;
- for a service outside Kubernetes: client left, service in the middle, queue and
  workers right, data stores along the bottom.

## 5. Script the steps

Each flow has 4 to 12 steps. Past 12, split the subject into two flows or two pages.
Rules, each from a correction the first pages earned:

- **Data arrows follow the real path at every step.** The first snapshot diagram
  didn't point the VM's writes at the scratch PVC when the writes went there, and
  that alone made it wrong.
- **One step, one action with one visible consequence.** "Create the overlays" hid
  three moments the audience cared about: freeze, switch and thaw. Split a step like
  that; merge two steps that look the same on the scene.
- **Separate a transition from the state it leads to** when its length matters.
  Freezing is not frozen: the guest flushes dirty pages first, which can take a minute.
- **Name key transitions on the picture** with a labeled arrow or pill drawn only in
  that step, in the words the code and docs use ("EXTERNAL SNAPSHOT", "PIVOT",
  "NodePublishVolume").
- **An arrow means something moves.** For a relation, use words: "vda uses
  ovl-rootdisk.qcow2", "web-0 claims data".
- **An arrow connects two boxes.** It starts on the one that acts or sends and ends
  on the one that receives or changes, a named transition included. A line that
  floats between arrows, or ends in empty space, says "connected to nothing"; route it
  through a corridor between the cards instead.
- **No shorthand.** "snapshot in progress", not "being cut"; "disk.img, as it was at
  the freeze", not "disk.img @ freeze".
- **The API's own names** (utility volume, readyToUse, VolumeAttachment), so people
  can find them in the code and in kubectl output.
- **Ghost what doesn't exist yet** (a dashed, faded card) instead of hiding it. The
  layout doesn't jump, and people see what's coming. Ghost again what was deleted.
- **One concrete example with real names**, and a note for how it scales ("with
  several disks, every disk switches in this same call").
- **Weights by rough duration**: a long wait is a wide step on the timeline; a
  single call is narrow.
- **Say how long, where it matters.** A step gets `time: [text, tone, short]` when
  its duration changes what the audience should expect: a wait on a person or a pod
  (`held`), the time the guest is frozen or paused (`ice`), a copy that scales with
  the data (`ext`), a timeout, cap or poll interval from the code (`accent`). Give
  the range and what bounds it ("the whole disk at storage speed, guest running",
  "qemu-img, 30 s cap per call"), with the file:line in the note. Steps where time
  says nothing get no `time`, so the blank reads as "instant or irrelevant".
- **Tag the bug and the fix**: `tag: "bug"` on the step where reality leaves the
  intended path, drawn on the scene (the wrong arrow, the stuck state, the bug mark);
  `tag: "fix"` on the step the fix changes.

## 6. Idioms: what the code does, how to draw it

The pivot is the archetype. In the snapshot page, the guest's writes went to a base
image, then to an overlay on another PVC, then back. The page showed that by moving
the red data arrow to the real destination at each step and drawing a named "PIVOT"
transition on the one step where the destination switched. Generalize:

| The code does | Draw |
|---|---|
| moves data from A to B | a data arrow with moving dots from the real source to the real destination, at every step where it moves |
| switches where something goes (pivot, failover, redirect, cutover, rebind) | a named transition drawn in during that step only, the old path dimmed, the new path lit, the "uses" text updated |
| creates an object or a file | ghost before, solid after, with the creation call on the control arrow |
| deletes it | solid before, ghost after, kicker "DELETED", the step's verb on the control arrow |
| asks another component | a lit control arrow with the verb, and the call in the caller's status lines |
| waits for something | the `held` tone on the waiter, a "wait" label where the arrow stops, the waited-for object pulsing |
| runs a long job in another system (a CSI snapshot, an image pull, a copy) | an external object card that pulses while in progress and shows a check when done; a wide, hatched step |
| moves through a state machine | the badge on the box, a facts row, and in detailed mode the chain of phases on the surface view |
| pauses or blocks the workload | the `ice` tone on the workload, writes shown as waiting |
| validates and rejects | the bug mark on the element that failed the check, the message in the note |
| goes wrong (the bug) | the `bug` tag, the wrong arrow or the stuck state drawn, the symptom named in the body |
| gets fixed | the `fix` tag, the `accent` tone on what the fix adds |
| retries with backoff | one step; the interval and the cap in the note |
| does the same for N things | one drawn; "with several, …" in the note |
| crosses a process boundary | the protocol or API name on the arrow (gRPC, CSI, CRI, libvirt) |
| races another actor | one flow per ordering; a lane per actor in the side-by-side view |
| has a limit or a timeout | the number in the note with its file:line, and in the side-by-side table |

## 7. Casts for common worlds, and where their code lives

Starting points, to be confirmed in the code at the pinned ref.

**Kubernetes core** (`kubernetes/kubernetes`)

| Box | Where it runs | Code |
|---|---|---|
| kubectl, the user | outside | the manifest |
| kube-apiserver (admission, defaulting, etcd) | control plane | `pkg/apis/<group>`, `plugin/pkg/admission`, `staging/src/k8s.io/api` |
| the controllers in kube-controller-manager | control plane | `pkg/controller/<name>`: `volume/persistentvolume` (PV and PVC binding), `volume/attachdetach`, `deployment`, `replicaset`, `job`, `statefulset`, `endpointslice`, `garbagecollector`, `namespace` |
| kube-scheduler | control plane | `pkg/scheduler`; volume binding in `pkg/scheduler/framework/plugins/volumebinding` |
| kubelet | the node | `pkg/kubelet`: pod workers (`pod_workers.go`), the volume manager (`volumemanager/`), CRI calls (`kuberuntime/`), probes (`prober/`); the CSI volume plugin in `pkg/volume/csi` |
| the container runtime (containerd, CRI-O) | the node | outside the repo; name the CRI call |
| the CNI plugin, kube-proxy | the node | `pkg/proxy`; the plugin's repo |

**CSI** (`kubernetes-csi/*`, the driver's repo)

| Box | Code |
|---|---|
| external-provisioner (CreateVolume, DeleteVolume) | `kubernetes-csi/external-provisioner` |
| external-attacher (VolumeAttachment, ControllerPublishVolume) | `kubernetes-csi/external-attacher` |
| external-snapshotter (VolumeSnapshot, VolumeSnapshotContent, CreateSnapshot) | `kubernetes-csi/external-snapshotter` |
| external-resizer, node-driver-registrar | their repos |
| the driver's controller and node plugins (NodeStageVolume, NodePublishVolume) | the driver's repo |
| the storage backend | outside; draw it in the storage band |

**KubeVirt** (`kubevirt/kubevirt`, `kubevirt/containerized-data-importer`)

| Box | Where it runs | Code |
|---|---|---|
| virt-api (webhooks, subresources) | control plane | `pkg/virt-api` |
| virt-controller (VM, VMI, migration, snapshot, restore, export, pools, hotplug attachment pods) | control plane | `pkg/virt-controller/watch`, `pkg/storage` |
| virt-handler (domain sync, hotplug mounts, migration proxy) | the node | `pkg/virt-handler` |
| virt-launcher, with libvirt and QEMU inside its pod | the node | `pkg/virt-launcher/virtwrap` |
| the guest and its agent | inside the VM | the QEMU guest agent commands named in `virtwrap` |
| CDI: the DataVolume controller and the importer, upload and clone pods | control plane and pods | `containerized-data-importer/pkg/controller`, `pkg/importer` |
| libvirt, QEMU | inside virt-launcher | `libvirt/src/qemu/qemu_driver.c`, `qemu_block.c`; `qemu/block/`, `blockdev.c`, `block/mirror.c`, `block/commit.c`, when the mechanism is theirs |

**A service outside Kubernetes**: the client, a gateway or API, the service, a queue
and its workers, the stores (database, cache, object storage), third-party APIs.
Entry points are the routes and handlers, the consumers, the cron jobs.

**A race**: the actors, the shared resource as a box, the orderings as flows.

## 8. Writing for QE

A tester wants, at each step, what to observe and what to assert:

- name the command that shows it (`kubectl get pvc data -o yaml`, `kubectl describe
  pod web-0`, `virsh domblklist`), and the field or line to look at;
- put the pass criterion in the note: "the PVC is `Bound` and its `volumeName` is the
  PV the provisioner created";
- in detailed mode, the "In the API" lines are the assertions, in order, and the API
  surface view is the checklist of everything that must appear;
- for a bug, the "Today" flow's bug step says what the reproduction looks like, and
  the fixed flow's step says what proves the fix.
