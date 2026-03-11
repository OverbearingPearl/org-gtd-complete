;;; org-gtd-complete-horizons.el --- Six horizons implementation  -*- lexical-binding: t; -*-

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

;; Six horizons implementation
;; This module is responsible for:
;; - Connecting actions to projects (L1 -> L2)
;; - Connecting projects to areas (L2 -> L3)
;; - Setting goals, visions, and purpose
;; - Viewing content by horizon level
;; Note: This module handles associations, not queries (use lists for queries)

;;; Code:

(require 'org-gtd-complete-lists)  ; Ensure we can access project lists

(defvar org-gtd-complete-horizons--action-project-alist nil
  "Alist mapping action IDs to project names.")

(defvar org-gtd-complete-horizons--action-area-alist nil
  "Alist mapping action IDs to area names.")

(defvar org-gtd-complete-horizons--project-area-alist nil
  "Alist mapping project names to area names.")

(defvar org-gtd-complete-horizons--project-goal-alist nil
  "Alist mapping project names to goal names.")

(defvar org-gtd-complete-horizons--project-vision-alist nil
  "Alist mapping project names to vision names.")

(defvar org-gtd-complete-horizons--project-purpose-alist nil
  "Alist mapping project names to purpose names.")

;;;###autoload
(defun org-gtd-complete-horizons-connect-action-to-project (action project)
  "Connect action to project.
ACTION: Action identifier (heading or ID).
PROJECT: Project name string."
  (if (org-gtd-complete-horizons--project-exists-p project)
      (progn
        (push (cons action project) org-gtd-complete-horizons--action-project-alist)
        (message "Connected action '%s' to project '%s'" action project))
    (error "Project '%s' does not exist" project)))

;;;###autoload
(defun org-gtd-complete-horizons-connect-action-to-area (action area)
  "Connect action to area of responsibility.
ACTION: Action identifier.
AREA: Area of responsibility name string."
  (push (cons action area) org-gtd-complete-horizons--action-area-alist)
  (message "Connected action '%s' to area '%s'" action area))

;;;###autoload
(defun org-gtd-complete-horizons-connect-project-to-area (proj area)
  "Connect project to area of responsibility.
PROJ: Project name string.
AREA: Area of responsibility name string."
  (if (org-gtd-complete-horizons--project-exists-p proj)
      (progn
        (push (cons proj area) org-gtd-complete-horizons--project-area-alist)
        (message "Connected project '%s' to area '%s'" proj area))
    (error "Project '%s' does not exist" proj)))

;;;###autoload
(defun org-gtd-complete-horizons-connect-project-to-goal (proj goal)
  "Connect project to goal.
PROJ: Project name string.
GOAL: Goal name string."
  (if (org-gtd-complete-horizons--project-exists-p proj)
      (progn
        (push (cons proj goal) org-gtd-complete-horizons--project-goal-alist)
        (message "Connected project '%s' to goal '%s'" proj goal))
    (error "Project '%s' does not exist" proj)))

;;;###autoload
(defun org-gtd-complete-horizons-connect-project-to-vision (proj vision)
  "Connect project to vision.
PROJ: Project name string.
VISION: Vision name string."
  (if (org-gtd-complete-horizons--project-exists-p proj)
      (progn
        (push (cons proj vision) org-gtd-complete-horizons--project-vision-alist)
        (message "Connected project '%s' to vision '%s'" proj vision))
    (error "Project '%s' does not exist" proj)))

;;;###autoload
(defun org-gtd-complete-horizons-connect-project-to-purpose (proj purpose)
  "Connect project to purpose.
PROJ: Project name string.
PURPOSE: Purpose name string."
  (if (org-gtd-complete-horizons--project-exists-p proj)
      (progn
        (push (cons proj purpose) org-gtd-complete-horizons--project-purpose-alist)
        (message "Connected project '%s' to purpose '%s'" proj purpose))
    (error "Project '%s' does not exist" proj)))

(defun org-gtd-complete-horizons--project-exists-p (proj)
  "Check if project PROJ exists.
PROJ: Project name string."
  (let ((projects (mapcar (lambda (item) (plist-get item :title)) (org-gtd-complete-lists--get-projects))))
    (member proj projects)))

;;;###autoload
(defun org-gtd-complete-horizons-show-area (area)
  "Show all related content for specific area of responsibility.
AREA: Area of responsibility name string.
Uses lists module for actual query."
  (org-gtd-complete-lists-show :projects :area area))

;;;###autoload
(defun org-gtd-complete-horizons-show-goal (goal)
  "Show all related content for specific goal.
GOAL: Goal name string.
Uses lists module for actual query."
  (org-gtd-complete-lists-show :projects :goal goal))

;;;###autoload
(defun org-gtd-complete-horizons-show-vision (vision)
  "Show all related content for specific vision.
VISION: Vision name string.
Uses lists module for actual query."
  (org-gtd-complete-lists-show :projects :vision vision))

;;;###autoload
(defun org-gtd-complete-horizons-show-purpose (purpose)
  "Show all related content for specific purpose.
PURPOSE: Purpose name string.
Uses lists module for actual query."
  (org-gtd-complete-lists-show :projects :purpose purpose))

(provide 'org-gtd-complete-horizons)

;;; org-gtd-complete-horizons.el ends here
