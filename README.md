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

Key Insight:
- L4-L6 can only be inherited through L2 Projects
- L1 actions without a project can at most be linked to L3 (Areas of Responsibility)
- L1 is always L1, the difference lies in the connection point

(Note: The diagram uses two different paths and annotations to visually distinguish between the two types of actions: project actions connect upward to L6 via solid arrows, while standalone actions connect only to L3 via dotted arrows and terminate at that level.)

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
   Records all desired outcomes that require multiple steps. Each project contains its full plan (all steps), expected result, and associated higher-level horizons (L4-L6).

2. **Single Actions List**
   Records standalone actionable items that do not belong to any project. These actions are linked directly to areas of responsibility (L3) and have no project-level planning.

#### Upward-Mapping Virtual Lists

**Virtual lists** are dynamic views derived from core lists according to different perspectives; they do not duplicate task storage:

- **L3 Areas of Responsibility**
  Maps all actions from core lists to their life areas (e.g., Health, Career, Family).

- **L4 Goals**
  Maps projects created to achieve specific medium-term goals.

- **L5 Vision**
  Maps projects aligned with long-term vision.

- **L6 Purpose & Core Values**
  Maps projects reflecting fundamental life meaning and principles.

Upward mapping follows the six-horizon rule: **L4-L6 are inherited only through projects**; **single actions map at most to L3**.

#### Downward-Mapping Virtual Lists

Based on execution status, actions from core lists can be dynamically grouped into the following virtual lists:

1. **Next Actions List**
   Contains all **immediately actionable** items, coming from:
   - The **next concrete step** of each active project in the Projects list
   - **Currently actionable** items in the Single Actions list

2. **Waiting For List**
   Contains all **delegated or pending-external-event** actions, also originating from either the Projects or Single Actions list.

Downward mapping follows the **transfer-station principle**: when a step within a project or a single action needs to be executed, it temporarily "moves out" from the core list into the appropriate virtual list (Next Actions or Waiting For), leaving a placeholder in the core list (e.g., "in-progress", "waiting" status). Upon completion it returns to the core list and is marked as done.

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
3. **Consistency**: Task-status changes (delegate, execute, complete) are recorded once in the core list; virtual lists automatically stay synchronized.

All lists should be maintained through **regular reviews** (especially the weekly review) to keep the system trustworthy and up-to-date.

### Review Process

The review process is a critical component of the GTD system that ensures the entire system remains current, effective, and trustworthy. Without regular reviews, a GTD system gradually loses its value—new tasks get missed, projects lose momentum, and the system becomes unreliable.

#### Core Purposes of Review

The review process addresses several key questions:
- **Brain dump**: Transfer new tasks, ideas, and commitments from your mind to the inbox
- **Status update**: Ensure all task statuses reflect actual current situations
- **Recalibration**: Adjust priorities and schedules based on the latest circumstances
- **Catch oversights**: Identify projects or actions that might have been overlooked
- **Maintain momentum**: Sustain execution motivation by seeing progress

#### Daily Review

The daily review is a process for planning and confirming the current day and next day, recommended at the start of each day, typically taking 10-20 minutes.

**Daily Review Checklist**:

1. **Review Calendar**
   - Confirm today's appointments and fixed schedule
   - Check if there are items requiring advance preparation

2. **Review Next Actions List**
   - Identify all actions executable in the current context
   - Filter available actions based on context (location, tools, time)
   - Decide on priority actions for the day

3. **Process Inbox**
   - Clear all new inputs since the last review
   - Process each item: Is it actionable?
   - Determine next actions and distribute to appropriate lists

4. **Update Waiting For List**
   - Review all waiting items
   - Follow up on overdue items
   - Confirm status of delegated tasks

5. **Review Schedule**
   - Confirm important appointments for tomorrow
   - Prepare materials and actions needed for tomorrow in advance

**Daily Review Best Practices**:
- Perform daily review at a fixed time each day (e.g., each morning before work)
- Keep reviews brief but efficient
- Write new ideas directly to the inbox; don't process them during the review

#### Weekly Review

The weekly review is the most critical review in the GTD system, recommended at a fixed time each week, typically taking 1-2 hours. The purpose is to fully update all lists, review project progress, and recalibrate priorities.

**Weekly Review Checklist**:

**Phase 1: Preparation & Clearing (15 minutes)**

1. **Clear Inbox**
   - Process all unprocessed items accumulated during the week
   - For each item: process, file, or discard

2. **Clear Your Head**
   - Transfer all thoughts, worries, and todos to the inbox
   - Use the "trigger list" (see below) for brainstorming

**Phase 2: Review & Update (45-60 minutes)**

3. **Review Projects List**
   - Check each project one by one
   - Confirm project status: active, on hold, completed
   - Identify stagnant projects and analyze blockers
   - Determine the next concrete action for each project

4. **Review Actions List**
   - Clear completed or expired actions
   - Reassess priorities and adjust order
   - Confirm all actions have clear next steps

5. **Review Waiting For List**
   - Check each waiting item
   - Take action on items needing follow-up
   - Confirm status of delegated tasks

6. **Review Someday/Maybe List**
   - Review currently inactive projects
   - Any projects that can be activated?
   - Any projects that can be discarded?

7. **Review Reference Material**
   - Organize filed reference materials
   - Ensure the reference system remains orderly and usable

**Phase 3: Outlook & Planning (15-30 minutes)**

8. **Review Areas of Responsibility**
   - Confirm status of each area
   - Identify areas needing attention but being neglected

9. **Review Six Horizons**
   - L3: Any new areas of responsibility to add?
   - L4: Are current goals still relevant? Need adjustment?
   - L5: Is vision still clear? Any new ideas?
   - L6: Are core values being reflected?

10. **Plan Next Week**
    - Select projects requiring attention from the projects list
    - Determine key goals for next week
    - Mark key dates on calendar

**Trigger List (For Clearing Your Head)**

Here are trigger questions to help clear your head:
- What concerns you?
- What have you been procrastinating on?
- What needs to be done before a specific time?
- What have you promised others?
- What would you like to accomplish?
- What could make your life or work better?
- What reference materials might you need?

#### Monthly/Annual Review

Monthly reviews focus on higher-level strategic thinking, while annual reviews address life direction and long-term goals.

**Monthly Review Checklist**:

1. **Review Monthly Goals**
   - Evaluate completion of last month's goals
   - Identify successes and areas for improvement

2. **Review Project Health**
   - Check overall status of all projects
   - Identify projects needing reassessment or adjustment

3. **Review Areas of Responsibility**
   - Evaluate satisfaction with each area
   - Identify areas needing more attention or resources

4. **Look Ahead to Next Month**
   - Set main goals for next month
   - Confirm important deadlines and milestones

**Annual Review Checklist**:

1. **Evaluate Annual Goals**
   - Review goals set for the past year
   - Assess completion and lessons learned

2. **Review Vision**
   - Think about your 3-5 year life vision
   - Any directions needing adjustment?

3. **Review Core Values**
   - Confirm if core values have changed
   - Consider how to better embody core values

4. **Set New Year Goals**
   - Set new year goals based on vision and values
   - Break goals down into projects and actions

#### Review Rhythm and Habits

Building effective review habits requires:

1. **Fixed Time**
   - Daily review: fixed time (e.g., each morning)
   - Weekly review: fixed time (e.g., Friday afternoon or Sunday)
   - Monthly review: first or last day of each month
   - Annual review: January each year or your birthday month

2. **Protect the Time**
   - Treat review time as an important appointment
   - Avoid handling other matters during this time

3. **Build Checklists**
   - Create personalized review checklists
   - Gradually refine checklist content

4. **Keep It Simple**
   - Don't let reviews become overly complex
   - Focus on the most critical checkpoints

5. **Continuous Improvement**
   - Record issues from reviews
   - Constantly optimize the review process

By sticking to regular reviews, the GTD system will remain active and effective, becoming a truly reliable assistant in your life and work.

### Context Management

Context is a key dimension in the GTD system used for filtering and executing actions. Context defines the specific conditions required to perform an action, including location, tools, time, energy, and other factors. Through context management, users can quickly identify all executable actions in a given environment, enabling efficient time allocation decisions.

#### Core Functions of Context

Context management addresses several key questions:
- **Environment matching**: Filter actions based on current location and available tools
- **Efficiency optimization**: Avoid attempting actions that require different conditions in unsuitable contexts
- **Decision simplification**: Reduce choice paralysis by quickly identifying executable actions in a given context

#### Common Context Types

**Location Contexts**

Location contexts organize actions based on physical location:
- **@Office**: Tasks that need to be completed in an office environment
- **@Home**: Tasks that can be done at home
- **@Errands**: Tasks to do while running outside
- **@Phone**: Items that require a phone call
- **@Email**: Tasks involving email communication

**Tool Contexts**

Tool contexts organize actions based on required tools or resources:
- **@Computer**: Tasks requiring computer use (specific software)
- **@Phone**: Tasks that can be completed on a mobile phone
- **@Paper**: Tasks requiring pen and paper
- **@Meeting**: Items to discuss in meetings

**Time Contexts**

Time contexts filter actions based on available time:
- **2min**: Quick tasks that can be completed in 2 minutes
- **15min**: Actions taking around 15 minutes
- **1hr**: Longer actions requiring focused deep work
- **Waiting**: Tasks for碎片 time while waiting for others

**Energy Contexts**

Energy contexts match actions with current energy levels:
- **High Energy**: Complex tasks requiring high focus
- **Medium Energy**: Routine tasks
- **Low Energy**: Simple, mechanical tasks
- **Creative**: Tasks requiring creative thinking

**Social Contexts**

Social contexts categorize actions based on whether interaction with others is needed:
- **Alone**: Tasks that can be completed independently
- **Conversation**: Tasks requiring face-to-face or online communication with others
- **Team**: Items that need to be handled in a team environment

#### Building a Personal Context System

Establishing a context system requires considering your personal life and work characteristics:

1. **Analyze Daily Activities**
   - List locations you frequently visit
   - Identify commonly used tools and devices
   - Assess energy levels at different times

2. **Select Core Contexts**
   - Choose 5-10 most frequently used contexts
   - Avoid too many contexts that complicate the system
   - Regularly evaluate whether contexts remain applicable

3. **Context Naming Conventions**
   - Use clear, concise names
   - Maintain consistent naming style
   - Avoid ambiguity

#### Practical Examples

Suppose you have set up the following contexts:

**@Office**:
- "Write project report"
- "Reply to work emails"
- "Organize file archives"

**@Phone**:
- "Schedule doctor's appointment"
- "Contact supplier to confirm delivery time"
- "Return client call"

**@Computer**:
- "Update spreadsheet"
- "Organize digital notes"

**2min**:
- "Acknowledge receipt of email"
- "Record a phone number"
- "Reply to simple message"

When you're at the office, you can quickly view all actions in the "@Office" context; when you have only 2 minutes of碎片 time, you can choose a quick task from the "2min" context.

#### Distinction Between Contexts and Projects

Contexts and projects are two different organizational dimensions:

- **Projects** focus on the **goal** of a task—the desired outcome
- **Contexts** focus on the **execution conditions** of a task—how and where to execute it

Different steps within the same project may belong to different contexts. For example, the project "Prepare Quarterly Report" might have the following context distribution:
- **@Office**: Write report body
- **@Computer**: Create data charts
- **@Conversation**: Present draft to manager for feedback

#### Best Practices for Context Management

1. **Appropriate Number of Contexts**
   - Keep 5-15 core contexts
   - Too many contexts increase maintenance burden
   - Too few contexts reduce filtering efficiency

2. **Dynamic Context Updates**
   - Adjust contexts based on life changes
   - Periodically clean up unused contexts
   - Keep contexts matching actual activities

3. **Combine with Reviews**
   - Check context settings during weekly reviews
   - Ensure contexts cover all action types
   - Optimize context structure for execution efficiency

4. **Flexible Combination**
   - Actions can be associated with multiple contexts
   - Choose the most suitable context perspective based on actual situation
   - Use contexts to quickly switch work modes

Through effective context management, the GTD system helps users quickly do the right things in the right context, investing limited energy into the most suitable actions.

### Two-Minute Rule

The Two-Minute Rule is a simple yet effective time management technique in GTD for quickly handling tasks that can be completed in two minutes or less.

#### Core Idea of the Two-Minute Rule

If a task can be completed in two minutes or less, do it immediately rather than postponing it. The benefits are:
- Avoid piling up small tasks and reduce the number of items in the inbox
- Reduce decision burden because you don't need to schedule time for small tasks
- Quickly completing small tasks can bring a sense of accomplishment and motivate you to continue processing other tasks

#### How to Apply the Two-Minute Rule

1. **When processing the inbox**
   - When processing items in the inbox, if you determine that an item is actionable and can be completed in two minutes or less, execute it immediately.
   - Example: Reply to a short email, confirm a meeting time, record a phone number, etc.

2. **During execution**
   - When you are executing an action and suddenly think of a small task that can be completed in two minutes, you can complete it first and then continue with the original action.
   - Example: While writing a report, you suddenly remember you need to reply to a short email. You can spend two minutes replying to the email and then continue writing the report.

3. **During review**
   - During daily or weekly review, check for any missed small tasks. If they can be completed in two minutes, handle them immediately.

#### Precautions

- **Strictly adhere to the time limit**: Only apply this rule to tasks that can truly be completed in two minutes. If a task takes longer, schedule it in the Next Actions list.
- **Avoid interruptions**: If a two-minute task would interrupt your deep work, record it and handle it later.
- **Keep the inbox empty**: The Two-Minute Rule helps quickly empty the inbox, but don't sacrifice task quality for speed.

#### Practical Example

Suppose your inbox has the following items:
- "Reply to colleague's email" (estimated 1 minute) -> Execute immediately
- "Call client" (estimated 5 minutes) -> Add to Next Actions list
- "Organize desk" (estimated 10 minutes) -> Add to Next Actions list
- "Read an interesting article" (estimated 3 minutes) -> Add to Next Actions list

By applying the Two-Minute Rule, you can quickly handle small tasks, thus reserving more energy for tasks that require deep work.

#### Limitations of the Two-Minute Rule

While the Two-Minute Rule is very practical, it has limitations:
- For complex tasks, the Two-Minute Rule is not applicable and requires further decomposition and planning.
- Frequent application of the Two-Minute Rule may lead to frequent task switching, affecting the efficiency of deep work.
- In some cases, two-minute tasks may only be surface-level work, providing temporary relief.

Therefore, the Two-Minute Rule should be used in conjunction with other GTD principles to form a complete task management system.
