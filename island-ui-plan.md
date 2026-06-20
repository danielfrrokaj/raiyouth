# Island UI — Implementation Plan

---

## Critical observation: images are composites, not layers

Each PNG is a **complete scene** showing the island at that stage — not a transparent layer.
They do not stack on top of each other in a ZStack. They **swap** via a crossfade transition.

This changes the architecture from "layered images" to "state-driven image swap with transition effect."

---

## Asset inventory

| File | What's on the island |
|---|---|
| `island_base.png` | Empty floating island, no buildings |
| `island_glow.png` | Island + golden glow burst in center |
| `island_guide.png` | Island + glow + orange guide character (waving) |
| `island_forge.png` | Island + character + forge/blacksmith building |
| `island_tower.png` | Island + character + forge + signal tower (lighthouse + wifi arcs) |
| `island_house.png` | Island + character + forge + tower + purple-roofed profile house |
| `island_gate.png` | Island + all above + golden trust gate (left) + red location pin |
| `island_pin.png` | Island + all above + vault door embedded bottom-right |

`island_pin.png` is the final complete state. There is no separate vault image.

---

## Gap: two onboarding steps exist as files but are not wired

These views were built but never added to `OnboardingContainerView`:

- `OnboardingPersonaView.swift` → maps to **Quest / Guide** stage
- `OnboardingCardCustomizationView.swift` → maps to **Card Forge** stage

Both need to be added to the container flow. Without them, two island stages (glow, forge) have no natural trigger.

---

## Proposed step flow (updated)

The current 17-step order needs to be reordered to match the island narrative. New proposed order:

| Step # | View | Island stage triggered |
|---|---|---|
| 1 | `OnboardingSlidesView` | Stage 0 — base (blurred) |
| 2 | `OnboardingPersonaView` *(add)* | Stage 1 — glow (quest begins) |
| 3 | `OnboardingCardCustomizationView` *(add)* | — |
| 4 | `OnboardingWelcomeView` (phone) | — |
| 5 | `OnboardingOTPView` | Stage 2 — guide appears (phone verified) |
| 6 | `OnboardingEmailView` | Stage 3 — forge (contact section done) |
| 7 | `OnboardingNotificationsView` | — |
| 8 | `OnboardingNameView` | — |
| 9 | `OnboardingDOBView` | Stage 4 — tower (profile info done) |
| 10 | `OnboardingCountryView` | — |
| 11 | `OnboardingCitizenshipView` | — |
| 12 | `OnboardingKYCOptionsView` | — |
| 13 | `OnboardingDocPickerView` | — |
| 14 | `OnboardingTermsView` | — |
| 15 | `OnboardingKYCView` | — |
| 16 | `OnboardingSelfieView` | Stage 5 — house (KYC complete) |
| 17 | `OnboardingAddressView` | Stage 6 — gate (home base set) |
| 18 | `OnboardingPasscodeView` | Stage 7 — pin/vault (vault locked) |
| 19 | `OnboardingSuccessView` | Stays on Stage 7 — island complete |

Note: forge (stage 3) is mapped to email completion because the card customization step doesn't naturally produce a "tower built" feeling, and email + phone + OTP together complete the Signal Tower concept from game-rules.

---

## Island stage definitions (source of truth)

```
enum IslandStage: Int, CaseIterable {
    case base    = 0   // blurred, in clouds
    case glow    = 1   // quest begins
    case guide   = 2   // guide appears
    case forge   = 3   // contact section done
    case tower   = 4   // profile done
    case house   = 5   // KYC done
    case gate    = 6   // home base set
    case vault   = 7   // vault locked / complete

    var imageName: String {
        switch self {
        case .base:  return "island_base"
        case .glow:  return "island_glow"
        case .guide: return "island_guide"
        case .forge: return "island_forge"
        case .tower: return "island_tower"
        case .house: return "island_house"
        case .gate:  return "island_gate"
        case .vault: return "island_pin"
        }
    }

    var rewardTitle: String? {
        switch self {
        case .base:  return nil
        case .glow:  return "Island Unlocked"
        case .guide: return "Guide Unlocked"
        case .forge: return "Card Forge Unlocked"
        case .tower: return "Signal Tower Activated"
        case .house: return "Profile House Built"
        case .gate:  return "Trust Gate Opened"
        case .vault: return "Vault Locked"
        }
    }

    var rewardSubtitle: String? {
        switch self {
        case .base:  return nil
        case .glow:  return "Your money journey has started."
        case .guide: return "Your money guide is ready."
        case .forge: return "Your first card style is ready."
        case .tower: return "Your phone is verified."
        case .house: return "Your profile is ready."
        case .gate:  return "Your identity checkpoint is complete."
        case .vault: return "Your app is protected."
        }
    }
}
```

---

## IslandHeaderView — component spec

Replaces the current 4px progress bar in `OnboardingContainerView`.

### Two states: compact and expanded

**Compact (normal):**
- Height: `~100pt`
- Island image displayed at this height, `aspectRatio(.fit)`, centered
- Always visible while user fills in the form below

**Expanded (on stage unlock):**
- Height: fills the screen (use `maxHeight: .infinity` or full screen overlay)
- Island image scales up to fill the space
- Reward title and subtitle appear below the island image
- Auto-collapses back to compact after `2.0s`
- User cannot tap through while expanded — it acts as a momentary blocker

### Transition sequence on stage unlock

1. `islandStage` advances
2. Island image crossfades to the new image (`.opacity` transition, `0.35s`)
3. Simultaneously: header height animates from `100pt` → full screen (spring `response: 0.5, dampingFraction: 0.8`)
4. Reward title + subtitle fade in below the island (`0.2s` delay after expand starts)
5. After `2.0s`: title/subtitle fade out, height animates back to `100pt`
6. Next form content slides in underneath as normal

### Stage 0 only (initial blurred state)

- `island_base.png` rendered with `.blur(radius: 18)` + `.opacity(0.5)` + `.grayscale(0.4)`
- Soft white gradient overlay at top and bottom edges suggesting clouds
- When stage 1 fires: blur + grayscale animate to 0 as the island "reveals from clouds" before expanding

### Haptic

- `.medium` UIImpactFeedbackGenerator fires at the moment the header starts expanding

### Accessibility

- When `reduceMotion` is true: skip the expand/collapse animation entirely
- Stage still advances and image still crossfades — just no height animation
- Reward text appears briefly as a static overlay then fades

---

## No separate IslandRewardOverlay needed

The expand behaviour of `IslandHeaderView` itself is the reward moment. The reward title and subtitle render inside the expanded header — not as a separate sheet or toast. Fewer moving parts.

---

## What stays the same

- Every onboarding step view's internal layout — no form content changes
- `OnboardingData` model — no new fields required
- Navigation logic in `OnboardingContainerView` — just new cases added for the two new steps
- The existing `OnboardingSuccessView` — island is already complete when user reaches it
- Theme, fonts, button styles — all untouched

---

## Files to create

| File | Purpose |
|---|---|
| `IslandHeaderView.swift` | The island image with stage-driven swap + blur/reveal effects |
| `IslandRewardOverlay.swift` | The auto-dismissing toast card that fires on each stage unlock |
| `IslandStage.swift` | The enum above — single source of truth for stages, images, reward copy |

---

## Files to modify

| File | Change |
|---|---|
| `OnboardingContainerView.swift` | Add `@State var islandStage: IslandStage = .base`, replace `progressHeader` with `IslandHeaderView(stage: islandStage)`, add `IslandRewardOverlay` to ZStack, add new step cases for persona + card, advance `islandStage` at the right steps |
| `OnboardingData.swift` | No changes needed |

---

## Assets to add to Xcode

All 8 PNGs from `/game-images/` need imagesets in `Assets.xcassets`:
- `island_base`, `island_glow`, `island_guide`, `island_forge`
- `island_tower`, `island_house`, `island_gate`, `island_pin`

Drop each into the **1x slot** of its imageset. No @2x/@3x needed for prototyping.

---

## Open decision before coding

The forge stage (stage 3) is currently mapped to "email complete" which is a loose thematic fit.
If `OnboardingCardCustomizationView` gets added as a step, the forge unlock can instead fire immediately after that step — which is the cleanest match. Decision: **add the card step** so forge has a proper narrative trigger.