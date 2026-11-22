# Styles

A style is the look of a page, kept apart from the engine: fonts, surfaces, the
emphasis color and what it may mean, the strong-block color, the tip color, the seven
tones, corner radius and the divider and table rules. The engine, the scene vocabulary
and the tones' meanings stay the same under every style, so a page reads the same way
whichever style it wears.

| File | Style | When |
|---|---|---|
| `plain.md` | neutral: system fonts, slate emphasis, soft corners | the default; `--style plain` |
| `redhat.md` | Red Hat's expressive slide template, without the logo | `--style redhat` |
| `<name>.md` | a style learned from a file the user brought | `--style <name>` once saved |

`assets/template.html` ships in the plain style. Applying another one means
replacing three things in the page, as the style file prescribes:

1. the `:root { … }` token block at the top of the `<style>`;
2. the `:root[data-dark] { … }` block right under it, the same style's dark set;
3. the font `<link>` lines in the head (none for a style on system fonts).

Everything else follows the tokens. The only non-token item is the scene's `rx`
attributes (6 px, soft corners): a style with square corners sets `--radius` and
lowers `rx` on the scene's `rect`s with `sed`, as redhat.md says.

## Picking a style

- No flag: `plain`.
- `--style <name>`: a saved style file.
- `--style <file or URL>`: a PDF, PPTX, HTML, CSS, SVG or image that shows the desired
  design language. Learn it, save it as `<name>.md`, apply it, and say in the reply
  that the style was saved so the user can reuse it by name.

## Learning a style from a file

Read the whole file with Read (PDF pages come back as images, so look at a cover, a
content slide, a table or chart slide and any palette or typography page). Then write
the style file with these sections, in this order:

1. **Source**: what was read and when. Never copy the file into the skill: a brand
   template is the user's, and a logo or a photo is not a style.
2. **What it looks like**: five to ten observations in plain words: the paper, how
   titles are set, what the emphasis color is used for, how sections are marked, what a
   tip or callout box looks like, how tables and timelines are drawn, which corners.
3. **Fonts**: display, body and mono. Use the file's fonts when they are on Google
   Fonts; otherwise the closest free face, and say so. Always keep a system fallback.
4. **Tokens**: the full `:root` block, copied from the template with the values
   changed. Every token the template defines must be present. Then the
   `:root[data-dark]` block: the same color tokens for a dark page, taken from the
   source's own dark variant when it has one, derived from its palette otherwise
   (dark surfaces, each tone as a dark wash with light text, the brand color kept
   where it still has contrast).
5. **What the colors mean**: which color is emphasis and whether it may mean "bad"
   (Red Hat's red may not), what is used for success, danger, information, neutral.
   Map these onto the seven tones; keep a tone's default when the brand has no color
   for it.
6. **Checks done**: contrast of each tone's text on its wash (4.5:1 for small text,
   3:1 for 14 px bold and larger) and of ink on paper, computed, not guessed, for the
   light set and for the dark set.

Rules that hold for every style:

- Pages open light. Every style also carries a dark set, and every page has the Dark
  switch at the top right (key D), a round on/off switch above Present, that turns it
  on; the viewer's choice is kept per browser. Dark is never the default and never
  follows the system or the host theme, so a page looks the same on every projector
  until someone flips the switch.
- The seven tones keep their meanings (anatomy.md, Tones). A brand's status colors
  replace a tone's color, never its meaning.
- The emphasis color is for emphasis only: the section marker, the selected tab, the
  Next button, the takeaway sentence, the data path. Something wrong is always `bug`.
- Text in the scene stays at or above 12 px, kickers at 10.5 px uppercase mono.
