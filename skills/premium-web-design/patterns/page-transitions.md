# Page Transitions

## 1. Fade Between Routes

**Use case:** Smooth fade out/fade in when navigating between pages
**Deps:** framer-motion, react-router-dom (or Next.js)

### Implementation
```tsx
import { motion, AnimatePresence } from 'framer-motion';
import { useLocation } from 'react-router-dom';

interface FadeRouterProps {
  children: React.ReactNode;
  duration?: number;
  easing?: string;
}

export function FadeRouter({ 
  children, 
  duration = 0.5,
  easing = 'easeInOut'
}: FadeRouterProps) {
  const location = useLocation();

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key={location.pathname}
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        transition={{
          duration,
          ease: easing as any
        }}
      >
        {children}
      </motion.div>
    </AnimatePresence>
  );
}
```

### Props
```typescript
interface FadeRouterProps {
  children: React.ReactNode;
  duration?: number;        // Default: 0.5s
  easing?: string;          // 'easeInOut', 'easeIn', 'easeOut', 'linear'
}
```

**RTL:** No adjustments needed; opacity animation is direction-agnostic.
**Perf:** Minimal impact; uses opacity only (GPU composited).

---

## 2. Clip-Path Transition

**Use case:** Reveal new page through expanding circle or polygon clip-path from click position or center
**Deps:** framer-motion

### Implementation
```tsx
import { motion, AnimatePresence } from 'framer-motion';
import { useLocation } from 'react-router-dom';
import { useState, useCallback } from 'react';

interface ClipPathTransitionProps {
  children: React.ReactNode;
  shape?: 'circle' | 'polygon';
  originX?: number;  // 0-1, 0.5 = center
  originY?: number;  // 0-1, 0.5 = center
  duration?: number;
}

export function ClipPathTransition({
  children,
  shape = 'circle',
  originX = 0.5,
  originY = 0.5,
  duration = 0.8
}: ClipPathTransitionProps) {
  const location = useLocation();
  const [clipPath, setClipPath] = useState<string>('');

  const getClipPath = useCallback((progress: number) => {
    if (shape === 'circle') {
      const radius = Math.sqrt(2) * 100 * progress;
      return `circle(${radius}% at ${originX * 100}% ${originY * 100}%)`;
    }
    
    const size = 100 * progress;
    return `polygon(
      ${originX * 100 - size}% ${originY * 100 - size}%,
      ${originX * 100 + size}% ${originY * 100 - size}%,
      ${originX * 100 + size}% ${originY * 100 + size}%,
      ${originX * 100 - size}% ${originY * 100 + size}%
    )`;
  }, [shape, originX, originY]);

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key={location.pathname}
        initial={{ clipPath: getClipPath(0) }}
        animate={{ clipPath: getClipPath(1) }}
        exit={{ clipPath: getClipPath(0) }}
        transition={{ duration, ease: 'easeInOut' }}
        style={{ overflow: 'hidden' }}
      >
        {children}
      </motion.div>
    </AnimatePresence>
  );
}
```

### Props
```typescript
interface ClipPathTransitionProps {
  children: React.ReactNode;
  shape?: 'circle' | 'polygon';     // Default: 'circle'
  originX?: number;                  // 0-1, center = 0.5
  originY?: number;                  // 0-1, center = 0.5
  duration?: number;                 // Default: 0.8s
}
```

**RTL:** Adjust originX in RTL mode (pass 1 - originX for right-aligned origins).
**Perf:** Clip-path is GPU-accelerated but recalculation on every frame; use for special transitions only.

---

## 3. Shared Layout Animation

**Use case:** Morph elements between pages (e.g., clicked card expands to detail view), with smooth shared element transition
**Deps:** framer-motion, react-router-dom

### Implementation
```tsx
import { motion, AnimatePresence } from 'framer-motion';
import { useLocation } from 'react-router-dom';

interface SharedLayoutProps {
  children: React.ReactNode;
  layoutDependency?: string | number;
}

export function SharedLayoutPage({ 
  children, 
  layoutDependency 
}: SharedLayoutProps) {
  const location = useLocation();

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key={location.pathname}
        layoutId={layoutDependency}
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.95 }}
        transition={{
          layout: { type: 'spring', damping: 25, stiffness: 120 },
          opacity: { duration: 0.4 },
          scale: { duration: 0.4 }
        }}
      >
        {children}
      </motion.div>
    </AnimatePresence>
  );
}

interface SharedLayoutCardProps {
  id: string;
  onClick?: () => void;
  children: React.ReactNode;
}

export function SharedLayoutCard({ 
  id, 
  onClick, 
  children 
}: SharedLayoutCardProps) {
  return (
    <motion.div
      layoutId={id}
      onClick={onClick}
      className="cursor-pointer"
      transition={{ type: 'spring', damping: 25, stiffness: 120 }}
    >
      {children}
    </motion.div>
  );
}
```

### Usage Example
```tsx
// List page
<SharedLayoutCard id="card-1" onClick={() => navigate('/detail/1')}>
  <h3>Service Name</h3>
</SharedLayoutCard>

// Detail page
<SharedLayoutPage layoutDependency="card-1">
  <div layoutId="card-1">
    <h3>Service Name</h3>
    {/* expanded content */}
  </div>
</SharedLayoutPage>
```

### Props
```typescript
interface SharedLayoutProps {
  children: React.ReactNode;
  layoutDependency?: string | number;  // Shared layoutId for morphing
}

interface SharedLayoutCardProps {
  id: string;                           // Unique identifier for shared layout
  onClick?: () => void;                 // Navigation handler
  children: React.ReactNode;
}
```

**RTL:** Layout animations respect text direction automatically; no adjustments needed.
**Perf:** Spring physics CPU-intensive on low-end devices; test Core Web Vitals on mobile.
