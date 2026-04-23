# Scroll Animation Patterns

## 1. Fade-In on Scroll

**Use case:** Simple entrance animation as element enters viewport
**Deps:** `framer-motion` or `gsap`

### Framer Motion Version
```tsx
"use client"
import { useRef } from "react"
import { motion } from "framer-motion"

interface FadeInProps {
  children: React.ReactNode
  duration?: number
  delay?: number
}

export function FadeInOnScroll({ children, duration = 0.6, delay = 0 }: FadeInProps) {
  return (
    <motion.div
      initial={{ opacity: 0 }}
      whileInView={{ opacity: 1 }}
      transition={{ duration, delay }}
      viewport={{ once: true, margin: "-100px" }}
    >
      {children}
    </motion.div>
  )
}
```

### GSAP Version
```tsx
"use client"
import { useEffect, useRef } from "react"
import gsap from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"

gsap.registerPlugin(ScrollTrigger)

interface FadeInProps {
  children: React.ReactNode
  duration?: number
}

export function FadeInOnScroll({ children, duration = 0.6 }: FadeInProps) {
  const ref = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (!ref.current) return
    gsap.fromTo(
      ref.current,
      { opacity: 0 },
      {
        opacity: 1,
        duration,
        scrollTrigger: {
          trigger: ref.current,
          start: "top 80%",
          once: true,
        },
      }
    )
  }, [duration])

  return <div ref={ref}>{children}</div>
}
```

### Props
```typescript
interface FadeInProps {
  children: React.ReactNode
  duration?: number
  delay?: number
}
```

**RTL:** No transform changes needed — opacity is direction-agnostic
**Perf:** GPU-accelerated opacity changes; will-change: opacity in Tailwind utility

---

## 2. Staggered Reveal

**Use case:** List items, grid cells, or child elements appear one by one
**Deps:** `framer-motion` or `gsap`

### Framer Motion Version
```tsx
"use client"
import { motion } from "framer-motion"
import { ReactNode } from "react"

interface StaggeredRevealProps {
  children: ReactNode[]
  staggerDelay?: number
  duration?: number
}

export function StaggeredReveal({
  children,
  staggerDelay = 0.1,
  duration = 0.5,
}: StaggeredRevealProps) {
  const container = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: staggerDelay,
        delayChildren: 0.2,
      },
    },
  }

  const item = {
    hidden: { opacity: 0, y: 20 },
    visible: {
      opacity: 1,
      y: 0,
      transition: { duration },
    },
  }

  return (
    <motion.div
      variants={container}
      initial="hidden"
      whileInView="visible"
      viewport={{ once: true, margin: "-50px" }}
    >
      {Array.isArray(children) &&
        children.map((child, idx) => (
          <motion.div key={idx} variants={item}>
            {child}
          </motion.div>
        ))}
    </motion.div>
  )
}
```

### GSAP Version
```tsx
"use client"
import { useEffect, useRef } from "react"
import gsap from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"

gsap.registerPlugin(ScrollTrigger)

interface StaggeredRevealProps {
  children: React.ReactNode[]
  staggerDelay?: number
  duration?: number
}

export function StaggeredReveal({
  children,
  staggerDelay = 0.1,
  duration = 0.5,
}: StaggeredRevealProps) {
  const containerRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const items = containerRef.current?.querySelectorAll("[data-stagger-item]")
    if (!items) return

    gsap.fromTo(
      items,
      { opacity: 0, y: 20 },
      {
        opacity: 1,
        y: 0,
        duration,
        stagger: staggerDelay,
        scrollTrigger: {
          trigger: containerRef.current,
          start: "top 75%",
          once: true,
        },
      }
    )
  }, [staggerDelay, duration])

  return (
    <div ref={containerRef}>
      {Array.isArray(children) &&
        children.map((child, idx) => (
          <div key={idx} data-stagger-item>
            {child}
          </div>
        ))}
    </div>
  )
}
```

### Props
```typescript
interface StaggeredRevealProps {
  children: React.ReactNode[]
  staggerDelay?: number
  duration?: number
}
```

**RTL:** Y-offset is vertical; no RTL adjustment needed
**Perf:** Stagger property essential for performance — avoids simultaneous animations

---

## 3. Parallax Background

**Use case:** Background layer moves slower than foreground for depth
**Deps:** `framer-motion` with useScroll, or `gsap` ScrollTrigger

### Framer Motion Version
```tsx
"use client"
import { useScroll, useTransform, motion } from "framer-motion"
import { useRef } from "react"

interface ParallaxProps {
  children: React.ReactNode
  bgImage: string
  speed?: number
}

export function ParallaxBackground({ children, bgImage, speed = 0.5 }: ParallaxProps) {
  const ref = useRef<HTMLDivElement>(null)
  const { scrollYProgress } = useScroll({ target: ref })
  const y = useTransform(scrollYProgress, [0, 1], [0, 300 * speed])

  return (
    <div ref={ref} className="relative h-screen overflow-hidden">
      <motion.div
        style={{
          y,
          backgroundImage: `url(${bgImage})`,
          backgroundSize: "cover",
          backgroundPosition: "center",
        }}
        className="absolute inset-0 will-change-transform"
      />
      <div className="relative z-10">{children}</div>
    </div>
  )
}
```

### GSAP Version
```tsx
"use client"
import { useEffect, useRef } from "react"
import gsap from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"

gsap.registerPlugin(ScrollTrigger)

interface ParallaxProps {
  children: React.ReactNode
  bgImage: string
  speed?: number
}

export function ParallaxBackground({ children, bgImage, speed = 0.5 }: ParallaxProps) {
  const containerRef = useRef<HTMLDivElement>(null)
  const bgRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    gsap.to(bgRef.current, {
      y: () => window.innerHeight * speed,
      ease: "none",
      scrollTrigger: {
        trigger: containerRef.current,
        scrub: 1,
        start: "top top",
        end: "bottom top",
      },
    })
  }, [speed])

  return (
    <div ref={containerRef} className="relative h-screen overflow-hidden">
      <div
        ref={bgRef}
        style={{
          backgroundImage: `url(${bgImage})`,
          backgroundSize: "cover",
          backgroundPosition: "center",
        }}
        className="absolute inset-0 will-change-transform"
      />
      <div className="relative z-10">{children}</div>
    </div>
  )
}
```

### Props
```typescript
interface ParallaxProps {
  children: React.ReactNode
  bgImage: string
  speed?: number
}
```

**RTL:** Transform-Y is vertical — no directional change
**Perf:** Use will-change-transform; translate3d applied via CSS transforms

---

## 4. Horizontal Scroll Section

**Use case:** Vertical scroll drives horizontal card carousel
**Deps:** `gsap` with ScrollTrigger

### GSAP Version
```tsx
"use client"
import { useEffect, useRef } from "react"
import gsap from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"

gsap.registerPlugin(ScrollTrigger)

interface HorizontalScrollProps {
  children: React.ReactNode
  itemCount: number
}

export function HorizontalScrollSection({ children, itemCount }: HorizontalScrollProps) {
  const containerRef = useRef<HTMLDivElement>(null)
  const wrapperRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const wrapper = wrapperRef.current
    if (!wrapper) return

    const totalWidth = wrapper.scrollWidth
    const containerWidth = containerRef.current?.clientWidth || 0

    gsap.to(wrapper, {
      x: -(totalWidth - containerWidth),
      ease: "none",
      scrollTrigger: {
        trigger: containerRef.current,
        start: "top top",
        end: () => `+=${totalWidth - containerWidth}`,
        scrub: 1,
        pin: true,
        markers: false,
      },
    })

    return () => ScrollTrigger.getAll().forEach((t) => t.kill())
  }, [])

  return (
    <div ref={containerRef} className="relative w-full h-screen overflow-hidden">
      <div
        ref={wrapperRef}
        className="flex gap-6 w-max will-change-transform"
        style={{ direction: "ltr" }}
      >
        {children}
      </div>
    </div>
  )
}
```

### Props
```typescript
interface HorizontalScrollProps {
  children: React.ReactNode
  itemCount: number
}
```

**RTL:** Force direction: ltr for horizontal scroll; RTL aware via CSS logical properties
**Perf:** Pin creates performance cost; reduce item count on mobile via responsive wrapper

---

## 5. Scroll Progress Bar

**Use case:** Fixed top bar showing page scroll completion percentage
**Deps:** `framer-motion` with useScroll and useTransform

### Framer Motion Version
```tsx
"use client"
import { useScroll, useTransform, motion } from "framer-motion"

interface ScrollProgressProps {
  height?: number
  gradient?: boolean
}

export function ScrollProgressBar({ height = 3, gradient = true }: ScrollProgressProps) {
  const { scrollYProgress } = useScroll()
  const scaleX = useTransform(scrollYProgress, [0, 1], [0, 1])

  return (
    <motion.div
      className={`fixed top-0 left-0 right-0 z-50 origin-left will-change-transform ${
        gradient ? "bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500" : "bg-blue-600"
      }`}
      style={{
        scaleX,
        height: `${height}px`,
      }}
    />
  )
}
```

### Props
```typescript
interface ScrollProgressProps {
  height?: number
  gradient?: boolean
}
```

**RTL:** origin-left becomes origin-right in RTL; use logical CSS property
**Perf:** GPU-accelerated scaleX transform; minimal layout impact

---

## 6. Text Reveal Word-by-Word

**Use case:** Headlines or important text reveal progressively on scroll
**Deps:** `gsap` or `framer-motion`

### GSAP Version
```tsx
"use client"
import { useEffect, useRef } from "react"
import gsap from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"

gsap.registerPlugin(ScrollTrigger)

interface TextRevealProps {
  text: string
  className?: string
}

export function TextRevealWordByWord({ text, className = "" }: TextRevealProps) {
  const ref = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const words = ref.current?.querySelectorAll("span")
    if (!words) return

    gsap.fromTo(
      words,
      { opacity: 0.2 },
      {
        opacity: 1,
        duration: 0.4,
        stagger: 0.05,
        scrollTrigger: {
          trigger: ref.current,
          start: "top 75%",
          once: true,
        },
      }
    )
  }, [text])

  return (
    <div ref={ref} className={className}>
      {text.split(" ").map((word, idx) => (
        <span key={idx} className="inline-block">
          {word}&nbsp;
        </span>
      ))}
    </div>
  )
}
```

### Clip-Path Variant (Framer Motion)
```tsx
"use client"
import { motion } from "framer-motion"

interface TextRevealProps {
  text: string
  className?: string
}

export function TextRevealClipPath({ text, className = "" }: TextRevealProps) {
  return (
    <div className={className}>
      {text.split(" ").map((word, idx) => (
        <motion.span
          key={idx}
          initial={{ clipPath: "inset(0 100% 0 0)" }}
          whileInView={{ clipPath: "inset(0 0 0 0)" }}
          transition={{ duration: 0.5, delay: idx * 0.05 }}
          viewport={{ once: true }}
          className="inline-block"
        >
          {word}&nbsp;
        </motion.span>
      ))}
    </div>
  )
}
```

### Props
```typescript
interface TextRevealProps {
  text: string
  className?: string
}
```

**RTL:** Clip-path direction auto-adjusts with text direction; test with dir="rtl"
**Perf:** Clip-path has lower perf than opacity; use sparingly for hero text only

---

## 7. Scale on Scroll

**Use case:** Element grows from small to full size as it enters viewport
**Deps:** `framer-motion` or `gsap`

### Framer Motion Version
```tsx
"use client"
import { motion } from "framer-motion"

interface ScaleOnScrollProps {
  children: React.ReactNode
  initialScale?: number
  duration?: number
}

export function ScaleOnScroll({
  children,
  initialScale = 0.85,
  duration = 0.6,
}: ScaleOnScrollProps) {
  return (
    <motion.div
      initial={{ opacity: 0, scale: initialScale }}
      whileInView={{ opacity: 1, scale: 1 }}
      transition={{ duration, ease: "easeOut" }}
      viewport={{ once: true, margin: "-50px" }}
      className="will-change-transform"
    >
      {children}
    </motion.div>
  )
}
```

### Props
```typescript
interface ScaleOnScrollProps {
  children: React.ReactNode
  initialScale?: number
  duration?: number
}
```

**RTL:** Scale is non-directional
**Perf:** Use transform: scale for GPU acceleration; combine with opacity for richness

---

## 8. Sticky Section with Scroll-Driven Content

**Use case:** Section stays fixed while internal content animates in response to scroll
**Deps:** `gsap` ScrollTrigger

### GSAP Version
```tsx
"use client"
import { useEffect, useRef } from "react"
import gsap from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"

gsap.registerPlugin(ScrollTrigger)

interface StickyContentProps {
  sections: { id: string; content: React.ReactNode }[]
}

export function StickySectionWithContent({ sections }: StickyContentProps) {
  const containerRef = useRef<HTMLDivElement>(null)
  const contentRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const container = containerRef.current
    const content = contentRef.current
    if (!container || !content) return

    gsap.to(content, {
      y: () => -(content.scrollHeight - window.innerHeight),
      ease: "none",
      scrollTrigger: {
        trigger: container,
        start: "top top",
        end: `+=${sections.length * 500}`,
        scrub: 1,
        pin: true,
        markers: false,
      },
    })

    return () => ScrollTrigger.getAll().forEach((t) => t.kill())
  }, [sections.length])

  return (
    <div ref={containerRef} className="relative">
      <div ref={contentRef} className="will-change-transform">
        {sections.map((section) => (
          <section
            key={section.id}
            className="h-screen flex items-center justify-center"
          >
            {section.content}
          </section>
        ))}
      </div>
    </div>
  )
}
```

### Props
```typescript
interface StickyContentProps {
  sections: { id: string; content: React.ReactNode }[]
}
```

**RTL:** Y-transform (vertical) doesn't change
**Perf:** Pin property is expensive; use sparingly and test on mobile devices
