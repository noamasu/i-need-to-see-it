# Modes: learning and presentation

The same page, built from the same facts, read in two situations: alone at a desk,
or projected while someone talks. `--learning` and `--presentation` pick one;
without a flag, ask (SKILL.md section 1). The engine takes `MODE` and `INTRO`.

| | `--learning` | `--presentation` |
|---|---|---|
| Opens on | the Background tab | the first flow, step 1 |
| Background tab | yes | no (`INTRO = null`; delete its section) |
| Step body | 2 to 4 sentences, who does what and why | 1 or 2 sentences, what happens |
| Note | numbers, limits, failure branches, sources | the one number that matters, or none |
| "takes" chip and Takes line | full text in the chip, short form on the line | the same; the line's short form is what the room reads |
| Narration type | as the template | larger (`data-mode="presentation"`) |
| Side by side, API surface, YAML drawer | as the template | as the template; the table is what the presenter points at, the drawer stays closed until asked for |

## The Background tab (learning)

A reading page in the page's own vocabulary, before any step. Six blocks, in this
order, each a panel:

1. **The problem**: what hurt before, with one real number, and why the obvious fix
   doesn't work.
2. **The catch, and the trick**: the constraint, the mechanism that gets around it,
   and its price ("one restart", "512Mi per VM").
3. **The one idea to hold on to**: the sentence the audience should repeat, set as
   the takeaway, followed by a chain of pills showing it over three instances, then
   one paragraph saying the rest is plumbing around it and naming what the flows show.
4. **The pieces**: four to six, as a definition list: what each is, where it lives,
   how you see it.
5. **Words you will meet**: a two-column table, term and one-line meaning, in the
   order the flows use them.
6. **How to read the rest**: how the stepping works, then one line per tab saying
   what to watch in it.

Then two buttons: "Start the walkthrough" to the first flow, and a jump to Side by
side. Write it for someone who knows the platform but not this subject, in plain
sentences, no shorthand. It is read, not projected: 600 to 900 words.

## Trimming for presentation

Keep every step; cut inside each one. The title stays. The body keeps the action
and its visible consequence. The note keeps a number only if the presenter would
say it. Code links stay. Facts and lanes stay as they are. Nothing on the scene
changes: the drawing is the presentation.
