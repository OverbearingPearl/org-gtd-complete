;;; org-gtd-complete-contexts.el --- Context management implementation  -*- lexical-binding: t; -*-

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

;; Context management implementation
;; This module is responsible for:
;; - Defining and managing contexts (@office, @phone, etc.)
;; - Setting current active context
;; - Executing actions within a specific context
;; Note: Complex multi-dimensional queries should use org-gtd-complete-lists-show

;;; Code:

(defvar org-gtd-complete-contexts--defined
  '("@office" "@home" "@phone" "@computer" "@meeting" "@errands")
  "Predefined contexts list.")

;;;###autoload
(defun org-gtd-complete-contexts-do (context)
  "Select and execute actions in specific context.
CONTEXT: Context string.
This function executes actions in a specific context.
For complex queries with multiple filters, use `org-gtd-complete-lists-show'."
  (interactive "sExecute in context: ")
  (org-gtd-complete-lists-show :actions :context context))

;;;###autoload
(defun org-gtd-complete-contexts-add (context)
  "Add a new context to the system.
CONTEXT: Context string to add."
  (interactive "sAdd context: ")
  (push context org-gtd-complete-contexts--defined)
  (message "Added context: %s" context))

;;;###autoload
(defun org-gtd-complete-contexts-list ()
  "List all defined contexts."
  (interactive)
  (message "Defined contexts: %s" org-gtd-complete-contexts--defined))

(provide 'org-gtd-complete-contexts)

;;; org-gtd-complete-contexts.el ends here
