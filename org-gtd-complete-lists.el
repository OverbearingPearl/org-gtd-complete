;;; org-gtd-complete-lists.el --- Lists management implementation  -*- lexical-binding: t; -*-

;; Copyright (C) 2026 OverbearingPearl

;; Author: OverbearingPearl <OverbearingPearl@outlook.com>
;; Maintainer: OverbearingPearl <OverbearingPearl@outlook.com>
;; URL: https://github.com/OverbearingPearl/org-gtd-complete
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (org "9.4"))
;; Keywords: outlines, tools, convenience, productivity, gtd, org

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

;; Lists management implementation
;; This module serves as the unified query entry point for GTD lists,
;; supporting multi-dimensional filtering (context + project + status, etc.)

;;; Code:

(defvar org-gtd-complete-lists--inbox-file "gtd-inbox.org"
  "Inbox file name.")

(defvar org-gtd-complete-lists--projects-file "gtd-projects.org"
  "Projects file name.")

(defvar org-gtd-complete-lists--single-actions-file "gtd-single-actions.org"
  "Single actions file name.")

(defun org-gtd-complete-lists--get-inbox ()
  "Get all items from inbox."
  (org-gtd-complete-lists--query-file org-gtd-complete-lists--inbox-file))

(defun org-gtd-complete-lists--get-projects ()
  "Get all projects."
  (org-gtd-complete-lists--query-file org-gtd-complete-lists--projects-file))

(defun org-gtd-complete-lists--get-single-actions ()
  "Get all single actions (independent tasks)."
  (org-gtd-complete-lists--query-file org-gtd-complete-lists--single-actions-file))

(defun org-gtd-complete-lists--query-file (file)
  "Query items from FILE.
FILE: File name string."
  ;; TODO: Implement actual file reading and parsing
  (message "Querying file: %s" file)
  nil)

(defun org-gtd-complete-lists--filter-by-context (items context)
  "Filter ITEMS by CONTEXT.
ITEMS: List of items to filter.
CONTEXT: Context string like \"@office\"."
  (seq-filter (lambda (item)
                (member context (plist-get item :contexts)))
              items))

(defun org-gtd-complete-lists--filter-by-project (items project)
  "Filter ITEMS by PROJECT.
ITEMS: List of items to filter.
PROJECT: Project name string."
  (seq-filter (lambda (item)
                (string= project (plist-get item :project)))
              items))

(defun org-gtd-complete-lists--filter-by-status (items status)
  "Filter ITEMS by STATUS.
ITEMS: List of items to filter.
STATUS: Status symbol (:waiting :delegated :pending :completed)."
  (seq-filter (lambda (item)
                (eq status (plist-get item :status)))
              items))

(defun org-gtd-complete-lists--filter-by-area (items area)
  "Filter ITEMS by AREA of responsibility.
ITEMS: List of items to filter.
AREA: Area name string."
  (seq-filter (lambda (item)
                (member area (plist-get item :areas)))
              items))

(defun org-gtd-complete-lists--filter-by-goal (items goal)
  "Filter ITEMS by GOAL.
ITEMS: List of items to filter.
GOAL: Goal name string."
  (seq-filter (lambda (item)
                (member goal (plist-get item :goals)))
              items))

(defun org-gtd-complete-lists--filter-by-vision (items vision)
  "Filter ITEMS by VISION.
ITEMS: List of items to filter.
VISION: Vision name string."
  (seq-filter (lambda (item)
                (member vision (plist-get item :visions)))
              items))

(defun org-gtd-complete-lists--filter-by-scheduled (items period)
  "Filter ITEMS by scheduled time period.
ITEMS: List of items to filter.
PERIOD: Time period (:today :week :month :year)."
  (seq-filter (lambda (item)
                (let ((scheduled (plist-get item :scheduled)))
                  (and scheduled
                       (pcase period
                         ('today (org-gtd-complete-lists--same-day-p scheduled (current-time)))
                         ('week (org-gtd-complete-lists--same-week-p scheduled (current-time)))
                         ('month (org-gtd-complete-lists--same-month-p scheduled (current-time)))
                         ('year (org-gtd-complete-lists--same-year-p scheduled (current-time)))))))
              items))

(defun org-gtd-complete-lists--same-day-p (time1 time2)
  "Check if TIME1 and TIME2 are on the same day."
  (equal (calendar-gregorian-from-absolute (time-to-days time1))
         (calendar-gregorian-from-absolute (time-to-days time2))))

(defun org-gtd-complete-lists--same-week-p (time1 time2)
  "Check if TIME1 and TIME2 are in the same week."
  (let* ((day1 (time-to-days time1))
         (day2 (time-to-days time2))
         (diff (- day2 day1)))
    (and (>= diff 0) (< diff 7))))

(defun org-gtd-complete-lists--same-month-p (time1 time2)
  "Check if TIME1 and TIME2 are in the same month."
  (let ((date1 (calendar-gregorian-from-absolute (time-to-days time1)))
        (date2 (calendar-gregorian-from-absolute (time-to-days time2))))
    (and (= (cadr date1) (cadr date2)) (= (caddr date1) (caddr date2)))))

(defun org-gtd-complete-lists--same-year-p (time1 time2)
  "Check if TIME1 and TIME2 are in the same year."
  (= (car (calendar-gregorian-from-absolute (time-to-days time1)))
     (car (calendar-gregorian-from-absolute (time-to-days time2)))))

(defun org-gtd-complete-lists--apply-filters (items filters)
  "Apply multiple FILTERS to ITEMS.
ITEMS: List of items to filter.
FILTERS: Plist of filter criteria like (:context \"@office\" :project \"购买汽车\")."
  (let ((result items))
    (when (plist-member filters :context)
      (setq result (org-gtd-complete-lists--filter-by-context
                    result (plist-get filters :context))))
    (when (plist-member filters :project)
      (setq result (org-gtd-complete-lists--filter-by-project
                    result (plist-get filters :project))))
    (when (plist-member filters :status)
      (setq result (org-gtd-complete-lists--filter-by-status
                    result (plist-get filters :status))))
    (when (plist-member filters :area)
      (setq result (org-gtd-complete-lists--filter-by-area
                    result (plist-get filters :area))))
    (when (plist-member filters :goal)
      (setq result (org-gtd-complete-lists--filter-by-goal
                    result (plist-get filters :goal))))
    (when (plist-member filters :vision)
      (setq result (org-gtd-complete-lists--filter-by-vision
                    result (plist-get filters :vision))))
    (when (plist-member filters :scheduled)
      (setq result (org-gtd-complete-lists--filter-by-scheduled
                    result (plist-get filters :scheduled))))
    result))

;;;###autoload
(defun org-gtd-complete-lists-show (what &rest filters)
  "View lists in GTD system with multi-dimensional filtering.
WHAT: What to view, can be:
      :inbox       - Inbox (unprocessed items)
      :projects    - All projects with their plans
      :actions     - All actionable items (next actions)
      :waiting     - All waiting/delegated items
      :someday     - Someday/Maybe items
FILTERS: Optional filter criteria as plist:
      :context     - Filter by context (e.g., \"@office\", \"@phone\")
      :project     - Filter by project name
      :status      - Filter by status (:waiting :delegated :pending :completed)
      :area        - Filter by area of responsibility
      :goal        - Filter by goal
      :vision      - Filter by vision

Examples:
  (org-gtd-complete-lists-show :actions)
  (org-gtd-complete-lists-show :actions :context \"@office\")
  (org-gtd-complete-lists-show :actions :context \"@phone\" :project \"购买汽车\" :status :waiting)"
  (pcase what
    (:inbox
     (org-gtd-complete-lists--apply-filters
       (org-gtd-complete-lists--get-inbox) filters))
    (:projects
     (org-gtd-complete-lists--apply-filters
       (org-gtd-complete-lists--get-projects) filters))
    (:single-actions
     (org-gtd-complete-lists--apply-filters
       (org-gtd-complete-lists--get-single-actions) filters))
    (:actions
     (let ((projects-actions (org-gtd-complete-lists--get-projects))
           (single-actions (org-gtd-complete-lists--get-single-actions)))
       (org-gtd-complete-lists--apply-filters
        (append projects-actions single-actions) filters)))
    (:waiting
     (let ((projects-actions (org-gtd-complete-lists--get-projects))
           (single-actions (org-gtd-complete-lists--get-single-actions)))
       (org-gtd-complete-lists--apply-filters
        (append projects-actions single-actions) (plist-put filters :status :waiting))))
    (:someday
     (org-gtd-complete-lists--apply-filters
       (org-gtd-complete-lists--get-inbox) (plist-put filters :status :someday)))
    (_
     (error "Invalid what: %s" what))))

(provide 'org-gtd-complete-lists)

;;; org-gtd-complete-lists.el ends here
