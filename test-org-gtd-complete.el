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
                (dolist (file (list inbox-file))
                  (when (get-file-buffer file)
                    (with-current-buffer (get-file-buffer file)
                      (auto-revert-mode 1))))
                (org-gtd-complete-capture input)
                (with-current-buffer (find-file-noselect inbox-file)
                  (goto-char (point-min))
                  (should (re-search-forward (concat "^\\* " (regexp-quote input)) nil t))
                  (should (re-search-forward ":PROPERTIES:" nil t))
                  (should (re-search-forward ":CAPTURED_AT:" nil t))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-reference ()
  "Test path: Not actionable, is reference."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir))
               (reference-file (expand-file-name "gtd-reference.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item)
            (insert "\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:"))
          (unwind-protect
              (progn
                (dolist (file (list inbox-file reference-file))
                  (when (get-file-buffer file)
                    (with-current-buffer (get-file-buffer file)
                      (auto-revert-mode 1))))
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) nil)
                                                               ((string-match "Is it reference material?" prompt) t)
                                                               (t nil)))))
                  (org-gtd-complete-inbox-process-inbox)
                  (with-current-buffer (find-file-noselect reference-file)
                    (revert-buffer t t)
                    (goto-char (point-min))
                    (should (re-search-forward (regexp-quote test-item) nil t)))
                  (with-temp-buffer
                    (insert-file-contents inbox-file)
                    (should (not (save-excursion (goto-char (point-min)) (re-search-forward (regexp-quote test-item) nil t))))
                    (should (string-match-p "^\\s-*$" (buffer-string))))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-someday ()
  "Test path: Not actionable, should go to Someday/Maybe."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir))
               (someday-file (expand-file-name "gtd-someday.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item)
            (insert "\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:"))
          (unwind-protect
              (progn
                (dolist (file (list inbox-file someday-file))
                  (when (get-file-buffer file)
                    (with-current-buffer (get-file-buffer file)
                      (auto-revert-mode 1))))
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) nil)
                                                               ((string-match "Is it reference material?" prompt) nil)
                                                               ((string-match "Should it go to Someday/Maybe?" prompt) t)
                                                               (t nil)))))
                  (org-gtd-complete-inbox-process-inbox)
                  (with-current-buffer (find-file-noselect someday-file)
                    (revert-buffer t t)
                    (goto-char (point-min))
                    (should (re-search-forward (regexp-quote test-item) nil t)))
                  (with-temp-buffer
                    (insert-file-contents inbox-file)
                    (should (not (save-excursion (goto-char (point-min)) (re-search-forward (regexp-quote test-item) nil t))))
                    (should (string-match-p "^\\s-*$" (buffer-string))))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-trash ()
  "Test path: Not actionable, trash."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item)
            (insert "\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:"))
          (unwind-protect
              (progn
                (dolist (file (list inbox-file))
                  (when (get-file-buffer file)
                    (with-current-buffer (get-file-buffer file)
                      (auto-revert-mode 1))))
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) nil)
                                                               ((string-match "Is it reference material?" prompt) nil)
                                                               ((string-match "Should it go to Someday/Maybe?" prompt) nil)
                                                               (t nil))))
                          ((symbol-function 'read-string) (lambda (&rest _) "")))
                  (org-gtd-complete-inbox-process-inbox)
                  (should (file-exists-p inbox-file))
                  (with-temp-buffer
                    (insert-file-contents inbox-file)
                    (should (string= (buffer-string) ""))
                    (should (not (save-excursion (goto-char (point-min)) (re-search-forward (regexp-quote test-item) nil t)))))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-actionable-2-minutes ()
  "Test path: Actionable, can be done in 2 minutes."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item)
            (insert "\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:"))
          (unwind-protect
              (progn
                (dolist (file (list inbox-file))
                  (when (get-file-buffer file)
                    (with-current-buffer (get-file-buffer file)
                      (auto-revert-mode 1))))
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) t)
                                                               ((string-match "Can it be done in 2 minutes?" prompt) t)
                                                               (t nil)))))
                  (org-gtd-complete-inbox-process-inbox)
                  (should (file-exists-p inbox-file))
                  (with-temp-buffer
                    (insert-file-contents inbox-file)
                    (should (string= (buffer-string) ""))
                    (should (not (save-excursion (goto-char (point-min)) (re-search-forward (regexp-quote test-item) nil t)))))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-actionable-delegated ()
  "Test delegating a non-project item."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir)
             (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
        (org-gtd-complete-setup)
        (with-temp-file inbox-file
          (insert "* Test item [Captured at: 2023-01-01 12:00:00]")
          (insert "\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:"))
        (unwind-protect
            (progn
              (dolist (file (list inbox-file
                                  (expand-file-name "gtd-single-actions.org" temp-dir)))
                (when (get-file-buffer file)
                  (with-current-buffer (get-file-buffer file)
                    (auto-revert-mode 1))))
              (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                       (cond ((string-match "Is .+ actionable?" prompt) t)
                                                             ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                                             ((string-match "Can it be delegated?" prompt) t)
                                                             ((string-match "Is it a project?" prompt) nil)
                                                             (t nil))))
                        ((symbol-function 'read-string) (lambda (prompt &rest args) "Simulated Person")))
                (org-gtd-complete-inbox-process-inbox)
                (with-current-buffer (find-file-noselect (expand-file-name "gtd-single-actions.org" temp-dir))
                  (revert-buffer t t)
                  (goto-char (point-min))
                  (should (re-search-forward (regexp-quote "* Test item") nil t))
                  (should (string-match ":WAITING:" (buffer-string)))
                  (should (string-match ":DELEGATED_TO:Simulated Person:" (buffer-string))))))
          (test-org-gtd-complete-cleanup-temp))))))

(ert-deftest test-org-gtd-complete-process-inbox-actionable-delegated-project ()
  "Test path: Actionable, not in 2 minutes, can be delegated."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item)
            (insert "\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:"))
          (unwind-protect
              (progn
                (dolist (file (list inbox-file
                                    (expand-file-name "gtd-projects.org" temp-dir)))
                  (when (get-file-buffer file)
                    (with-current-buffer (get-file-buffer file)
                      (auto-revert-mode 1))))
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) t)
                                                               ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                                               ((string-match "Can it be delegated?" prompt) t)
                                                               ((string-match "Is this delegated task part of a project?" prompt) t)
                                                               (t nil))))
                          ((symbol-function 'read-string) (lambda (prompt &rest args) "Simulated Person")))
                  (org-gtd-complete-inbox-process-inbox)
                  (with-current-buffer (find-file-noselect (expand-file-name "gtd-projects.org" temp-dir))
                    (revert-buffer t t)
                    (goto-char (point-min))
                    (should (re-search-forward (regexp-quote test-item) nil t))
                    (should (string-match ":WAITING:" (buffer-string)))
                    (should (string-match ":DELEGATED_TO:Simulated Person:" (buffer-string))))
                  (with-current-buffer (find-file-noselect (expand-file-name "gtd-projects.org" temp-dir))
                    (revert-buffer t t)))
                (test-org-gtd-complete-cleanup-temp))))))))

(ert-deftest test-org-gtd-complete-process-inbox-actionable ()
  "Test path: Actionable, not in 2 minutes, not delegated, not project."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item)
            (insert "\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:"))
          (unwind-protect
              (progn
                (dolist (file (list inbox-file
                                    (expand-file-name "gtd-single-actions.org" temp-dir)))
                  (when (get-file-buffer file)
                    (with-current-buffer (get-file-buffer file)
                      (auto-revert-mode 1))))
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) t)
                                                               ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                                               ((string-match "Can it be delegated?" prompt) nil)
                                                               ((string-match "Is it a project?" prompt) nil)
                                                               (t nil)))))
                  (org-gtd-complete-inbox-process-inbox)
                  (with-current-buffer (find-file-noselect (expand-file-name "gtd-single-actions.org" temp-dir))
                    (revert-buffer t t)
                    (goto-char (point-min))
                    (should (re-search-forward (regexp-quote test-item) nil t)))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-actionable-project ()
  "Test path: Actionable, not in 2 minutes, not delegated, is project."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir))
        (org-gtd-complete-setup)
        (let* ((test-item "* Test item")
               (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
          (with-temp-file inbox-file
            (insert test-item)
            (insert "\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:"))
          (unwind-protect
              (progn
                (dolist (file (list inbox-file
                                    (expand-file-name "gtd-projects.org" temp-dir)))
                  (when (get-file-buffer file)
                    (with-current-buffer (get-file-buffer file)
                      (auto-revert-mode 1))))
                (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                         (cond ((string-match "Is .+ actionable?" prompt) t)
                                                               ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                                               ((string-match "Can it be delegated?" prompt) nil)
                                                               ((string-match "Is it a project?" prompt) t)
                                                               (t nil)))))
                  (org-gtd-complete-inbox-process-inbox)
                  (with-current-buffer (find-file-noselect (expand-file-name "gtd-projects.org" temp-dir))
                    (revert-buffer t t)
                    (goto-char (point-min))
                    (should (re-search-forward (regexp-quote test-item) nil t)))))
            (test-org-gtd-complete-cleanup-temp)))))))

(ert-deftest test-org-gtd-complete-process-inbox-empty-file ()
  "Test processing when inbox file is empty."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir)
             (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
        (org-gtd-complete-setup)
        ;; Create an empty file
        (with-temp-file inbox-file)
        (unwind-protect
            (progn
              (org-gtd-complete-inbox-process-inbox)
              (with-temp-buffer
                (insert-file-contents inbox-file)
                (should (string= (buffer-string) ""))))
          (test-org-gtd-complete-cleanup-temp))))))

(ert-deftest test-org-gtd-complete-process-inbox-nonexistent-file ()
  "Test processing when inbox file does not exist."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir)
             (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))  ;; File won't be created
        (unwind-protect
            (progn
              (org-gtd-complete-inbox-process-inbox)
              (should-not (file-exists-p inbox-file)))
          (test-org-gtd-complete-cleanup-temp))))))

(ert-deftest test-org-gtd-complete-process-inbox-multiple-items ()
  "Test processing multiple items in the inbox."
  (save-window-excursion
    (save-excursion
      (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
             (org-gtd-complete-base-directory temp-dir)
             (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
        (org-gtd-complete-setup)
        ;; Create inbox with multiple items
        (with-temp-file inbox-file
          (insert "* Item 1\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:\n")
          (insert "* Item 2\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:01:00\n:END:\n"))
        (unwind-protect
            (progn
              (dolist (file (list inbox-file
                                  (expand-file-name "gtd-single-actions.org" temp-dir)))
                (when (get-file-buffer file)
                  (with-current-buffer (get-file-buffer file)
                    (auto-revert-mode 1))))
              (cl-letf (((symbol-function 'y-or-n-p) (lambda (prompt)
                                                       ;; Simulate decisions for both items, e.g., both actionable and not in 2 minutes
                                                       (cond ((string-match "Is .+ actionable?" prompt) t)
                                                             ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                                             ((string-match "Can it be delegated?" prompt) nil)
                                                             ((string-match "Is it a project?" prompt) nil)
                                                             (t nil))))
                        ((symbol-function 'read-string) (lambda (&rest _) "")))
                (org-gtd-complete-inbox-process-inbox)
                ;; Verify outcomes, e.g., both items moved to single-actions.org
                (let ((actions-file (expand-file-name "gtd-single-actions.org" temp-dir)))
                  (with-temp-buffer
                    (insert-file-contents actions-file)
                    (should (re-search-forward "Item 1" nil t))
                    (should (re-search-forward "Item 2" nil t)))
                  (with-temp-buffer
                    (insert-file-contents inbox-file)
                    (should (string-match-p "^\\s-*$" (buffer-string)))))))  ;; Inbox should be empty
          (test-org-gtd-complete-cleanup-temp))))))

(defun test-org-gtd-complete-cleanup-temp ()
  "Clean up temporary directories and buffers created for test."
  (let ((temp-dirs (directory-files temporary-file-directory t "test-org-gtd-complete-")))
    (dolist (dir temp-dirs)
      (when (file-directory-p dir)
        (delete-directory dir t 'trash)))
    (dolist (buf (buffer-list))
      (when (and (buffer-file-name buf)
                 (string-match-p "test-org-gtd-complete-" (buffer-file-name buf)))
        (kill-buffer buf)))
    (when (get-buffer "*GTD Inbox View*")
      (kill-buffer "*GTD Inbox View*"))))

(provide 'test-org-gtd-complete)

;;; test-org-gtd-complete.el ends here
