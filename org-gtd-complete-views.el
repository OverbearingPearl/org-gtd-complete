;;; org-gtd-complete-views.el --- Views for Org-GTD-Complete  -*- lexical-binding: t; -*-

;; Copyright (C) 2026 OverbearingPearl

;; Author: OverbearingPearl <OverbearingPearl@outlook.com>
;; Maintainer: OverbearingPearl <OverbearingPearl@outlook.com>
;; URL: https://github.com/OverbearingPearl/org-gtd-complete
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (org "9.4"))
;; Keywords: outlines, tools, convenience, productivity, gtd, org
;; Homepage: https://github.com/OverbearingPearl/org-gtd-complete

;;; Commentary:

;; View handling functions for Org-GTD-Complete.

;;; Code:

(defvar org-gtd-complete-views-inbox-overlay nil "Overlay for highlighting current item in inbox view.")

(defun org-gtd-complete-views-format-age-compact (seconds)
  "Format SECONDS into a compact string, e.g., '2d 1h 30m'."
  (let ((days (floor seconds 86400))
        (hours (floor (mod seconds 86400) 3600))
        (minutes (floor (mod seconds 3600) 60))
        (secs (floor (mod seconds 60)))
        parts)
    (when (> days 0) (push (format "%dd" days) parts))
    (when (> hours 0) (push (format "%dh" hours) parts))
    (when (> minutes 0) (push (format "%dm" minutes) parts))
    (when (or (> secs 0) (null parts)) (push (format "%ds" secs) parts))
    (if parts
        (string-join (nreverse parts) " ")
      "0s")))

(defun org-gtd-complete-views-refresh-inbox-view ()
  "Refresh the '*GTD Inbox View*' buffer."
  (with-current-buffer (get-buffer-create "*GTD Inbox View*")
    (let ((in-buffer-read-only buffer-read-only))
      (org-mode)
      (read-only-mode -1)
      (erase-buffer)
      (insert "| Item          | Captured At          | Residency Time     |\n")
      (insert "|---------------|----------------------|--------------------|\n")
      (let ((new-inbox-items (org-gtd-complete-lists--get-inbox)))
        (dolist (item new-inbox-items)
          (let* ((full-title (plist-get item :title))
                 (captured-at (plist-get item :captured-at))
                 (captured-time (and captured-at (date-to-time captured-at)))
                 (age (and captured-time (float-time (time-subtract (current-time) captured-time))))
                 (age-string (and age (org-gtd-complete-views-format-age-compact age))))
            (insert (format "| %s | %s | %s |\n" full-title (or captured-at "N/A") age-string))))
        (org-table-align)
        (read-only-mode 1)
        (when (and org-gtd-complete-inbox--current-inbox-index
                   (>= org-gtd-complete-inbox--current-inbox-index 0)
                   (< org-gtd-complete-inbox--current-inbox-index (length new-inbox-items)))
          (let* ((index org-gtd-complete-inbox--current-inbox-index)
                 (start (save-excursion
                          (goto-line (+ 3 index))
                          (line-beginning-position)))
                 (end (save-excursion
                        (goto-line (+ 3 index))
                        (line-end-position))))
            (when (and start end)
              (setq org-gtd-complete-views-inbox-overlay (make-overlay start end))
              (overlay-put org-gtd-complete-views-inbox-overlay 'face 'highlight))))))))

(provide 'org-gtd-complete-views)

;;; org-gtd-complete-views.el ends here
