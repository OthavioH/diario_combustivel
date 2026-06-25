---
name: Fuel Diary Utility System
colors:
  surface: '#f8f9fa'
  surface-dim: '#d9dadb'
  surface-bright: '#f8f9fa'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f5'
  surface-container: '#edeeef'
  surface-container-high: '#e7e8e9'
  surface-container-highest: '#e1e3e4'
  on-surface: '#191c1d'
  on-surface-variant: '#43474e'
  inverse-surface: '#2e3132'
  inverse-on-surface: '#f0f1f2'
  outline: '#73777f'
  outline-variant: '#c3c6cf'
  surface-tint: '#426086'
  primary: '#002547'
  on-primary: '#ffffff'
  primary-container: '#1b3b5f'
  on-primary-container: '#88a6cf'
  inverse-primary: '#abc8f4'
  secondary: '#2c694e'
  on-secondary: '#ffffff'
  secondary-container: '#aeeecb'
  on-secondary-container: '#316e52'
  tertiary: '#322100'
  on-tertiary: '#ffffff'
  tertiary-container: '#4e3500'
  on-tertiary-container: '#d59800'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d3e4ff'
  primary-fixed-dim: '#abc8f4'
  on-primary-fixed: '#001c38'
  on-primary-fixed-variant: '#2a486d'
  secondary-fixed: '#b1f0ce'
  secondary-fixed-dim: '#95d4b3'
  on-secondary-fixed: '#002114'
  on-secondary-fixed-variant: '#0e5138'
  tertiary-fixed: '#ffdea9'
  tertiary-fixed-dim: '#ffba27'
  on-tertiary-fixed: '#271900'
  on-tertiary-fixed-variant: '#5e4100'
  background: '#f8f9fa'
  on-background: '#191c1d'
  surface-variant: '#e1e3e4'
typography:
  display-data:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  unit-mono:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  touch-target: 48px
  container-padding: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 24px
  gutter: 12px
---

## Brand & Style

The design system is built on the principle of **Utility-Modernism**. It prioritizes high-speed data entry and effortless legibility for drivers who need to log information quickly while at a filling station. The aesthetic is "Tool-like"—functional, reliable, and devoid of unnecessary decorative flourishes.

The target audience consists of pragmatic vehicle owners who value efficiency and data accuracy. The UI evokes a sense of mechanical precision and digital reliability through a systematic application of whitespace, structured grids, and a professional, "engineering-first" visual language.

Key stylistic pillars include:
- **Pragmatism:** Every element has a clear functional purpose.
- **Speed:** Large touch targets and high-contrast visuals accommodate one-handed mobile use.
- **Clarity:** Distinct separation between labels and data units (km, L, $).

## Colors

The palette is rooted in automotive and industrial tones. **Gasoline Blue** serves as the primary brand color for structural elements and primary navigation, while **Efficiency Green** is reserved for high-value actions like completing a log.

- **Primary (Gasoline Blue):** Used for headers, primary buttons, and active navigation states.
- **Secondary (Efficiency Green):** Used for "Add Fuel" actions and positive trend indicators.
- **Accent (Amber):** Specifically for low-fuel warnings, missing data alerts, or price spikes.
- **Background:** A crisp `#F8F9FA` prevents screen glare and provides a neutral canvas for data-heavy cards.
- **Neutral/Text:** A scale of cool grays derived from the Primary Blue to maintain tonal harmony.

## Typography

This design system uses **Inter** for its exceptional legibility and neutral tone. For data units and technical values, **JetBrains Mono** is introduced to provide a distinct "instrument cluster" feel that separates units (km, L) from the primary values.

- **Data Numerals:** Large, bold weights are used for the primary metrics (e.g., total cost, fuel volume) to ensure they are readable at a glance.
- **Labels:** Small-caps are utilized for field labels to create a clear visual hierarchy against user input.
- **Units:** Always append units using the `unit-mono` style, positioned either as a suffix or a secondary label to ensure numerical values remain the focal point.

## Layout & Spacing

The layout follows a **fluid mobile grid** with a 4-column structure. Because the app is intended for one-handed use (often at a gas pump), interactive elements are concentrated in the "natural thumb zone" (bottom two-thirds of the screen).

- **Touch Targets:** All interactive elements maintain a minimum 48x48px area.
- **Vertical Rhythm:** A strict 8px base unit governs all spacing to ensure a tight, organized UI.
- **Safe Areas:** 16px horizontal margins are mandatory for all main content containers to prevent visual crowding against the device edges.

## Elevation & Depth

To maintain the "Utility-Modern" aesthetic, depth is communicated through **tonal layering** and **subtle outlines** rather than heavy shadows.

- **Level 0 (Background):** The base `#F8F9FA` surface.
- **Level 1 (Cards):** Pure white `#FFFFFF` surfaces with a 1px border of `#E9ECEF`. This provides a "flat-stack" look that feels sturdy.
- **Active State:** Elements may use a subtle, highly diffused 4px shadow (Primary color at 5% opacity) only when being pressed or dragged.
- **Separators:** Use 1px solid lines for list items to maintain a high-density, organized data structure.

## Shapes

The design system uses a **Soft** shape language. Corners are slightly rounded to feel modern and accessible, but remain sharp enough to convey a sense of precision and professional utility.

- **Small (4px):** Checkboxes, segmented control thumbs, and small tags.
- **Medium (8px):** Standard buttons, input fields, and dashboard cards.
- **Large (12px):** Modal sheets and bottom drawers.
- **Full (Pill):** Used exclusively for the Floating Action Button and status "chips".

## Components

### Buttons & Input
- **Primary FAB:** A pill-shaped button in Efficiency Green with a white outline icon, fixed to the bottom-right for quick entry.
- **Input Fields:** Outlined style with a permanent "unit suffix" (e.g., "0.00 | L") pinned to the right side of the field.

### Data Visualization
- **Metric Cards:** White background, 1px border. The primary number is top-left, with the JetBrains Mono unit label immediately following it. A secondary "trend" indicator (small sparkline or % change) is placed in the bottom right.
- **Charts:** Minimalist line charts using a 2px stroke width. No filled areas below the line to maintain cleanliness. Use Gasoline Blue for general trends and Success Green for efficiency gains.

### Controls
- **Segmented Controls:** Used for fuel types (95, 98, Diesel). These should span the full width of the container with a light gray background and a white "elevated" selection chip.
- **List Items:** High-density rows with an outline icon on the left, primary data in the center, and a chevron or date-stamp on the right.

### Iconography
- **Style:** 24px grid, 1.5px stroke weight, rounded caps. Outline style only.
- **Standard Icons:** `fuel-pump` (Refuel), `trending-up` (Stats), `clock-history` (Logs), `settings-gear` (Profile).