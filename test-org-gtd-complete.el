;;; test-org-gtd-complete.el --- Tests for org-gtd-complete  -*- lexical-binding: t; -*-

;; Copyright (C) 2026 OverbearingPearl

;; Author: OverbearingPearl <OverbearingPearl@outlook.com>
;; Maintainer: OverbearingPearl <OverbearingPearl@outlook.com>
;; URL: https://github.com/OverbearingPearl/org-gtd-complete
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (org "9.4"))
;; Keywords: outlines, tools, convenience, productivity, gtd, org
;; Homepage: https://github.com/OverbearingPearl/org-gtd-complete

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

;; This file contains tests for org-gtd-complete package.

;;; Code:

(require 'ert)
(require 'org-gtd-complete)
(require 'cl-lib)

(ert-deftest test-org-gtd-complete-capture-item-to-inbox ()
  "Should capture an item to the inbox successfully."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((input "New test item")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (unwind-protect
              (progn
                (org-gtd-complete-capture input)
                (with-current-buffer (find-file-noselect inbox-file)
                  (goto-char (point-min))
                  (should (re-search-forward (concat "^\\* " (regexp-quote input) " \\[Captured at: .+\\]") nil t))
                  (kill-buffer)))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-items-correctly ()
  "Should process inbox items correctly."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item [Captured at: 2023-01-01 12:00:00]")
               (expected-output "Inbox processing complete, but some items remain.")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item))
          (unwind-protect
              (progn
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (&rest args) t)))  ; Always return t for simulation
                  (should (string= (org-gtd-complete-inbox-process-inbox) expected-output))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-not-actionable-reference ()
  "Test path: Not actionable, is reference."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item [Captured at: 2023-01-01 12:00:00]")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item))
          (unwind-protect
              (progn
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) nil)  ; No
                                                                ((string-match "Is it reference material?" prompt) t)  ; Yes
                                                                (t nil)))))  ; Other defaults to no
                  (org-gtd-complete-inbox-process-inbox)
                  ;; Add assertions, e.g., check if item was added to reference
                  (should (file-exists-p (expand-file-name "gtd-reference.org" temp-dir)))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-not-actionable-someday ()
  "Test path: Not actionable, should go to Someday/Maybe."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item [Captured at: 2023-01-01 12:00:00]")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item))
          (unwind-protect
              (progn
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) nil)  ; No
                                                                ((string-match "Is it reference material?" prompt) nil)  ; No
                                                                ((string-match "Should it go to Someday/Maybe?" prompt) t)  ; Yes
                                                                (t nil)))))  ; Other defaults to no
                  (org-gtd-complete-inbox-process-inbox)
                  (with-current-buffer (find-file-noselect (expand-file-name "gtd-someday.org" temp-dir))
                    (revert-buffer t t)  ; Reload the file
                    (goto-char (point-min))
                    (should (re-search-forward (regexp-quote test-item) nil t))
                    (kill-buffer))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-not-actionable-trash ()
  "Test path: Not actionable, trash."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item [Captured at: 2023-01-01 12:00:00]")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item))
          (unwind-protect
              (progn
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt) nil))
                          ((symbol-function 'read-string) (lambda (&rest _) "")))
                  (org-gtd-complete-inbox-process-inbox)
                  (with-temp-buffer
                    (insert-file-contents inbox-file)
                    (should (string= (buffer-string) "")))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-actionable-in-two-minutes ()
  "Test path: Actionable, can be done in 2 minutes."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item [Captured at: 2023-01-01 12:00:00]")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item))
          (unwind-protect
              (progn
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) t)
                                                               ((string-match "Can it be done in 2 minutes?" prompt) t)
                                                               (t nil)))))
                  (org-gtd-complete-inbox-process-inbox)
                  (with-temp-buffer
                    (insert-file-contents inbox-file)
                    (should (not (re-search-forward test-item nil t))))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-actionable-not-two-minutes-delegated ()
  "Test path: Actionable, not in 2 minutes, can be delegated."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item [Captured at: 2023-01-01 12:00:00]")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item))
          (unwind-protect
              (progn
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) t)
                                                               ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                                               ((string-match "Can it be delegated?" prompt) t)
                                                               ((string-match "Is this delegated task part of a project?" prompt) t)
                                                               (t nil))))
                          ((symbol-function 'read-string) (lambda (prompt &rest args) "Simulated Person")))  ; Simulate return value
                  (org-gtd-complete-inbox-process-inbox)
                  (with-current-buffer (find-file-noselect (expand-file-name "gtd-projects.org" temp-dir))
                    (revert-buffer t t)  ; Reload the file
                    (goto-char (point-min))
                    (should (re-search-forward (regexp-quote test-item) nil t))
                    (should (re-search-forward ":WAITING" nil t))
                    (kill-buffer))
                  (with-current-buffer (find-file-noselect (expand-file-name "gtd-projects.org" temp-dir))
                    (revert-buffer t t)  ; Reload the file  (Note: This is redundant, but keeping as is)
                    (kill-buffer))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-actionable-not-two-minutes-not-delegated-project ()
  "Test path: Actionable, not in 2 minutes, not delegated, is project."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item [Captured at: 2023-01-01 12:00:00]")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item))
          (unwind-protect
              (progn
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) t)
                                                               ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                                               ((string-match "Can it be delegated?" prompt) nil)
                                                               ((string-match "Is it a project?" prompt) t)
                                                               (t nil)))))
                  (org-gtd-complete-inbox-process-inbox)
                  (with-current-buffer (find-file-noselect (expand-file-name "gtd-projects.org" temp-dir))
                    (revert-buffer t t)  ; Reload the file
                    (goto-char (point-min))
                    (should (re-search-forward (regexp-quote test-item) nil t))
                    (kill-buffer))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-actionable-not-two-minutes-not-delegated-not-project ()
  "Test path: Actionable, not in 2 minutes, not delegated, not project."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item [Captured at: 2023-01-01 12:00:00]")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item))
          (unwind-protect
              (progn
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) t)
                                                               ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                                               ((string-match "Can it be delegated?" prompt) nil)
                                                               ((string-match "Is it a project?" prompt) nil)
                                                               (t nil)))))
                  (org-gtd-complete-inbox-process-inbox)
                  (with-current-buffer (find-file-noselect (expand-file-name "gtd-single-actions.org" temp-dir))
                    (revert-buffer t t)  ; Reload the file
                    (goto-char (point-min))
                    (should (re-search-forward (regexp-quote test-item) nil t))
                    (kill-buffer))))
            (test-org-gtd-complete-cleanup-temp)))))))

(defun test-org-gtd-complete-cleanup-temp ()
  "Clean up temporary directories and buffers created for test."
  (let ((temp-dirs (directory-files temporary-file-directory t "test-org-gtd-complete-")))
    (dolist (dir temp-dirs)
      (when (file-directory-p dir)
        (delete-directory dir t 'trash)))
    ;; Kill temporary buffers
    (dolist (buf (buffer-list))
      (when (and (buffer-file-name buf)
                 (string-match-p "test-org-gtd-complete-" (buffer-file-name buf)))
        (kill-buffer buf)))))

(provide 'test-org-gtd-complete)

;;; test-org-gtd-complete.el ends here
