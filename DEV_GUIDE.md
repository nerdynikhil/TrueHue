# TrueHue iOS Game Development Guide

## 🎯 Project Overview
**Name:** TrueHue  
**Platform:** iOS (14+)  
**Tech:** Swift + SwiftUI  
**Type:** Color matching puzzle game  

## 🎮 Game Modes
1. **Classic Mode:** Match color names with display colors (game ends on first mistake)
2. **Chrono Mode:** Same as Classic but with 30-second timer (continuous play)
3. **Find Color Mode:** Tap the correct color from a grid of 6 options

## 🚀 Development Workflow

### Commit Convention
Use conventional commits for all changes:
- `feat:` new features
- `fix:` bug fixes
- `ui:` UI/styling changes
- `refactor:` code refactoring
- `test:` testing changes
- `docs:` documentation
- `chore:` maintenance tasks

Example: `feat: add classic mode game logic`

### Testing Protocol
**Ask user to run in simulator after completing each major phase:**
- After basic project setup
- After each game mode implementation
- After UI polish phases
- Before final build

---

## 📋 Development Phases

### Phase 1: Project Foundation
**Goal:** Set up basic iOS project structure

**Tasks:**
1. Create new iOS project "TrueHue" with SwiftUI
2. Configure for iOS 14+ target
3. Set up basic ContentView with navigation
4. Clean up default generated code
5. Add basic folder structure (Views/, Models/, Managers/)

**Commit:** `feat: initialize TrueHue iOS project with SwiftUI`

**🔍 Test Point:** Ask user to run empty app in simulator

---

### Phase 2: Core Data Models
**Goal:** Create game logic foundation

**Tasks:**
1. Create `GameManager.swift` as ObservableObject
2. Add game state enums (GameState, GameMode)
3. Create colors array with name-color pairs
4. Implement basic game lifecycle methods
5. Add published properties for SwiftUI binding

**Properties needed:**
```swift
@Published var currentScore = 0
@Published var gameState: GameState = .menu
@Published var gameMode: GameMode = .classic
@Published var currentColorName = ""
@Published var currentDisplayColor = Color.blue
@Published var isCorrectMatch = false
```

**Commit:** `feat: add core game manager and data models`

---

### Phase 3: Main Menu
**Goal:** Create navigation hub

**Tasks:**
1. Create `MainMenuView.swift`
2. Add app title with stylized typography
3. Create three mode selection buttons with SF Symbols
4. Add high score display placeholders
5. Implement navigation to game views
6. Apply iOS design guidelines (proper spacing, colors)

**Commit:** `feat: implement main menu with game mode selection`

**🔍 Test Point:** Ask user to run and test navigation

---

### Phase 4: Classic Mode - UI
**Goal:** Build Classic Mode interface

**Tasks:**
1. Create `ClassicModeView.swift`
2. Add score display at top
3. Create large centered text for color name
4. Add "Match ✅" and "No Match ❌" buttons
5. Style with proper iOS button design
6. Add navigation back to main menu

**Commit:** `ui: create classic mode interface layout`

---

### Phase 5: Classic Mode - Logic
**Goal:** Make Classic Mode functional

**Tasks:**
1. Connect ClassicModeView to GameManager
2. Implement question generation logic
3. Add answer checking functionality
4. Handle correct/incorrect responses
5. Implement game over state
6. Add score increment animations

**Game Logic:**
- Generate random color name and random display color
- User decides if they match
- Increment score on correct answer
- End game on first mistake

**Commit:** `feat: implement classic mode game logic and scoring`

**🔍 Test Point:** Ask user to test Classic Mode gameplay

---

### Phase 6: Chrono Mode - UI & Logic
**Goal:** Create timed gameplay mode

**Tasks:**
1. Create `ChronoModeView.swift` (copy from Classic)
2. Add 30-second countdown timer display
3. Modify GameManager for timer functionality
4. Implement continuous play (no game over on mistakes)
5. Add timer visual effects (color changes)
6. Handle timer expiration

**Timer Logic:**
- 30-second countdown
- Game continues on wrong answers
- Ends only when timer reaches 0
- Visual countdown with color transitions

**Commit:** `feat: add chrono mode with 30-second timer gameplay`

**🔍 Test Point:** Ask user to test Chrono Mode

---

### Phase 7: Find Color Mode - UI
**Goal:** Create color selection interface

**Tasks:**
1. Create `FindColorModeView.swift`
2. Add color name display (in neutral color)
3. Create 3x2 grid of colored square buttons
4. Make buttons responsive to different screen sizes
5. Add score display
6. Style color buttons with proper touch feedback

**Commit:** `ui: create find color mode grid interface`

---

### Phase 8: Find Color Mode - Logic
**Goal:** Implement color selection gameplay

**Tasks:**
1. Generate 6 random colors (1 correct, 5 distractors)
2. Shuffle color positions randomly
3. Handle color button taps
4. Validate correct color selection
5. Ensure good color contrast/visibility
6. Implement scoring system

**Commit:** `feat: implement find color mode selection logic`

**🔍 Test Point:** Ask user to test Find Color Mode

---

### Phase 9: High Score System
**Goal:** Add persistent score tracking

**Tasks:**
1. Create UserDefaults extension for high scores
2. Implement separate high scores for each mode
3. Add save/load functionality to GameManager
4. Update main menu to display high scores
5. Add "New High Score!" celebration
6. Handle score comparison logic

**Commit:** `feat: add persistent high score system`

---

### Phase 10: UI Polish & Animations
**Goal:** Professional iOS app feel

**Tasks:**
1. Add smooth transitions between questions
2. Implement score increment animations
3. Add button press feedback (haptics + visual)
4. Create game over overlay animations
5. Add color transition effects
6. Implement proper loading states

**Animation Types:**
- Fade in/out for question changes
- Scale animation for button presses
- Slide-in for game over screen
- Number counting for score increments

**Commit:** `ui: add smooth animations and visual feedback`

**🔍 Test Point:** Ask user to test overall app experience

---

### Phase 11: App-wide Styling
**Goal:** Consistent iOS design

**Tasks:**
1. Create custom color scheme
2. Implement consistent typography (SF Pro)
3. Add dark mode support
4. Ensure proper accessibility labels
5. Apply iOS Human Interface Guidelines
6. Optimize for different iPhone screen sizes

**Commit:** `ui: implement consistent iOS design system`

---

### Phase 12: Final Polish
**Goal:** App Store readiness

**Tasks:**
1. Add app icon (create simple geometric design)
2. Implement launch screen
3. Add proper error handling
4. Optimize performance and memory usage
5. Add sound effects (optional)
6. Final bug testing and fixes

**Commit:** `chore: final polish and app store preparation`

**🔍 Test Point:** Ask user for final testing on multiple simulators

---

## 🎨 Design Guidelines

### Colors
- Primary: iOS Blue (#007AFF)
- Secondary: iOS Gray (#8E8E93)
- Success: iOS Green (#34C759)
- Error: iOS Red (#FF3B30)
- Background: System Background

### Typography
- Title: SF Pro Display, Bold, 28pt
- Headline: SF Pro Display, Semibold, 22pt
- Body: SF Pro Text, Regular, 17pt
- Caption: SF Pro Text, Regular, 15pt

### Spacing
- Standard padding: 16pt
- Button height: 50pt
- Button corner radius: 12pt

---

## 🧪 Testing Checklist

### Functionality
- [ ] All three game modes work correctly
- [ ] Scoring system accurate
- [ ] High scores save/load properly
- [ ] Navigation works smoothly
- [ ] Timer functions correctly in Chrono Mode

### UI/UX
- [ ] Responsive on different iPhone sizes
- [ ] Dark mode support
- [ ] Smooth animations
- [ ] Proper button feedback
- [ ] Accessibility labels

### Performance
- [ ] No memory leaks
- [ ] Smooth 60fps gameplay
- [ ] Quick app launch
- [ ] Efficient color generation

---

## 📱 Simulator Testing Instructions

When asked to test:
1. Open Xcode
2. Select iPhone simulator (test multiple sizes)
3. Build and run (⌘+R)
4. Test all game modes thoroughly
5. Check navigation and UI responsiveness
6. Report any bugs or issues back to cursor

---

**Remember:** Commit after each completed phase and ask for simulator testing at designated test points!