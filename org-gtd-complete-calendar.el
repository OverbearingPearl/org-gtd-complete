;;; org-gtd-complete-calendar.el --- Calendar integration for GTD  -*- lexical-binding: t; -*-

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

;; Calendar integration for GTD system
;; This module provides functions to:
;; - Schedule actions with deadlines or appointments
;; - View scheduled actions in calendar
;; - Manage time-based commitments

;;; Code:

(defvar org-gtd-complete-calendar--scheduled-file "gtd-scheduled.org"
  "File for storing scheduled actions.")

;;;###autoload
(defun org-gtd-complete-calendar-schedule (action &optional when)
  "Schedule an ACTION for a specific time.
ACTION: Action description string.
WHEN: When to schedule (timestamp string). If nil, prompt user."
  (interactive "sAction to schedule: \nsWhen (e.g., 2024-03-15): ")
  (let ((timestamp (or when (read-string "Date (YYYY-MM-DD): "))))
    (with-current-buffer (find-file-noselect org-gtd-complete-calendar--scheduled-file)
      (goto-char (point-max))
      (insert (format "* TODO %s\n  SCHEDULED: <%s>\n" action timestamp))
      (save-buffer)
      (message "Scheduled: %s for %s" action timestamp))))

;;;###autoload
(defun org-gtd-complete-calendar-view-today ()
  "View all scheduled actions for today."
  (interactive)
  (org-gtd-complete-lists-show :actions :scheduled 'today))

;;;###autoload
(defun org-gtd-complete-calendar-view-week ()
  "View all scheduled actions for the week."
  (interactive)
  (org-gtd-complete-lists-show :actions :scheduled 'week))

(provide 'org-gtd-complete-calendar)

;;; org-gtd-complete-calendar.el ends here
