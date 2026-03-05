# Frontend Design Guide

Design guidelines for creating distinctive, production-grade frontend interfaces. Use this reference when Sub-Agent tasks involve UI/frontend development.

## Quick Reference

### Before Coding, Decide:
1. **Purpose** — What problem does this UI solve? Who uses it?
2. **Tone** — What aesthetic direction? (minimal, maximalist, retro, editorial...)
3. **Constraints** — Framework, performance, accessibility requirements
4. **Differentiation** — What makes this memorable?

### Anti-Patterns (AI Slop)
❌ Inter/Roboto/Arial as default fonts
❌ Purple gradients on white backgrounds
❌ Excessive centered layouts
❌ Uniform rounded corners everywhere
❌ Cookie-cutter component patterns

---

## Design Thinking Process

Before writing any frontend code, commit to a clear aesthetic direction:

### 1. Purpose Analysis
- What problem does this interface solve?
- Who are the users?
- What's the primary workflow?
- What emotions should it evoke?

### 2. Aesthetic Direction

Choose and commit to a direction — bold maximalism and refined minimalism both work. The key is **intentionality**:

| Direction | Characteristics |
|-----------|----------------|
| Brutally minimal | Lots of whitespace, stark contrast, few elements |
| Maximalist | Dense, colorful, layered, information-rich |
| Retro-futuristic | Neon, gradients, sci-fi vibes |
| Organic/natural | Earthy tones, soft shapes, nature-inspired |
| Luxury/refined | Gold accents, serif fonts, elegant spacing |
| Playful/toy-like | Bright colors, rounded shapes, animations |
| Editorial/magazine | Strong typography, grid layouts, bold headlines |
| Brutalist/raw | Monospace fonts, borders, no decoration |
| Industrial/utilitarian | Functional, no-nonsense, data-dense |

### 3. Design System

Before implementing, establish:
- **Color palette** (CSS variables for consistency)
- **Typography scale** (2 fonts max: display + body)
- **Spacing system** (consistent margins/padding)
- **Component patterns** (buttons, cards, inputs)

---

## Typography

**CRITICAL**: Typography is the #1 differentiator between "AI slop" and good design.

### Do
- Choose distinctive, characterful fonts
- Pair a display font with a refined body font
- Use clear hierarchy: size, weight, spacing
- Consider readability at all sizes

### Don't
- Default to Inter, Roboto, Arial, or system fonts
- Use more than 2-3 font families
- Make body text too small (<14px)

### Font Sources
```html
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Space+Mono&family=DM+Sans&display=swap" rel="stylesheet">

<!-- Or use CSS -->
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;500;700&display=swap');
```

---

## Color & Theme

### Principles
- Dominant color with sharp accents > evenly-distributed palette
- Use CSS variables for consistency:
  ```css
  :root {
    --bg-primary: #0a0a0a;
    --text-primary: #fafafa;
    --accent: #ff6b35;
    --accent-subtle: #ff6b3520;
  }
  ```
- Support dark/light themes from the start
- Test contrast ratios for accessibility (WCAG AA: 4.5:1)

### Avoid
- Purple gradients (most overused AI aesthetic)
- Rainbow or too many colors
- Low contrast text

---

## Motion & Animation

### High-Impact Moments
Focus animation budget on:
1. **Page load** — Staggered reveals with `animation-delay`
2. **State transitions** — Smooth content changes
3. **Hover states** — Subtle feedback that surprises
4. **Scroll triggers** — Elements appearing on scroll

### Implementation
```css
/* Prefer CSS-only for performance */
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.card {
  animation: fadeInUp 0.5s ease-out;
  animation-fill-mode: both;
}

/* Stagger children */
.card:nth-child(1) { animation-delay: 0.1s; }
.card:nth-child(2) { animation-delay: 0.2s; }
.card:nth-child(3) { animation-delay: 0.3s; }
```

For React: use Motion library (`framer-motion`) when available.

### Avoid
- Animations without purpose
- Slow animations (>500ms for most interactions)
- Animating everything (less is more for minimal designs)

---

## Spatial Composition

### Beyond Standard Layouts
- **Asymmetry** — Break the grid intentionally
- **Overlap** — Elements layered with `z-index`
- **Diagonal flow** — Tilted elements, angular sections
- **Generous whitespace** — Let elements breathe
- **Controlled density** — Information-rich but organized

### Backgrounds & Depth
Create atmosphere, don't default to solid colors:
- Gradient meshes
- Noise/grain textures
- Geometric patterns
- Layered transparencies
- Dramatic shadows

```css
/* Subtle noise texture */
.bg-textured {
  background-image: url("data:image/svg+xml,..."); /* noise SVG */
  background-color: var(--bg-primary);
}

/* Gradient mesh */
.bg-mesh {
  background: 
    radial-gradient(at 20% 80%, var(--accent-subtle) 0%, transparent 50%),
    radial-gradient(at 80% 20%, var(--secondary-subtle) 0%, transparent 50%),
    var(--bg-primary);
}
```

---

## Integration with Multi-Agent Workflow

### When to Load This Guide

Include this reference in Sub-Agent task descriptions when the task involves:
- Building UI components or pages
- Styling or beautifying interfaces
- Creating landing pages or dashboards
- Any visual/frontend work

### Example Task Description
```
sessions_spawn(
  task="Build the chat interface per plan-chat-ui.md.
  
  Design requirements:
  - Read reference/frontend_design.md for aesthetic guidelines
  - Choose a distinctive font pairing (NOT Inter/Roboto)
  - Dark theme by default with light theme toggle
  - Smooth message animations (staggered reveal)
  - Avoid generic AI aesthetics
  
  DO NOT write code until you've decided on:
  1. Color palette (document in plan)
  2. Font pairing (document in plan)  
  3. Animation strategy (document in plan)",
  label="chat-ui",
  cleanup="keep"
)
```

---

## Checklist for Frontend Sub-Agents

Before marking a frontend task complete:

- [ ] Fonts are distinctive (not Inter/Roboto/Arial)
- [ ] Color palette is cohesive with CSS variables
- [ ] Dark/light theme support
- [ ] Responsive design (mobile → desktop)
- [ ] Meaningful animations (not gratuitous)
- [ ] Accessibility basics (contrast, focus states, alt text)
- [ ] No generic "AI slop" patterns
- [ ] Screenshots captured for review
