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

```
User request → Agent reads SKILL.md
  │
  ├─ 1. Ask 3 questions (content/theme/template)
  │     └─ 🔴 CHECKPOINT: all answered
  │
  ├─ 2. Scaffold: bash scripts/new-deck.sh <name>
  │     └─ creates examples/<name>/index.html with paths rewritten
  │
  ├─ 3. Build outline: add/remove <section class="slide">
  │     └─ 🔴 CHECKPOINT: slide count matches request
  │
  ├─ 4. Fill layouts: copy from templates/single-page/*.html
  │     └─ replace demo data with real content
  │
  ├─ 5. Add animations: data-anim="fade-up" (max 1-2/slide)
  │
  ├─ 6. Add notes: <div class="notes"> per slide
  │
  ├─ 7. Review: O (overview) / T (themes) / S (notes)
  │     └─ 🔴 CHECKPOINT: all clean
  │
  └─ 8. Export: bash scripts/render.sh <file> <N>
        └─ PNG files at 1920×1080
```

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

**Decision branches at each step:**

| If user says... | Then... |
|-----------------|---------|
| "你自己定" / "随便" | Pick `corporate-clean` theme + `tech-sharing` template, confirm once |
| "小红书图文" | Use `xhs-post` template (fixed 810×1080), `xiaohongshu-white` theme |
| "带演讲者模式" / "有逐字稿" | Use `presenter-mode-reveal` template, write 150-300 words per `<aside class="notes">` |
| "暗色/深色" | Choose from: `tokyo-night`, `dracula`, `catppuccin-mocha`, `gruvbox-dark`, `cyberpunk-neon` |
| "简洁/极简" | Choose from: `minimal-white`, `arctic-cool`, `swiss-grid`, `editorial-serif` |
| "炫酷/科技感" | Choose from: `cyberpunk-neon`, `vaporwave`, `y2k-chrome`, `aurora`, `glassmorphism` |
| "要导出图片/PNG" | After building, run `render.sh` with slide count |
| "不需要动画" | Skip Step 5, remove all `data-anim` attributes |

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

## End-to-End Example: "做一份 6 页技术分享"

This is a complete walkthrough showing exactly what the agent produces at each step.

**Step 1 — User says:** "做一份 6 页技术分享，用 tokyo-night 主题"

**Step 2 — Scaffold:**
```bash
SKILL_DIR="<skill-root>"
bash "$SKILL_DIR/scripts/new-deck.sh tech-share"
# Output: ✔ created examples/tech-share/index.html
```

**Step 3 — Set theme (edit index.html line 8):**
```html
<link rel="stylesheet" id="theme-link" href="../../assets/themes/tokyo-night.css">
```

**Step 4 — Build 6 slides** (replace the 6 default `<section class="slide">` blocks):
```html
<!-- Slide 1: Cover -->
<section class="slide center tc" data-title="Cover">
  <p class="kicker">TECH SHARING · 2026</p>
  <h1 class="h1 anim-rise-in" data-anim="rise-in">系统架构升级<br><span class="dim">从单体到微服务</span></h1>
  <p class="lede">张三 · 2026-06-21</p>
  <div class="notes">
    <p>大家好！今天分享我们团队<strong>过去三个月</strong>做的架构升级。</p>
    <p>先说背景——去年底我们遇到了<strong>三个核心问题</strong>：延迟高、成本炸、稳定性差。</p>
  </div>
</section>

<!-- Slide 2: Agenda -->
<section class="slide" data-title="Agenda">
  <p class="kicker">Agenda</p>
  <h2 class="h2">今天讲三件事</h2>
  <div class="grid g3 mt-l anim-stagger-list" data-anim-target>
    <div class="card"><h4>01 · 问题</h4><p class="dim">现状与痛点</p></div>
    <div class="card"><h4>02 · 方案</h4><p class="dim">架构设计</p></div>
    <div class="card"><h4>03 · 结果</h4><p class="dim">数据对比</p></div>
  </div>
</section>

<!-- Slides 3-6: follow same pattern — copy layout from templates/single-page/, replace data -->
```

**Step 5 — Render:**
```bash
bash "$SKILL_DIR/scripts/render.sh" "$SKILL_DIR/examples/tech-share/index.html" 6
# Output: 6 PNG files at 1920×1080
```

**Result:** 6 professional slides in `tokyo-night` theme with keyboard nav, presenter mode, and PNG export.

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
| Ken Burns effect not visible | `.kenburns` needs a background-image on the element | Add `style="background-image:url(...)"` or use gradient placeholder |
| Overview grid (O key) shows empty cards | Each `<section class="slide">` needs `data-title="..."` | Add `data-title="Cover"` etc. to every slide |
| Hash deep-link `#/3` not working | URL must be `file://path#3` not `file://path#/3` | Use `#3` (no slash) for 1-based slide index |
| `stagger-list` children not animating one-by-one | Children must be direct descendants, not wrapped in extra divs | Put grid items directly inside the `.anim-stagger-list` container |
| Deck works locally but breaks on web server | Relative paths (`../../assets/`) break if directory structure changes | Use `<base href="...">` or absolute paths when deploying |
| Two decks on same page conflict | CSS class names like `.slide`, `.card` are global | Scope with `.deck` parent or use iframe isolation (like showcases do) |
| SVG `path-draw` not rendering | Older browsers may not support CSS `stroke-dasharray` animation | Add fallback: static SVG with `stroke-dasharray: 0` |
| Print layout broken | `base.css` has `@media print` rules but custom CSS may override | Test with Ctrl+P before delivering PDF version |

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
| 19 | Omit `<html lang="zh-CN">` on Chinese decks | Always set `lang` for proper font rendering and accessibility |
| 20 | Use `<b>` / `<i>` instead of `<strong>` / `<em>` in notes | Semantic HTML; `<strong>` and `<em>` are styled in presenter view |
| 21 | Hard-code slide dimensions in pixels | Use CSS variables (`--slide-w`, `--slide-h`) from `base.css` for consistency |
| 22 | Use `position: absolute` for slide layout | Use CSS Grid (`.grid.g2/g3/g4`) — it's responsive and token-driven |
| 23 | Include Chart.js CDN on slides without charts | Only add `<script src="chart.js">` when slides actually use `chart-bar/line/pie/radar.html` |
| 24 | Write notes in English for a Chinese deck | Match notes language to deck language; bilingual decks use Chinese notes |
| 25 | Copy entire showcase HTML as a starting point | Use `new-deck.sh` scaffold or copy a `full-decks/` template — showcases are reference, not starters |

## Writing guide

See [references/authoring-guide.md](references/authoring-guide.md) for a
step-by-step walkthrough: file structure, naming, how to transform an outline
into a deck, how to choose layouts and themes per audience, how to do a
Chinese + English deck, and how to export.

## Catalogs (load when needed)

**When to load which reference:**

| User asks about... | Load this | Key content |
|--------------------|-----------|-------------|
| "什么主题好看" / theme choice | [references/themes.md](references/themes.md) | 36 themes with when-to-use + audience mapping |
| "用什么布局" / layout type | [references/layouts.md](references/layouts.md) | 31 layouts: opener/text/data/code/diagram/plan/visual/closer |
| "加什么动画" / animation | [references/animations.md](references/animations.md) | 27 CSS + 20 canvas FX with trigger syntax |
| "有现成模板吗" / full deck | [references/full-decks.md](references/full-decks.md) | 15 templates: 8 extracted + 7 scenario |
| "演讲者模式怎么用" / presenter | [references/presenter-mode.md](references/presenter-mode.md) | S-key guide + 逐字稿三铁律 + HTML structure |
| "怎么从零开始做" / workflow | [references/authoring-guide.md](references/authoring-guide.md) | 10-step walkthrough from request to PNG |

All 6 references are searchable via `skill_view(name, file_path='references/<name>.md')`.

## Rendering to PNG

`scripts/render.sh` wraps headless Chrome for PNG export. It auto-detects
Chrome on macOS, Linux, and Windows (Git Bash / MSYS).

```bash
./scripts/render.sh templates/single-page/kpi-grid.html        # single page
./scripts/render.sh examples/demo-deck/index.html 8 out-dir    # 8 slides, custom dir
```

## Quality Standards

A deck is **done** when ALL of these are true:

| Check | Pass criteria |
|-------|--------------|
| Slide count | Exactly matches user request (±0) |
| Theme applied | `<link id="theme-link">` points to correct theme CSS |
| Every slide has `data-title` | Overview grid (O key) shows all slide titles |
| No placeholder text | No "Lorem ipsum", "TBD", "TODO", "Your content here" |
| Notes present | Every slide has `<div class="notes">` with 150-300 words |
| Keyboard works | ← → navigate, T cycles themes, S opens presenter |
| Tokens only | Zero hardcoded hex colors in slide markup |
| PNG renders | `render.sh` produces non-blank PNGs (37KB+ for 1920×1080) |

## Common Scenarios → Recommended Combos

| User request | Template | Theme | Animations | Notes |
|-------------|----------|-------|------------|-------|
| 技术分享 (8页) | `tech-sharing` | `tokyo-night` | `fade-up` + `stagger-list` | 每页 200 字逐字稿 |
| 投资人路演 (10页) | `pitch-deck` | `pitch-deck-vc` | `rise-in` cover + `counter-up` KPIs | English notes OK |
| 小红书图文 (9张) | `xhs-post` | `xiaohongshu-white` | Minimal, `fade-up` only | 3:4 ratio, 810×1080 |
| 周报 (7页) | `weekly-report` | `corporate-clean` | `stagger-list` + `counter-up` | 数据驱动，少文字 |
| 产品发布会 (8页) | `product-launch` | `glassmorphism` | `blur-in` cover + `zoom-pop` features | 每页一个重点 |
| 教学课件 (7页) | `course-module` | `academic-paper` | `fade-up` only | 左侧学习目标栏 |
| 演讲带逐字稿 (6页) | `presenter-mode-reveal` | `tokyo-night` | `rise-in` titles | 150-300字/页，口语化 |
| 代码分享 (8页) | `tech-sharing` | `dracula` | `fade-up` + `glitch-in` code | code.html 布局 |
| 项目架构图 (5页) | scratch | `blueprint` | `path-draw` SVG | arch-diagram.html |
| 安全审计报告 (6页) | `testing-safety-alert` | `neo-brutalism` | `fade-up` + `counter-up` | 红/琥珀/绿三级卡片 |

## Agent Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────┐
│  html-ppt · Agent Speed Reference                               │
├─────────────────────────────────────────────────────────────────┤
│  THEMES (pick by tone):                                         │
│    Dark: tokyo-night dracula catppuccin-mocha gruvbox-dark      │
│    Light: minimal-white corporate-clean arctic-cool swiss-grid  │
│    Fun: aurora glassmorphism cyberpunk-neon vaporwave xhs-white │
│    Formal: pitch-deck-vc academic-paper editorial-serif         │
├─────────────────────────────────────────────────────────────────┤
│  LAYOUTS (pick by content):                                     │
│    Cover: cover.html                                            │
│    Text: bullets.html two-column.html three-column.html         │
│    Data: stat-highlight.html kpi-grid.html table.html           │
│    Charts: chart-bar.html chart-line.html chart-pie.html        │
│    Code: code.html terminal.html diff.html                      │
│    Diagram: flow-diagram.html arch-diagram.html mindmap.html    │
│    Plan: timeline.html roadmap.html gantt.html                  │
│    End: cta.html thanks.html                                    │
├─────────────────────────────────────────────────────────────────┤
│  ANIMATIONS (max 1-2/slide):                                    │
│    Safe: fade-up stagger-list rise-in                           │
│    Bold: blur-in glitch-in perspective-zoom                     │
│    Data: counter-up path-draw                                   │
│    Canvas: particle-burst confetti-cannon knowledge-graph       │
├─────────────────────────────────────────────────────────────────┤
│  COMMANDS:                                                      │
│    Scaffold: bash scripts/new-deck.sh <name>                    │
│    Render 1: bash scripts/render.sh <html> 1                    │
│    Render N: bash scripts/render.sh <html> <N>                  │
│    Verify:   grep -c '../../assets/' <html>  # expect 6         │
├─────────────────────────────────────────────────────────────────┤
│  SLIDE TEMPLATE:                                                │
│    <section class="slide" data-title="...">                     │
│      <p class="kicker">LABEL</p>                                │
│      <h2 class="h2 anim-fade-up" data-anim="fade-up">Title     │
│      <div class="grid g3 mt-l">...</div>                        │
│      <div class="notes">150-300 words</div>                     │
│    </section>                                                   │
├─────────────────────────────────────────────────────────────────┤
│  CSS CLASSES: .grid.g2/g3/g4 .card .center .tc .kicker .lede   │
│               .dim .dim2 .gradient-text .mt-s .mt-m .mt-l       │
├─────────────────────────────────────────────────────────────────┤
│  KEYS: ←→navigate T:theme A:anim F:fullscreen S:presenter      │
│        O:overview N:notes R:reset-timer Esc:close               │
└─────────────────────────────────────────────────────────────────┘
```

## License & author

MIT. Copyright (c) 2026 lewis &lt;sudolewis@gmail.com&gt;.
