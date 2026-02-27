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
      +----------+
      | Capture  |
      +-----+----+
            |
            v
      +-----+----+
      | Clarify  |
      +-----+----+
            |
            v
      +-----+----+
      | Organize |
      +-----+----+
            |
            v
      +-----+----+
      | Reflect  |
      +-----+----+
            |
            v
      +-----+----+
      |  Engage  |
      +----------+
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
              |       Inbox       |
              +---------+---------+
                        |
                        v
              +---------+---------+
              | Is it actionable? |
              +---------+---------+
                        |
          +-------------+------------+
          |                          |
          v                          v
   +------+------+            +------+------+
   |      No     |            |     Yes     |
   +------+------+            +------+------+
          |                          |
          v                          v
  +--------+------+          +-------+------+
  | Trash/        |          | Can I do it  |
  | Reference/    |          | in less than |
  | Someday/Maybe |          |  2 minutes?  |
  +-------+-------+          +-------+------+
          |                          |
          v                          v
  +-------+-------+           +------+------+
  |      Done     |           |  Yes |  No  |
  +---------------+           +--+---+---+--+
                                 |       |
                                 v       v
                        +--------+--+ +--+--------+
                        | Do it now | | Delegate? |
                        +-----------+ +-----+-----+
                                            |
                                     +------+------+
                                     |  Yes |  No  |
                                     +--+---+---+--+
                                        |       |
                                        v       |
                             +----------+--+    |
                             | Waiting For |    |
                             +------+------+    |
                                    |           |
                This is where GTD's description |
                is somewhat vague, even when    |
                delegated, it must still be     |
                determined whether it belongs   |
                to a project.                   |
                                    |           |
                                    v           v
                                +---+-----------+--+
                                | Is it a project? |
                                +---------+--------+
                                          |
                                   +------+------+
                                   |  Yes |  No  |
                                   +--+---+---+--+
                                      |       |
                                      v       v
                              +-------+--+ +--+-------------+
                              | Projects | | Single Actions |
                              +----------+ +----------------+
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
   - Not a project: Add to Single Actions list
4. **Engage**: Choose actions based on context

With this flowchart, users can intuitively understand how to implement the GTD workflow using this package, ensuring every task is properly processed and categorized.

### Six Horizons of Focus

GTD's "Six Horizons of Focus" provides a complete perspective framework from concrete actions to life goals. Each level represents a different layer of focus, helping users think and plan at appropriate levels of abstraction.

Key Rules:
- **L4-L6 are set only at the project or responsibility level**: Higher horizons (Goals, Vision, Purpose) should not be directly linked to individual actions, but rather reflected through projects or areas of responsibility.
- **Individual actions can be linked up to L3 (Area) at most**: Specific actions can belong to a responsibility area, but cannot directly have higher-level horizon tags.
- **Actions inherit L4-L6 through their associated projects**: When an action belongs to a project, it automatically inherits the higher horizons linked to that project, without needing duplicate settings.
- **Standalone actions (not part of any project) should not have L4-L6 horizons**: These actions should only be linked to L3 areas, not reaching higher levels.

Below is a basic ASCII diagram of the six horizons:

```
  +---------------------------+
  | L6: Purpose & Core Values |
  +-------------+-------------+
                ^
                |
  +-------------+-------------+
  |         L5: Vision        |
  +-------------+-------------+
                ^
                |
  +-------------+-------------+
  |         L4: Goals         |
  +-------------+-------------+
                ^                    ◉ stops here
                |                     |
  +-------------+---------------------+-----+
  |       L3: Areas of Responsibility       |
  +-------------+---------------------+-----+
                ^                     ^
                |                     |
  +-------------+-------------+       |
  |        L2: Projects       |  not part of any project
  +-------------+-------------+       |
                ^                     |
                |                     |
  +-------------+---------------------+-----+
  |            L1: Next Actions             |
  +-----------------------------------------+
```

(Note: The diagram uses different line styles and annotations to visually distinguish between the two types of actions: project actions connect upward to L6 via solid arrows, while standalone actions connect only to L3 via dotted arrows and terminate at that level.)

#### Detailed Explanation of Each Level

**L1: Next Actions**
- Concrete physical actions that can be done immediately.
- Examples: "Email client to confirm meeting time", "Buy printer ink".
- **Key Distinction**:
  - Actions belonging to projects: Inherit L2-L6 horizons from the project
  - Standalone actions: Can only link up to L3 (Area), no L4-L6 involvement

**L2: Projects**
- Desired outcomes that require multiple steps to complete.
- Each project should be linked to at least one area of responsibility (L3).
- Examples: "Complete quarterly report", "Organize team-building event".
- Projects themselves can have L4-L6 tags.

**L3: Areas of Responsibility**
- Important areas of life that require ongoing attention and maintenance.
- Examples: Health, Family, Career Development, Financial Management.
- All actions (both project and standalone) can be linked to areas.

**L4: Goals**
- Medium-term objectives to be achieved within 1-2 years.
- Examples: "Get promoted to technical lead", "Complete marathon training".
- Goals are realized through projects, not directly linked to individual actions.

**L5: Vision**
- Long-term outlook and life picture for the next 3-5 years.
- Examples: "Become a domain expert", "Establish stable passive income".
- Vision is materialized through goals, which are then implemented via projects.

**L6: Purpose & Core Values**
- Fundamental life meaning and guiding principles.
- Examples: "Help others grow", "Pursue technological innovation".
- This is the highest horizon, guiding all lower-level decisions.

#### Practical Example

Suppose your core value (L6) is "Maintain a healthy lifestyle", vision (L5) is "Have abundant energy", and goal (L4) is "Complete a half marathon this year". To achieve this goal, you create a project (L2) "Half Marathon Training Plan", which belongs to the area of responsibility (L3) "Health".

**Project Actions**:
- Next actions within the project: "Run three times per week", "Buy professional running shoes"
- These actions **automatically inherit** the project's L2-L6 horizons

**Standalone Actions**:
- Actions not part of any project: "Weigh myself today"
- Can be linked to area (L3) "Health"
- **But should NOT** be linked to L4 (Goal: "Complete half marathon"), L5 (Vision), or L6 (Core Values)

In org-gtd-complete, you only need to set L4-L6 tags at the project level. All actions belonging to that project will automatically inherit these higher horizons. Standalone actions only require area (L3) tagging, and the system ensures they won't incorrectly link to L4-L6. This ensures system simplicity and consistency.

### List System

GTD's list architecture employs a **hierarchy of core lists and virtual lists**, ensuring tasks are stored completely according to their organizational structure while being accessed flexibly based on execution status.

#### Key Concept Distinctions

When understanding the GTD list system, it's important to clarify the distinctions between several key concepts:

**Next Actions vs Single Actions**

- **Next Actions**: Refers to **concrete actions that can be done immediately**. This is a **virtual list** whose items come from two sources:
  1. The **next concrete step** of each active project in the Projects list
  2. **Currently actionable** items in the Single Actions list

- **Single Actions**: Refers to **standalone actionable items that don't belong to any project**. This is a **core list** that stores all independent tasks that don't require multiple steps.

**In simple terms**:
- The Single Actions list is where independent tasks are **stored**
- The Next Actions list is a **dynamically generated** view containing all currently executable tasks (both the next steps of projects and executable single actions)

**Waiting For List**: Refers to tasks that are **delegated to others or pending external events**. This is also a **virtual list**, whose items similarly originate from either the Projects list or Single Actions list.

#### Core Lists (Physical Storage)

**Core lists** are where tasks are originally recorded and form the foundation of the GTD system:

1. **Projects List**
   Records all desired outcomes that require multiple steps. Each project contains its full plan (all steps), expected result, and associated higher‑level horizons (L4‑L6).

2. **Single Actions List**
   Records standalone actionable items that do not belong to any project. These actions are linked directly to areas of responsibility (L3) and have no project‑level planning.

#### Upward‑Mapping Virtual Lists

**Virtual lists** are dynamic views derived from core lists according to different perspectives; they do not duplicate task storage:

- **L3 Areas of Responsibility**
  Maps all actions from core lists to their life areas (e.g., Health, Career, Family).

- **L4 Goals**
  Maps projects created to achieve specific medium‑term goals.

- **L5 Vision**
  Maps projects aligned with long‑term vision.

- **L6 Purpose & Core Values**
  Maps projects reflecting fundamental life meaning and principles.

Upward mapping follows the six‑horizon rule: **L4‑L6 are inherited only through projects**; **single actions map at most to L3**.

#### Downward‑Mapping Virtual Lists

Based on execution status, actions from core lists can be dynamically grouped into the following virtual lists:

1. **Next Actions List**
   Contains all **immediately actionable** items, coming from:
   - The **next concrete step** of each active project in the Projects list
   - **Currently actionable** items in the Single Actions list

2. **Waiting For List**
   Contains all **delegated or pending‑external‑event** actions, also originating from either the Projects or Single Actions list.

Downward mapping follows the **transfer‑station principle**: when a step within a project or a single action needs to be executed, it temporarily "moves out" from the core list into the appropriate virtual list (Next Actions or Waiting For), leaving a placeholder in the core list (e.g., "in‑progress", "waiting" status). Upon completion it returns to the core list and is marked as done.

#### Auxiliary Lists

- **Inbox**: Temporary collection of all unprocessed inputs.
- **Someday/Maybe List**: Ideas or tasks not to be acted on now but possibly in the future.
- **Reference Material**: Information that requires no action but should be kept.

#### List Interaction Diagram

```
            +----------------------------------+
            |       Core Lists (Storage)       |
            |  +----------------------------+  |
            |  |       Projects List        |  |
            |  +----------------------------+  |
            |  |    Single Actions List     |  |
            |  +----------------------------+  |
            +----------------+-----------------+
                             |
                +------------+--------------+
                |                           |
                v                           v
    +-----------+----------+   +------------+-----------+
    | Upward Virtual Lists |   | Downward Virtual Lists |
    |       (Horizons)     |   |         (Status)       |
    +-----------+----------+   +------------+-----------+
                |                           |
    +------+----+-+-------+          +------+------+
    |      |      |       |          |             |
    v      v      v       v          v             v
   L3     L4     L5      L6     Next Actions   Waiting For
(Areas)(Goals)(Vision)(Purpose)                (Delegated)
```

#### Practical Implications

1. **Completeness**: Core lists keep a complete record of every task (project steps, standalone actions), enabling holistic review.
2. **Flexibility**: Virtual lists let users focus only on the relevant current view (e.g., "what can I do in the office today?", "all pending project tasks").
3. **Consistency**: Task‑status changes (delegate, execute, complete) are recorded once in the core list; virtual lists automatically stay synchronized.

All lists should be maintained through **regular reviews** (especially the weekly review) to keep the system trustworthy and up‑to‑date.

### Review Process
### Context Management
### Two-Minute Rule
