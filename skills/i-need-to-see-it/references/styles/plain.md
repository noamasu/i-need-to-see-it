# Plain

The default style: system fonts, no web font requests, slate for emphasis, soft
corners. The template ships in it.

## Source

None. Written as the neutral default.

## What it looks like

- White paper, near-black ink, slate (`#334155`) where the Red Hat style uses red:
  the section rule, the eyebrow, the selected tab, Next, the takeaway.
- Titles in the system sans at regular weight; body in the same face; code in the
  system mono.
- Corners rounded at 6 px; thin light lines; dotted dividers kept.
- The data path is a warm red, so "where the bytes go" still reads at a glance.
- Tips in a teal wash; the current step and named transitions in a deep slate.

## Fonts

No `<link>` lines; the template has none.

## Tokens

```css
:root {
  --paper: #FFFFFF; --sheet: #F8FAFC; --card: #FFFFFF; --pod: #F1F5F9; --band: #F1F5F9;
  --ink: #0F172A; --ink-2: #475569; --muted: #64748B; --line: #E2E8F0; --line-2: #94A3B8; --grid: #EDF2F7;
  --brand: #334155; --brand-ink: #334155; --on-brand: #FFFFFF;
  --strong: #0F172A; --on-strong: #FFFFFF;
  --link: #0B57D0; --tip: #2A6F6F; --tip-wash: #E3F2F2;
  --accent: #2A6F6F; --accent-ink: #134E4E; --accent-wash: #E3F2F2;
  --data: #D23A2E; --data-ink: #9A2A21; --data-wash: #FBE4E2;
  --ice: #0066CC; --ice-ink: #003366; --ice-wash: #E0F0FF;
  --ext: #5E40BE; --ext-ink: #3D2785; --ext-wash: #ECE6FF;
  --held: #707070; --held-ink: #383838; --pause-wash: #F2F2F2;
  --ok: #3D7317; --ok-ink: #204D00; --ok-wash: #E9F7DF;
  --bug: #B1380B; --bug-ink: #731F00; --bug-wash: #FFE3D9;
  --font-display: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  --font-body: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  --font-mono: ui-monospace, "SFMono-Regular", Menlo, Consolas, "Liberation Mono", monospace;
  --radius: 6px;
  color-scheme: light;
}
```

The scene's cards are already `rx="6"` in the template.

### Dark set

Slate surfaces, light slate for emphasis, the current step as a light block. The tones keep their hues as dark washes with light text. It goes right under the `:root` block.

```css
:root[data-dark] {
  --paper: #0B1220; --sheet: #0F172A; --card: #162033; --pod: #1E293B; --band: #131C2E;
  --ink: #F1F5F9; --ink-2: #CBD5E1; --muted: #94A3B8; --line: #2A3648; --line-2: #64748B; --grid: #172236;
  --brand: #CBD5E1; --brand-ink: #CBD5E1; --on-brand: #0F172A;
  --strong: #E2E8F0; --on-strong: #0F172A;
  --link: #8AB4F8; --tip: #7FD1D1; --tip-wash: #12302F;
  --accent: #4FB3B3; --accent-ink: #A8E3E3; --accent-wash: #12302F;
  --data: #F0655A; --data-ink: #FFB3AB; --data-wash: #3A1714;
  --ice: #4C9AFF; --ice-ink: #B9DCFF; --ice-wash: #0E2A4A;
  --ext: #9F87F5; --ext-ink: #D5C9FF; --ext-wash: #261B4D;
  --held: #9AA0A6; --held-ink: #D4D4D4; --pause-wash: #26282C;
  --ok: #7CC04A; --ok-ink: #C6EBA5; --ok-wash: #1B3310;
  --bug: #F08A5D; --bug-ink: #FFC7AD; --bug-wash: #3F1B0C;
  color-scheme: dark;
}
```

## What the colors mean

The seven tones keep the default meanings. Slate is emphasis only; something wrong is
`bug` (orange).

## Checks done

| Pair | Ratio |
|---|---|
| `--ink` #0F172A on paper | 17.9:1 |
| `--ink-2` #475569 on paper | 7.6:1 |
| `--muted` #64748B on paper | 4.8:1 |
| `--brand-ink` #334155 on paper | 10.4:1 |
| `--tip` #2A6F6F on `--tip-wash` | 5.1:1 |
| `--data-ink` #9A2A21 on `--data-wash` | 6.3:1 |
| `--accent-ink` #134E4E on `--accent-wash` | 8.2:1 |
| `--on-strong` on `--strong` | 17.9:1 |
| the other tones | as in redhat.md |

Dark set:

| Pair | Ratio |
|---|---|
| `--ink` on paper | 17.1:1 |
| `--ink-2` on card | 11.0:1 |
| `--muted` on card | 6.4:1 |
| `--brand-ink` on paper | 12.6:1 |
| `--on-brand` on `--brand` | 12.0:1 |
| `--on-strong` on `--strong` | 14.5:1 |
| `--tip` on `--tip-wash` | 8.0:1 |
| each tone's text on its wash | 9.4:1 to 10.4:1 |
