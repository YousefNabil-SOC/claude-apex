# Navigation Patterns

## 1. Transparent-to-Solid on Scroll

**Use case:** Nav bar fades in background color after scrolling past hero
**Deps:** `framer-motion` with useScroll and useTransform

### Framer Motion Version
```tsx
"use client"
import { useScroll, useTransform, motion } from "framer-motion"

interface NavBar {
  links: { label: string; href: string }[]
  scrollThreshold?: number
  bgColor?: string
}

export function TransparentNav({
  links,
  scrollThreshold = 100,
  bgColor = "white",
}: NavBar) {
  const { scrollY } = useScroll()
  const opacity = useTransform(scrollY, [0, scrollThreshold], [0, 1])
  const bgOpacity = useTransform(scrollY, [0, scrollThreshold], ["rgba(255,255,255,0)", `rgba(255,255,255,1)`])

  return (
    <motion.nav
      className="fixed top-0 left-0 right-0 z-50 px-6 py-4 md:px-12 md:py-6 backdrop-blur-sm"
      style={{
        backgroundColor: bgOpacity,
        boxShadow: opacity,
      }}
    >
      <div className="max-w-7xl mx-auto flex items-center justify-between">
        <div className="text-xl font-light text-slate-900">Logo</div>
        <ul className="hidden md:flex gap-8">
          {links.map((link) => (
            <li key={link.href}>
              <a
                href={link.href}
                className="text-slate-700 hover:text-slate-900 transition-colors text-sm font-medium"
              >
                {link.label}
              </a>
            </li>
          ))}
        </ul>
      </div>
    </motion.nav>
  )
}
```

### Props
```typescript
interface NavBar {
  links: { label: string; href: string }[]
  scrollThreshold?: number
  bgColor?: string
}
```

**RTL:** Flex direction auto-reverses with dir="rtl"; text direction handled by browser
**Perf:** backdrop-blur-sm has performance cost; test on mobile; useTransform is GPU-accelerated

---

## 2. Full-Screen Hamburger Overlay

**Use case:** Mobile menu as full-screen overlay with animated link stagger
**Deps:** `framer-motion`

### React Component
```tsx
"use client"
import { useState, useEffect } from "react"
import { AnimatePresence, motion } from "framer-motion"

interface MobileNavProps {
  links: { label: string; href: string }[]
}

export function HamburgerNav({ links }: MobileNavProps) {
  const [isOpen, setIsOpen] = useState(false)

  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = "hidden"
    } else {
      document.body.style.overflow = "unset"
    }
    return () => {
      document.body.style.overflow = "unset"
    }
  }, [isOpen])

  const menuVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.08,
        delayChildren: 0.1,
      },
    },
    exit: {
      opacity: 0,
      transition: {
        staggerChildren: 0.05,
        staggerDirection: -1,
      },
    },
  }

  const itemVariants = {
    hidden: { opacity: 0, x: -20 },
    visible: {
      opacity: 1,
      x: 0,
      transition: { duration: 0.4 },
    },
    exit: {
      opacity: 0,
      x: -20,
    },
  }

  return (
    <>
      {/* Fixed hamburger button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="fixed top-6 right-6 z-50 md:hidden flex flex-col gap-1.5 w-6 h-6"
        aria-label="Toggle menu"
      >
        <motion.span
          animate={isOpen ? { rotate: 45, y: 11 } : { rotate: 0, y: 0 }}
          className="w-full h-0.5 bg-slate-900 block origin-center"
          transition={{ type: "spring", stiffness: 300, damping: 30 }}
        />
        <motion.span
          animate={isOpen ? { opacity: 0 } : { opacity: 1 }}
          className="w-full h-0.5 bg-slate-900"
          transition={{ duration: 0.2 }}
        />
        <motion.span
          animate={isOpen ? { rotate: -45, y: -11 } : { rotate: 0, y: 0 }}
          className="w-full h-0.5 bg-slate-900 block origin-center"
          transition={{ type: "spring", stiffness: 300, damping: 30 }}
        />
      </button>

      {/* Full-screen overlay menu */}
      <AnimatePresence>
        {isOpen && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.2 }}
              onClick={() => setIsOpen(false)}
              className="fixed inset-0 bg-black/50 z-40 md:hidden"
            />
            <motion.div
              variants={menuVariants}
              initial="hidden"
              animate="visible"
              exit="exit"
              className="fixed inset-0 z-40 md:hidden bg-white flex flex-col items-center justify-center gap-8"
            >
              {links.map((link) => (
                <motion.a
                  key={link.href}
                  href={link.href}
                  variants={itemVariants}
                  onClick={() => setIsOpen(false)}
                  className="text-2xl font-light text-slate-900 hover:text-slate-600 transition-colors"
                >
                  {link.label}
                </motion.a>
              ))}
            </motion.div>
          </>
        )}
      </AnimatePresence>

      {/* Desktop nav (always visible) */}
      <nav className="hidden md:flex fixed top-0 left-0 right-0 z-50 px-12 py-6 bg-white/95 backdrop-blur-sm">
        <div className="max-w-7xl mx-auto w-full flex items-center justify-between">
          <div className="text-lg font-light">Logo</div>
          <ul className="flex gap-8">
            {links.map((link) => (
              <li key={link.href}>
                <a
                  href={link.href}
                  className="text-slate-700 hover:text-slate-900 transition-colors text-sm font-medium"
                >
                  {link.label}
                </a>
              </li>
            ))}
          </ul>
        </div>
      </nav>
    </>
  )
}
```

### Props
```typescript
interface MobileNavProps {
  links: { label: string; href: string }[]
}
```

**RTL:** flex-col stacks vertically; x-offset reverses automatically with dir="rtl"
**Perf:** AnimatePresence prevents ghost renders; body scroll lock prevents layout shift

---

## 3. Animated Underline Links

**Use case:** Link underline slides in on hover from left
**Deps:** CSS only or Framer Motion for enhanced

### CSS-Only Version
```tsx
export function NavLinkWithUnderline() {
  return (
    <style jsx>{`
      .nav-link {
        position: relative;
        color: #374151;
        text-decoration: none;
        font-weight: 500;
        font-size: 0.875rem;
        transition: color 0.3s ease;
      }

      .nav-link::after {
        content: "";
        position: absolute;
        bottom: -4px;
        left: 0;
        width: 100%;
        height: 2px;
        background-color: #1f2937;
        transform: scaleX(0);
        transform-origin: left;
        transition: transform 0.3s ease;
      }

      .nav-link:hover {
        color: #1f2937;
      }

      .nav-link:hover::after {
        transform: scaleX(1);
      }

      .nav-link.active::after {
        transform: scaleX(1);
        background-color: #0d1b3e;
      }
    `}</style>
  )
}

interface NavProps {
  links: { label: string; href: string; active?: boolean }[]
}

export function NavWithUnderlines({ links }: NavProps) {
  return (
    <nav className="flex gap-8 px-6">
      {links.map((link) => (
        <a
          key={link.href}
          href={link.href}
          className={`nav-link ${link.active ? "active" : ""}`}
        >
          {link.label}
        </a>
      ))}
    </nav>
  )
}
```

### Framer Motion Version
```tsx
"use client"
import { motion } from "framer-motion"

interface NavProps {
  links: { label: string; href: string; active?: boolean }[]
}

export function NavWithFramerUnderlines({ links }: NavProps) {
  return (
    <nav className="flex gap-8 px-6">
      {links.map((link) => (
        <motion.a
          key={link.href}
          href={link.href}
          className="relative text-sm font-medium text-slate-700 hover:text-slate-900"
          whileHover={{ color: "#1f2937" }}
        >
          {link.label}
          <motion.span
            layoutId={link.active ? "underline" : undefined}
            className="absolute bottom-0 left-0 right-0 h-0.5 bg-slate-900"
            initial={false}
            whileHover={{ scaleX: 1 }}
            animate={link.active ? { scaleX: 1 } : { scaleX: 0 }}
            transition={{ type: "spring", stiffness: 300, damping: 30 }}
            style={{ transformOrigin: "left", scaleX: 0 }}
          />
        </motion.a>
      ))}
    </nav>
  )
}
```

### Props
```typescript
interface NavProps {
  links: { label: string; href: string; active?: boolean }[]
}
```

**RTL:** scaleX origin reverses with dir="rtl"; transform-origin: right in RTL stylesheets
**Perf:** CSS version is zero-cost; Framer version uses GPU-accelerated scaleX

---

## 4. Bilingual Language Switcher

**Use case:** EN/AR toggle that switches document direction and persists preference
**Deps:** None (native HTML5)

### React Component
```tsx
"use client"
import { useEffect, useState } from "react"

interface LanguageSwitcherProps {
  onLanguageChange?: (lang: "en" | "ar") => void
}

export function LanguageSwitcher({ onLanguageChange }: LanguageSwitcherProps) {
  const [language, setLanguage] = useState<"en" | "ar">("en")
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    const saved = localStorage.getItem("language") as "en" | "ar" | null
    const initialLang = saved || "en"
    setLanguage(initialLang)
    applyLanguage(initialLang)
  }, [])

  const applyLanguage = (lang: "en" | "ar") => {
    document.documentElement.lang = lang
    document.documentElement.dir = lang === "ar" ? "rtl" : "ltr"
    localStorage.setItem("language", lang)
    onLanguageChange?.(lang)
  }

  const handleToggle = () => {
    const newLang = language === "en" ? "ar" : "en"
    setLanguage(newLang)
    applyLanguage(newLang)
  }

  if (!mounted) return null

  return (
    <div className="flex items-center gap-2 px-4 py-2 bg-slate-100 rounded-lg">
      <button
        onClick={handleToggle}
        className={`px-3 py-1 rounded font-medium text-sm transition-all ${
          language === "en"
            ? "bg-white text-slate-900 shadow-sm"
            : "text-slate-600 hover:text-slate-900"
        }`}
        aria-label="Switch to English"
      >
        EN
      </button>
      <span className="text-slate-400">/</span>
      <button
        onClick={handleToggle}
        className={`px-3 py-1 rounded font-medium text-sm transition-all ${
          language === "ar"
            ? "bg-white text-slate-900 shadow-sm"
            : "text-slate-600 hover:text-slate-900"
        }`}
        aria-label="Switch to Arabic"
      >
        AR
      </button>
    </div>
  )
}
```

### Usage in Layout
```tsx
// In your root layout or nav component
import { LanguageSwitcher } from "@/components/LanguageSwitcher"

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" dir="ltr">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </head>
      <body>
        <nav className="flex justify-between items-center px-6 py-4">
          <div>Logo</div>
          <LanguageSwitcher />
        </nav>
        {children}
      </body>
    </html>
  )
}
```

### Props
```typescript
interface LanguageSwitcherProps {
  onLanguageChange?: (lang: "en" | "ar") => void
}
```

**RTL:** Fully RTL-aware; toggles dir="rtl" on html element; localStorage persists across sessions
**Perf:** useEffect delays rendering until client-side hydration; prevents hydration mismatch
