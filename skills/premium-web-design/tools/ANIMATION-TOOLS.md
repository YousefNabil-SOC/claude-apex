# Animation Tools & Techniques Reference

Quick-reference guide for production animation libraries and CSS techniques for luxury medical spa websites.

---

## GSAP 3.14 Core Patterns

### Scroll-Triggered Animations
```tsx
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

// Fade-in on scroll
gsap.to('.element', {
  scrollTrigger: {
    trigger: '.element',
    start: 'top 80%',
    end: 'top 20%',
    scrub: 1,
    markers: false
  },
  opacity: 1,
  duration: 0.8
});

// Parallax effect
gsap.to('.parallax-bg', {
  scrollTrigger: {
    trigger: '.parallax-section',
    scrub: 0.5
  },
  y: -100,
  ease: 'none'
});

// Count-up animation on scroll
gsap.to('.counter', {
  scrollTrigger: {
    trigger: '.counter',
    start: 'top 80%'
  },
  textContent: '1000',
  duration: 2,
  snap: { textContent: 1 }
});
```

### Timeline Sequencing
```tsx
const tl = gsap.timeline();

tl.to('.hero-title', { duration: 0.6, opacity: 1, y: 0 })
  .to('.hero-subtitle', { duration: 0.6, opacity: 1, y: 0 }, '-=0.3')
  .to('.cta-button', { duration: 0.6, opacity: 1, scale: 1 }, '-=0.3');

// Repeat timeline
tl.repeat(-1).yoyo(true);
```

### Advanced Easing
```tsx
// Custom ease: power2.inOut, back.out, elastic.out, bounce.out
gsap.to('.box', {
  duration: 1,
  x: 300,
  ease: 'power2.inOut'
});

// Custom bezier
gsap.to('.box', {
  duration: 1,
  x: 300,
  ease: 'custom(0, 0.8, 0.2, 1)'
});
```

**Perf:** GSAP is highly optimized; use for complex sequences and scroll timelines. Transform-only (GPU-accelerated).

---

## Motion v12 (formerly Framer Motion) Patterns

> **IMPORTANT:** Framer Motion was rebranded to **Motion** in mid-2025.
> Package: `motion` (not `framer-motion`). Import: `motion/react`.
> Install: `npm install motion`
> New in v12: hardware-accelerated scroll animations, oklch/oklab/lab/lch color animation,
> `layoutAnchor` prop, axis-locked layout animations (`layout="x"`, `layout="y"`).
> Motion+ (premium tier) adds magnetic cursors, infinite scrolling components.

### Variants & Lifecycle
```tsx
const variants = {
  hidden: { opacity: 0, y: 20 },
  visible: (index) => ({
    opacity: 1,
    y: 0,
    transition: {
      delay: index * 0.1,
      duration: 0.6
    }
  })
};

<motion.div
  initial="hidden"
  whileInView="visible"
  custom={0}
  variants={variants}
>
  Content
</motion.div>
```

### Drag & Gesture
```tsx
<motion.div
  drag
  dragConstraints={{ left: -100, right: 100, top: -50, bottom: 50 }}
  dragElastic={0.2}
  onDragEnd={(event, info) => {
    console.log(info.offset.x, info.velocity.x);
  }}
  whileHover={{ scale: 1.05 }}
  whileTap={{ scale: 0.95 }}
>
  Drag me
</motion.div>
```

### Exit Animations with AnimatePresence
```tsx
<AnimatePresence mode="wait">
  {isVisible && (
    <motion.div
      key="modal"
      initial={{ opacity: 0, scale: 0.8 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 0.8 }}
      transition={{ type: 'spring', damping: 25 }}
    >
      Modal content
    </motion.div>
  )}
</AnimatePresence>
```

### Stagger Container
```tsx
const container = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
      delayChildren: 0.2
    }
  }
};

const item = {
  hidden: { opacity: 0, y: 20 },
  visible: { opacity: 1, y: 0 }
};

<motion.ul variants={container} initial="hidden" animate="visible">
  {items.map((item) => (
    <motion.li key={item} variants={item}>
      {item}
    </motion.li>
  ))}
</motion.ul>
```

**Perf:** Spring physics CPU-intensive; test on low-end devices. Use `type: "tween"` for performance-critical animations.

---

## CSS Scroll-Driven Animations (Native)

Zero-JS scroll animations running on the compositor thread. Production-ready in Chrome 115+, Safari 18+ (Sep 2025), Firefox partial behind flag.

### scroll() Timeline — Animate Based on Scroll Position
```css
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}

.scroll-reveal {
  animation: fadeIn linear both;
  animation-timeline: scroll(root block);
  animation-range: entry 0% entry 40%;
}
```

### view() Timeline — Animate When Element Enters Viewport
```css
@keyframes slideUp {
  from { opacity: 0; transform: translateY(40px); }
  to { opacity: 1; transform: translateY(0); }
}

.reveal-on-view {
  animation: slideUp ease-out both;
  animation-timeline: view();
  animation-range: entry 0% entry 100%;
}
```

### Parallax with CSS Only
```css
.parallax-layer {
  animation: parallax linear both;
  animation-timeline: scroll();
}

@keyframes parallax {
  from { transform: translateY(0); }
  to { transform: translateY(-100px); }
}
```

### Progress Bar (Zero JS)
```css
.progress-bar {
  position: fixed;
  top: 0;
  left: 0;
  height: 3px;
  background: #C9A035;
  transform-origin: left;
  animation: progressGrow linear both;
  animation-timeline: scroll(root);
}

@keyframes progressGrow {
  from { transform: scaleX(0); }
  to { transform: scaleX(1); }
}
```

### Progressive Enhancement Pattern
```css
/* Fallback: elements visible by default */
.reveal { opacity: 1; }

/* Enhancement: only animate when supported */
@supports (animation-timeline: view()) {
  .reveal {
    opacity: 0;
    animation: fadeIn ease-out both;
    animation-timeline: view();
    animation-range: entry 10% entry 60%;
  }
}
```

**Perf:** Compositor-thread only. Never blocks main thread, never causes layout recalc. Always 60fps even during heavy JS. Use for simple reveal/fade/parallax. Use GSAP/Motion for complex sequences.

**When to use CSS vs JS:**
- CSS scroll animations: simple reveals, parallax, progress bars, fade-ins
- GSAP ScrollTrigger: complex timelines, pinning, scrubbing, staggered sequences
- Motion (Framer): component-level animations, gestures, exit animations, spring physics

---

## Lenis Smooth Scrolling

### Setup
```tsx
import Lenis from '@studio-freight/lenis';

useEffect(() => {
  const lenis = new Lenis({
    duration: 1.2,
    easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
    direction: 'vertical',
    gestureDirection: 'vertical',
    smooth: true,
    mouseMultiplier: 1,
    smoothTouch: false,
    touchMultiplier: 2,
    infinite: false
  });

  function raf(time) {
    lenis.raf(time);
    requestAnimationFrame(raf);
  }

  requestAnimationFrame(raf);

  return () => lenis.destroy();
}, []);
```

### Integration with GSAP
```tsx
import { useGSAP } from '@gsap/react';

useGSAP(() => {
  ScrollTrigger.create({
    onUpdate: (self) => {
      lenis.scrollTo(window.scrollY + self.getVelocity(), {
        duration: 1
      });
    }
  });
});
```

**Perf:** Smooth scroll adds ~2-3% overhead. Disable on low-end mobile if needed.

---

## CSS-Only Techniques

### Keyframe Animation
```css
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.element {
  animation: fadeInUp 0.6s ease-out forwards;
}
```

### Cubic Bezier Easing
```css
/* Common easings */
.ease-in-out: cubic-bezier(0.4, 0, 0.2, 1); /* Smooth */
.ease-out: cubic-bezier(0.0, 0, 0.2, 1);    /* Fast start */
.ease-in: cubic-bezier(0.4, 0, 1, 1);       /* Slow start */

.element {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
```

### GPU-Accelerated Properties
```css
/* FAST: Hardware-accelerated */
.element {
  transition: transform 0.3s, opacity 0.3s;
  will-change: transform, opacity;
}

/* SLOW: Layout recalc */
/* Avoid: width, height, left, right, top, bottom, margin, padding */
```

### Clip-Path Animations
```css
@keyframes reveal {
  from {
    clip-path: circle(0% at 50% 50%);
  }
  to {
    clip-path: circle(100% at 50% 50%);
  }
}

.element {
  animation: reveal 0.8s ease-out;
}
```

### Filter Blur Transition
```css
.image-blur {
  filter: blur(8px);
  transition: filter 0.6s ease-out;
}

.image-blur.loaded {
  filter: blur(0px);
}
```

**Perf:** CSS animations are GPU-native and faster than JS. Use for simple, declarative animations.

---

## 21st.dev Integration

### Shadcn/UI Motion Components
```tsx
import { Button } from '@/components/ui/button';
import { motion } from 'framer-motion';

export function AnimatedButton() {
  return (
    <motion.div
      whileHover={{ scale: 1.05 }}
      whileTap={{ scale: 0.95 }}
    >
      <Button>Click me</Button>
    </motion.div>
  );
}
```

### Magic UI Animated Gradient
```tsx
// Import from 21st.dev Magic UI
import { AnimatedGradientText } from '@/components/magic-ui/animated-gradient';

export function GradientTitle() {
  return (
    <AnimatedGradientText>
      Where Science Meets Beauty
    </AnimatedGradientText>
  );
}
```

### Spotlight Effect
```tsx
// Spotlight follows cursor
import { Spotlight } from '@/components/magic-ui/spotlight';

export function SpotlightHero() {
  return (
    <div className="relative">
      <Spotlight className="blur-3xl" size={80} />
      <h1>Luxury Medical Spa</h1>
    </div>
  );
}
```

---

## Performance Guidelines

### Do's
- Use `transform`, `opacity`, `filter` only
- Leverage GPU compositing with `will-change`
- Batch DOM reads/writes with `requestAnimationFrame`
- Memoize animated components with `React.memo`
- Use `useCallback` for event handlers in animations
- Test Core Web Vitals with DevTools Performance tab

### Don'ts
- Animate `width`, `height`, `position` properties
- Use `setInterval` for animations (prefer `requestAnimationFrame`)
- Animate too many elements simultaneously (stagger instead)
- Forget `pointer-events: none` on overlay animations
- Ignore Lighthouse performance scores

### Mobile Optimization
```tsx
// Detect low-end device and reduce animations
const prefersReducedMotion = window.matchMedia(
  '(prefers-reduced-motion: reduce)'
).matches;

const animationDuration = prefersReducedMotion ? 0 : 0.6;
```

### Production Checklist
- [ ] All animations use `transform` only
- [ ] Scroll animations have `scrub` on mobile (not continuous)
- [ ] AnimatePresence has `mode="wait"` to prevent layout shift
- [ ] Stagger delays < 0.2s per item
- [ ] Spring damping 20-30 (natural feel)
- [ ] Font rendering optimized (prefer `font-display: swap`)
- [ ] Image lazy loading enabled
- [ ] DevTools shows no jank (60fps target)

---

## Library Comparison

| Library | Use Case | Bundle Size | Learning Curve |
|---------|----------|------------|-----------------|
| **Motion v12** (was Framer Motion) | React component animations, drag, gestures, hw-accel scroll | ~50KB | Easy |
| **GSAP** | Complex timelines, scroll, advanced easing | ~40KB | Medium |
| **Lenis** | Smooth scrolling only | ~10KB | Very Easy |
| **CSS Scroll-Driven** | Native scroll/view animations, GPU-native | 0KB | Easy |
| **CSS Animations** | Simple fade/slide, GPU-native | 0KB | Easy |
| **Three.js** | 3D animations (avoid for 2D) | ~400KB | Hard |

---

## Medical Spa Color Palette Animation

### Gold Accent Pulse
```tsx
gsap.to('.accent-gold', {
  backgroundColor: '#C9A035',
  boxShadow: '0 0 30px rgba(201, 160, 53, 0.4)',
  duration: 2,
  repeat: -1,
  yoyo: true
});
```

### Navy Gradient Shift
```tsx
const gradient = [
  'linear-gradient(135deg, #0D1B3E, #1A2952)',
  'linear-gradient(135deg, #1A2952, #0D1B3E)'
];

gsap.to('.nav-bg', {
  backgroundImage: (i) => gradient[i % 2],
  duration: 4,
  repeat: -1
});
```

### Beige Fade Entrance
```tsx
<motion.div
  initial={{ backgroundColor: '#F5F3F0' }}
  animate={{ backgroundColor: 'transparent' }}
  transition={{ duration: 1.5, delay: 0.3 }}
/>
```

---

## Browser Compatibility

- **Chrome/Edge**: Full support for all libraries
- **Safari**: Full support (test spring physics)
- **Firefox**: Full support
- **Mobile Safari**: Test GSAP ScrollTrigger (may need workaround)

Use `@supports` for graceful fallbacks:
```css
@supports (backdrop-filter: blur(10px)) {
  .glass-effect {
    backdrop-filter: blur(10px);
  }
}
```

---

## Summary

**Start here:** CSS animations + Framer Motion basic variants
**Scale up:** GSAP for scroll sequences, complex timelines
**Smooth UX:** Lenis for scroll feel, Spring physics for gestures
**Monitor:** Lighthouse Performance, DevTools Frame rate meter
**Deploy:** Always measure Core Web Vitals before production

---

## Free Design Utilities

Browser-based tools for generating textures, particles, and design assets. No installation needed.

### particles.casberry.in
Browser-based 3D particle generator for hero backgrounds and ambient effects. Export particle configurations as CSS/JS for integration into React components. Use for creating atmospheric hero sections with floating particles, starfields, or organic motion.

### grainrad.com
Grain and noise texture generator for premium background overlays. Adds depth and tactile quality that flat colors lack. Export as PNG/SVG overlay. Apply with CSS `mix-blend-mode: overlay` or `multiply` on top of gradient backgrounds.

```css
.premium-bg {
  position: relative;
}
.premium-bg::after {
  content: '';
  position: absolute;
  inset: 0;
  background: url('/textures/grain.png');
  mix-blend-mode: overlay;
  opacity: 0.3;
  pointer-events: none;
}
```

### freedesigntool.online
Miscellaneous design utilities including shadow generators, gradient builders, and color palette tools. Useful for quickly generating CSS values for box-shadow, background gradients, and color harmonies.

### endlesstools.io
Collection of micro design tools for specific tasks. Includes color converters, spacing calculators, and typography scale generators.

### relume.io
AI wireframing and component library. Generates website wireframes from text descriptions, exports to Figma and Webflow. Useful for rapid prototyping and layout exploration before coding. Not a code tool — use for design exploration, then implement with React + Tailwind.
