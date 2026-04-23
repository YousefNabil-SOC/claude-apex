# Hero Section Patterns

## 1. Full-Screen Text Reveal

**Use case:** Dramatic headline entrance with staggered subheadline and CTA
**Deps:** `framer-motion` or `gsap`

### Framer Motion Version
```tsx
"use client"
import { motion } from "framer-motion"

interface TextRevealHeroProps {
  headline: string
  subheadline: string
  cta?: string
  onCta?: () => void
}

export function TextRevealHero({
  headline,
  subheadline,
  cta,
  onCta,
}: TextRevealHeroProps) {
  const container = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: { staggerChildren: 0.2, delayChildren: 0.1 },
    },
  }

  const item = {
    hidden: { opacity: 0, y: 20, clipPath: "inset(0 0 100% 0)" },
    visible: {
      opacity: 1,
      y: 0,
      clipPath: "inset(0 0 0 0)",
      transition: { duration: 0.8, ease: "easeOut" },
    },
  }

  return (
    <section className="relative h-screen flex items-center justify-center overflow-hidden bg-gradient-to-b from-slate-900 to-slate-800">
      <motion.div
        variants={container}
        initial="hidden"
        animate="visible"
        className="text-center max-w-4xl px-6 z-10"
      >
        <motion.h1
          variants={item}
          className="text-6xl md:text-7xl font-light text-white mb-6 tracking-tight"
        >
          {headline}
        </motion.h1>
        <motion.p
          variants={item}
          className="text-xl md:text-2xl text-slate-300 mb-12 font-light"
        >
          {subheadline}
        </motion.p>
        {cta && (
          <motion.button
            variants={item}
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.98 }}
            onClick={onCta}
            className="px-8 py-4 bg-white text-slate-900 font-semibold rounded-lg hover:bg-slate-100 transition-colors"
          >
            {cta}
          </motion.button>
        )}
      </motion.div>
    </section>
  )
}
```

### Props
```typescript
interface TextRevealHeroProps {
  headline: string
  subheadline: string
  cta?: string
  onCta?: () => void
}
```

**RTL:** Text direction auto-follows document dir; clipPath works seamlessly with RTL
**Perf:** GPU-accelerated clip-path and y-transforms; stagger prevents layout thrashing

---

## 2. Video Background with Overlay

**Use case:** Autoplay muted video behind text with responsive fallback
**Deps:** None (native HTML5 video)

### React Component
```tsx
"use client"
import { useRef, useEffect, useState } from "react"

interface VideoHeroProps {
  videoSrc: string
  fallbackImage: string
  headline: string
  subheadline: string
  overlayOpacity?: number
}

export function VideoBackgroundHero({
  videoSrc,
  fallbackImage,
  headline,
  subheadline,
  overlayOpacity = 0.4,
}: VideoHeroProps) {
  const videoRef = useRef<HTMLVideoElement>(null)
  const [videoLoaded, setVideoLoaded] = useState(false)

  useEffect(() => {
    if (videoRef.current) {
      videoRef.current.play().catch(() => {
        setVideoLoaded(false)
      })
    }
  }, [])

  return (
    <section className="relative h-screen w-full overflow-hidden">
      {/* Video background */}
      <video
        ref={videoRef}
        className={`absolute inset-0 w-full h-full object-cover transition-opacity duration-500 ${
          videoLoaded ? "opacity-100" : "opacity-0"
        }`}
        autoPlay
        muted
        loop
        playsInline
        onLoadedData={() => setVideoLoaded(true)}
      >
        <source src={videoSrc} type="video/mp4" />
      </video>

      {/* Fallback image */}
      <div
        className={`absolute inset-0 w-full h-full bg-cover bg-center transition-opacity duration-500 ${
          videoLoaded ? "opacity-0" : "opacity-100"
        }`}
        style={{ backgroundImage: `url(${fallbackImage})` }}
      />

      {/* Gradient overlay */}
      <div
        className="absolute inset-0 bg-gradient-to-b from-black/50 to-black/30"
        style={{ opacity: overlayOpacity }}
      />

      {/* Content */}
      <div className="relative z-10 h-full flex items-center justify-center px-6">
        <div className="text-center max-w-3xl">
          <h1 className="text-5xl md:text-6xl font-light text-white mb-4 tracking-tight">
            {headline}
          </h1>
          <p className="text-lg md:text-xl text-gray-200 font-light">
            {subheadline}
          </p>
        </div>
      </div>

      {/* Reduced motion support */}
      <style jsx>{`
        @media (prefers-reduced-motion: reduce) {
          video {
            animation: none;
          }
        }
      `}</style>
    </section>
  )
}
```

### Props
```typescript
interface VideoHeroProps {
  videoSrc: string
  fallbackImage: string
  headline: string
  subheadline: string
  overlayOpacity?: number
}
```

**RTL:** Flexbox centering auto-adjusts; text-center and background properties are RTL-safe
**Perf:** Video loading deferred; fallback image ready instantly; muted autoplay widely supported

---

## 3. Parallax Image Layers

**Use case:** Multiple image layers move at different speeds for depth perception
**Deps:** `framer-motion` with useScroll

### Framer Motion Version
```tsx
"use client"
import { useScroll, useTransform, motion } from "framer-motion"
import { useRef } from "react"

interface ParallaxLayerData {
  image: string
  speed: number
  zIndex: number
}

interface ParallaxHeroProps {
  layers: ParallaxLayerData[]
  headline: string
  overlayOpacity?: number
}

export function ParallaxImageHero({
  layers,
  headline,
  overlayOpacity = 0.3,
}: ParallaxHeroProps) {
  const ref = useRef<HTMLDivElement>(null)
  const { scrollYProgress } = useScroll({ target: ref })

  return (
    <div ref={ref} className="relative h-screen overflow-hidden">
      {layers.map((layer, idx) => {
        const y = useTransform(
          scrollYProgress,
          [0, 1],
          [0, 300 * layer.speed]
        )

        return (
          <motion.div
            key={idx}
            style={{
              y,
              backgroundImage: `url(${layer.image})`,
              backgroundSize: "cover",
              backgroundPosition: "center",
              zIndex: layer.zIndex,
            }}
            className="absolute inset-0 will-change-transform"
          />
        )
      })}

      {/* Overlay */}
      <div
        className="absolute inset-0 bg-black z-10"
        style={{ opacity: overlayOpacity }}
      />

      {/* Content */}
      <div className="absolute inset-0 z-20 flex items-center justify-center">
        <h1 className="text-5xl md:text-6xl font-light text-white text-center px-6">
          {headline}
        </h1>
      </div>
    </div>
  )
}
```

### Props
```typescript
interface ParallaxLayerData {
  image: string
  speed: number
  zIndex: number
}

interface ParallaxHeroProps {
  layers: ParallaxLayerData[]
  headline: string
  overlayOpacity?: number
}
```

**RTL:** No horizontal transforms; background centering works in all directions
**Perf:** will-change-transform applied; GPU acceleration on transform property

---

## 4. Animated Gradient Background

**Use case:** Slowly shifting gradient colors with no JavaScript overhead
**Deps:** None (pure CSS)

### CSS Animation Version
```tsx
"use client"

interface AnimatedGradientHeroProps {
  headline: string
  subheadline: string
  colors: [string, string, string, string]
}

export function AnimatedGradientHero({
  headline,
  subheadline,
  colors,
}: AnimatedGradientHeroProps) {
  const gradientStyle = {
    background: `linear-gradient(-45deg, ${colors[0]}, ${colors[1]}, ${colors[2]}, ${colors[3]})`,
    backgroundSize: "400% 400%",
    animation: "gradient 15s ease infinite",
  }

  return (
    <section
      className="relative h-screen w-full flex items-center justify-center overflow-hidden"
      style={gradientStyle}
    >
      <div className="text-center max-w-3xl px-6 z-10">
        <h1 className="text-5xl md:text-6xl font-light text-white mb-6 tracking-tight drop-shadow-lg">
          {headline}
        </h1>
        <p className="text-lg md:text-xl text-white/90 font-light drop-shadow">
          {subheadline}
        </p>
      </div>

      <style jsx>{`
        @keyframes gradient {
          0% {
            background-position: 0% 50%;
          }
          50% {
            background-position: 100% 50%;
          }
          100% {
            background-position: 0% 50%;
          }
        }

        @media (prefers-reduced-motion: reduce) {
          section {
            animation: none !important;
          }
        }
      `}</style>
    </section>
  )
}
```

### Props
```typescript
interface AnimatedGradientHeroProps {
  headline: string
  subheadline: string
  colors: [string, string, string, string]
}
```

**RTL:** No directional properties; works identically in all languages
**Perf:** Pure CSS animation; no JavaScript; respects prefers-reduced-motion; 60fps on most devices

---

## 5. Split-Screen (Image + Text)

**Use case:** Left image with animation, right text with staggered reveal; responsive stack
**Deps:** `framer-motion`

### Framer Motion Version
```tsx
"use client"
import { motion } from "framer-motion"

interface SplitScreenHeroProps {
  image: string
  headline: string
  subheadline: string
  cta?: string
  onCta?: () => void
}

export function SplitScreenHero({
  image,
  headline,
  subheadline,
  cta,
  onCta,
}: SplitScreenHeroProps) {
  const container = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: { staggerChildren: 0.15, delayChildren: 0.2 },
    },
  }

  const item = {
    hidden: { opacity: 0, y: 20 },
    visible: {
      opacity: 1,
      y: 0,
      transition: { duration: 0.6 },
    },
  }

  return (
    <section className="relative min-h-screen w-full flex">
      {/* Left: Image with animation */}
      <motion.div
        initial={{ opacity: 0, x: -100 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.8, ease: "easeOut" }}
        className="hidden md:flex md:w-1/2 overflow-hidden"
      >
        <div
          className="w-full h-screen bg-cover bg-center will-change-transform"
          style={{
            backgroundImage: `url(${image})`,
            backgroundAttachment: "fixed",
          }}
        />
      </motion.div>

      {/* Right: Text content with stagger */}
      <div className="w-full md:w-1/2 h-screen flex items-center px-8 md:px-12 bg-white dark:bg-slate-900">
        <motion.div
          variants={container}
          initial="hidden"
          animate="visible"
          className="max-w-lg"
        >
          <motion.h1
            variants={item}
            className="text-4xl md:text-5xl font-light text-slate-900 dark:text-white mb-4 tracking-tight"
          >
            {headline}
          </motion.h1>
          <motion.p
            variants={item}
            className="text-lg text-slate-600 dark:text-slate-300 mb-8 font-light leading-relaxed"
          >
            {subheadline}
          </motion.p>
          {cta && (
            <motion.button
              variants={item}
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.98 }}
              onClick={onCta}
              className="px-8 py-3 bg-slate-900 dark:bg-white text-white dark:text-slate-900 font-semibold rounded-lg hover:shadow-lg transition-shadow"
            >
              {cta}
            </motion.button>
          )}
        </motion.div>
      </div>

      {/* Mobile: Stack fallback */}
      <style jsx>{`
        @media (max-width: 768px) {
          section {
            flex-direction: column;
          }
        }
      `}</style>
    </section>
  )
}
```

### Props
```typescript
interface SplitScreenHeroProps {
  image: string
  headline: string
  subheadline: string
  cta?: string
  onCta?: () => void
}
```

**RTL:** Flex direction swaps automatically with dir="rtl"; image moves right in RTL; use logical CSS properties (inset-inline-start instead of left)
**Perf:** backgroundAttachment fixed can be expensive; test on mobile; consider removing for performance; x-transform uses GPU
