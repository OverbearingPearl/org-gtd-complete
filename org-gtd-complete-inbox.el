;;; org-gtd-complete-inbox.el --- Inbox handling for Org-GTD-Complete  -*- lexical-binding: t; -*-

;; Copyright (C) 2026 OverbearingPearl

;; Author: OverbearingPearl <OverbearingPearl@outlook.com>
;; Maintainer: OverbearingPearl <OverbearingPearl@outlook.com>
;; URL: https://github.com/OverbearingPearl/org-gtd-complete
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (org "9.4"))
;; Keywords: outlines, tools, convenience, productivity, gtd, org
;; Homepage: https://github.com/OverbearingPearl/org-gtd-complete

;;; Commentary:

;; Inbox processing functions.

;;; Code:

(require 'org-gtd-complete-lists)
(require 'org-gtd-complete-projects)
(require 'org-gtd-complete-views)

(defvar org-gtd-complete-inbox--current-inbox-index nil "Index of the current inbox item being processed.")

(defvar org-gtd-complete-inbox-pending-edits '() "List of pending edits, each as (old-title . new-title).")

(defvar org-gtd-complete-inbox-items-to-delete '() "List of items to delete.")

;;;###autoload
(defun org-gtd-complete-inbox-process-inbox ()
  "Process all items in inbox.
Ask five questions for each item and execute decisions immediately:
1. What is it?
2. Is it actionable?
3. Can it be done in 2 minutes?
4. Can it be delegated?
5. Is it a project?
Organize items into appropriate lists based on decisions."
  (org-gtd-complete-views-refresh-inbox-view)
  (switch-to-buffer "*GTD Inbox View*")
  (let* ((base-dir org-gtd-complete-base-directory)
         (inbox-file (expand-file-name org-gtd-complete-lists--inbox-file base-dir))
         (someday-file (expand-file-name "gtd-someday.org" base-dir))
         (reference-file (expand-file-name "gtd-reference.org" base-dir))
         (waiting-file (expand-file-name "gtd-waiting.org" base-dir))
         (projects-file (expand-file-name "gtd-projects.org" base-dir))
         (actions-file (expand-file-name "gtd-single-actions.org" base-dir))
         (inbox-items (org-gtd-complete-lists--get-inbox)))
    (setq inbox-items (org-gtd-complete-lists--get-inbox))
    (if (file-exists-p inbox-file)
        (if inbox-items
            (progn
              (let ((index 0))
                (dolist (item inbox-items)
                  (setq org-gtd-complete-inbox--current-inbox-index index)
                  (message "Debug: Updated current index to %s" index)
                  (let* ((title (plist-get item :title))
                         (captured-time (plist-get item :captured-at))
                         (age (and captured-time (float-time (time-subtract (current-time) (date-to-time captured-time)))))
                         (age-string (and age (org-gtd-complete-views-format-age-compact age))))
                    (message "Processing item: %s (Residency time: %s)" title age-string)
                    (let ((view-buffer (get-buffer "*GTD Inbox View*")))
                      (when view-buffer
                        (with-current-buffer view-buffer
                          (when org-gtd-complete-views-inbox-overlay (delete-overlay org-gtd-complete-views-inbox-overlay))
                          (save-excursion
                            (goto-line (+ 3 index))
                            (let ((start (line-beginning-position))
                                  (end (line-end-position)))
                              (setq org-gtd-complete-views-inbox-overlay (make-overlay start end view-buffer))
                              (overlay-put org-gtd-complete-views-inbox-overlay 'face 'highlight))))))
                    (let* ((actionable (y-or-n-p (format "Is '%s' actionable? " title))))
                      (if actionable
                          (let ((two-minutes (y-or-n-p "Can it be done in 2 minutes? ")))
                            (if two-minutes
                                (progn
                                  (message "Do it now: %s" title)
                                  (push title org-gtd-complete-inbox-items-to-delete))
                              (let ((delegatable (y-or-n-p "Can it be delegated? ")))
                                (if delegatable
                                    (let ((person (read-string "Delegate to whom? "))
                                          (is-project (y-or-n-p "Is this delegated task part of a project? ")))
                                      (with-current-buffer (find-file-noselect (if is-project
                                                                                   (expand-file-name "gtd-projects.org" base-dir)
                                                                                 (expand-file-name "gtd-single-actions.org" base-dir)))
                                        (goto-char (point-max))
                                        (insert (format "* %s :WAITING:DELEGATED_TO:%s:\n" title person))
                                        (save-buffer)))
                                  (let ((project (y-or-n-p "Is it a project? ")))
                                    (if project
                                        (let ((target-file (expand-file-name "gtd-projects.org" base-dir)))
                                          (with-current-buffer (find-file-noselect target-file)
                                            (goto-char (point-max))
                                            (insert (format "* %s\n" title))
                                            (save-buffer)))
                                      (let ((target-file (expand-file-name "gtd-single-actions.org" base-dir)))
                                        (with-current-buffer (find-file-noselect target-file)
                                          (goto-char (point-max))
                                          (insert (format "* %s\n" title))
                                          (save-buffer)))))))))
                        (let ((reference (y-or-n-p "Is it reference material? ")))
                          (if reference
                              (progn
                                (with-current-buffer (find-file-noselect reference-file)
                                  (goto-char (point-max))
                                  (insert (format "* %s\n" title))
                                  (save-buffer))
                                (push title org-gtd-complete-inbox-items-to-delete))
                            (let ((someday (y-or-n-p "Should it go to Someday/Maybe? ")))
                              (if someday
                                  (progn
                                    (with-current-buffer (find-file-noselect someday-file)
                                      (goto-char (point-max))
                                      (insert (format "* %s\n" title))
                                      (save-buffer))
                                    (push title org-gtd-complete-inbox-items-to-delete))
                                (push title org-gtd-complete-inbox-items-to-delete)))))))
                    (setq index (1+ index))))))
          (message "Inbox file does not exist or is empty")))
    (dolist (title org-gtd-complete-inbox-items-to-delete)
      (org-gtd-complete-inbox-remove-task inbox-file title))
    ;; Apply pending edits
    (dolist (edit org-gtd-complete-inbox-pending-edits)
      (let ((old-title (car edit))
            (new-title (cdr edit)))
        (org-gtd-complete-inbox-update-title inbox-file old-title new-title)))
    (setq org-gtd-complete-inbox-pending-edits '())
    (org-gtd-complete-views-refresh-inbox-view)
    (setq inbox-items (org-gtd-complete-lists--get-inbox))
    (when org-gtd-complete-views-inbox-overlay
      (delete-overlay org-gtd-complete-views-inbox-overlay)
      (message "Overlay cleaned up in view buffer"))
    (if inbox-items
        (message "Inbox processing complete, but some items remain.")
      (message "Inbox is empty."))
    (setq org-gtd-complete-inbox--current-inbox-index nil)
    (message "Debug: Reset current index to nil")))

(defun org-gtd-complete-inbox-edit-title ()
  "Mark the current inbox title for editing and refresh the view."
  (interactive)
  (if org-gtd-complete-inbox--current-inbox-index
      (let* ((inbox-items (org-gtd-complete-lists--get-inbox))
             (current-index org-gtd-complete-inbox--current-inbox-index)
             (item (and current-index (nth current-index inbox-items)))
             (old-title (and item (plist-get item :title))))
        (if item
            (let ((new-title (read-string "New title: " old-title)))
              ;; Mark edit request
              (add-to-list 'org-gtd-complete-inbox-pending-edits (cons old-title new-title))
              (message "Marked edit for '%s' to '%s'; will apply in process-inbox." old-title new-title)
              (org-gtd-complete-views-refresh-inbox-view))
          (message "No valid inbox item for the current index.")))
    (message "No current inbox index set; run inbox processing first.")))

(defun org-gtd-complete-inbox-remove-task (file title)
  "Remove the task with TITLE from the file FILE.
FILE is the path to the Org file containing the task.
TITLE is the title of the task to remove."
  (with-current-buffer (find-file-noselect file)
    (goto-char (point-min))
    (when (search-forward (concat "* " title) nil t)
      (org-mark-subtree)
      (kill-region (region-beginning) (region-end))
      (save-buffer))))

(defun org-gtd-complete-inbox-capture (input)
  "Internal implementation to capture input to inbox.
INPUT: Content string to capture."
  (with-current-buffer (find-file-noselect (expand-file-name org-gtd-complete-lists--inbox-file org-gtd-complete-base-directory))
    (goto-char (point-max))
    (org-insert-heading-respect-content)
    (insert input)
    (org-set-property "CAPTURED_AT" (format-time-string "%Y-%m-%d %H:%M:%S"))
    (save-buffer)
    (message "Captured: %s" input)
    (org-gtd-complete-views-refresh-inbox-view)))

(defun org-gtd-complete-inbox--get-current-index ()
  "Return the index of the current inbox item being processed."
  org-gtd-complete--current-inbox-index)

(defun org-gtd-complete-inbox--update-inbox-title (item new-title)
  "Update the title of the inbox ITEM in the file.
ITEM is the item plist to update.
NEW-TITLE is the new title string."
  (let* ((file (expand-file-name org-gtd-complete-lists--inbox-file org-gtd-complete-base-directory))
         (old-title (plist-get item :title)))
    (with-current-buffer (find-file-noselect file)
      (goto-char (point-min))
      (when (search-forward (concat "* " old-title) nil t)
        (replace-match (concat "* " new-title))
        (save-buffer)))))

(defun org-gtd-complete-inbox-update-title (file old-title new-title)
  "Update the title in FILE from OLD-TITLE to NEW-TITLE."
  (with-current-buffer (find-file-noselect file)
    (goto-char (point-min))
    (when (search-forward (concat "* " old-title) nil t)
      (replace-match (concat "* " new-title))
      (save-buffer))))

(provide 'org-gtd-complete-inbox)

;;; org-gtd-complete-inbox.el ends here
