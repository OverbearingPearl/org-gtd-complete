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
  (let* ((base-dir org-gtd-complete-base-directory)
         (inbox-file (expand-file-name org-gtd-complete-lists--inbox-file base-dir))
         (someday-file (expand-file-name "gtd-someday.org" base-dir))
         (reference-file (expand-file-name "gtd-reference.org" base-dir))
         (waiting-file (expand-file-name "gtd-waiting.org" base-dir))
         (projects-file (expand-file-name "gtd-projects.org" base-dir))
         (actions-file (expand-file-name "gtd-single-actions.org" base-dir))
         (inbox-items (org-gtd-complete-lists--get-inbox)))
    (setq inbox-items (org-gtd-complete-lists--get-inbox))  ; Reload
    (if (file-exists-p inbox-file)
        (if inbox-items
            (progn
              ;; Now process each item interactively
              (dolist (item inbox-items)
                (let* ((title (plist-get item :title))
                       (timestamp-str (and (string-match "\\[Captured at: \\([^\]]+\\)\\]" title) (match-string 1 title)))
                       (clean-title (if timestamp-str (replace-regexp-in-string (concat "\\[Captured at: " timestamp-str "\\]") "" title) title))  ; Add clean-title here
                       (captured-time (and timestamp-str (date-to-time timestamp-str)))
                       (age (and captured-time (float-time (time-subtract (current-time) captured-time))))
                       (age-string (and age (org-gtd-complete-views-format-age-compact age))))
                  (message "Processing item: %s (Residency time: %s)" title age-string)
                  ;; Add highlighting code here
                  (let ((view-buffer (get-buffer "*GTD Inbox View*")))
                    (when view-buffer
                      (with-current-buffer view-buffer
                        (when org-gtd-complete-views-inbox-overlay (delete-overlay org-gtd-complete-views-inbox-overlay))
                        (save-excursion
                          (goto-char (point-min))
                          (if (search-forward clean-title nil t)
                              (progn
                                (let ((start (line-beginning-position))
                                      (end (line-end-position)))
                                  (setq org-gtd-complete-views-inbox-overlay (make-overlay start end view-buffer))
                                  (overlay-put org-gtd-complete-views-inbox-overlay 'face 'highlight))))))))
                  (let* ((actionable (y-or-n-p (format "Is '%s' actionable? " title))))
                    (if actionable
                        ;; Sequential questioning
                        (let ((two-minutes (y-or-n-p "Can it be done in 2 minutes? ")))
                          (if two-minutes
                              (progn
                                (message "Do it now: %s" title)
                                (org-gtd-complete-inbox-remove-task inbox-file title))
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
                      ;; Not actionable
                      (let ((reference (y-or-n-p "Is it reference material? ")))
                        (if reference
                            (progn
                              (with-current-buffer (find-file-noselect reference-file)
                                (goto-char (point-max))
                                (insert (format "* %s\n" title))
                                (save-buffer))
                              (org-gtd-complete-inbox-remove-task inbox-file title))
                          (let ((someday (y-or-n-p "Should it go to Someday/Maybe? ")))
                            (if someday
                                (progn
                                  (with-current-buffer (find-file-noselect someday-file)
                                    (goto-char (point-max))
                                    (insert (format "* %s\n" title))
                                    (save-buffer))
                                  (org-gtd-complete-inbox-remove-task inbox-file title))
                              (org-gtd-complete-inbox-remove-task inbox-file title))))))))))
          (message "Inbox file does not exist or is empty")))
    (setq inbox-items (org-gtd-complete-lists--get-inbox))
    (when org-gtd-complete-views-inbox-overlay
      (delete-overlay org-gtd-complete-views-inbox-overlay)
      (message "Overlay cleaned up in view buffer"))
    (org-gtd-complete-views-refresh-inbox-view)
    (if inbox-items
        (message "Inbox processing complete, but some items remain.")
      (message "Inbox is empty."))))

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
    (insert (format "* %s [Captured at: %s]\n" input (format-time-string "%Y-%m-%d %H:%M:%S")))
    (save-buffer)
    (message "Captured: %s" input)
    (org-gtd-complete-views-refresh-inbox-view)))

(provide 'org-gtd-complete-inbox)

;;; org-gtd-complete-inbox.el ends here
