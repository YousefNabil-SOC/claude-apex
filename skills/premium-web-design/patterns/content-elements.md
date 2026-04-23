# Content Elements

## 1. Staggered Card Grid

**Use case:** Cards animate in sequentially as grid scrolls into view
**Deps:** framer-motion, react

### Implementation
```tsx
import { motion } from 'framer-motion';
import { useInView } from 'react-intersection-observer';

interface StaggeredCardGridProps {
  items: { id: string; title: string; description: string }[];
  columns?: number;
  staggerDelay?: number;
}

export function StaggeredCardGrid({
  items,
  columns = 3,
  staggerDelay = 0.1
}: StaggeredCardGridProps) {
  const { ref, inView } = useInView({ threshold: 0.1, triggerOnce: true });

  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: staggerDelay,
        delayChildren: 0.2
      }
    }
  };

  const itemVariants = {
    hidden: { opacity: 0, y: 20 },
    visible: {
      opacity: 1,
      y: 0,
      transition: { duration: 0.6, ease: 'easeOut' }
    }
  };

  return (
    <motion.div
      ref={ref}
      variants={containerVariants}
      initial="hidden"
      animate={inView ? 'visible' : 'hidden'}
      className={`grid gap-6 grid-cols-1 md:grid-cols-${columns === 2 ? '2' : columns === 4 ? '4' : '3'}`}
    >
      {items.map((item) => (
        <motion.div
          key={item.id}
          variants={itemVariants}
          className="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow"
        >
          <h3 className="text-lg font-semibold text-gray-900 mb-2">
            {item.title}
          </h3>
          <p className="text-gray-600">{item.description}</p>
        </motion.div>
      ))}
    </motion.div>
  );
}
```

### Props
```typescript
interface StaggeredCardGridProps {
  items: { id: string; title: string; description: string }[];
  columns?: number;                    // Default: 3
  staggerDelay?: number;               // Default: 0.1s
}
```

**RTL:** Apply `dir="rtl"` on parent; grid auto-reverses. Ensure items array order matches visual priority.
**Perf:** IntersectionObserver triggers animation once; uses transform only (GPU).

---

## 2. Counter Animation on Scroll

**Use case:** Numbers count from 0 to target value when element becomes visible
**Deps:** None (vanilla JS)

### Implementation
```tsx
import { useEffect, useRef, useState } from 'react';

interface CounterProps {
  target: number;
  duration?: number;
  suffix?: string;
  prefix?: string;
  decimals?: number;
}

export function Counter({
  target,
  duration = 2000,
  suffix = '',
  prefix = '',
  decimals = 0
}: CounterProps) {
  const [count, setCount] = useState(0);
  const ref = useRef<HTMLDivElement>(null);
  const hasAnimated = useRef(false);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting && !hasAnimated.current) {
          hasAnimated.current = true;
          let startTime: number;

          const animate = (timestamp: number) => {
            if (!startTime) startTime = timestamp;
            const elapsed = timestamp - startTime;
            const progress = Math.min(elapsed / duration, 1);
            const current = Math.floor(target * progress * Math.pow(10, decimals)) / Math.pow(10, decimals);

            setCount(current);

            if (progress < 1) {
              requestAnimationFrame(animate);
            }
          };

          requestAnimationFrame(animate);
        }
      },
      { threshold: 0.1 }
    );

    if (ref.current) {
      observer.observe(ref.current);
    }

    return () => observer.disconnect();
  }, [target, duration, decimals]);

  const formatted = count.toLocaleString('en-US', {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals
  });

  return (
    <div ref={ref} className="text-center">
      <span className="text-4xl font-bold text-[#C9A035]">
        {prefix}{formatted}{suffix}
      </span>
    </div>
  );
}
```

### Props
```typescript
interface CounterProps {
  target: number;                      // Final number to count to
  duration?: number;                   // Default: 2000ms
  suffix?: string;                     // e.g., '+', '%', 'K'
  prefix?: string;                     // e.g., '$'
  decimals?: number;                   // Default: 0
}
```

**RTL:** Text direction auto-applied via parent dir="rtl"; no component changes needed.
**Perf:** requestAnimationFrame-based; minimal paint impact. Runs once per mount.

---

## 3. Before/After Image Comparison Slider

**Use case:** Draggable divider reveals before/after images horizontally or vertically
**Deps:** framer-motion, react

### Implementation
```tsx
import { useState, useRef } from 'react';
import { motion } from 'framer-motion';

interface BeforeAfterProps {
  beforeSrc: string;
  afterSrc: string;
  orientation?: 'horizontal' | 'vertical';
  initialPosition?: number;
}

export function BeforeAfter({
  beforeSrc,
  afterSrc,
  orientation = 'horizontal',
  initialPosition = 50
}: BeforeAfterProps) {
  const [position, setPosition] = useState(initialPosition);
  const containerRef = useRef<HTMLDivElement>(null);

  const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    if (!containerRef.current) return;

    const rect = containerRef.current.getBoundingClientRect();
    if (orientation === 'horizontal') {
      const newPosition = ((e.clientX - rect.left) / rect.width) * 100;
      setPosition(Math.max(0, Math.min(100, newPosition)));
    } else {
      const newPosition = ((e.clientY - rect.top) / rect.height) * 100;
      setPosition(Math.max(0, Math.min(100, newPosition)));
    }
  };

  const handleTouchMove = (e: React.TouchEvent<HTMLDivElement>) => {
    if (!containerRef.current) return;

    const rect = containerRef.current.getBoundingClientRect();
    const touch = e.touches[0];
    if (orientation === 'horizontal') {
      const newPosition = ((touch.clientX - rect.left) / rect.width) * 100;
      setPosition(Math.max(0, Math.min(100, newPosition)));
    } else {
      const newPosition = ((touch.clientY - rect.top) / rect.height) * 100;
      setPosition(Math.max(0, Math.min(100, newPosition)));
    }
  };

  return (
    <div
      ref={containerRef}
      className="relative w-full overflow-hidden bg-gray-200 rounded-lg cursor-col-resize"
      onMouseMove={handleMouseMove}
      onTouchMove={handleTouchMove}
      style={{ aspectRatio: '16 / 9' }}
    >
      <img
        src={beforeSrc}
        alt="Before"
        className="absolute inset-0 w-full h-full object-cover"
      />

      <div
        className="absolute inset-0 overflow-hidden"
        style={{
          width: orientation === 'horizontal' ? `${position}%` : '100%',
          height: orientation === 'vertical' ? `${position}%` : '100%'
        }}
      >
        <img
          src={afterSrc}
          alt="After"
          className="absolute inset-0 w-full h-full object-cover"
        />
      </div>

      <motion.div
        className={`absolute ${
          orientation === 'horizontal'
            ? 'top-0 bottom-0 w-1 bg-white'
            : 'left-0 right-0 h-1 bg-white'
        }`}
        style={{
          [orientation === 'horizontal' ? 'left' : 'top']: `${position}%`
        }}
      >
        <div
          className={`absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 
            bg-white rounded-full shadow-lg w-12 h-12 flex items-center justify-center`}
        >
          <span className="text-gray-700 text-xs font-bold">DRAG</span>
        </div>
      </motion.div>
    </div>
  );
}
```

### Props
```typescript
interface BeforeAfterProps {
  beforeSrc: string;                   // Before image URL
  afterSrc: string;                    // After image URL
  orientation?: 'horizontal' | 'vertical';  // Default: 'horizontal'
  initialPosition?: number;            // 0-100, default: 50
}
```

**RTL:** In RTL context, swap beforeSrc/afterSrc or add logic to position divider from right. Consider cursor-col-resize vs cursor-ew-resize.
**Perf:** Clientside calculations only; no transforms. Smooth 60fps on desktop/mobile.

---

## 4. Testimonial Carousel with Swipe

**Use case:** Auto-rotating testimonials with touch swipe, pause on hover, dot indicators
**Deps:** framer-motion, react

### Implementation
```tsx
import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

interface Testimonial {
  id: string;
  name: string;
  text: string;
  rating: number;
  avatar?: string;
}

interface TestimonialCarouselProps {
  testimonials: Testimonial[];
  autoplayInterval?: number;
}

export function TestimonialCarousel({
  testimonials,
  autoplayInterval = 5000
}: TestimonialCarouselProps) {
  const [current, setCurrent] = useState(0);
  const [direction, setDirection] = useState(0);
  const [isPaused, setIsPaused] = useState(false);

  useEffect(() => {
    if (isPaused) return;

    const interval = setInterval(() => {
      setDirection(1);
      setCurrent((prev) => (prev + 1) % testimonials.length);
    }, autoplayInterval);

    return () => clearInterval(interval);
  }, [isPaused, autoplayInterval, testimonials.length]);

  const slideVariants = {
    enter: (dir: number) => ({
      x: dir > 0 ? 1000 : -1000,
      opacity: 0
    }),
    center: {
      zIndex: 1,
      x: 0,
      opacity: 1
    },
    exit: (dir: number) => ({
      zIndex: 0,
      x: dir < 0 ? 1000 : -1000,
      opacity: 0
    })
  };

  const handleDrag = (e: any, info: any) => {
    if (Math.abs(info.offset.x) > 50) {
      setDirection(info.offset.x > 0 ? -1 : 1);
      setCurrent(
        (prev) =>
          (prev + (info.offset.x > 0 ? -1 : 1) + testimonials.length) %
          testimonials.length
      );
    }
  };

  const testimonial = testimonials[current];

  return (
    <div
      className="w-full max-w-2xl mx-auto"
      onMouseEnter={() => setIsPaused(true)}
      onMouseLeave={() => setIsPaused(false)}
    >
      <div className="relative h-96 flex items-center justify-center overflow-hidden rounded-lg bg-gradient-to-b from-[#F5F3F0] to-white p-8">
        <AnimatePresence initial={false} custom={direction}>
          <motion.div
            key={current}
            custom={direction}
            variants={slideVariants}
            initial="enter"
            animate="center"
            exit="exit"
            transition={{ type: 'spring', stiffness: 300, damping: 30 }}
            drag="x"
            dragElastic={0.2}
            onDragEnd={handleDrag}
            className="absolute inset-0 flex flex-col items-center justify-center px-8"
          >
            {testimonial.avatar && (
              <img
                src={testimonial.avatar}
                alt={testimonial.name}
                className="w-16 h-16 rounded-full mb-4 object-cover"
              />
            )}

            <div className="flex items-center justify-center gap-1 mb-4">
              {[...Array(5)].map((_, i) => (
                <span
                  key={i}
                  className={`text-xl ${
                    i < testimonial.rating
                      ? 'text-[#C9A035]'
                      : 'text-gray-300'
                  }`}
                >
                  ★
                </span>
              ))}
            </div>

            <p className="text-center text-gray-700 text-lg mb-4 italic">
              "{testimonial.text}"
            </p>

            <p className="font-semibold text-gray-900">{testimonial.name}</p>
          </motion.div>
        </AnimatePresence>
      </div>

      <div className="flex justify-center gap-2 mt-6">
        {testimonials.map((_, idx) => (
          <motion.button
            key={idx}
            onClick={() => {
              setDirection(idx > current ? 1 : -1);
              setCurrent(idx);
            }}
            className={`w-3 h-3 rounded-full transition-colors ${
              idx === current ? 'bg-[#C9A035]' : 'bg-gray-300'
            }`}
            whileHover={{ scale: 1.2 }}
          />
        ))}
      </div>
    </div>
  );
}
```

### Props
```typescript
interface Testimonial {
  id: string;
  name: string;
  text: string;
  rating: number;              // 1-5
  avatar?: string;             // Avatar image URL
}

interface TestimonialCarouselProps {
  testimonials: Testimonial[];
  autoplayInterval?: number;   // Default: 5000ms
}
```

**RTL:** Swap drag direction logic (reverse dir values for RTL contexts).
**Perf:** AnimatePresence + single visible slide; minimal DOM. Spring animation smooth on all devices.

---

## 5. Accordion with Smooth Height

**Use case:** Expand/collapse sections with animated height, one-at-a-time optional
**Deps:** framer-motion, react

### Implementation
```tsx
import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

interface AccordionItem {
  id: string;
  title: string;
  content: React.ReactNode;
}

interface AccordionProps {
  items: AccordionItem[];
  allowMultiple?: boolean;
  defaultOpen?: string[];
}

export function Accordion({
  items,
  allowMultiple = false,
  defaultOpen = []
}: AccordionProps) {
  const [openItems, setOpenItems] = useState<Set<string>>(
    new Set(defaultOpen)
  );

  const toggleItem = (id: string) => {
    const newOpen = new Set(openItems);

    if (allowMultiple) {
      if (newOpen.has(id)) {
        newOpen.delete(id);
      } else {
        newOpen.add(id);
      }
    } else {
      newOpen.clear();
      if (!openItems.has(id)) {
        newOpen.add(id);
      }
    }

    setOpenItems(newOpen);
  };

  return (
    <div className="w-full border border-gray-200 rounded-lg divide-y">
      {items.map((item) => {
        const isOpen = openItems.has(item.id);

        return (
          <div key={item.id} className="overflow-hidden">
            <button
              onClick={() => toggleItem(item.id)}
              className="w-full px-6 py-4 text-left font-semibold text-gray-900 hover:bg-[#F5F3F0] transition-colors flex items-center justify-between"
            >
              <span>{item.title}</span>
              <motion.span
                animate={{ rotate: isOpen ? 180 : 0 }}
                transition={{ duration: 0.3 }}
                className="text-[#C9A035]"
              >
                ▼
              </motion.span>
            </button>

            <AnimatePresence initial={false}>
              {isOpen && (
                <motion.div
                  key={`content-${item.id}`}
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: 'auto' }}
                  exit={{ opacity: 0, height: 0 }}
                  transition={{ duration: 0.3, ease: 'easeInOut' }}
                >
                  <div className="px-6 py-4 bg-white text-gray-700 border-t border-gray-100">
                    {item.content}
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        );
      })}
    </div>
  );
}
```

### Props
```typescript
interface AccordionItem {
  id: string;
  title: string;
  content: React.ReactNode;
}

interface AccordionProps {
  items: AccordionItem[];
  allowMultiple?: boolean;               // Default: false (one at a time)
  defaultOpen?: string[];                // IDs of items open on mount
}
```

**RTL:** Icon rotation works in RTL; ensure parent has `dir="rtl"` for text direction.
**Perf:** Animated height using layout; avoid large content in many open items.

---

## 6. Blur-to-Sharp Image Lazy Load

**Use case:** Tiny blurred placeholder image sharpens when full image loads
**Deps:** None (vanilla CSS + JS)

### Implementation
```tsx
import { useState, useEffect, useRef } from 'react';

interface BlurToSharpProps {
  src: string;
  blurSrc: string;
  alt: string;
  width?: number;
  height?: number;
  onLoadComplete?: () => void;
}

export function BlurToSharp({
  src,
  blurSrc,
  alt,
  width,
  height,
  onLoadComplete
}: BlurToSharpProps) {
  const [isLoaded, setIsLoaded] = useState(false);
  const [isInView, setIsInView] = useState(false);
  const imgRef = useRef<HTMLImageElement>(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsInView(true);
          observer.disconnect();
        }
      },
      { threshold: 0.1 }
    );

    if (imgRef.current) {
      observer.observe(imgRef.current);
    }

    return () => observer.disconnect();
  }, []);

  useEffect(() => {
    if (!isInView) return;

    const img = new Image();
    img.onload = () => {
      setIsLoaded(true);
      onLoadComplete?.();
    };
    img.src = src;
  }, [isInView, src, onLoadComplete]);

  return (
    <div className="relative overflow-hidden bg-gray-100 rounded-lg" style={{ width, height }}>
      <img
        ref={imgRef}
        src={blurSrc}
        alt={alt}
        className={`absolute inset-0 w-full h-full object-cover transition-opacity duration-500 ${
          isLoaded ? 'opacity-0' : 'opacity-100'
        }`}
        style={{ filter: 'blur(20px)' }}
      />

      {isInView && (
        <img
          src={src}
          alt={alt}
          className={`absolute inset-0 w-full h-full object-cover transition-opacity duration-500 ${
            isLoaded ? 'opacity-100' : 'opacity-0'
          }`}
        />
      )}

      {!isLoaded && (
        <div className="absolute inset-0 bg-gradient-to-b from-transparent to-black/10" />
      )}
    </div>
  );
}
```

### Props
```typescript
interface BlurToSharpProps {
  src: string;                          // Full-quality image URL
  blurSrc: string;                      // Tiny blurred placeholder (LQIP)
  alt: string;                          // Image alt text (required for a11y)
  width?: number;                       // Container width
  height?: number;                      // Container height
  onLoadComplete?: () => void;          // Callback when full image loads
}
```

**RTL:** No directional adjustments needed; image display is direction-agnostic.
**Perf:** IntersectionObserver defers load until visible. Blur filter GPU-accelerated. Typical LQIP: <1KB.
