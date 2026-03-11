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
;; `org-gtd-complete-capture' - Capture any thought, task or commitment
;; `org-gtd-complete-process-inbox' - Process inbox items
;; `org-gtd-complete-review' - Review the GTD system
;; `org-gtd-complete-do' - Engage with actions based on context
;; `org-gtd-complete-plan-project' - Unified project planning function supporting creation and enhancement
;;

;;; Code:

;; ============================================================
;; Submodule dependencies
;; ============================================================

(require 'org-gtd-complete-projects)
(require 'org-gtd-complete-contexts)
(require 'org-gtd-complete-horizons)
(require 'org-gtd-complete-review)
(require 'org-gtd-complete-system)
(require 'org-gtd-complete-reference)
(require 'org-gtd-complete-calendar)
(require 'org-gtd-complete-inbox)
(require 'org-gtd-complete-lists)

(defcustom org-gtd-complete-base-directory (expand-file-name ".org-gtd-complete" "~")
  "Base directory for all GTD Org files."
  :type 'directory
  :group 'org-gtd-complete)

;; ============================================================
;; Capture
;; ============================================================

;;;###autoload
(defun org-gtd-complete-capture (input)
  "Capture any thought, task or commitment to inbox.
INPUT: Content string to capture."
  (interactive "sInput to capture: ")
  (org-gtd-complete-inbox-capture input))

;;;###autoload
(defun org-gtd-complete-trigger-list ()
  "Display trigger list questions to help empty the mind."
  (interactive)
  (org-gtd-complete-review-trigger-list))

;; ============================================================
;; Organize
;; ============================================================

;;;###autoload
(defun org-gtd-complete-process-inbox ()
  "Process inbox items using the inbox module."
  (interactive)
  (org-gtd-complete-inbox-process-inbox))

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

;;;###autoload
(defun org-gtd-complete-brainstorm (topic)
  "Brainstorm on specific topic.
TOPIC: Brainstorming topic string."
  (interactive "sBrainstorming topic: ")
  (org-gtd-complete-projects-brainstorm topic))

;;;###autoload
(defun org-gtd-complete-connect-action-to-project (action project)
  "Connect action to project.
ACTION: Action identifier.
PROJECT: Project name string."
  (interactive)
  (org-gtd-complete-horizons-connect-action-to-project action project))

;;;###autoload
(defun org-gtd-complete-connect-action-to-area (action area)
  "Connect action to area of responsibility.
ACTION: Action identifier.
AREA: Area of responsibility name string."
  (interactive)
  (org-gtd-complete-horizons-connect-action-to-area action area))

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
  (org-gtd-complete-reference-store content tags))

;;;###autoload
(defun org-gtd-complete-search-reference (keyword)
  "Search reference material.
KEYWORD: Search keyword string."
  (interactive "sSearch keyword: ")
  (org-gtd-complete-reference-find keyword))

;;;###autoload
(defun org-gtd-complete-delegate (task person)
  "Delegate task to someone.
TASK: Task description string.
PERSON: Responsible person string."
  (interactive "sTask: \nsPerson: ")
  (org-gtd-complete-lists-delegate task person))

;;;###autoload
(defun org-gtd-complete-archive (proj)
  "Archive completed project.
PROJ: Project name string."
  (interactive)
  (org-gtd-complete-projects-archive proj))

;;;###autoload
(defun org-gtd-complete-schedule (action &optional when)
  "Schedule an ACTION for a specific time.
ACTION: Action description string.
WHEN: When to schedule (timestamp string)."
  (interactive "sAction to schedule: \nsWhen (YYYY-MM-DD): ")
  (org-gtd-complete-calendar-schedule action when))

;; ============================================================
;; Reflect
;; ============================================================

;;;###autoload
(defun org-gtd-complete-review (&optional level)
  "Review the GTD system.
LEVEL: Review level, can be 'daily, 'weekly, 'monthly, or 'yearly.
Default is daily review."
  (interactive)
  (org-gtd-complete-review-execute level))

;;;###autoload
(defun org-gtd-complete-status ()
  "View GTD system status overview."
  (interactive)
  (org-gtd-complete-system-status))

;;;###autoload
(defun org-gtd-complete-connect-project-to-goal (proj goal)
  "Connect project to goal.
PROJ: Project name string.
GOAL: Goal name string."
  (interactive)
  (org-gtd-complete-horizons-connect-project-to-goal proj goal))

;;;###autoload
(defun org-gtd-complete-connect-project-to-vision (proj vision)
  "Connect project to vision.
PROJ: Project name string.
VISION: Vision name string."
  (interactive)
  (org-gtd-complete-horizons-connect-project-to-vision proj vision))

;;;###autoload
(defun org-gtd-complete-connect-project-to-purpose (proj purpose)
  "Connect project to purpose.
PROJ: Project name string.
PURPOSE: Purpose name string."
  (interactive)
  (org-gtd-complete-horizons-connect-project-to-purpose proj purpose))

;; ============================================================
;; Engage
;; ============================================================

;;;###autoload
(defun org-gtd-complete-do ()
  "Select and execute actions based on current context.
Consider four criteria: context, available time, available energy, priority."
  (interactive)
  (let ((context (completing-read "Context: " org-gtd-complete-contexts--defined)))
    (org-gtd-complete-lists-show :actions :context context)))

;;;###autoload
(defun org-gtd-complete-do-in-context (context)
  "Select and execute actions in specific context.
CONTEXT: Context string."
  (interactive "sExecute in context: ")
  (org-gtd-complete-contexts-do context))

;;;###autoload
(defun org-gtd-complete-today ()
  "Show all scheduled actions for today."
  (interactive)
  (org-gtd-complete-calendar-show-today))

;;;###autoload
(defun org-gtd-complete-week ()
  "Show all scheduled actions for the week."
  (interactive)
  (org-gtd-complete-calendar-show-week))

;; ============================================================
;; System Management
;; ============================================================

;;;###autoload
(defun org-gtd-complete-setup ()
  "Initialize GTD system setup."
  (interactive)
  (org-gtd-complete-system-setup))

;;;###autoload
(defun org-gtd-complete-export ()
  "Export GTD system data."
  (interactive)
  (org-gtd-complete-system-export))

;;;###autoload
(defun org-gtd-complete-config (key &optional value)
  "Configure GTD system at runtime.
KEY: Configuration key.
VALUE: Configuration value (when setting)."
  (interactive)
  (org-gtd-complete-system-configure key value))

;; ============================================================
;; Utility
;; ============================================================

;;;###autoload
(defalias 'org-gtd-complete-show 'org-gtd-complete-lists-show)

;; ============================================================
;; Minor Mode
;; ============================================================

;;;###autoload
(define-minor-mode org-gtd-complete-mode
  "Toggle Org-GTD-Complete mode."
  :lighter " GTD"
  :group 'org-gtd-complete
  (if org-gtd-complete-mode
      (org-gtd-complete-setup)
    (message "Org-GTD-Complete mode disabled.")))

(provide 'org-gtd-complete)

;;; org-gtd-complete.el ends here
