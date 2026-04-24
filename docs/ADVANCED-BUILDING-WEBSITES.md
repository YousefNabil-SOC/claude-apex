# Advanced — Building Premium Websites

> The full Apex web-dev stack: premium-web-design skill (36 patterns), 21st.dev Magic MCP, impeccable polish skill, animation toolkit, RTL support, and Playwright verification.

## The Three Web-Dev Skills (and their order)

Apex's web skills compose in a specific order. Following this order produces premium results:

```
1. 21st-dev-magic      → scaffold components from natural language
2. premium-web-design  → apply animation patterns + reference-site techniques
3. impeccable          → polish layer (hover, focus, empty states, micro-interactions)
```

Each skill handles what it does best, then hands off.

## Skill 1 — `21st-dev-magic` (scaffolding)

### What it does

Uses the `@21st-dev/magic` MCP server to generate production-ready React+TS+Tailwind components from natural language.

### When to use

- Starting a new component from scratch
- Generating variations of a common UI pattern (pricing tables, feature grids, testimonials)
- You need a Tailwind-first baseline to customize

### Activates on

Keywords: `21st`, `magic component`, `generate component`, `ui component`.

Or directly:
```
use the 21st.dev magic MCP to generate a pricing table with 3 tiers
```

### API key required

`TWENTY_FIRST_DEV_API_KEY` in `~/.claude/.env`.

### Example

```
> generate a hero section with a background gradient, headline, subheading, and two CTA buttons

[CARL] WEB-DEVELOPMENT loaded
[Skill] 21st-dev-magic activated
[MCP] @21st-dev/magic invoked

Generated: src/components/Hero.tsx (78 lines)

Returned TSX:
  - Semantic <section> with accessible heading hierarchy
  - Tailwind gradient (from-slate-900 to-slate-700)
  - Responsive text sizing (text-4xl md:text-6xl lg:text-7xl)
  - Two Button components (primary + secondary variant)
  - TypeScript interfaces for all props
```

### Limits

- Good for standard patterns; weaker for novel interactions
- Generates static structure; no animations by default (that's premium-web-design's job)

## Skill 2 — `premium-web-design` (animation + polish)

### What it does

Applies luxury animation patterns and techniques from 10 reference-site analyses. Lives at `~/.claude/skills/premium-web-design/`.

### Contents

- `SKILL.md` — master file (~200 lines)
- `patterns/` — 36 curated animation patterns
- `references/` — analyses of 10 premium sites (Airbnb, Apple, Linear, Stripe, etc.)
- `tools/` — GSAP and Framer Motion technique guides

### When to use

- After scaffolding with 21st-dev-magic
- When "make it feel premium" is the goal
- Scroll-triggered reveals, parallax, smooth-scroll, hero animations

### Activates on

Keywords: `premium design`, `luxury`, `animation`, `scroll effect`, `parallax`, `hero section`, `hover effect`, `GSAP`, `framer motion`, `lenis`, `smooth scroll`.

### The 36 patterns (categories)

**Hero animations (5):**
- Text reveal (word-by-word or line-by-line)
- Gradient shift on scroll
- Parallax image layer
- Video background with mask
- Split-screen reveal

**Scroll effects (8):**
- Scroll-triggered fade-ins
- Scroll-pinned sections
- Horizontal scroll within vertical scroll
- Progress indicators
- Scroll-linked animations
- Reveal-on-scroll image grids
- Sticky scroll transforms
- Scroll-jacked sections (use sparingly)

**Interactive (7):**
- Magnetic buttons
- Cursor-follow effects
- Hover card tilts
- Scroll-to-section navigation
- Smooth anchor scrolling
- Image distortion on hover
- Scroll-linked color shifts

**Transitions (6):**
- Page transitions (fade, slide, curtain)
- Modal open/close with easing
- Tab transitions
- Route transitions in React Router
- Loading state transitions
- Error state transitions

**Micro-interactions (5):**
- Button press feedback
- Form field focus animations
- Checkbox/toggle animations
- Number count-ups
- Link underline reveals

**Layouts (5):**
- Bento grids
- Asymmetric hero layouts
- Stacked cards with offsets
- Masonry with animation
- Split viewports

### Example

```
> apply the premium-web-design scroll-reveal pattern to my ProductGrid component

[Skill] premium-web-design loaded
  Reading patterns/scroll-reveal.md...
  Reading references/linear.md...

Applied scroll-triggered reveal:
  - Intersection Observer on each .product-card
  - GSAP fade-in with stagger (0.1s between cards)
  - Respects prefers-reduced-motion
  - Falls back gracefully without JS
```

## Skill 3 — `impeccable` (polish layer)

### What it does

The "make it feel impeccable" skill. Runs after you have a working UI and adds:
- Hover states (every interactive element)
- Focus rings (keyboard-visible)
- Active / pressed states
- Disabled state styling
- Empty states (no data)
- Error states
- Loading skeletons
- Smooth transitions between states
- Accessibility audit

### When to use

Run last, after structure + animation are in place. Takes a working-but-rough UI and raises it to production quality.

### Example

```
> run the impeccable skill on my landing page

[Skill] impeccable loaded

Polishing:
  ✓ Added focus-visible rings to 7 interactive elements
  ✓ Added hover scale-105 to all cards
  ✓ Added active:scale-95 to all buttons
  ✓ Added disabled: opacity-50 + cursor-not-allowed
  ✓ Created LoadingSkeleton for ProductGrid
  ✓ Created EmptyState for zero search results
  ✓ Added transition-all duration-200 to 14 interactive elements

Accessibility check:
  ✓ All buttons have accessible names
  ✓ All interactive elements keyboard-accessible
  ✓ prefers-reduced-motion honored in 4 animations
  ⚠ Missing alt on 2 decorative images (added role="presentation")
```

## How All Three Compose

### The order matters

```
Stage 1 — Scaffold with 21st-dev-magic
    ↓
Stage 2 — Add animations with premium-web-design
    ↓
Stage 3 — Polish with impeccable
    ↓
Stage 4 — Verify with Playwright
```

### Example — build a premium landing page

```
> build me a premium landing page for a luxury coffee brand with scroll animations

[CARL Layer 1] WEB-DEVELOPMENT + DEVELOPMENT domains loaded (12 rules)
[CAPABILITY-REGISTRY Layer 2] Skills: premium-web-design, 21st-dev-magic, 
  frontend-design, tailwind-patterns, react-patterns, ui-ux-pro-max, impeccable
[COMMAND-REGISTRY Layer 3] /feature-dev auto-invoked

Stage 1 — Scaffold (21st-dev-magic)
  Generated Hero.tsx (156 lines)
  Generated ProductGrid.tsx (112 lines)
  Generated Testimonials.tsx (88 lines)
  Generated Footer.tsx (64 lines)

Stage 2 — Animate (premium-web-design)
  Applied: text-reveal pattern to Hero headline
  Applied: scroll-fade-stagger pattern to ProductGrid
  Applied: parallax pattern to Hero background
  Applied: magnetic-button pattern to CTAs
  Installed: GSAP 3.14, Lenis smooth scroll

Stage 3 — Polish (impeccable)
  Added: focus rings, hover states, active states
  Added: loading skeletons, empty states
  Added: prefers-reduced-motion fallbacks
  Accessibility: 100/100

Stage 4 — Verify (Playwright)
  npm run build: PASS (0 errors, 0 warnings)
  Screenshot at 1920x1080: saved to /tmp/landing.png
  Screenshot at 375x667 (mobile): saved to /tmp/landing-mobile.png
  Lighthouse: Performance 94, Accessibility 100, Best Practices 100, SEO 98
```

## The Animation Toolkit

Apex supports four animation libraries. Which to use depends on the pattern:

### GSAP 3.14

**Best for:** scroll-triggered animations, complex timelines, SVG animation

```typescript
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

gsap.to('.product-card', {
  scrollTrigger: {
    trigger: '.product-grid',
    start: 'top 80%',
    end: 'bottom 20%',
    scrub: 1,
  },
  opacity: 1,
  y: 0,
  stagger: 0.1,
});
```

### Framer Motion 12

**Best for:** component-level animations, React state transitions, gesture handling

```tsx
import { motion } from 'framer-motion';

<motion.div
  initial={{ opacity: 0, y: 20 }}
  whileInView={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.5 }}
  viewport={{ once: true }}
>
  Content
</motion.div>
```

### Lenis 1.x

**Best for:** smooth scroll across entire page

```typescript
import Lenis from 'lenis';

const lenis = new Lenis({
  duration: 1.2,
  easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
});

function raf(time: number) {
  lenis.raf(time);
  requestAnimationFrame(raf);
}
requestAnimationFrame(raf);
```

### CSS Scroll-Driven Animations

**Best for:** simple scroll effects with no JS (modern browsers only)

```css
@keyframes fade-in {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.card {
  animation: fade-in linear;
  animation-timeline: view();
  animation-range: entry 0% cover 30%;
}
```

### When to pick which

| Use case | Library |
|---|---|
| Scroll animations, scrub effects | GSAP + ScrollTrigger |
| Component state transitions | Framer Motion |
| Page-wide smooth scroll | Lenis |
| Simple scroll-based reveals, modern browsers | CSS Scroll-Driven |
| Complex interactive cursor effects | GSAP |
| Drag/pan/pinch gestures | Framer Motion |

## RTL / Bilingual Sites

If the user's audience uses RTL scripts (Arabic, Hebrew, Urdu, Persian, Dari), follow these rules (from CARL's DOCUMENT-CREATION + WEB-DEVELOPMENT domains).

### Never mix RTL and LTR in the same text run

Bad:
```tsx
<p>Welcome مرحبا to our site</p>
```

Good:
```tsx
<p>Welcome to our site</p>
<p dir="rtl">مرحبا بكم في موقعنا</p>
```

### Use logical CSS properties

Bad (breaks RTL):
```css
.button { margin-left: 1rem; }
```

Good (works both ways):
```css
.button { margin-inline-start: 1rem; }
```

Tailwind equivalents: `ms-4` instead of `ml-4`, `me-4` instead of `mr-4`.

### Set `dir` on the `<html>` or section

```html
<html lang="ar" dir="rtl">
```

Or per-section:
```tsx
<section dir="rtl" lang="ar">
  <!-- Arabic content -->
</section>
<section dir="ltr" lang="en">
  <!-- English content -->
</section>
```

### Mirror directional animations

Slide-in-from-left should slide-in-from-right in RTL. Use CSS logical properties:
```css
@keyframes slide-in {
  from { transform: translateX(-100%); }
  to   { transform: translateX(0); }
}

[dir="rtl"] .slide-in {
  animation-direction: reverse;
}
```

### Test both directions

```
> screenshot the LTR version
> then set dir="rtl" and screenshot again
```

Playwright MCP can automate this.

## Playwright Verification Workflow

### Standard verification checklist

After any UI change:

```
1. npm run build        → zero errors, zero warnings
2. Screenshot 1920x1080 → desktop check
3. Screenshot 768x1024  → tablet check
4. Screenshot 375x667   → mobile check
5. Playwright: tab through all interactive elements → keyboard accessible
6. Playwright: Lighthouse audit → ≥90 on Performance/A11y/SEO
7. Playwright: prefers-reduced-motion test → animations disabled when set
```

### Example Playwright verification

```typescript
import { test, expect } from '@playwright/test';

test('landing page premium quality', async ({ page }) => {
  await page.goto('/');
  
  // Build integrity
  await expect(page.locator('main')).toBeVisible();
  
  // Responsive
  await page.setViewportSize({ width: 375, height: 667 });
  await page.screenshot({ path: 'landing-mobile.png', fullPage: true });
  
  await page.setViewportSize({ width: 1920, height: 1080 });
  await page.screenshot({ path: 'landing-desktop.png', fullPage: true });
  
  // Keyboard accessibility
  await page.keyboard.press('Tab');
  const focused = await page.evaluate(() => document.activeElement?.tagName);
  expect(focused).toBeTruthy();
  
  // Reduced motion
  await page.emulateMedia({ reducedMotion: 'reduce' });
  const animatedEl = page.locator('.hero-heading');
  const animationName = await animatedEl.evaluate(el => getComputedStyle(el).animationName);
  expect(animationName).toBe('none');
});
```

### Lighthouse via Playwright

```bash
npx lighthouse http://localhost:3000 --output=json --output-path=./lighthouse-report.json
```

Parse the JSON for Performance/A11y/SEO scores.

## Common Full-Stack Prompts

### "Build a landing page for X"

Activates: 21st-dev-magic → premium-web-design → impeccable → Playwright

### "Review my frontend"

Activates: code-reviewer + security-reviewer (parallel), impeccable for polish audit

### "Make this feel premium"

Activates: premium-web-design (apply missing animation patterns)

### "Audit accessibility"

Activates: `seo-visual` + impeccable (WCAG compliance check)

### "Deploy this to Vercel"

Activates: DEPLOYMENT CARL domain (6 rules: git add specific, commit, push, --prod, alias set, verify screenshot)

## Full-Stack Workflow Example

Building a new feature end to end:

```
1. /deep-interview "Add a checkout flow"
   → clarifies scope, generates spec

2. /paul:plan
   → 5 phases: Schema, API, UI, Payment, Tests

3. /paul:apply
   → Phase 1: Schema (database-reviewer audits)
   → Phase 2: API (backend-dev + security-reviewer)
   → Phase 3: UI (21st-dev-magic + premium-web-design + impeccable)
   → Phase 4: Payment (security-reviewer deep audit)
   → Phase 5: Tests (tdd-guide + e2e-runner)

4. /paul:unify
   → Plan vs reality reconciled, lessons added to lessons.md

5. Deploy
   → DEPLOYMENT CARL rules fire
   → git add specific → commit → push → vercel --prod
   → vercel alias set (MANDATORY)
   → Playwright screenshot to verify production
```

## Pro Tips

- **Order matters: scaffold → animate → polish.** Don't try to scaffold with animations — the code gets tangled.
- **Graphify before large refactors.** 10-30× cheaper for "where does X live" navigation.
- **Respect prefers-reduced-motion always.** Every animation should check it.
- **Use Tailwind logical properties for RTL.** `ms-`, `me-`, `ps-`, `pe-` save pain later.
- **Don't over-animate.** 3-5 patterns per page is the sweet spot. More than that feels busy.
- **Screenshots after every change.** Playwright MCP makes this cheap; regression catches are priceless.
- **Check bundle size before shipping GSAP.** It's 50KB minified. Framer Motion is ~30KB. Use one, not both.

## Next Step

- [ADVANCED-TOKEN-OPTIMIZATION.md](./ADVANCED-TOKEN-OPTIMIZATION.md) — Cut token cost
- [ADVANCED-CUSTOMIZATION.md](./ADVANCED-CUSTOMIZATION.md) — Custom agents and skills
- [ADVANCED-MULTI-SESSION.md](./ADVANCED-MULTI-SESSION.md) — Multi-terminal workflows

---
*Claude Apex by Engineer Yousef Nabil — [GitHub](https://github.com/YousefNabil-SOC/claude-apex)*
