;;; org-gtd-complete.el --- Complete GTD implementation for org-mode  -*- lexical-binding: t; -*-

;; Copyright (C) 2026 OverbearingPearl

;; Author: OverbearingPearl <OverbearingPearl@outlook.com>
;; Maintainer: OverbearingPearl <OverbearingPearl@outlook.com>
;; URL: https://github.com/OverbearingPearl/org-gtd-complete
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (org "9.4"))
;; Keywords: outlines, tools, convenience, productivity, gtd, org
;; Homepage: https://github.com/OverbearingPearl/org-gtd-complete

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides a complete GTD implementation for org-mode,
;; including six horizon levels: Purpose, Vision, Goals, Areas,
;; Projects, and Actions.
;;
;; Usage:
;;
;; (require 'org-gtd-complete)
;;
;; Core workflow functions:
;;
;; `org-gtd-capture' - Capture any thought, task or commitment
;; `org-gtd-process-inbox' - Process inbox items
;; `org-gtd-review' - Review the GTD system
;; `org-gtd-do' - Engage with actions based on context
;; `org-gtd-plan-project' - Plan project using natural planning
;;

;;; Code:

;; ============================================================
;; Submodule dependencies
;; ============================================================

(require 'org-gtd-complete-core)
(require 'org-gtd-complete-projects)
(require 'org-gtd-complete-lists)
(require 'org-gtd-complete-contexts)
(require 'org-gtd-complete-horizons)
(require 'org-gtd-complete-review)
(require 'org-gtd-complete-system)

;; ============================================================
;; Layer 1: Core workflow API (user facing)
;; ============================================================

;;;###autoload
(defun org-gtd-complete-capture (input)
  "Capture any thought, task or commitment to inbox.
INPUT: Content string to capture."
  (interactive "sInput to capture: ")
  (org-gtd-complete-core-capture input))

;;;###autoload
(defun org-gtd-complete-process-inbox ()
  "Process all items in inbox.
Ask five questions for each item and execute decisions immediately:
1. What is it?
2. Is it actionable?
3. Can it be done in 2 minutes?
4. Can it be delegated?
5. Is it a project?
Organize items into appropriate lists based on decisions."
  (interactive)
  (org-gtd-complete-core-process-inbox))

;;;###autoload
(defun org-gtd-complete-review (&optional level)
  "Review the GTD system.
LEVEL: Review level, can be 'daily, 'weekly, 'monthly, or 'yearly.
Default is daily review."
  (interactive)
  (org-gtd-complete-review-execute level))

;;;###autoload
(defun org-gtd-complete-do ()
  "Select and execute actions based on current context.
Consider four criteria: context, available time, available energy, priority."
  (interactive)
  (org-gtd-complete-core-engage))

;;;###autoload
(defun org-gtd-complete-plan-project (name &optional mode)
  "Unified project planning function supporting creation and enhancement.
NAME: Project name string.
MODE: Mode, can be 'create (new project), 'enhance (enhance existing)
      or 'review (enhance during review). Default is 'create.

For new projects: Start complete natural planning five steps.
For existing projects: Intelligently continue unfinished planning steps."
  (interactive "sProject name: ")
  (org-gtd-complete-projects-plan name mode))

;; ============================================================
;; Layer 2: Lists viewing API (as needed)
;; ============================================================

;;;###autoload
(defun org-gtd-complete-show (what &optional filter)
  "View lists in GTD system.
WHAT: What to view, can be:
      :inbox       - Inbox (unprocessed items)
      :projects    - All projects with their plans
      :actions     - All actionable items (next actions)
      :waiting     - All waiting/delegated items
      :someday     - Someday/Maybe items
      :context     - Items filtered by context
      :area        - Items filtered by area of responsibility
      :goal        - Items filtered by goal
      :vision      - Items filtered by vision
FILTER: Optional filter criteria.

Examples:
  (org-gtd-complete-show :actions)          ; View all actionable items
  (org-gtd-complete-show :actions \"@office\") ; View actions for office context
  (org-gtd-complete-show :projects \"health\") ; View projects in health area"
  (interactive)
  (org-gtd-complete-lists-show what filter))

;; ============================================================
;; Layer 3: Advanced operations API (occasional use)
;; ============================================================

;;;###autoload
(defun org-gtd-complete-set-context (context)
  "Set current context.
CONTEXT: Context string, e.g. \"@office\", \"@phone\"."
  (interactive "sSet current context: ")
  (org-gtd-complete-contexts-set context))


;;;###autoload
(defun org-gtd-complete-do-in-context (context)
  "Select and execute actions in specific context.
CONTEXT: Context string."
  (interactive "sExecute in context: ")
  (org-gtd-complete-contexts-engage context))

;;;###autoload
(defun org-gtd-complete-do-two-minute-tasks ()
  "Execute all tasks that can be done in 2 minutes."
  (interactive)
  (org-gtd-complete-core-do-two-minute-tasks))

;;;###autoload
(defun org-gtd-complete-brainstorm (topic)
  "Brainstorm on specific topic.
TOPIC: Brainstorming topic string."
  (interactive "sBrainstorming topic: ")
  (org-gtd-complete-projects-brainstorm topic))

;;;###autoload
(defun org-gtd-complete-trigger-list ()
  "Display trigger list questions to help empty the mind."
  (interactive)
  (org-gtd-complete-review-trigger-list))


;;;###autoload
(defun org-gtd-complete-connect-action-to-project (action project)
  "Connect action to project.
ACTION: Action identifier.
PROJECT: Project name string."
  (interactive)
  (org-gtd-complete-horizons-connect-action-to-project action project))

;;;###autoload
(defun org-gtd-complete-connect-project-to-area (proj area)
  "Connect project to area of responsibility.
PROJ: Project name string.
AREA: Area of responsibility name string."
  (interactive)
  (org-gtd-complete-horizons-connect-project-to-area proj area))

;;;###autoload
(defun org-gtd-complete-add-reference (content &optional tags)
  "Add reference material.
CONTENT: Reference content string.
TAGS: Optional tags list."
  (interactive "sReference content: ")
  (org-gtd-complete-system-add-reference content tags))

;;;###autoload
(defun org-gtd-complete-search-reference (keyword)
  "Search reference material.
KEYWORD: Search keyword string."
  (interactive "sSearch keyword: ")
  (org-gtd-complete-system-search-reference keyword))

;;;###autoload
(defun org-gtd-complete-delegate (task person)
  "Delegate task to someone.
TASK: Task description string.
PERSON: Responsible person string."
  (interactive "sTask: \nsPerson: ")
  (org-gtd-complete-core-delegate task person))

;;;###autoload
(defun org-gtd-complete-archive (proj)
  "Archive completed project.
PROJ: Project name string."
  (interactive)
  (org-gtd-complete-projects-archive proj))

;; ============================================================
;; Layer 4: System management API (setup use)
;; ============================================================

;;;###autoload
(defun org-gtd-complete-setup ()
  "Initialize GTD system setup."
  (interactive)
  (org-gtd-complete-system-setup))

;;;###autoload
(defun org-gtd-complete-status ()
  "View GTD system status overview."
  (interactive)
  (org-gtd-complete-system-status))

;;;###autoload
(defun org-gtd-complete-export ()
  "Export GTD system data."
  (interactive)
  (org-gtd-complete-system-export))

;;;###autoload
(defun org-gtd-complete-config (key &optional value)
  "Configure GTD system.
KEY: Configuration key.
VALUE: Configuration value (when setting)."
  (interactive)
  (org-gtd-complete-system-config key value))

;; ============================================================
;; Minor Mode
;; ============================================================

;;;###autoload
(define-minor-mode org-gtd-complete-mode
  "Toggle Org-GTD-Complete mode."
  :global t
  :lighter " GTD"
  :group 'org-gtd-complete
  (if org-gtd-complete-mode
      (org-gtd-complete-setup)
    (message "Org-GTD-Complete mode disabled.")))

(provide 'org-gtd-complete)

;;; org-gtd-complete.el ends here
