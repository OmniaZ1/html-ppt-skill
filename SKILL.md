---
name: html-ppt
version: 1.0.0
author: lewis <sudolewis@gmail.com>
license: MIT
platforms: [linux, macos, windows]
description: HTML PPT Studio — author professional static HTML presentations in many styles, layouts, and animations, all driven by templates. Use when the user asks for a presentation, PPT, slides, keynote, deck, slideshow, "幻灯片", "演讲稿", "做一份 PPT", "做一份 slides", a reveal-style HTML deck, a 小红书 图文, or any kind of multi-slide pitch/report/sharing document that should look tasteful and be usable with keyboard navigation. Triggers include keywords like "presentation", "ppt", "slides", "deck", "keynote", "reveal", "slideshow", "幻灯片", "演讲稿", "分享稿", "小红书图文", "talk slides", "pitch deck", "tech sharing", "technical presentation".
---

# html-ppt — HTML PPT Studio

Author professional HTML presentations as static files. One theme file = one
look. One layout file = one page type. One animation class = one entry effect.
All pages share a token-based design system in `assets/base.css`.

## Install

```bash
# Hermes Agent
hermes skills install https://github.com/lewislulu/html-ppt-skill

# Claude Code / Codex
npx skills add https://github.com/lewislulu/html-ppt-skill
```

One command, no build. Pure static HTML/CSS/JS with only CDN webfonts.

## What the skill gives you

- **36 themes** (`assets/themes/*.css`) — minimal-white, editorial-serif, soft-pastel, sharp-mono, arctic-cool, sunset-warm, catppuccin-latte/mocha, dracula, tokyo-night, nord, solarized-light, gruvbox-dark, rose-pine, neo-brutalism, glassmorphism, bauhaus, swiss-grid, terminal-green, xiaohongshu-white, rainbow-gradient, aurora, blueprint, memphis-pop, cyberpunk-neon, y2k-chrome, retro-tv, japanese-minimal, vaporwave, midcentury, corporate-clean, academic-paper, news-broadcast, pitch-deck-vc, magazine-bold, engineering-whiteprint
- **15 full-deck templates** (`templates/full-decks/<name>/`) — complete multi-slide decks with scoped `.tpl-<name>` CSS. 8 extracted from real-world decks (xhs-white-editorial, graphify-dark-graph, knowledge-arch-blueprint, hermes-cyber-terminal, obsidian-claude-gradient, testing-safety-alert, xhs-pastel-card, dir-key-nav-minimal), 7 scenario scaffolds (pitch-deck, product-launch, tech-sharing, weekly-report, xhs-post 3:4, course-module, **presenter-mode-reveal** — 演讲者模式专用)
- **31 layouts** (`templates/single-page/*.html`) with realistic demo data
- **27 CSS animations** (`assets/animations/animations.css`) via `data-anim`
- **20 canvas FX animations** (`assets/animations/fx/*.js`) via `data-fx` — particle-burst, confetti-cannon, firework, starfield, matrix-rain, knowledge-graph (force-directed), neural-net (pulses), constellation, orbit-ring, galaxy-swirl, word-cascade, letter-explode, chain-react, magnetic-field, data-stream, gradient-blob, sparkle-trail, shockwave, typewriter-multi, counter-explosion
- **Keyboard runtime** (`assets/runtime.js`) — arrows, T (theme), A (anim), F/O, **S (presenter mode: magnetic-card popup with CURRENT / NEXT / SCRIPT / TIMER cards)**, N (notes drawer), R (reset timer in presenter)
- **FX runtime** (`assets/animations/fx-runtime.js`) — auto-inits `[data-fx]` on slide enter, cleans up on leave
- **Showcase decks** for themes / layouts / animations / full-decks gallery
- **Headless Chrome render script** for PNG export

## When to use

Use when the user asks for any kind of slide-based output or wants to turn
text/notes into a presentable deck. Prefer this over building from scratch.

### 🎤 Presenter Mode (演讲者模式 + 逐字稿)

If the user mentions any of: **演讲 / 分享 / 讲稿 / 逐字稿 / speaker notes / presenter view / 演讲者视图 / 提词器**, or says things like "我要去给团队讲 xxx", "要做一场技术分享", "怕讲不流畅", "想要一份带逐字稿的 PPT" — **use the `presenter-mode-reveal` full-deck template** and write 150–300 words of 逐字稿 in each slide's `<aside class="notes">`.

See [references/presenter-mode.md](references/presenter-mode.md) for the full authoring guide including the 3 rules of speaker script writing:
1. **不是讲稿，是提示信号** — 加粗核心词 + 过渡句独立成段
2. **每页 150–300 字** — 2–3 分钟/页的节奏
3. **用口语，不用书面语** — "因此"→"所以"，"该方案"→"这个方案"

All full-deck templates support the S key presenter mode (it's built into `runtime.js`). **S opens a new popup window with 4 magnetic cards**:
- 🔵 **CURRENT** — pixel-perfect iframe preview of the current slide
- 🟣 **NEXT** — pixel-perfect iframe preview of the next slide
- 🟠 **SPEAKER SCRIPT** — large-font 逐字稿 (scrollable)
- 🟢 **TIMER** — elapsed time + slide counter + prev/next/reset buttons

Each card is **draggable by its header** and **resizable by the bottom-right corner handle**. Card positions/sizes persist to `localStorage` per deck. A "Reset layout" button restores the default arrangement.

**Why the previews are pixel-perfect**: each preview is an `<iframe>` that loads the actual deck HTML with a `?preview=N` query param; `runtime.js` detects this and renders only slide N with no chrome. So the preview uses the **same CSS, theme, fonts, and viewport as the audience view** — colors and layout are guaranteed identical.

**Smooth navigation**: on slide change, the presenter window sends `postMessage({type:'preview-goto', idx:N})` to each iframe. The iframe just toggles `.is-active` between slides — **no reload, no flicker**. The two windows also stay in sync via `BroadcastChannel`.

Only `presenter-mode-reveal` is designed from the ground up around the feature with proper example 逐字稿 on every slide.

Keyboard in presenter window: `← →` navigate (syncs audience) · `R` reset timer · `Esc` close popup.
Keyboard in audience window: `S` open presenter · `T` cycle theme · `← →` navigate (syncs presenter) · `F` fullscreen · `O` overview.

## Before you author anything — ALWAYS ask or recommend

🔴 **CHECKPOINT: Do not start writing slides until you understand three things.**
Either ask the user directly, or — if they already handed you rich content — propose a
tasteful default and confirm.

1. **Content & audience.** What's the deck about, how many slides, who's
   watching (engineers / execs / 小红书读者 / 学生 / VC)?
2. **Style / theme.** Which of the 36 themes fits? If unsure, recommend 2-3
   candidates based on tone:
   - Business / investor pitch → `pitch-deck-vc`, `corporate-clean`, `swiss-grid`
   - Tech sharing / engineering → `tokyo-night`, `dracula`, `catppuccin-mocha`,
     `terminal-green`, `blueprint`
   - 小红书图文 → `xiaohongshu-white`, `soft-pastel`, `rainbow-gradient`,
     `magazine-bold`
   - Academic / report → `academic-paper`, `editorial-serif`, `minimal-white`
   - Edgy / cyber / launch → `cyberpunk-neon`, `vaporwave`, `y2k-chrome`,
     `neo-brutalism`
3. **Starting point.** One of the 15 full-deck templates, or scratch? Point
   to the closest `templates/full-decks/<name>/` and ask if it fits. If the
   user's content suggests something obvious (e.g. "我要做产品发布会" →
   `product-launch`), propose it confidently instead of asking blindly.

A good opening message looks like:

> 我可以给你做这份 PPT！先确认三件事：
> 1. 大致内容 / 页数 / 观众是谁？
> 2. 风格偏好？我建议从这 3 个主题里选一个：`tokyo-night`（技术分享默认好看）、`xiaohongshu-white`（小红书风）、`corporate-clean`（正式汇报）。
> 3. 要不要用我现成的 `tech-sharing` 全 deck 模板打底？

🔴 **CHECKPOINT: All 3 items answered → proceed. If user says "你自己定" → pick defaults and confirm once.**

## Authoring Workflow (step-by-step)

Follow these steps in order. Each step has a clear input → action → output.

| Step | Input | Action | Output |
|------|-------|--------|--------|
| 1. Scaffold | Deck name | `bash scripts/new-deck.sh <name>` | `examples/<name>/index.html` |
| 2. Set theme | User's tone/audience | Change `<link id="theme-link" href="...">` | Correct theme CSS loaded |
| 3. Build outline | Content + page count | Add/remove `<section class="slide">` blocks | Right number of slides |

🔴 **CHECKPOINT: Outline complete → verify slide count matches user request before filling content.**

| 4. Fill layouts | Outline structure | Copy from `templates/single-page/*.html`, replace demo data | Real content in each slide |
| 5. Add animations | Visual rhythm | `data-anim="fade-up"` on hero elements, max 1-2 per slide | Entry effects |
| 6. Add notes | Speaker needs | `<div class="notes">…</div>` per slide | S-key presenter notes |
| 7. Review | Completed deck | Open in browser, press O/T/S to verify | No layout clipping |

🔴 **CHECKPOINT: Review checklist — press O (overview grid), T (cycle 3 themes), S (verify notes). All clean → export.**

| 8. Export | Reviewed deck | `bash scripts/render.sh <file> <N>` | PNG files |

## Quick start

**Agent workflow — copy-paste these commands in order:**

```bash
# Step 1: scaffold (from skill root)
SKILL_DIR="$(dirname "$(readlink -f "$0")")"  # or hardcode the path
bash "$SKILL_DIR/scripts/new-deck.sh my-talk"

# Step 2: verify scaffold created correctly
grep -c '../../assets/' "$SKILL_DIR/examples/my-talk/index.html"
# Expected: 6 (fonts, base, theme, animations, theme-base, runtime)

# Step 3: render to PNG (single page)
bash "$SKILL_DIR/scripts/render.sh" "$SKILL_DIR/examples/my-talk/index.html" 1

# Step 4: render all slides
bash "$SKILL_DIR/scripts/render.sh" "$SKILL_DIR/examples/my-talk/index.html" 6
```

**When composing a deck, the HTML for each slide looks like this:**

```html
<section class="slide" data-title="Your Title">
  <p class="kicker">Section Label</p>
  <h2 class="h2 anim-fade-up" data-anim="fade-up">Slide Title</h2>
  <div class="grid g3 mt-l anim-stagger-list" data-anim-target>
    <div class="card"><h4>Point 1</h4><p class="dim">Details...</p></div>
    <div class="card"><h4>Point 2</h4><p class="dim">Details...</p></div>
    <div class="card"><h4>Point 3</h4><p class="dim">Details...</p></div>
  </div>
  <div class="notes">Speaker notes here (150-300 words).</div>
</section>
```

**Available layout classes:**
- `.grid.g2` / `.grid.g3` / `.grid.g4` — 2/3/4 column grid
- `.card` / `.card-soft` / `.card-outline` / `.card-accent` — card styles
- `.center` / `.tc` — center slide content
- `.kicker` / `.eyebrow` — small label above title
- `.lede` — subtitle text below title
- `.dim` / `.dim2` — muted text
- `.gradient-text` — rainbow gradient on text
- `.mt-s` / `.mt-m` / `.mt-l` — margin-top spacing

## Authoring rules (important)

- **Always start from a template.** Don't author slides from scratch — copy the
  closest layout from `templates/single-page/` first, then replace content.
- **Use tokens, not literal colors.** Every color, radius, shadow should come
  from CSS variables defined in `assets/base.css` and overridden by a theme.
  Good: `color: var(--text-1)`. Bad: `color: #111`.
- **Don't invent new layout files.** Prefer composing existing ones. Only add
  a new `templates/single-page/*.html` if none of the 30 fit.
- **Respect chrome slots.** `.deck-header`, `.deck-footer`, `.slide-number`
  and the progress bar are provided by `assets/base.css` + `runtime.js`.
- **Keyboard-first.** Always include `<script src="../assets/runtime.js"></script>`
  so the deck supports ← → / T / A / F / S / O / hash deep-links.
- **One `.slide` per logical page.** `runtime.js` makes `.slide.is-active`
  visible; all others are hidden.
- **Supply notes.** Wrap speaker notes in `<div class="notes">…</div>` inside
  each slide. Press S to open the overlay.
- **NEVER put presenter-only text on the slide itself.** Descriptive text like
  "这一页展示了……" or "Speaker: 这里可以补充……" or small explanatory captions
  aimed at the presenter MUST go inside `<div class="notes">`, NOT as visible
  `<p>` / `<span>` elements on the slide. The `.notes` class is `display:none`
  by default — it only appears in the S overlay. Slides should contain ONLY
  audience-facing content (titles, bullet points, data, charts, images).

## Failure Modes & Troubleshooting

If any step fails, follow this fallback chain:

| Trigger | First-line fix | Still failing |
|---------|---------------|---------------|
| `render.sh` returns ERR_FILE_NOT_FOUND | Check Chrome path: `which google-chrome` (Linux) / verify `LOCALAPPDATA` (Windows) | Set `CHROME=/path/to/chrome.exe` env var and retry |
| `render.sh` produces blank/white PNG | Increase `--virtual-time-budget=4000` to `8000` in render.sh | Open HTML in browser manually, screenshot with `browser_screenshot` |
| Theme not switching with T key | Verify `data-themes="a,b,c"` on `<body>` and `data-theme-base` pointing to themes dir | Hard-code `<link id="theme-link" href="...">` instead of T-cycle |
| Fonts look wrong / fallback to system | Check `fonts.css` is linked BEFORE the theme CSS | CDN blocked (China firewall) — add local font fallback or use proxy |
| Canvas FX not playing | Verify `<script src="...fx-runtime.js"></script>` is AFTER the `<div class="deck">` | Check browser console for JS errors; FX modules load async |
| `new-deck.sh` path rewrite wrong | Verify output HTML has `../../assets/` (not `../assets/`) | Manually edit paths: add one more `../` for each nesting level |
| `open` command not found | macOS: `open`, Windows: `start`, Linux: `xdg-open` | Just drag the HTML file into Chrome |
| Slide layout broken in a theme | Some themes override border-radius/shadow aggressively | Test with `minimal-white` first; if broken there, fix the layout HTML |
| Chart.js colors wrong | Charts read CSS vars in JS; must run after DOM ready | Wrap in `addEventListener('DOMContentLoaded', ...)` |
| presenter-mode S key not working | `runtime.js` must be linked | Check `<script src="../assets/runtime.js"></script>` is present |
| 小红书 3:4 图文尺寸不对 | `xhs-post` template uses fixed `810×1080` viewport | Check `.slide` CSS has `width:810px;height:1080px` — don't override |
| Presenter window shows wrong slide | BroadcastChannel only works same-origin (same file:// or http://) | Open via `http://localhost` instead of `file://` for cross-window sync |
| Progress bar missing | `.progress-bar` is auto-created by `runtime.js` only if `.deck` exists | Verify `<div class="deck">` wraps all `.slide` elements |
| Counter animation not ticking | `.counter` needs `data-to="123"` attribute | Add `<span class="counter" data-to="1248">0</span>` |
| `render.sh` hangs on Linux | Chrome needs `--no-sandbox` when running as root | Already in the script; if still hanging, add `--disable-dev-shm-usage` |

## Anti-Patterns — DO NOT

| # | ❌ Don't | ✅ Do instead |
|---|---------|---------------|
| 1 | Author slides from a blank HTML file | Copy the closest layout from `templates/single-page/` first |
| 2 | Use literal hex colors (`#111`, `rgb(...)`) | Use CSS tokens: `var(--text-1)`, `var(--accent)` |
| 3 | Put presenter-only text on the visible slide | Wrap in `<div class="notes">` or `<aside class="notes">` |
| 4 | Skip `runtime.js` | Always include it — keyboard nav, S-key, T-cycle, overview all depend on it |
| 5 | Invent new layout files for minor variations | Compose existing layouts; only create new if genuinely novel |
| 6 | Use heavy animation frameworks (GSAP, anime.js) | Use the built-in 27 CSS animations + 20 canvas FX |
| 7 | Hard-code font families in slides | Use `var(--font-sans)` / `var(--font-display)` from tokens |
| 8 | Mix 5+ animation types on one slide | Max 1-2 animation types per slide for clean rhythm |
| 9 | Write 逐字稿 in formal written Chinese | Use conversational Chinese: "所以" not "因此", "这个" not "该" |
| 10 | Write 逐字稿 longer than 300 words per slide | Keep 150–300 words; >300 = can't scan in time |
| 11 | Delete slides from showcase/template files | They are reference material; copy, don't delete |
| 12 | Load fx-runtime.js without any `data-fx` elements | Only include fx-runtime.js when slides actually use canvas FX |
| 13 | Forget `<!DOCTYPE html>` or `<meta charset>` | Always start from `templates/deck.html` — it has all required boilerplate |
| 14 | Use `../assets/` paths in nested `full-decks/` templates | Full-deck templates need `../../../assets/` (3 levels up from `full-decks/<name>/`) |
| 15 | Assume CDN fonts load in offline/China environments | Pre-import only essential fonts in `fonts.css`; add `font-display: swap` |
| 16 | Use `<div class="slide">` without `data-title` | Always add `data-title="..."` — used by overview grid (O key) |
| 17 | Put `<script>` tags inside `.slide` sections | Scripts go AFTER `<div class="deck">` closing tag, before `</body>` |
| 18 | Override `.slide` display/visibility in custom CSS | `runtime.js` controls `.is-active` — overriding breaks navigation |

## Writing guide

See [references/authoring-guide.md](references/authoring-guide.md) for a
step-by-step walkthrough: file structure, naming, how to transform an outline
into a deck, how to choose layouts and themes per audience, how to do a
Chinese + English deck, and how to export.

## Catalogs (load when needed)

- [references/themes.md](references/themes.md) — all 36 themes with when-to-use.
- [references/layouts.md](references/layouts.md) — all 31 layout types.
- [references/animations.md](references/animations.md) — 27 CSS + 20 canvas FX animations.
- [references/full-decks.md](references/full-decks.md) — all 15 full-deck templates.
- [references/presenter-mode.md](references/presenter-mode.md) — **演讲者模式 + 逐字稿编写指南（技术分享/演讲必看）**.
- [references/authoring-guide.md](references/authoring-guide.md) — full workflow.

## File structure

```
html-ppt/
├── SKILL.md                 (this file)
├── references/              (detailed catalogs, load as needed)
├── assets/
│   ├── base.css             (tokens + primitives — do not edit per deck)
│   ├── fonts.css            (webfont imports)
│   ├── runtime.js           (keyboard + presenter + overview + theme cycle)
│   ├── themes/*.css         (36 token overrides, one per theme)
│   └── animations/
│       ├── animations.css   (27 named CSS entry animations)
│       ├── fx-runtime.js    (auto-init [data-fx] on slide enter)
│       └── fx/*.js          (20 canvas FX modules: particles/graph/fireworks…)
├── templates/
│   ├── deck.html                  (minimal 6-slide starter)
│   ├── theme-showcase.html        (36 slides, iframe-isolated per theme)
│   ├── layout-showcase.html       (iframe tour of all 31 layouts)
│   ├── animation-showcase.html    (20 FX + 27 CSS animation slides)
│   ├── full-decks-index.html      (gallery of all 14 full-deck templates)
│   ├── full-decks/<name>/         (14 scoped multi-slide deck templates)
│   └── single-page/*.html         (31 layout files with demo data)
├── scripts/
│   ├── new-deck.sh                (scaffold a deck from deck.html)
│   └── render.sh                  (headless Chrome → PNG)
└── examples/demo-deck/            (complete working deck)
```

## Rendering to PNG

`scripts/render.sh` wraps headless Chrome for PNG export. It auto-detects
Chrome on macOS, Linux, and Windows (Git Bash / MSYS).

```bash
./scripts/render.sh templates/single-page/kpi-grid.html        # single page
./scripts/render.sh examples/demo-deck/index.html 8 out-dir    # 8 slides, custom dir
```

## Keyboard cheat sheet

```
←  →  Space  PgUp  PgDn  Home  End    navigate
F                                       fullscreen
S                                       open presenter window (magnetic cards: current/next/script/timer)
N                                       quick notes drawer (bottom overlay)
R                                       reset timer (in presenter window)
?preview=N                              URL param — force preview-only mode (single slide, no chrome)
O                                       slide overview grid
T                                       cycle themes (reads data-themes attr)
A                                       cycle demo animation on current slide
#/N in URL                              deep-link to slide N
Esc                                     close all overlays
```

## License & author

MIT. Copyright (c) 2026 lewis &lt;sudolewis@gmail.com&gt;.
