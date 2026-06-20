---
trigger: always_on
---

1. Design principles


Calm gray, one loud accent. The canvas and cards are quiet gray; yellow marks only the next action, key values, and rewards.
Glass for surfaces, solid yellow for actions. Cards/nav/bubbles are glass. Primary buttons are solid yellow so the eye always finds the CTA.
One job per screen. Each onboarding screen asks for at most one thing.
Progress is always visible. Show where the user is and what they unlock next.
The guide makes it human. A friendly 3D character with positive movement turns a form into a relationship.
Scaffolding fades. Rai helps most on hard/scary steps, then gets quieter as confidence grows.
Sentence case, human copy. Never Title Case, never ALL CAPS. Warm, short, second person.



2. Color tokens (sampled from the live app — fine-tune as needed)

Canvas & surfaces (slate gray)

TokenHexUsecanvas#24272CApp background (behind everything)surface/1#2C2F35Base surface under glasssurface/2#34373ESolid card / fallback when blur offsurface/3#3D4047Raised solid (bubbles, inputs)hairline#484B521px outline on ghost buttons

Glass (translucent — see §3 for blur)

TokenValueUseglass/fillrgba(255,255,255,0.07)Standard frosted panel over grayglass/fill-strongrgba(255,255,255,0.12)Nav bars, sheets, emphasisglass/tintrgba(40,43,49,0.55)Tinted-gray glass alternativeglass/borderrgba(255,255,255,0.15)1px edge highlight (the glass "rim")glass/border-strongrgba(255,255,255,0.22)Focused / pressed edge

Accents

TokenHexText-on colorUseaccent/primary (yellow)#FFD21E#1A1A14Hero: primary CTA, links, icons, active nav, rewards, pointsaccent/primary-deep (gold)#E6A800#1A1A14Card gradient depth, pressed yellowaccent/teal (KUIK)#2C7A87#FFFFFFKUIK, progress bars, goals, info

Yellow is the only attention color. Use teal only for KUIK, progress and goals so the two never compete. Do not introduce extra accent hues.

Text

TokenHexUsetext/primary#FFFFFFHeadlines, key valuestext/secondary#A6A9B0Supporting copy, labels, account numbertext/tertiary#70737AHints, disclaimers, locked itemstext/on-accentper accent aboveText on a filled accent

Semantic

TokenHexUsesuccess#3DD68CConfirmationswarning#FF9F2ECaution (orange, so it never clashes with brand yellow)danger#FF5A5AErrors, destructiveinfo#2C7A87Info (reuses teal)

Ambient background (subtle, keeps the gray calm)

The gray scheme is flatter than a neon one — keep glows faint so it reads premium, not busy.


Glow A: #FFD21E at ~10% opacity, top-right.
Glow B: #2C7A87 at ~8% opacity, bottom-left.


Rules


Never put yellow text on teal or teal text on yellow. Use text/on-accent mappings only.
Color encodes meaning: yellow = action/highlight/reward; teal = progress/goal/KUIK.
Max one accent emphasis per region; yellow always wins the screen.



3. Glassmorphism system

Recipe (every glass panel)


Backdrop blur 20–30pt (cards), 30–40pt (nav/sheets) — use SwiftUI Materials.
Fill = glass/fill (or glass/tint for darker context).
Border = 1pt glass/border (the rim is what makes it read as glass).
Corner radius = lg (20) for cards, xl (28) for hero panels/sheets, style: .continuous.
Soft shadow for float: y 8, blur 24, rgba(0,0,0,0.35). Keep subtle.
Optional 1pt top inner highlight rgba(255,255,255,0.10) for a "lit edge."


Material tiers (SwiftUI)

TierSwiftUIWhenultra-thin.ultraThinMaterialFloating chips, pills, speech bubble, bottom nav pillthin.thinMaterialStandard cards, option rowsregular.regularMaterialModal sheets, overlays

Accessibility (critical for glass)


Body text needs 4.5:1, large text (≥20pt/600) needs 3:1 against what shows through the glass. If the area behind is bright, add a dark scrim rgba(0,0,0,0.25–0.4) under the text.
Honor Reduce Transparency (accessibilityReduceTransparency): swap glass → surface/2 solid + glass/border. Design must look correct with zero blur.
Don't animate blur radius live (expensive + flicker); animate opacity/position instead.



4. Typography

Font


Primary: SF Pro (system) for native feel and Dynamic Type. Brand alternative: Inter. Pick one.
Display / big numbers: SF Pro Display (or SF Pro Rounded for Wolt warmth) at 600.
Money & figures: enable tabular figures (.monospacedDigit()); tighten tracking -0.5 on large numbers (e.g. the balance 252.12 ALL).


Type scale (pt)

RoleSizeWeightNotesDisplay (balance)32600tabular, tracking -0.5H124600screen titlesH220600section / card titlesTitle17600list item titlesBody15400default copy, line-height 1.5Caption13400labels, helper textMicro12500pills, badges, overlines

Rules


Weights: 400 / 500 / 600 only. No 700+, no <400 (thin fails over glass).
Sentence case everywhere, including buttons, pills, and the guide's speech.
Line-height: 1.25–1.3 headings, 1.45–1.5 body. Min font size 12. Support Dynamic Type where feasible.



5. Spacing, radius, elevation


Spacing scale (4-pt): 4, 8, 12, 16, 20, 24, 32, 40. Screen edge padding 16–20. Gap between cards 12.
Radius: sm 10 (chips/inputs), md 14 (buttons), lg 20 (cards), xl 28 (hero/sheets), pill 999 (badges, nav). Use .continuous.
Touch targets: ≥ 44×44 pt.
Elevation: glass float shadow (see §3). Don't stack heavy shadows; use border + blur for hierarchy.



6. Motion


Durations: micro 120ms, standard 220ms, screen transition 300–350ms.
Easing: ease-out for entrances, spring (.spring(response: 0.4, dampingFraction: 0.8)) for taps and the guide.
Patterns: screens slide+fade horizontally; cards scale 0.98 on press; progress fills with a teal spring; reward = brief confetti + yellow pulse + haptic.
Guide: the 3D character carries the "alive" feeling via video (§8). Keep surrounding UI motion calm.
Haptics: .light on tap, .success on reward, .warning on error.
Respect Reduce Motion: cross-fade instead of slide, no confetti, swap the guide video for a static poster (§8).



7. Components

ComponentSpecGlass card.thinMaterial, radius lg, padding 16. Title H2, body Body.Primary button (CTA)SOLID accent/primary yellow, text #1A1A14 15/600, radius md, full width, height 50. Pressed: scale 0.98 + accent/primary-deep. Never glass.Secondary button.ultraThinMaterial, 1pt glass/border, text white (the "Transactions" / "Top Up" style).Tap-option row.thinMaterial, radius 13, leading yellow icon (20), label 14/500, advances on tap.KUIK buttonSOLID accent/teal, white icon + label.Guide speech bubble.ultraThinMaterial, radius 14, bottom-left corner squared (tail toward Zog), text 12.5/400. One per screen.Progress / quest trackerdone = teal check, current = yellow pulse, locked = text/tertiary. Ring shows % at top (teal fill).Pill / badgepill radius, accent fill at 12–15% opacity, text in the accent's dark stop, 12/500.Bottom nav.ultraThinMaterial rounded pill bar, SF Symbols, active = yellow, inactive = text/secondary.Input fieldsurface/3, radius sm, height 44, 1pt glass/border, focus ring yellow.Card preview (debit)radius 16, gold gradient #FFD21E → #E6A800, brand text #1A1A14; swatches let the user recolor.

Icons: SF Symbols, regular/medium weight, 20pt inline / 24pt decorative, tinted yellow for accent or white for neutral.


8. 3D guide character — "Zog" (video)

Identity & art direction


A young, rounded 3D Pixar-style eagle (Albania = "Land of the Eagles"): big expressive eyes, appealing soft shapes, friendly not fierce, positive body language.
Render palette to match the UI: charcoal-gray feathers, cream chest, yellow #FFD21E beak.
Lighting: dark-gray scene with a warm yellow rim light + soft cool-gray fill so Zog sits in the brand palette and reads cleanly over gray glass.
Render with a transparent (alpha) background so the character floats over glass — no baked backdrop. Consistent camera, scale, and eye-line toward the user/CTA across all clips.


Delivery: video clips


Zog ships as short video clips, not a live 3D engine — cheaper, smoother, beautiful on device.
Clip set (asset names): idle (2–4s seamless loop), wave (intro), point (guiding), reassure (KYC), wait (verifying), cheer (reward), wink (tips), rest (tapered idle).
Each reaction is a one-shot resolving to a neutral pose so it crossfades into idle.


Sizes & placement


Hero (welcome / success): 220–320pt tall, centered.
Inline guide (most steps): 96–120pt, top-left beside the speech bubble.
Nav peek (post-onboarding): 32–40pt.


Voice / copy


First person, warm, ≤14 words, sentence case, one bubble per screen. May reference learned data ("Because you're abroad, I set euro").


Scaffolding curve


wave/point/reassure and larger size on steps 1–4; switch to rest and smaller size from step 5; near-silent on the home handoff.


Rules


Never block the CTA, cover inputs, or play more than one clip at once. Muted always; the bubble carries meaning.



9. Video asset pipeline (high-quality, performant)

Format & codec


Transparent character over glass → HEVC with alpha (Apple's transparent video). Export with AVAssetExportPresetHEVCHighestQualityWithAlpha; container .mov (or fragmented MP4 with hvc1). Only reliable way to get alpha video on iOS.
Full-frame / opaque clips → standard HEVC (H.265) MP4; H.264 only as legacy fallback. No audio track.


Resolution & frame rate


Master each clip square, 1200×1200 (covers ~400pt at @3x); smaller masters (720×720) for the inline guide. 30 fps standard (24 for a softer idle).


Duration & size budget


idle 2–4s; reactions 1–2.5s. Target: idle ≤ ~1.5MB, each reaction ≤ ~1MB. Total character pack ≤ ~15–20MB.


Bundling & loading


Bundle all onboarding clips in the app — onboarding must work with no network. Preload the next clip; keep one active player; pause/teardown off-screen. Always show a poster frame (still PNG with alpha) instantly while a clip warms up.


Fallbacks (mandatory)


Reduce Motion or Low Power Mode → static poster PNG of Zog.
Reduce Transparency → solid surfaces (§3); character still allowed.
Old/low-end device or decode failure → poster PNG.


Accessibility


accessibilityLabel per state ("Zog, your guide, waving"). The speech bubble text is the real accessible content; no captions needed.



10. SwiftUI implementation notes

Glass


RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.thinMaterial) then .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(.white.opacity(0.15), lineWidth: 1)).
Tiers: .ultraThinMaterial (chips/bubble/nav), .thinMaterial (cards), .regularMaterial (sheets).
Money: Text(value).monospacedDigit() with the display font.
Read @Environment(\.accessibilityReduceTransparency) and \.accessibilityReduceMotion.


Transparent looping video (the guide)


Do not use VideoPlayer — it shows controls, won't loop seamlessly, and won't render alpha. Wrap AVPlayerLayer in a UIViewRepresentable.
In the backing UIView: view.backgroundColor = .clear, playerLayer.backgroundColor = UIColor.clear.cgColor, don't force the layer opaque. Alpha HEVC then composites over the glass.
Seamless idle loop: AVQueuePlayer + AVPlayerLooper. Reactions: swap the player item, play once, on AVPlayerItemDidPlayToEndTime crossfade back to idle.
player.isMuted = true. Preload AVPlayerItems; reuse a single representable; pause() on disappear.
Switch to Image("zog_poster") when reduceMotion or ProcessInfo.processInfo.isLowPowerModeEnabled.


Cross-cutting


Centralize tokens (colors, radii, type scale, durations) in one Theme so nothing drifts.
Test every screen in: bright-glow state, Reduce Transparency on, Reduce Motion on, Low Power on, and a contrast checker.



11. Personalization hooks (adaptive onboarding)

Capture: intent (1 tap), persona (1 tap), goal seed, card color, plus behavioral signals (dwell, retries, back-taps). Use to: pick Zog's clip + tip timing, reorder features, default currency (lek/euro), pre-fill first goal, time rewards. Keep KYC data separate from gamification data; gate behind explicit consent; let users view/reset what Rai "knows."