# Org-GTD-Complete: A comprehensive GTD workflow system for Emacs org-mode

[English](README.md) | [中文](README_zh.md)

This package provides a complete implementation of David Allen's "Getting Things Done" methodology within Emacs org-mode. It covers all five core GTD workflow steps (Capture, Clarify, Organize, Reflect, Engage) and fully supports the six-level Horizon of Focus, Natural Planning Model, Weekly Review process, Contexts system, Two-Minute Rule, and all standard GTD lists (Projects, Next Actions, Waiting For, Someday/Maybe, Reference).

The system also includes inbox processing, project planning, periodic review cycles, reference material management, trigger lists, brainstorming tools, and organizing principles, enabling comprehensive vertical and horizontal focus management from daily tasks to life goals.

## Installation

```elisp
M-x package-install org-gtd-complete
```

## GTD Philosophy

### Core Principles

GTD methodology is built on several fundamental philosophical concepts that form the foundation of the entire system:

1. **Mind Like Water**: By externalizing tasks into a trusted system, free the mind from the burden of remembering, allowing it to focus on creative thinking rather than information storage.
2. **Outcome Orientation**: Every task must have a clear desired outcome; vague goals cannot drive effective action, and precise definition is a prerequisite for execution.
3. **System Trust**: Build a complete, reliable external system that users can fully trust, thereby reducing psychological anxiety and decision fatigue.
4. **Context-Driven**: Action selection should be based on current context, available time, energy, and tools, not solely on task importance or urgency.
5. **Continuous Evolution**: Through regular review and adjustment, the system must continually adapt to changing environments and goals, maintaining its relevance and effectiveness.

### The Five Steps

The GTD workflow consists of five sequential steps that form a closed-loop system:

```
      +──────────+
      │ Capture  │
      +────┬─────+
           │
           ▼
      +────┬─────+
      │ Clarify  │
      +────┬─────+
           │
           ▼
      +────┬─────+
      │ Organize │
      +────┬─────+
           │
           ▼
      +────┬─────+
      │ Reflect  │
      +────┬─────+
           │
           ▼
      +────┬─────+
      │ Engage   │
      +──────────+
```

#### 1. Capture
Collect all tasks, ideas, commitments, and to-dos from your mind and external sources into an "inbox." The goal is to clear your mind and ensure nothing is missed.

#### 2. Clarify
Process each item in the inbox one by one:
- Ask: "What is this?"
- If not actionable, discard, file as reference, or mark as "Someday/Maybe"
- If actionable, determine the next action and desired outcome

#### 3. Organize
Place processed items into appropriate systems:
- **Next Actions List**: Specific actions that can be done immediately
- **Projects List**: Tasks requiring multiple steps to complete
- **Waiting For List**: Items delegated to others or pending external events
- **Someday/Maybe List**: Tasks not to be done now but possibly in the future
- **Reference Material**: Information to keep but not requiring action

#### 4. Reflect
Review your system regularly to keep it up-to-date and effective:
- **Daily Review**: Check your action lists and calendar for the day
- **Weekly Review**: Fully update all lists, review goals and project progress
- **Monthly/Annual Review**: Examine higher-level goals and vision

#### 5. Engage
Choose the most appropriate action from your lists based on current context, time, energy, and priority. This is the stage where actual work gets done.

These five steps form a continuous cycle: executing actions generates new tasks to capture, regular reviews ensure system effectiveness, leading to sustained personal productivity.

### GTD Workflow Diagram

Below is the classic GTD workflow diagram that illustrates the complete decision path from capture to engagement:

```
                      +-------------------+
                      │      Inbox        │
                      +─────────+─────────+
                                │
                                ▼
                      +─────────+─────────+
                      │ Is it actionable? │
                      +─────────+─────────+
                                │
                 ┌──────────────+──────────────┐
                 │                             │
                 ▼                             ▼
          +──────+──────+               +──────+──────+
          │      No      │               │     Yes     │
          +──────+──────+               +──────+──────+
                 │                             │
                 ▼                             ▼
        +────────+─────────+           +────────+────────+
        │ Trash/Reference/ │           │ Can I do it in  │
        │ Someday/Maybe    │           │   less than 2   │
        │                  │           │     minutes?    │
        +──────────────────+           +────────+────────+
                 │                             │
                 ▼                             ▼
        +────────+────────+           +────────+────────+
        │      Done       │           │  Yes   │   No   │
        +─────────────────+           +───+────+────+───+
                                          │         │
                                          ▼         ▼
                                +─────────+─+   +───+─────────+
                                │  Do it now │   │ Delegate?  │
                                +───────────+   +─────+───────+
                                                      │
                                              +───────+───────+
                                              │  Yes  │  No   │
                                              +───+───+───+───+
                                                  │       │
                                                  ▼       ▼
                                       +──────────+──+ +──+──────────+
                                       │ Waiting For │ │ Is it a     │
                                       │             │ │ project?    │
                                       +─────────────+ +─────+───────+
                                                             │
                                                     +───────+───────+
                                                     │  Yes  │  No   │
                                                     +───+───+───+───+
                                                         │       │
                                                         ▼       ▼
                                               +─────────+──+ +──+────────────+
                                               │  Projects  │ │ Next Actions │
                                               │            │ │              │
                                               +─────────────+ +──────────────+
```

This diagram clearly illustrates how to process each item in your inbox:
1. **Capture**: All tasks enter the inbox
2. **Clarify**: Determine if it's actionable
   - If not actionable: Trash, file as reference, or add to Someday/Maybe
   - If actionable: Continue to determine if it can be done in less than 2 minutes
3. **Organize**: Route tasks to appropriate lists based on decisions
   - Can be done in 2 minutes: Do it now
   - Needs delegation: Add to Waiting For list
   - Is a project: Add to Projects list
   - Not a project: Add to Next Actions list
4. **Engage**: Choose actions based on context

With this flowchart, users can intuitively understand how to implement the GTD workflow using this package, ensuring every task is properly processed and categorized.

### Six Horizons of Focus
### List System
### Review Process
### Context Management
### Two-Minute Rule
