# Hover & Cursor Patterns

## 1. Magnetic Button Effect

**Use case:** Button follows cursor approach within radius, then snaps back with spring physics
**Deps:** `framer-motion` with useMotionValue and useTransform

### Framer Motion Version
```tsx
"use client"
import { useRef, useState } from "react"
import { motion, useMotionValue, useTransform } from "framer-motion"

interface MagneticButtonProps {
  label: string
  onClick?: () => void
  magneticRadius?: number
}

export function MagneticButton({
  label,
  onClick,
  magneticRadius = 100,
}: MagneticButtonProps) {
  const buttonRef = useRef<HTMLButtonElement>(null)
  const x = useMotionValue(0)
  const y = useMotionValue(0)

  const handleMouseMove = (e: React.MouseEvent<HTMLButtonElement>) => {
    if (!buttonRef.current) return

    const rect = buttonRef.current.getBoundingClientRect()
    const centerX = rect.left + rect.width / 2
    const centerY = rect.top + rect.height / 2

    const distance = Math.hypot(e.clientX - centerX, e.clientY - centerY)

    if (distance < magneticRadius) {
      x.set(e.clientX - centerX)
      y.set(e.clientY - centerY)
    }
  }

  const handleMouseLeave = () => {
    x.set(0)
    y.set(0)
  }

  return (
    <motion.button
      ref={buttonRef}
      onMouseMove={handleMouseMove}
      onMouseLeave={handleMouseLeave}
      style={{ x, y }}
      transition={{
        type: "spring",
        stiffness: 400,
        damping: 30,
        mass: 0.5,
      }}
      className="px-6 py-3 bg-slate-900 text-white font-semibold rounded-lg hover:shadow-lg active:scale-95 transition-shadow will-change-transform"
      onClick={onClick}
    >
      {label}
    </motion.button>
  )
}
```

### Props
```typescript
interface MagneticButtonProps {
  label: string
  onClick?: () => void
  magneticRadius?: number
}
```

**RTL:** Cursor tracking works in both directions; no direction-specific logic needed
**Perf:** useMotionValue prevents re-renders; spring physics GPU-accelerated via transform; magneticRadius scales based on interaction distance

---

## 2. Image Grayscale-to-Color on Hover

**Use case:** Image starts desaturated, animates to full color on hover
**Deps:** CSS filters or `framer-motion`

### CSS + Framer Motion Version
```tsx
"use client"
import { motion } from "framer-motion"

interface ColorRevealImageProps {
  src: string
  alt: string
  duration?: number
}

export function ColorRevealImage({
  src,
  alt,
  duration = 0.6,
}: ColorRevealImageProps) {
  return (
    <motion.div
      whileHover={{ filter: "grayscale(0%)" }}
      transition={{ duration, type: "tween" }}
      className="overflow-hidden rounded-lg"
      style={{
        filter: "grayscale(100%)",
      }}
    >
      <motion.img
        src={src}
        alt={alt}
        whileHover={{ scale: 1.05 }}
        transition={{ duration }}
        className="w-full h-auto block will-change-filter"
      />
    </motion.div>
  )
}
```

### Pure CSS Version with JS Enhancement
```tsx
"use client"
import { useState } from "react"

interface ColorRevealImageProps {
  src: string
  alt: string
  duration?: number
}

export function ColorRevealImageCSS({
  src,
  alt,
  duration = 0.6,
}: ColorRevealImageProps) {
  const [isHovering, setIsHovering] = useState(false)

  return (
    <style jsx>{`
      .image-container {
        overflow: hidden;
        border-radius: 0.5rem;
        filter: ${isHovering ? "grayscale(0%)" : "grayscale(100%)"};
        transition: filter ${duration}s ease-in-out;
      }

      .image-container img {
        display: block;
        width: 100%;
        height: auto;
        transition: transform ${duration}s ease-in-out;
      }

      .image-container:hover img {
        transform: scale(1.05);
      }

      @media (prefers-reduced-motion: reduce) {
        .image-container,
        .image-container img {
          transition: none;
        }
      }
    `}
    </style>
    <div
      className="image-container"
      onMouseEnter={() => setIsHovering(true)}
      onMouseLeave={() => setIsHovering(false)}
    >
      <img src={src} alt={alt} />
    </div>
  )
}
```

### Props
```typescript
interface ColorRevealImageProps {
  src: string
  alt: string
  duration?: number
}
```

**RTL:** Filter is non-directional; scale is symmetric; no RTL-specific changes needed
**Perf:** GPU-accelerated filter changes (grayscale is optimized in modern browsers); scale via transform; avoid animating opacity simultaneously

---

## 3. 3D Card Tilt

**Use case:** Card tilts in 3D space following cursor position with glare overlay effect
**Deps:** `framer-motion` or vanilla JavaScript with CSS transforms

### Vanilla JS + CSS Version
```tsx
"use client"
import { useRef, useState } from "react"

interface TiltCardProps {
  children: React.ReactNode
  maxTilt?: number
}

export function TiltCard({ children, maxTilt = 15 }: TiltCardProps) {
  const cardRef = useRef<HTMLDivElement>(null)
  const [rotation, setRotation] = useState({ x: 0, y: 0 })
  const [glarePos, setGlarePos] = useState({ x: 0, y: 0 })

  const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    if (!cardRef.current) return

    const rect = cardRef.current.getBoundingClientRect()
    const centerX = rect.left + rect.width / 2
    const centerY = rect.top + rect.height / 2

    const distX = (e.clientX - centerX) / (rect.width / 2)
    const distY = (e.clientY - centerY) / (rect.height / 2)

    setRotation({
      x: -distY * maxTilt,
      y: distX * maxTilt,
    })

    setGlarePos({
      x: ((e.clientX - rect.left) / rect.width) * 100,
      y: ((e.clientY - rect.top) / rect.height) * 100,
    })
  }

  const handleMouseLeave = () => {
    setRotation({ x: 0, y: 0 })
    setGlarePos({ x: 50, y: 50 })
  }

  return (
    <div
      style={{
        perspective: "1000px",
      }}
    >
      <div
        ref={cardRef}
        onMouseMove={handleMouseMove}
        onMouseLeave={handleMouseLeave}
        className="relative w-full rounded-lg bg-white shadow-lg p-8 transition-transform will-change-transform"
        style={{
          transform: `rotateX(${rotation.x}deg) rotateY(${rotation.y}deg)`,
          transformStyle: "preserve-3d",
          transition: "transform 0.1s ease-out",
        }}
      >
        {/* Card content */}
        <div style={{ transformZ: "50px" }}>{children}</div>

        {/* Glare overlay */}
        <div
          className="absolute inset-0 rounded-lg pointer-events-none opacity-0 will-change-transform"
          style={{
            background: `radial-gradient(circle at ${glarePos.x}% ${glarePos.y}%, rgba(255,255,255,0.8) 0%, transparent 50%)`,
            mixBlendMode: "screen",
            transition: "opacity 0.1s ease-out",
          }}
        />
      </div>
    </div>
  )
}
```

### Framer Motion Version (Advanced)
```tsx
"use client"
import { useRef, useState } from "react"
import { motion } from "framer-motion"

interface TiltCardProps {
  children: React.ReactNode
  maxTilt?: number
}

export function TiltCardMotion({ children, maxTilt = 15 }: TiltCardProps) {
  const cardRef = useRef<HTMLDivElement>(null)
  const [rotationX, setRotationX] = useState(0)
  const [rotationY, setRotationY] = useState(0)

  const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    if (!cardRef.current) return

    const rect = cardRef.current.getBoundingClientRect()
    const centerX = rect.left + rect.width / 2
    const centerY = rect.top + rect.height / 2

    const distX = (e.clientX - centerX) / (rect.width / 2)
    const distY = (e.clientY - centerY) / (rect.height / 2)

    setRotationX(-distY * maxTilt)
    setRotationY(distX * maxTilt)
  }

  return (
    <motion.div
      ref={cardRef}
      onMouseMove={handleMouseMove}
      onMouseLeave={() => {
        setRotationX(0)
        setRotationY(0)
      }}
      style={{
        perspective: "1000px",
      }}
      className="w-full"
    >
      <motion.div
        animate={{
          rotateX,
          rotateY,
        }}
        transition={{ type: "spring", stiffness: 300, damping: 30 }}
        className="relative rounded-lg bg-white shadow-lg p-8 will-change-transform"
        style={{
          transformStyle: "preserve-3d",
        }}
      >
        {children}
      </motion.div>
    </motion.div>
  )
}
```

### Props
```typescript
interface TiltCardProps {
  children: React.ReactNode
  maxTilt?: number
}
```

**RTL:** Tilt calculation is based on cursor distance from center; works identically in RTL layouts; no transform direction changes needed
**Perf:** Use will-change-transform; perspective parent essential for GPU acceleration; glare overlay uses mix-blend-mode (supported in all modern browsers); avoid on mobile or use touch-only variant

---

## 4. Custom Cursor Follower

**Use case:** Global custom cursor with spring-based lag effect, reacts to interactive elements
**Deps:** React Context, `framer-motion` useMotionValue

### Context + Provider Version
```tsx
"use client"
import { createContext, useContext, useRef, useEffect, useState } from "react"
import { motion, useMotionValue, useTransform } from "framer-motion"

interface CursorContextType {
  x: number
  y: number
}

const CursorContext = createContext<CursorContextType | null>(null)

export function CursorProvider({ children }: { children: React.ReactNode }) {
  const [position, setPosition] = useState({ x: 0, y: 0 })
  const [isVisible, setIsVisible] = useState(false)

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      setPosition({ x: e.clientX, y: e.clientY })
      setIsVisible(true)
    }

    const handleMouseLeave = () => {
      setIsVisible(false)
    }

    window.addEventListener("mousemove", handleMouseMove)
    document.addEventListener("mouseleave", handleMouseLeave)

    return () => {
      window.removeEventListener("mousemove", handleMouseMove)
      document.removeEventListener("mouseleave", handleMouseLeave)
    }
  }, [])

  return (
    <CursorContext.Provider value={position}>
      {children}
      {isVisible && <CursorFollower x={position.x} y={position.y} />}
    </CursorContext.Provider>
  )
}

interface CursorFollowerProps {
  x: number
  y: number
}

function CursorFollower({ x, y }: CursorFollowerProps) {
  const cursorX = useMotionValue(0)
  const cursorY = useMotionValue(0)

  const smoothX = useTransform(cursorX, [0, 100], [0, 100], {
    clamp: false,
  })
  const smoothY = useTransform(cursorY, [0, 100], [0, 100], {
    clamp: false,
  })

  useEffect(() => {
    cursorX.set(x - 10)
    cursorY.set(y - 10)
  }, [x, y, cursorX, cursorY])

  return (
    <motion.div
      style={{
        x: smoothX,
        y: smoothY,
      }}
      transition={{
        type: "spring",
        stiffness: 100,
        damping: 25,
        mass: 0.5,
      }}
      className="pointer-events-none fixed w-5 h-5 rounded-full border-2 border-slate-900 z-50 will-change-transform"
    />
  )
}

export function useCursor() {
  const context = useContext(CursorContext)
  if (!context) {
    throw new Error("useCursor must be used within CursorProvider")
  }
  return context
}
```

### Enhanced Version with Click Feedback
```tsx
"use client"
import { createContext, useContext, useRef, useEffect, useState } from "react"
import { motion, useMotionValue } from "framer-motion"

interface EnhancedCursorContextType {
  isHovering: boolean
  isClicking: boolean
}

const EnhancedCursorContext = createContext<EnhancedCursorContextType | null>(
  null
)

export function EnhancedCursorProvider({
  children,
}: {
  children: React.ReactNode
}) {
  const [position, setPosition] = useState({ x: 0, y: 0 })
  const [isVisible, setIsVisible] = useState(false)
  const [isHovering, setIsHovering] = useState(false)
  const [isClicking, setIsClicking] = useState(false)
  const cursorX = useMotionValue(0)
  const cursorY = useMotionValue(0)

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      setPosition({ x: e.clientX, y: e.clientY })
      cursorX.set(e.clientX - 10)
      cursorY.set(e.clientY - 10)
      setIsVisible(true)

      const target = e.target as HTMLElement
      const isInteractive =
        target.matches("button, a, input, [data-interactive]") ||
        target.closest("button, a, input, [data-interactive]")
      setIsHovering(!!isInteractive)
    }

    const handleMouseDown = () => setIsClicking(true)
    const handleMouseUp = () => setIsClicking(false)
    const handleMouseLeave = () => setIsVisible(false)

    window.addEventListener("mousemove", handleMouseMove)
    window.addEventListener("mousedown", handleMouseDown)
    window.addEventListener("mouseup", handleMouseUp)
    document.addEventListener("mouseleave", handleMouseLeave)

    return () => {
      window.removeEventListener("mousemove", handleMouseMove)
      window.removeEventListener("mousedown", handleMouseDown)
      window.removeEventListener("mouseup", handleMouseUp)
      document.removeEventListener("mouseleave", handleMouseLeave)
    }
  }, [cursorX, cursorY])

  return (
    <EnhancedCursorContext.Provider value={{ isHovering, isClicking }}>
      {children}
      {isVisible && (
        <motion.div
          style={{
            x: cursorX,
            y: cursorY,
          }}
          transition={{
            type: "spring",
            stiffness: 100,
            damping: 25,
          }}
          className={`pointer-events-none fixed w-5 h-5 rounded-full z-50 will-change-transform ${
            isClicking
              ? "scale-75 bg-slate-900/50"
              : isHovering
                ? "scale-150 border-2 border-slate-900"
                : "border-2 border-slate-900"
          }`}
          animate={{
            scale: isClicking ? 0.75 : isHovering ? 1.5 : 1,
          }}
        />
      )}
    </EnhancedCursorContext.Provider>
  )
}

export function useEnhancedCursor() {
  const context = useContext(EnhancedCursorContext)
  if (!context) {
    throw new Error(
      "useEnhancedCursor must be used within EnhancedCursorProvider"
    )
  }
  return context
}
```

### Usage Example
```tsx
// In your root layout
import { CursorProvider } from "@/components/CursorFollower"

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html>
      <body>
        <CursorProvider>{children}</CursorProvider>
      </body>
    </html>
  )
}

// In interactive elements
<button data-interactive>Click me</button>
```

### Props & Context
```typescript
interface CursorContextType {
  x: number
  y: number
}

interface EnhancedCursorContextType {
  isHovering: boolean
  isClicking: boolean
}
```

**RTL:** Cursor position is absolute from viewport edge; no RTL adjustment needed; works identically in both directions
**Perf:** useMotionValue prevents re-renders on every mouse move; spring physics GPU-accelerated; hide cursor on mobile via media query; set `pointer-events-none` to prevent blocking interactions
