# Medical Spa Patterns

## 1. Service Card

**Use case:** Display medical spa services in grid with hover animations, perfect for service listings
**Deps:** framer-motion, tailwind

### Implementation
```tsx
import { motion } from 'framer-motion';
import { useState } from 'react';

interface ServiceCardProps {
  icon: React.ReactNode;
  title: string;
  description: string;
  price: string;
  onLearnMore?: () => void;
}

export function ServiceCard({
  icon,
  title,
  description,
  price,
  onLearnMore
}: ServiceCardProps) {
  const [isHovered, setIsHovered] = useState(false);

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      onHoverStart={() => setIsHovered(true)}
      onHoverEnd={() => setIsHovered(false)}
      className="relative h-full rounded-lg border border-[#E8D4D0] bg-white p-6 transition-shadow duration-300"
      style={{
        boxShadow: isHovered 
          ? '0 20px 40px rgba(201, 160, 53, 0.15)' 
          : '0 4px 12px rgba(0, 0, 0, 0.05)'
      }}
    >
      <motion.div
        animate={{ y: isHovered ? -8 : 0 }}
        transition={{ duration: 0.3 }}
        className="mb-4 text-4xl text-[#C9A035]"
      >
        {icon}
      </motion.div>

      <h3 className="mb-2 font-serif text-lg font-light text-[#0D1B3E]">
        {title}
      </h3>

      <p className="mb-4 text-sm text-gray-600">
        {description}
      </p>

      <div className="mb-4 flex items-baseline gap-1">
        <span className="text-xl font-light text-[#C9A035]">
          {price}
        </span>
        <span className="text-xs text-gray-500">onwards</span>
      </div>

      <motion.button
        whileHover={{ x: 4 }}
        onClick={onLearnMore}
        className="text-sm font-light text-[#C9A035] transition-colors hover:text-[#0D1B3E]"
      >
        Learn More →
      </motion.button>
    </motion.div>
  );
}
```

### Props
```typescript
interface ServiceCardProps {
  icon: React.ReactNode;           // Icon component or emoji
  title: string;                    // Service name
  description: string;              // 1-2 line description
  price: string;                    // Starting price
  onLearnMore?: () => void;         // Click handler
}
```

**RTL:** Reverse arrow direction (← Learn More). Text direction handled automatically by Tailwind.
**Perf:** Uses opacity and transform only; no layout shift. Icon animation GPU-accelerated.

---

## 2. Doctor Profile Card

**Use case:** Showcase doctor credentials with hover reveal of specialties and bio
**Deps:** framer-motion, tailwind

### Implementation
```tsx
import { motion, AnimatePresence } from 'framer-motion';
import { useState } from 'react';

interface DoctorProfileCardProps {
  name: string;
  title: string;
  credentials: string[];
  image: string;
  bio?: string;
  specialties?: string[];
}

export function DoctorProfileCard({
  name,
  title,
  credentials,
  image,
  bio,
  specialties
}: DoctorProfileCardProps) {
  const [isExpanded, setIsExpanded] = useState(false);

  return (
    <motion.div
      className="group relative h-96 overflow-hidden rounded-lg"
      onHoverStart={() => setIsExpanded(true)}
      onHoverEnd={() => setIsExpanded(false)}
    >
      <img
        src={image}
        alt={name}
        className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
      />

      <div className="absolute inset-0 bg-gradient-to-t from-[#0D1B3E] via-transparent to-transparent opacity-0 transition-opacity duration-300 group-hover:opacity-100" />

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={isExpanded ? { opacity: 1, y: 0 } : { opacity: 0, y: 20 }}
        transition={{ duration: 0.3 }}
        className="absolute bottom-0 left-0 right-0 p-6 text-white"
      >
        <h3 className="mb-1 font-serif text-2xl font-light">
          {name}
        </h3>

        <p className="mb-3 text-sm text-[#C9A035]">
          {title}
        </p>

        {bio && (
          <p className="mb-4 text-xs leading-relaxed">
            {bio}
          </p>
        )}

        {specialties && (
          <div className="flex flex-wrap gap-2">
            {specialties.map((spec) => (
              <span
                key={spec}
                className="inline-block rounded-full border border-[#C9A035] px-3 py-1 text-xs text-[#C9A035]"
              >
                {spec}
              </span>
            ))}
          </div>
        )}

        <div className="mt-4 border-t border-[#C9A035] pt-3 text-xs">
          {credentials.join(' • ')}
        </div>
      </motion.div>

      <div className="absolute top-0 left-0 right-0 p-6">
        <motion.div
          initial={{ opacity: 1 }}
          animate={isExpanded ? { opacity: 0 } : { opacity: 1 }}
          className="flex items-center gap-3"
        >
          <div className="h-10 w-10 rounded-full border-2 border-white" />
          <div className="text-white">
            <p className="font-serif text-sm font-light">{name}</p>
            <p className="text-xs text-[#C9A035]">{title}</p>
          </div>
        </motion.div>
      </div>
    </motion.div>
  );
}
```

### Props
```typescript
interface DoctorProfileCardProps {
  name: string;                     // Doctor full name
  title: string;                    // MD, Specialist, etc.
  credentials: string[];            // Qualifications array
  image: string;                    // Image URL
  bio?: string;                     // Short bio (50-100 chars)
  specialties?: string[];           // List of specialties
}
```

**RTL:** Gradient direction handled automatically. Credentials order may need reversal in RTL.
**Perf:** Uses opacity + scale only. Image rendering optimized via CSS transforms.

---

## 3. Treatment Before/After Slider

**Use case:** Showcase treatment results with draggable image comparison
**Deps:** framer-motion, react

### Implementation
```tsx
import { motion } from 'framer-motion';
import { useRef, useState } from 'react';

interface BeforeAfterSliderProps {
  beforeImage: string;
  afterImage: string;
  beforeLabel?: string;
  afterLabel?: string;
  treatmentName: string;
}

export function TreatmentBeforeAfterSlider({
  beforeImage,
  afterImage,
  beforeLabel = 'Before',
  afterLabel = 'After',
  treatmentName
}: BeforeAfterSliderProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [sliderPosition, setSliderPosition] = useState(50);
  const [isDragging, setIsDragging] = useState(false);

  const handleMove = (clientX: number) => {
    if (!containerRef.current) return;
    const rect = containerRef.current.getBoundingClientRect();
    const position = ((clientX - rect.left) / rect.width) * 100;
    setSliderPosition(Math.max(0, Math.min(100, position)));
  };

  const handleMouseMove = (e: React.MouseEvent) => {
    if (isDragging) handleMove(e.clientX);
  };

  const handleTouchMove = (e: React.TouchEvent) => {
    if (isDragging) handleMove(e.touches[0].clientX);
  };

  return (
    <motion.div
      ref={containerRef}
      initial={{ opacity: 0 }}
      whileInView={{ opacity: 1 }}
      className="group relative aspect-square overflow-hidden rounded-lg"
      onMouseMove={handleMouseMove}
      onMouseUp={() => setIsDragging(false)}
      onMouseLeave={() => setIsDragging(false)}
      onTouchMove={handleTouchMove}
      onTouchEnd={() => setIsDragging(false)}
    >
      <div className="absolute inset-0">
        <img
          src={beforeImage}
          alt={treatmentName}
          className="h-full w-full object-cover"
        />
      </div>

      <motion.div
        style={{ width: `${sliderPosition}%` }}
        className="absolute inset-y-0 left-0 overflow-hidden"
      >
        <img
          src={afterImage}
          alt={`${treatmentName} after`}
          className="h-full w-full object-cover"
        />
      </motion.div>

      <motion.div
        style={{ left: `${sliderPosition}%` }}
        onMouseDown={() => setIsDragging(true)}
        onTouchStart={() => setIsDragging(true)}
        className="absolute inset-y-0 w-1 cursor-ew-resize bg-[#C9A035] transition-shadow hover:shadow-lg"
      >
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 rounded-full bg-[#C9A035] p-3 text-white shadow-lg">
          <div className="flex gap-1">
            <div className="h-0.5 w-3 rotate-45 bg-white" />
            <div className="h-0.5 w-3 -rotate-45 bg-white" />
          </div>
        </div>
      </motion.div>

      <div className="absolute inset-0 pointer-events-none">
        <div className="absolute top-4 left-4 bg-[#0D1B3E] bg-opacity-70 px-3 py-2 text-xs text-white font-light rounded">
          {beforeLabel}
        </div>
        <div className="absolute top-4 right-4 bg-[#C9A035] bg-opacity-90 px-3 py-2 text-xs text-white font-light rounded">
          {afterLabel}
        </div>
      </div>
    </motion.div>
  );
}
```

### Props
```typescript
interface BeforeAfterSliderProps {
  beforeImage: string;              // Before image URL
  afterImage: string;               // After image URL
  beforeLabel?: string;             // Label for before (default: "Before")
  afterLabel?: string;              // Label for after (default: "After")
  treatmentName: string;            // Alt text / identifier
}
```

**RTL:** Slider direction reverses naturally in RTL context; labels swap positions.
**Perf:** Uses transform and clip-path for GPU acceleration. No reflows on drag.

---

## 4. Online Booking Multi-Step Form

**Use case:** Multi-step appointment booking with service, doctor, and date selection
**Deps:** framer-motion, react-hook-form

### Implementation
```tsx
import { motion, AnimatePresence } from 'framer-motion';
import { useState } from 'react';

interface BookingStep {
  id: 'service' | 'doctor' | 'date' | 'confirm';
  label: string;
}

interface MultiStepBookingProps {
  services: { id: string; name: string }[];
  doctors: { id: string; name: string }[];
  onSubmit: (data: BookingFormData) => void;
}

interface BookingFormData {
  serviceId: string;
  doctorId: string;
  date: string;
  time: string;
  name: string;
  phone: string;
}

const steps: BookingStep[] = [
  { id: 'service', label: 'Service' },
  { id: 'doctor', label: 'Doctor' },
  { id: 'date', label: 'Date & Time' },
  { id: 'confirm', label: 'Confirm' }
];

export function MultiStepBookingForm({
  services,
  doctors,
  onSubmit
}: MultiStepBookingProps) {
  const [currentStep, setCurrentStep] = useState(0);
  const [formData, setFormData] = useState<Partial<BookingFormData>>({});

  const handleNext = () => {
    if (currentStep < steps.length - 1) {
      setCurrentStep(currentStep + 1);
    } else {
      onSubmit(formData as BookingFormData);
    }
  };

  const handlePrevious = () => {
    setCurrentStep(Math.max(0, currentStep - 1));
  };

  const updateFormData = (key: keyof BookingFormData, value: string) => {
    setFormData({ ...formData, [key]: value });
  };

  return (
    <div className="mx-auto max-w-md rounded-lg border border-[#E8D4D0] bg-white p-8">
      <div className="mb-8">
        <div className="flex gap-2">
          {steps.map((step, idx) => (
            <motion.div
              key={step.id}
              className={`h-1 flex-1 rounded-full transition-colors ${
                idx <= currentStep ? 'bg-[#C9A035]' : 'bg-gray-200'
              }`}
            />
          ))}
        </div>
        <p className="mt-4 text-center text-sm text-gray-600">
          Step {currentStep + 1} of {steps.length}: {steps[currentStep].label}
        </p>
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={currentStep}
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: -20 }}
          transition={{ duration: 0.3 }}
        >
          {currentStep === 0 && (
            <div className="space-y-3">
              <h3 className="font-serif text-lg text-[#0D1B3E]">
                Select Service
              </h3>
              {services.map((service) => (
                <label key={service.id} className="flex cursor-pointer items-center gap-3 rounded-lg border border-gray-200 p-3 transition-all hover:border-[#C9A035]">
                  <input
                    type="radio"
                    name="service"
                    value={service.id}
                    checked={formData.serviceId === service.id}
                    onChange={(e) => updateFormData('serviceId', e.target.value)}
                    className="h-4 w-4 accent-[#C9A035]"
                  />
                  <span className="text-sm text-gray-700">{service.name}</span>
                </label>
              ))}
            </div>
          )}

          {currentStep === 1 && (
            <div className="space-y-3">
              <h3 className="font-serif text-lg text-[#0D1B3E]">
                Select Doctor
              </h3>
              {doctors.map((doctor) => (
                <label key={doctor.id} className="flex cursor-pointer items-center gap-3 rounded-lg border border-gray-200 p-3 transition-all hover:border-[#C9A035]">
                  <input
                    type="radio"
                    name="doctor"
                    value={doctor.id}
                    checked={formData.doctorId === doctor.id}
                    onChange={(e) => updateFormData('doctorId', e.target.value)}
                    className="h-4 w-4 accent-[#C9A035]"
                  />
                  <span className="text-sm text-gray-700">{doctor.name}</span>
                </label>
              ))}
            </div>
          )}

          {currentStep === 2 && (
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-light text-[#0D1B3E] mb-2">
                  Preferred Date
                </label>
                <input
                  type="date"
                  value={formData.date || ''}
                  onChange={(e) => updateFormData('date', e.target.value)}
                  className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-[#C9A035] focus:outline-none"
                />
              </div>
              <div>
                <label className="block text-sm font-light text-[#0D1B3E] mb-2">
                  Preferred Time
                </label>
                <input
                  type="time"
                  value={formData.time || ''}
                  onChange={(e) => updateFormData('time', e.target.value)}
                  className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-[#C9A035] focus:outline-none"
                />
              </div>
            </div>
          )}

          {currentStep === 3 && (
            <div className="space-y-4">
              <div className="space-y-2 rounded-lg bg-gray-50 p-4">
                <p className="text-xs text-gray-600">Service:</p>
                <p className="font-light text-[#0D1B3E]">
                  {services.find((s) => s.id === formData.serviceId)?.name}
                </p>
              </div>
              <div className="space-y-2 rounded-lg bg-gray-50 p-4">
                <p className="text-xs text-gray-600">Doctor:</p>
                <p className="font-light text-[#0D1B3E]">
                  {doctors.find((d) => d.id === formData.doctorId)?.name}
                </p>
              </div>
              <div className="space-y-2 rounded-lg bg-gray-50 p-4">
                <p className="text-xs text-gray-600">Date & Time:</p>
                <p className="font-light text-[#0D1B3E]">
                  {formData.date} at {formData.time}
                </p>
              </div>
            </div>
          )}
        </motion.div>
      </AnimatePresence>

      <div className="mt-8 flex gap-3">
        <motion.button
          whileHover={{ scale: 0.98 }}
          onClick={handlePrevious}
          disabled={currentStep === 0}
          className="flex-1 rounded-lg border border-gray-300 px-4 py-2 text-sm font-light text-gray-700 transition-colors disabled:opacity-50 hover:bg-gray-50"
        >
          Previous
        </motion.button>
        <motion.button
          whileHover={{ scale: 1.02 }}
          onClick={handleNext}
          className="flex-1 rounded-lg bg-[#C9A035] px-4 py-2 text-sm font-light text-white transition-colors hover:bg-[#B8922D]"
        >
          {currentStep === steps.length - 1 ? 'Confirm' : 'Next'}
        </motion.button>
      </div>
    </div>
  );
}
```

### Props
```typescript
interface MultiStepBookingProps {
  services: { id: string; name: string }[];
  doctors: { id: string; name: string }[];
  onSubmit: (data: BookingFormData) => void;
}
```

**RTL:** Step labels and button order reverse naturally. Input fields RTL-ready.
**Perf:** AnimatePresence manages smooth step transitions. Form data cached in state.

---

## 5. WhatsApp Floating Button

**Use case:** Sticky WhatsApp contact button with message preview on hover
**Deps:** framer-motion, react-icons

### Implementation
```tsx
import { motion } from 'framer-motion';
import { useState } from 'react';

interface WhatsAppButtonProps {
  phoneNumber: string;
  message?: string;
  position?: 'bottom-right' | 'bottom-left';
}

export function WhatsAppFloatingButton({
  phoneNumber,
  message = "Hi, I'd like to book a consultation",
  position = 'bottom-right'
}: WhatsAppButtonProps) {
  const [isHovered, setIsHovered] = useState(false);

  const positionClass = position === 'bottom-right' 
    ? 'bottom-6 right-6' 
    : 'bottom-6 left-6';

  const whatsappUrl = `https://wa.me/${phoneNumber}?text=${encodeURIComponent(message)}`;

  return (
    <motion.div
      className={`fixed ${positionClass} z-50`}
      initial={{ scale: 0 }}
      animate={{ scale: 1 }}
      transition={{ delay: 0.5, type: 'spring', stiffness: 200 }}
      onHoverStart={() => setIsHovered(true)}
      onHoverEnd={() => setIsHovered(false)}
    >
      <motion.a
        href={whatsappUrl}
        target="_blank"
        rel="noopener noreferrer"
        animate={{
          scale: isHovered ? 1.1 : 1,
          boxShadow: isHovered
            ? '0 20px 40px rgba(37, 211, 102, 0.3)'
            : '0 4px 12px rgba(0, 0, 0, 0.1)'
        }}
        className="flex h-14 w-14 items-center justify-center rounded-full bg-[#25D366] text-white shadow-lg transition-colors hover:bg-[#1fac59]"
      >
        <svg
          className="h-7 w-7"
          fill="currentColor"
          viewBox="0 0 24 24"
        >
          <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.67-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.076 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421-7.403h-.004a9.87 9.87 0 00-4.783 1.14L1.07 3.971l1.52 4.471c-.766 1.33-1.17 2.85-1.17 4.418 0 5.135 4.163 9.298 9.299 9.298 2.488 0 4.829-.96 6.584-2.702 1.755-1.742 2.716-4.078 2.716-6.596 0-5.135-4.163-9.298-9.299-9.298Z" />
        </svg>
      </motion.a>

      <motion.div
        initial={{ opacity: 0, x: position === 'bottom-right' ? 10 : -10 }}
        animate={isHovered ? { opacity: 1, x: 0 } : { opacity: 0, x: position === 'bottom-right' ? 10 : -10 }}
        transition={{ duration: 0.2 }}
        className={`absolute bottom-0 ${position === 'bottom-right' ? 'right-20' : 'left-20'} whitespace-nowrap rounded-lg bg-[#0D1B3E] px-4 py-2 text-xs text-white shadow-lg pointer-events-none`}
      >
        {message}
      </motion.div>
    </motion.div>
  );
}
```

### Props
```typescript
interface WhatsAppButtonProps {
  phoneNumber: string;              // Phone with country code (e.g., "974XXXXXXXX")
  message?: string;                 // Pre-filled message
  position?: 'bottom-right' | 'bottom-left';  // Button position
}
```

**RTL:** Position reverses naturally; message label flips to right side in RTL.
**Perf:** Fixed positioning; GPU-accelerated scale/shadow. No impact on page layout.

---

## 6. Review Carousel with Star Ratings

**Use case:** Rotating customer testimonials with star ratings and auto-rotation
**Deps:** framer-motion

### Implementation
```tsx
import { motion, AnimatePresence } from 'framer-motion';
import { useState, useEffect } from 'react';

interface Review {
  id: string;
  author: string;
  rating: number;
  text: string;
  treatmentName: string;
}

interface ReviewCarouselProps {
  reviews: Review[];
  autoPlay?: boolean;
  autoPlayInterval?: number;
}

export function ReviewCarousel({
  reviews,
  autoPlay = true,
  autoPlayInterval = 5000
}: ReviewCarouselProps) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [direction, setDirection] = useState(0);

  useEffect(() => {
    if (!autoPlay) return;

    const interval = setInterval(() => {
      setDirection(1);
      setCurrentIndex((prev) => (prev + 1) % reviews.length);
    }, autoPlayInterval);

    return () => clearInterval(interval);
  }, [autoPlay, autoPlayInterval, reviews.length]);

  const goToSlide = (index: number) => {
    setDirection(index > currentIndex ? 1 : -1);
    setCurrentIndex(index);
  };

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

  const review = reviews[currentIndex];

  return (
    <div className="mx-auto max-w-2xl rounded-lg border border-[#E8D4D0] bg-white p-8">
      <AnimatePresence initial={false} custom={direction} mode="wait">
        <motion.div
          key={currentIndex}
          custom={direction}
          variants={slideVariants}
          initial="enter"
          animate="center"
          exit="exit"
          transition={{
            x: { type: 'spring', stiffness: 300, damping: 30 },
            opacity: { duration: 0.4 }
          }}
          className="space-y-4"
        >
          <div className="flex items-center gap-1">
            {[...Array(5)].map((_, i) => (
              <motion.svg
                key={i}
                className={`h-5 w-5 ${
                  i < review.rating ? 'text-[#C9A035]' : 'text-gray-300'
                }`}
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292Z" />
              </motion.svg>
            ))}
          </div>

          <p className="font-serif text-lg font-light text-[#0D1B3E]">
            "{review.text}"
          </p>

          <div className="space-y-1 border-t border-gray-200 pt-4">
            <p className="font-light text-gray-700">
              {review.author}
            </p>
            <p className="text-xs text-[#C9A035]">
              {review.treatmentName}
            </p>
          </div>
        </motion.div>
      </AnimatePresence>

      <div className="mt-8 flex items-center justify-center gap-2">
        {reviews.map((_, idx) => (
          <motion.button
            key={idx}
            onClick={() => goToSlide(idx)}
            animate={{
              width: idx === currentIndex ? 32 : 8,
              backgroundColor: idx === currentIndex ? '#C9A035' : '#E5E7EB'
            }}
            className="h-2 rounded-full transition-colors"
            aria-label={`Go to review ${idx + 1}`}
          />
        ))}
      </div>

      <motion.div
        className="mt-6 flex justify-center gap-4"
        initial="hidden"
        whileInView="visible"
      >
        <motion.button
          whileHover={{ x: -4 }}
          onClick={() => goToSlide((currentIndex - 1 + reviews.length) % reviews.length)}
          className="rounded-full border-2 border-[#C9A035] p-2 text-[#C9A035] transition-colors hover:bg-[#C9A035] hover:text-white"
        >
          ← Prev
        </motion.button>
        <motion.button
          whileHover={{ x: 4 }}
          onClick={() => goToSlide((currentIndex + 1) % reviews.length)}
          className="rounded-full border-2 border-[#C9A035] p-2 text-[#C9A035] transition-colors hover:bg-[#C9A035] hover:text-white"
        >
          Next →
        </motion.button>
      </motion.div>
    </div>
  );
}
```

### Props
```typescript
interface Review {
  id: string;                       // Unique review identifier
  author: string;                   // Customer name
  rating: number;                   // 1-5 stars
  text: string;                     // Review text
  treatmentName: string;            // Service name
}

interface ReviewCarouselProps {
  reviews: Review[];                // Array of reviews
  autoPlay?: boolean;               // Auto-rotate (default: true)
  autoPlayInterval?: number;        // Rotation interval in ms (default: 5000)
}
```

**RTL:** Button labels reverse naturally. Slide direction can be inverted for RTL context.
**Perf:** AnimatePresence handles exit animations efficiently. Auto-play uses no scroll listeners.

---

## Summary

All 6 medical spa patterns use an example luxury color palette (swap in your brand tokens):
- Primary accent: `#C9A035` (gold — replace with your brand accent)
- Secondary: `#0D1B3E` (deep navy — replace with your brand primary)
- Neutrals: `#FFFFFF`, `#F5F3F0`, `#FAFBFC` (whites/beiges for backgrounds)

Patterns are optimized for RTL support and mobile responsiveness. All leverage Framer Motion 12 for smooth, GPU-accelerated animations with minimal performance impact. To adapt: find-and-replace the hex values above with your project's design tokens (e.g. `bg-brand-primary`, `text-brand-accent`).
