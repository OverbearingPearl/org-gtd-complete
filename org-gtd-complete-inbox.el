;;; org-gtd-complete-inbox.el --- Inbox handling for Org-GTD-Complete  -*- lexical-binding: t; -*-

;; Copyright (C) 2026 OverbearingPearl

;; Author: OverbearingPearl <OverbearingPearl@outlook.com>
;; Maintainer: OverbearingPearl <OverbearingPearl@outlook.com>
;; URL: https://github.com/OverbearingPearl/org-gtd-complete
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (org "9.4"))

;;; Commentary:
;; Inbox processing functions.

;;; Code:

(require 'org-gtd-complete-lists)

(defvar org-gtd-complete-inbox-overlay nil "Overlay for highlighting current item.")

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
  (interactive)
  (let* ((base-dir org-gtd-complete-base-directory)
         (inbox-file (expand-file-name org-gtd-complete-lists--inbox-file base-dir))
         (inbox-items (org-gtd-complete-lists--get-inbox)))
    ;; Create base directory if it doesn't exist
    (unless (file-directory-p base-dir)
      (make-directory base-dir t)
      (message "Created base directory: %s" base-dir))
    ;; Create inbox file if it doesn't exist
    (unless (file-exists-p inbox-file)
      (with-temp-buffer
        (org-mode)
        (write-region "" nil inbox-file nil 0)
        (message "Created inbox file: %s" inbox-file)))
    (message "Checking inbox file: %s" inbox-file)  ; Debug: Check file path
    (setq inbox-items (org-gtd-complete-lists--get-inbox))  ; Reload after potential creation
    (if (file-exists-p inbox-file)
        (if inbox-items
            (progn
              ;; Create and display read-only buffer if it doesn't exist
              (let ((view-buffer (get-buffer "*GTD Inbox View*")))
                (with-current-buffer (or view-buffer (get-buffer-create "*GTD Inbox View*"))
                  (org-mode)  ; Switch to Org mode
                  (unless view-buffer  ; Only insert content if buffer is newly created
                    (erase-buffer)
                    (insert "| Item          | Captured At          | Residency Time     |\n")  ; Table header
                    (insert "|---------------|----------------------|--------------------|\n")  ; Separator
                    (dolist (item inbox-items)
                      (let* ((full-title (plist-get item :title))
                             (timestamp-str (and (string-match "\\[Captured at: \\([^\]]+\\)\\]" full-title) (match-string 1 full-title)))
                             (clean-title (if timestamp-str (replace-regexp-in-string (concat "\\[Captured at: " timestamp-str "\\]") "" full-title) full-title))  ; Clean title
                             (captured-time (and timestamp-str (date-to-time timestamp-str)))
                             (age (and captured-time (float-time (time-subtract (current-time) captured-time))))
                             (age-string (and age (format-seconds "%h hours, %m minutes, %s seconds" age))))
                        (insert (format "| %s | %s | %s |\n" clean-title timestamp-str age-string))))
                    (org-table-align))  ; Align the table
                  (read-only-mode 1)  ; Make buffer read-only
                  (pop-to-buffer (current-buffer))))  ; Switch to buffer
              ;; Now process each item interactively
              (dolist (item inbox-items)
                (let* ((title (plist-get item :title))
                       (timestamp-str (and (string-match "\\[Captured at: \\([^\]]+\\)\\]" title) (match-string 1 title)))
                       (clean-title (if timestamp-str (replace-regexp-in-string (concat "\\[Captured at: " timestamp-str "\\]") "" title) title))  ; Add clean-title here
                       (captured-time (and timestamp-str (date-to-time timestamp-str)))
                       (age (and captured-time (float-time (time-subtract (current-time) captured-time))))
                       (age-string (and age (format-seconds "%h hours, %m minutes, %s seconds" age))))
                  (message "Processing item: %s (Residency time: %s)" title age-string)
                  ;; Add highlighting code here
                  (let ((view-buffer (get-buffer "*GTD Inbox View*")))
                    (when view-buffer
                      (with-current-buffer view-buffer
                        (when org-gtd-complete-inbox-overlay (delete-overlay org-gtd-complete-inbox-overlay))
                        (save-excursion
                          (goto-char (point-min))
                          (if (search-forward clean-title nil t)
                              (progn
                                (let ((start (line-beginning-position))
                                      (end (line-end-position)))
                                  (setq org-gtd-complete-inbox-overlay (make-overlay start end view-buffer))
                                  (overlay-put org-gtd-complete-inbox-overlay 'face 'highlight))))))))
                  (let* ((actionable (y-or-n-p (format "Is '%s' actionable? " title))))
                    (if actionable
                        (let ((two-minutes (y-or-n-p "Can it be done in 2 minutes? "))
                              (delegatable (y-or-n-p "Can it be delegated? "))
                              (project (y-or-n-p "Is it a project? ")))
                          (cond
                           (two-minutes
                            (message "Do it now: %s" title))
                           (delegatable
                            (let ((person (read-string "Delegate to whom? ")))
                              (org-gtd-complete-delegate title person)))
                           (project
                            (org-gtd-complete-plan-project title 'create))
                           (t
                            (org-gtd-complete-lists-show :actions))))
                      ;; Not actionable
                      (let ((reference (y-or-n-p "Is it reference material? "))
                            (someday (y-or-n-p "Should it go to Someday/Maybe? ")))
                        (cond
                         (reference
                          (org-gtd-complete-add-reference title))
                         (someday
                          (message "Moved to Someday/Maybe: %s" title))
                         (t
                          (message "Trashed: %s" title)))))))))
          (message "Inbox items retrieved: %s" inbox-items))  ; Debug: Check retrieved items
      (message "Inbox file does not exist or is empty"))
    ;; Add cleanup code before the last message
    (when org-gtd-complete-inbox-overlay
      (delete-overlay org-gtd-complete-inbox-overlay)
      (message "Overlay cleaned up in view buffer"))
    ;; Re-check inbox after processing
    (setq inbox-items (org-gtd-complete-lists--get-inbox))
    (if inbox-items
        (message "Inbox processing complete, but some items remain.")
      (message "Inbox is empty."))))

(defun org-gtd-complete-inbox-capture (input)
  "Internal implementation to capture input to inbox.
INPUT: Content string to capture."
  (with-current-buffer (find-file-noselect (expand-file-name org-gtd-complete-lists--inbox-file org-gtd-complete-base-directory))
    (goto-char (point-max))
    (insert (format "* %s [Captured at: %s]\n" input (format-time-string "%Y-%m-%d %H:%M:%S")))
    (save-buffer)
    (message "Captured: %s" input)))

(provide 'org-gtd-complete-inbox)

;;; org-gtd-complete-inbox.el ends here
