# Red Hat expressive

## Source

Red Hat's official expressive presentation template, the Google Slides deck exported
to PDF (72 slides, "Last updated: April 10, 2026"), read on 2026-11-07. The look is
taken, nothing else: no logo, no hat, no photos, no 3D artwork, no confidential
designator. The file stays with its owner and is not part of this skill.

## What it looks like

- White slides. A thin red vertical rule drops from the top edge at the left, with a
  small red "section marker" line of text beside it; the same rule stands at the
  bottom left before "Source:". The page's eyebrow and footer reproduce this.
- Titles in Red Hat Display at regular weight, black, one line. Subheadings in red.
  Body text in Red Hat Text. Code and labels in Red Hat Mono.
- Red is the brand: a statement set as a large red paragraph, a big red number with a
  headline under it, red dots and year labels on a timeline. Red never means
  "negative" (the template's own color table says so).
- Columns are separated by thin dotted vertical rules, not boxes.
- "Quick tip" boxes: a teal block (`#147878`) with white text and a light-bulb icon.
  Section divider slides are light teal with teal text. The page's notes use the
  light teal wash with teal heading.
- Deep purple (`#1B0D33`) for strong blocks: a sidebar, a timeline bar. The page uses
  it for the current step and for named transitions.
- Light red (pink) washes for statement blocks; the page uses the wash for the data
  tone.
- Tables: a heavy black rule under the header row, light striped rows (`#FAFAFA`),
  thin light vertical cell dividers, no outer border.
- Charts: brand red, light red, grays and black; text sizes and labels carry the
  meaning, never color alone.
- Square corners everywhere, thin lines, flat surfaces, no shadows.

## Fonts

Red Hat Display (titles, regular 400; 500 for small headings), Red Hat Text (body),
Red Hat Mono (code, labels, kickers). All three are on Google Fonts:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Red+Hat+Display:wght@400;500;700&family=Red+Hat+Mono:wght@400;500;600;700&family=Red+Hat+Text:wght@400;500;700&display=swap">
```

Fallbacks: Helvetica Neue, Arial; ui-monospace, Menlo, Consolas. Add the three
`<link>` lines right after the viewport meta at the top of the page.

Square corners: the template ships with soft corners, so also run
`sed -i 's/ rx="6"/ rx="2"/g'` on the page.

## Tokens

```css
:root {
  --paper: #FFFFFF; --sheet: #FAFAFA; --card: #FFFFFF; --pod: #F2F2F2; --band: #F2F2F2;
  --ink: #151515; --ink-2: #4D4D4D; --muted: #707070; --line: #E0E0E0; --line-2: #A3A3A3; --grid: #EDEDED;
  --brand: #EE0000; --brand-ink: #EE0000; --on-brand: #FFFFFF;
  --strong: #1B0D33; --on-strong: #FFFFFF;
  --link: #0066CC; --tip: #147878; --tip-wash: #DAF2F2;
  --accent: #147878; --accent-ink: #004D4D; --accent-wash: #DAF2F2;
  --data: #EE0000; --data-ink: #A60000; --data-wash: #FCE3E3;
  --ice: #0066CC; --ice-ink: #003366; --ice-wash: #E0F0FF;
  --ext: #5E40BE; --ext-ink: #3D2785; --ext-wash: #ECE6FF;
  --held: #707070; --held-ink: #383838; --pause-wash: #F2F2F2;
  --ok: #3D7317; --ok-ink: #204D00; --ok-wash: #E9F7DF;
  --bug: #B1380B; --bug-ink: #731F00; --bug-wash: #FFE3D9;
  --font-display: "Red Hat Display", "Helvetica Neue", Arial, sans-serif;
  --font-body: "Red Hat Text", "Helvetica Neue", Arial, sans-serif;
  --font-mono: "Red Hat Mono", ui-monospace, "SFMono-Regular", Menlo, Consolas, monospace;
  --radius: 3px;
  color-scheme: light;
}
```

### Dark set

Red Hat's dark surfaces (`#151515`, `#1F1F1F`, `#292929`), white text, the brand red kept for rules and the Next button and lightened to `#F56E6E` where it is text, strong blocks in light purple with deep purple text. Derived from the brand's palette, not from the slide template, which has no dark slides: check it against the brand's own dark-theme guidance before using it outside the team. It goes right under the `:root` block.

```css
:root[data-dark] {
  --paper: #151515; --sheet: #1A1A1A; --card: #1F1F1F; --pod: #292929; --band: #232323;
  --ink: #FFFFFF; --ink-2: #C7C7C7; --muted: #A3A3A3; --line: #383838; --line-2: #707070; --grid: #242424;
  --brand: #EE0000; --brand-ink: #F56E6E; --on-brand: #FFFFFF;
  --strong: #B6A6E9; --on-strong: #1B0D33;
  --link: #92C5F9; --tip: #9AD8D8; --tip-wash: #0D3B3B;
  --accent: #63BDBD; --accent-ink: #B9E5E5; --accent-wash: #0D3B3B;
  --data: #F56E6E; --data-ink: #FBBEBE; --data-wash: #4A0A0A;
  --ice: #4394E5; --ice-ink: #B9DAFC; --ice-wash: #032142;
  --ext: #876FD4; --ext-ink: #D0C5F4; --ext-wash: #21134D;
  --held: #A3A3A3; --held-ink: #E0E0E0; --pause-wash: #292929;
  --ok: #87BB62; --ok-ink: #D1F1BB; --ok-wash: #183301;
  --bug: #F4784A; --bug-ink: #FBBEA8; --bug-wash: #4D1F00;
  color-scheme: dark;
}
```

## What the colors mean

The template's color table for data, tables and graphs, and how the page maps it:

| Template | Color | Template's use | Page tone |
|---|---|---|---|
| Red Hat | red | brand; never for negative things | `--brand`, and `data` (the data path, the guest's writes) |
| Danger | orange | negative, a decrease | `bug` |
| Success | green | positive | `ok` |
| Link/interaction | blue | links, buttons | `--link`; `ice` (frozen, blocked) uses the same blue family |
| Info/note tip | purple | helpful information | `ext` (storage and other external systems); the deep purple is `--strong` |
| Neutral | gray | no severity | `held` (waiting, paused) |
| Quick tip box | teal | tips | `--tip` (notes) and `accent` (the new mechanism, the fix) |

## Checks done

Contrast on white and on each wash, computed with the WCAG formula:

| Pair | Ratio |
|---|---|
| `--ink` #151515 on paper | 18.3:1 |
| `--ink-2` #4D4D4D on paper | 8.5:1 |
| `--muted` #707070 on paper | 5.0:1 |
| `--brand-ink` #EE0000 on paper | 4.5:1 (used at 13 px medium and larger) |
| `--tip` #147878 on `--tip-wash` | 4.5:1 (the note heading, 13 px bold) |
| `--ok-ink` on `--ok-wash` | 8.9:1 |
| `--ice-ink` on `--ice-wash` | 10.9:1 |
| `--ext-ink` on `--ext-wash` | 9.5:1 |
| `--accent-ink` on `--accent-wash` | 8.3:1 |
| `--data-ink` on `--data-wash` | 6.6:1 |
| `--bug-ink` on `--bug-wash` | 9.0:1 |
| `--held-ink` on `--pause-wash` | 10.5:1 |
| `--on-strong` on `--strong` | 18.2:1 |

Dark set:

| Pair | Ratio |
|---|---|
| `--ink` on paper | 18.3:1 |
| `--ink-2` on card | 9.8:1 |
| `--muted` on card | 6.5:1 |
| `--brand-ink` #F56E6E on paper | 6.4:1 |
| `--on-brand` on `--brand` #EE0000 | 4.5:1 (the Next button, 15 px medium) |
| `--on-strong` on `--strong` | 8.4:1 |
| `--tip` on `--tip-wash` | 7.7:1 |
| each tone's text on its wash | 8.6:1 to 11.2:1 |
