# zzstudio.design — Agency Site Reference

## Overview
- **Agency:** ZzStudio (by Abdul Mutakabar Ayaz / @ayzz.thedesigner)
- **URL:** zzstudio.design
- **Tagline:** "Immersive design + development for future-proof brands"
- **Clients:** 60+ companies across AI, SaaS, D2C
- **Booking:** cal.com/zz-studio-design/30min

## Layout Approach
- **Structure:** Portfolio-first, chronological project listing
- **Navigation:** Minimal horizontal header — "ZzStudio" brand + "Home" / "Contact" links
- **Hero:** Bold typographic statement + CTA ("Book a 30-min call")
- **Content:** Case studies as date-stamped entries with project name and category label
- **Approach:** Editorial split layout — sticky left panel with scrolling right content columns

## Color Scheme
- **Mode:** Dark mode (deep black/charcoal backgrounds)
- **Accent:** Acid/lime yellow-green for highlights and CTAs
- **Text:** White/light gray on dark backgrounds
- **Contrast strategy:** High contrast yellow-on-black for emphasis, muted grays for secondary info

## Typography
- **Headlines:** Huge display type (likely 60-80px+), creating visual dominance
- **Captions/meta:** Monospaced typeface for dates, categories, and labels
- **Hierarchy:** Extreme size contrast between headlines and body text
- **Weight:** Mix of bold display and light body for elegance

## Scroll Behavior
- **Expected patterns** (based on Ayzz's design philosophy):
  - Smooth scroll with momentum (Lenis-style)
  - Scroll-triggered case study reveals
  - Parallax depth on hero elements
  - Section-by-section storytelling progression

## Case Study Presentation
- **Format:** Date stamp + project name + category tag
- **Chronological order:** Most recent first (July 2025 back to March 2024)
- **Categories:** App Design, Web Design (with "Coming Soon" for upcoming work)
- **Portfolio entries observed:**
  - HOCL Labs — Luxury Skincare (3D bottle hero)
  - Fragile Base — Clothing Brand (editorial fashion)
  - Aesthetic Origins — Healthcare personal brand
  - Sunnakids — Kids storytelling app
  - Real Estate — Coming Soon

## Dark Mode Implementation
- **Strategy:** Dark-first (not a toggle — dark IS the brand)
- **Background:** Deep black/charcoal (#0a0a0a or similar)
- **Card/section backgrounds:** Slightly lighter dark (#111 or #161616) for depth
- **Text rendering:** Anti-aliased white text on dark, with font-smoothing for crispness
- **Imagery:** Device mockups on textured/grainy dark backgrounds

## Design Techniques

### Grain Textures
Background noise/grain overlays add tactile depth to flat dark sections. CSS implementation:
```css
.section-bg::after {
  content: '';
  position: absolute;
  inset: 0;
  background: url('/grain.png');
  mix-blend-mode: overlay;
  opacity: 0.15;
  pointer-events: none;
}
```

### Device Mockups
Large, high-fidelity device mockups (laptop, phone frames) showcasing work. Creates authority and context.

### Editorial Split Layout
Sticky left panel (brand/navigation) with independently scrolling right column (case studies). Implementation:
```tsx
<div className="flex min-h-screen">
  <aside className="sticky top-0 h-screen w-1/3 flex flex-col justify-between p-8">
    {/* Brand + nav */}
  </aside>
  <main className="w-2/3 p-8">
    {/* Scrolling case studies */}
  </main>
</div>
```

## Relevance to Luxury Medical / Wellness Brands
- **Dark mode sections** could work for dramatic before/after reveals or specialist introductions
- **Editorial split layout** excellent for service category browsing (services left, details right)
- **Grain textures** add premium tactile quality to any gold/navy or dark-accent palette
- **Monospace meta text** useful for appointment dates, clinic hours, subtle data
- **Huge typography** for hero taglines (e.g. "Where Science Meets Beauty")

## Key Takeaways
1. Dark mode creates drama and luxury feel — use for key sections, not entire site
2. Acid accent color on dark = instant visual punch — in a luxury medical palette, gold-on-navy achieves the same effect
3. Minimal navigation builds confidence — let the work (or services) speak
4. Chronological case studies pattern = great for "Our Results" or blog sections
5. Device mockups add credibility — show the booking interface or patient portal in context
