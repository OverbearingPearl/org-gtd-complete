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

(defvar org-gtd-complete-inbox-overlay nil "Overlay for highlighting current item.")

(defun org-gtd-complete-inbox-format-age-compact (seconds)
  "Format SECONDS into a compact string, e.g., '2d 1h 30m'."
  (let ((days (floor seconds 86400))
        (hours (floor (mod seconds 86400) 3600))
        (minutes (floor (mod seconds 3600) 60))
        (secs (floor (mod seconds 60)))
        parts)
    (when (> days 0) (push (format "%dd" days) parts))
    (when (> hours 0) (push (format "%dh" hours) parts))
    (when (> minutes 0) (push (format "%dm" minutes) parts))
    (when (or (> secs 0) (null parts)) (push (format "%ds" secs) parts))  ; Add seconds if nothing else
    (if parts
        (string-join (nreverse parts) " ")
      "0s")))  ; Default to 0s if no parts

(defun org-gtd-complete-inbox-refresh-view ()
  "Refresh the '*GTD Inbox View*' buffer."
  (when (get-buffer "*GTD Inbox View*")
    (with-current-buffer "*GTD Inbox View*"
      (let ((in-buffer-read-only buffer-read-only))
        (read-only-mode -1)  ; Temporarily disable read-only mode
        (erase-buffer)
        (insert "| Item          | Captured At          | Residency Time     |\n")  ; Table header
        (insert "|---------------|----------------------|--------------------|\n")  ; Separator
        (let ((new-inbox-items (org-gtd-complete-lists--get-inbox)))
          (dolist (item new-inbox-items)
            (let* ((full-title (plist-get item :title))
                   (timestamp-str (and (string-match "\\[Captured at: \\([^\]]+\\)\\]" full-title) (match-string 1 full-title)))
                   (clean-title (if timestamp-str (replace-regexp-in-string (concat "\\[Captured at: " timestamp-str "\\]") "" full-title) full-title))
                   (captured-time (and timestamp-str (date-to-time timestamp-str)))
                   (age (and captured-time (float-time (time-subtract (current-time) captured-time))))
                   (age-string (and age (org-gtd-complete-inbox-format-age-compact age))))
              (insert (format "| %s | %s | %s |\n" clean-title timestamp-str age-string)))))
        (org-table-align)
        (when in-buffer-read-only (read-only-mode 1))))))  ; Restore read-only mode

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
                             (age-string (and age (org-gtd-complete-inbox-format-age-compact age))))
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
                       (age-string (and age (org-gtd-complete-inbox-format-age-compact age))))
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
                        ;; Sequential questioning
                        (let ((two-minutes (y-or-n-p "Can it be done in 2 minutes? ")))
                          (if two-minutes
                              (message "Do it now: %s" title)  ; Stop here if yes
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
                      (let ((reference (y-or-n-p "Is it reference material? "))
                            (someday (y-or-n-p "Should it go to Someday/Maybe? ")))
                        (cond
                         (reference
                          (with-current-buffer (find-file-noselect reference-file)
                            (goto-char (point-max))
                            (insert (format "* %s\n" title))
                            (save-buffer)))
                         (someday
                          (with-current-buffer (find-file-noselect someday-file)
                            (goto-char (point-max))
                            (insert (format "* %s\n" title))
                            (save-buffer)))
                         (t
                          (with-current-buffer (find-file-noselect inbox-file)
                            (goto-char (point-min))
                            (when (search-forward (concat "* " title) nil t)
                              (org-mark-subtree)
                              (kill-region (region-beginning) (region-end))
                              (save-buffer)))))))))))
          (message "Inbox file does not exist or is empty")))
    (setq inbox-items (org-gtd-complete-lists--get-inbox))
    (when org-gtd-complete-inbox-overlay
      (delete-overlay org-gtd-complete-inbox-overlay)
      (message "Overlay cleaned up in view buffer"))
    (org-gtd-complete-inbox-refresh-view)
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
    (message "Captured: %s" input)
    (org-gtd-complete-inbox-refresh-view)))

(provide 'org-gtd-complete-inbox)

;;; org-gtd-complete-inbox.el ends here
