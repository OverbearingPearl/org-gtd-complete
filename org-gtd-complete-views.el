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
  (when (get-buffer "*GTD Inbox View*")
    (with-current-buffer "*GTD Inbox View*"
      (let ((in-buffer-read-only buffer-read-only))
        (read-only-mode -1)
        (erase-buffer)
        (insert "| Item          | Captured At          | Residency Time     |\n")
        (insert "|---------------|----------------------|--------------------|\n")
        (let ((new-inbox-items (org-gtd-complete-lists--get-inbox)))
          (dolist (item new-inbox-items)
            (let* ((full-title (plist-get item :title))
                   (timestamp-str (and (string-match "\\[Captured at: \\([^\]]+\\)\\]" full-title) (match-string 1 full-title)))
                   (clean-title (if timestamp-str (replace-regexp-in-string (concat "\\[Captured at: " timestamp-str "\\]") "" full-title) full-title))
                   (captured-time (and timestamp-str (date-to-time timestamp-str)))
                   (age (and captured-time (float-time (time-subtract (current-time) captured-time))))
                   (age-string (and age (org-gtd-complete-views-format-age-compact age))))
              (insert (format "| %s | %s | %s |\n" clean-title timestamp-str age-string)))))
        (org-table-align)
        (when in-buffer-read-only (read-only-mode 1))))))

(provide 'org-gtd-complete-views)

;;; org-gtd-complete-views.el ends here
