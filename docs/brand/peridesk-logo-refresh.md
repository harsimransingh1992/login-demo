# PeriDesk Logo Refresh

A visually appealing refresh that preserves the recognizable PeriDesk wordmark while adding dental-themed cues. This kit includes multiple variations for digital and print.

## Goals
- Preserve core identity: the name “PeriDesk” and overall simplicity.
- Add complementary dental elements: molar icon, smile underline, shield badge.
- Use clean, professional colors: blues, whites, teals/greens.
- Work across sizes and formats: responsive SVGs, single-color options.
- Maintain brand consistency and legibility.

## Variations
- `peridesk-logo-wordmark-blue.svg` — Primary: molar + wordmark (blue/indigo gradient)
- `peridesk-logo-wordmark-smile.svg` — Wordmark + smile underline (blue→teal gradient)
- `peridesk-logo-monogram-p-tooth.svg` — Compact monogram P with tooth (app icons / favicon)
- `peridesk-logo-badge-shield.svg` — Shield badge with tooth (certificates / signage)
- `peridesk-logo-mono-dark.svg` — Monochrome dark (single-color printing)
- `peridesk-logo-mono-light.svg` — Monochrome light (white on dark backgrounds)

## Color Palette
- Brand Blue: `#1663ff`
- Indigo: `#5a67d8`
- Teal Accent: `#14b8a6`
- Brand Dark: `#0b1e3d`
- White: `#ffffff`
- Light Surface: `#f2f6ff`

## Usage Guidance
- Primary digital use: `peridesk-logo-wordmark-blue.svg`
- Secondary/marketing: `peridesk-logo-wordmark-smile.svg`
- Iconography: `peridesk-logo-monogram-p-tooth.svg` (≥ 32px for clarity)
- Formal/print: `peridesk-logo-badge-shield.svg`
- One-color constraints: use mono variants; ensure sufficient contrast.

### Sizing
- Wordmarks: height 24–48px in UI headers; maintain clear space (≥ the height of the P on all sides).
- Monogram: minimum size 24px; preferred 32–48px.
- Badge: used sparingly; ensure legible tooth shape at ≥ 64px height.

### Backgrounds
- Use blue/indigo gradients on light backgrounds for modern feel.
- For dark backgrounds, switch to `mono-light`.
- Avoid busy images behind the logo; keep contrast ≥ 4.5:1.

### File Formats
- SVGs included for responsive web. If needed for print, export to high-res PNG or PDF from the SVG source.
  - For fonts in SVG text, outline during export if the specific typeface must be preserved.

## Integration Example
```html
<img src="/images/branding/peridesk-logo-wordmark-blue.svg" alt="PeriDesk logo" height="28" />
```

## Next Options
- Replace wordmark text with fully outlined vector typography for locked branding.
- Add an inline SVG in the header with color theme switching via CSS variables.
- Provide localized variants if needed.