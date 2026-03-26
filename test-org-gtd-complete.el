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

(defmacro test-org-gtd-complete-define-test (name docstring &rest args)
  "Define an ERT test for org-gtd-complete with structured setup.
NAME is the test name symbol.
DOCSTRING is the test description.
ARGS is a plist with keys: :setup, :files, :mock, :body, :asserts, :teardown.
If :SETUP, :BODY, :ASSERTS, or :TEARDOWN contain multiple forms, wrap them in (progn ...).
:MOCK should be a list of bindings suitable for `cl-letf', which will wrap :BODY and :ASSERTS.
:FILES is expected to be a list in its specific format and is not wrapped."
  (declare (indent defun))
  (let ((setup (plist-get args :setup))
        (files (plist-get args :files))
        (mock (plist-get args :mock))
        (body (plist-get args :body))
        (asserts (plist-get args :asserts))
        (teardown (plist-get args :teardown)))
    `(ert-deftest ,name ()
       ,docstring
       (save-window-excursion
         (save-excursion
           (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))
                  (org-gtd-complete-base-directory temp-dir))
             ,setup
             (dolist (file-spec ',files)
               (let ((file (car file-spec))
                     (content (cadr file-spec)))
                 (with-temp-file (expand-file-name file temp-dir)
                   (insert content))))
             (unwind-protect
                 (progn
                   (dolist (file (directory-files temp-dir t "\\.org$"))
                     (when (get-file-buffer file)
                       (with-current-buffer (get-file-buffer file)
                         (auto-revert-mode 1))))
                   (cl-letf ,mock
                     ,body
                     ,asserts))
               ,teardown
               (test-org-gtd-complete-cleanup-temp))))))))

(test-org-gtd-complete-define-test test-org-gtd-complete-capture-item-to-inbox
  "Should capture an item to the inbox successfully."
  :setup (org-gtd-complete-setup)
  :files (("gtd-inbox.org" ""))
  :body (org-gtd-complete-capture "New test item")
  :asserts (with-current-buffer (find-file-noselect (expand-file-name "gtd-inbox.org" temp-dir))
             (goto-char (point-min))
             (should (re-search-forward "^\\* New test item" nil t))
             (should (re-search-forward ":PROPERTIES:" nil t))
             (should (re-search-forward ":CAPTURED_AT:" nil t))))

(test-org-gtd-complete-define-test test-org-gtd-complete-process-inbox-reference
  "Test path: Not actionable, is reference."
  :setup (org-gtd-complete-setup)
  :files (("gtd-inbox.org" "* Test item\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:")
          ("gtd-reference.org" ""))
  :mock (((symbol-function 'y-or-n-p) (lambda (prompt)
                                        (cond ((string-match "Is .+ actionable?" prompt) nil)
                                              ((string-match "Is it reference material?" prompt) t)
                                              (t nil)))))
  :body (org-gtd-complete-inbox-process-inbox)
  :asserts (progn
             (with-current-buffer (find-file-noselect (expand-file-name "gtd-reference.org" temp-dir))
               (revert-buffer t t)
               (goto-char (point-min))
               (should (re-search-forward "\\* Test item" nil t)))
             (with-temp-buffer
               (insert-file-contents (expand-file-name "gtd-inbox.org" temp-dir))
               (should (not (save-excursion (goto-char (point-min)) (re-search-forward "\\* Test item" nil t))))
               (should (string-match-p "^\\s-*$" (buffer-string))))))

(test-org-gtd-complete-define-test test-org-gtd-complete-process-inbox-someday
  "Test path: Not actionable, should go to Someday/Maybe."
  :setup (org-gtd-complete-setup)
  :files (("gtd-inbox.org" "* Test item\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:")
          ("gtd-someday.org" ""))
  :mock (((symbol-function 'y-or-n-p) (lambda (prompt)
                                        (cond ((string-match "Is .+ actionable?" prompt) nil)
                                              ((string-match "Is it reference material?" prompt) nil)
                                              ((string-match "Should it go to Someday/Maybe?" prompt) t)
                                              (t nil)))))
  :body (org-gtd-complete-inbox-process-inbox)
  :asserts (progn
             (with-current-buffer (find-file-noselect (expand-file-name "gtd-someday.org" temp-dir))
               (revert-buffer t t)
               (goto-char (point-min))
               (should (re-search-forward "\\* Test item" nil t)))
             (with-temp-buffer
               (insert-file-contents (expand-file-name "gtd-inbox.org" temp-dir))
               (should (not (save-excursion (goto-char (point-min)) (re-search-forward "\\* Test item" nil t))))
               (should (string-match-p "^\\s-*$" (buffer-string))))))

(test-org-gtd-complete-define-test test-org-gtd-complete-process-inbox-trash
  "Test path: Not actionable, trash."
  :setup (org-gtd-complete-setup)
  :files (("gtd-inbox.org" "* Test item\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:"))
  :mock (((symbol-function 'y-or-n-p) (lambda (prompt)
                                        (cond ((string-match "Is .+ actionable?" prompt) nil)
                                              ((string-match "Is it reference material?" prompt) nil)
                                              ((string-match "Should it go to Someday/Maybe?" prompt) nil)
                                              (t nil))))
         ((symbol-function 'read-string) (lambda (&rest _) "")))
  :body (org-gtd-complete-inbox-process-inbox)
  :asserts (progn
             (should (file-exists-p (expand-file-name "gtd-inbox.org" temp-dir)))
             (with-temp-buffer
               (insert-file-contents (expand-file-name "gtd-inbox.org" temp-dir))
               (should (string= (buffer-string) ""))
               (should (not (save-excursion (goto-char (point-min)) (re-search-forward "\\* Test item" nil t)))))))

(test-org-gtd-complete-define-test test-org-gtd-complete-process-inbox-actionable-2-minutes
  "Test path: Actionable, can be done in 2 minutes."
  :setup (org-gtd-complete-setup)
  :files (("gtd-inbox.org" "* Test item\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:"))
  :mock (((symbol-function 'y-or-n-p) (lambda (prompt)
                                        (cond ((string-match "Is .+ actionable?" prompt) t)
                                              ((string-match "Can it be done in 2 minutes?" prompt) t)
                                              (t nil)))))
  :body (org-gtd-complete-inbox-process-inbox)
  :asserts (progn
             (should (file-exists-p (expand-file-name "gtd-inbox.org" temp-dir)))
             (with-temp-buffer
               (insert-file-contents (expand-file-name "gtd-inbox.org" temp-dir))
               (should (string= (buffer-string) ""))
               (should (not (save-excursion (goto-char (point-min)) (re-search-forward "\\* Test item" nil t)))))))

(test-org-gtd-complete-define-test test-org-gtd-complete-process-inbox-actionable-delegated
  "Test delegating a non-project item."
  :setup (org-gtd-complete-setup)
  :files (("gtd-inbox.org" "* Test item [Captured at: 2023-01-01 12:00:00]\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:")
          ("gtd-single-actions.org" ""))
  :mock (((symbol-function 'y-or-n-p) (lambda (prompt)
                                        (cond ((string-match "Is .+ actionable?" prompt) t)
                                              ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                              ((string-match "Can it be delegated?" prompt) t)
                                              ((string-match "Is it a project?" prompt) nil)
                                              (t nil))))
         ((symbol-function 'read-string) (lambda (prompt &rest args) "Simulated Person")))
  :body (org-gtd-complete-inbox-process-inbox)
  :asserts (with-current-buffer (find-file-noselect (expand-file-name "gtd-single-actions.org" temp-dir))
             (revert-buffer t t)
             (goto-char (point-min))
             (should (re-search-forward "\\* Test item" nil t))
             (should (string-match ":WAITING:" (buffer-string)))
             (should (string-match ":DELEGATED_TO:Simulated Person:" (buffer-string)))))

(test-org-gtd-complete-define-test test-org-gtd-complete-process-inbox-actionable-delegated-project
  "Test path: Actionable, not in 2 minutes, can be delegated."
  :setup (org-gtd-complete-setup)
  :files (("gtd-inbox.org" "* Test item\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:")
          ("gtd-projects.org" ""))
  :mock (((symbol-function 'y-or-n-p) (lambda (prompt)
                                        (cond ((string-match "Is .+ actionable?" prompt) t)
                                              ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                              ((string-match "Can it be delegated?" prompt) t)
                                              ((string-match "Is this delegated task part of a project?" prompt) t)
                                              (t nil))))
         ((symbol-function 'read-string) (lambda (prompt &rest args) "Simulated Person")))
  :body (org-gtd-complete-inbox-process-inbox)
  :asserts (with-current-buffer (find-file-noselect (expand-file-name "gtd-projects.org" temp-dir))
             (revert-buffer t t)
             (goto-char (point-min))
             (should (re-search-forward "\\* Test item" nil t))
             (should (string-match ":WAITING:" (buffer-string)))
             (should (string-match ":DELEGATED_TO:Simulated Person:" (buffer-string)))))

(test-org-gtd-complete-define-test test-org-gtd-complete-process-inbox-actionable
  "Test path: Actionable, not in 2 minutes, not delegated, not project."
  :setup (org-gtd-complete-setup)
  :files (("gtd-inbox.org" "* Test item\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:")
          ("gtd-single-actions.org" ""))
  :mock (((symbol-function 'y-or-n-p) (lambda (prompt)
                                        (cond ((string-match "Is .+ actionable?" prompt) t)
                                              ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                              ((string-match "Can it be delegated?" prompt) nil)
                                              ((string-match "Is it a project?" prompt) nil)
                                              (t nil)))))
  :body (org-gtd-complete-inbox-process-inbox)
  :asserts (with-current-buffer (find-file-noselect (expand-file-name "gtd-single-actions.org" temp-dir))
             (revert-buffer t t)
             (goto-char (point-min))
             (should (re-search-forward "\\* Test item" nil t))))

(test-org-gtd-complete-define-test test-org-gtd-complete-process-inbox-actionable-project
  "Test path: Actionable, not in 2 minutes, not delegated, is project."
  :setup (org-gtd-complete-setup)
  :files (("gtd-inbox.org" "* Test item\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:")
          ("gtd-projects.org" ""))
  :mock (((symbol-function 'y-or-n-p) (lambda (prompt)
                                        (cond ((string-match "Is .+ actionable?" prompt) t)
                                              ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                              ((string-match "Can it be delegated?" prompt) nil)
                                              ((string-match "Is it a project?" prompt) t)
                                              (t nil)))))
  :body (org-gtd-complete-inbox-process-inbox)
  :asserts (with-current-buffer (find-file-noselect (expand-file-name "gtd-projects.org" temp-dir))
             (revert-buffer t t)
             (goto-char (point-min))
             (should (re-search-forward "\\* Test item" nil t))))

(test-org-gtd-complete-define-test test-org-gtd-complete-process-inbox-empty-file
  "Test processing when inbox file is empty."
  :setup (org-gtd-complete-setup)
  :files (("gtd-inbox.org" ""))
  :body (org-gtd-complete-inbox-process-inbox)
  :asserts (with-temp-buffer
             (insert-file-contents (expand-file-name "gtd-inbox.org" temp-dir))
             (should (string= (buffer-string) ""))))

(test-org-gtd-complete-define-test test-org-gtd-complete-process-inbox-nonexistent-file
  "Test processing when inbox file does not exist."
  :body (org-gtd-complete-inbox-process-inbox)
  :asserts (should-not (file-exists-p (expand-file-name "gtd-inbox.org" temp-dir))))

(test-org-gtd-complete-define-test test-org-gtd-complete-process-inbox-multiple-items
  "Test processing multiple items in the inbox."
  :setup (org-gtd-complete-setup)
  :files (("gtd-inbox.org" "* Item 1\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:00:00\n:END:\n* Item 2\n:PROPERTIES:\n:CAPTURED_AT: 2023-01-01 12:01:00\n:END:")
          ("gtd-single-actions.org" ""))
  :mock (((symbol-function 'y-or-n-p) (lambda (prompt)
                                        (cond ((string-match "Is .+ actionable?" prompt) t)
                                              ((string-match "Can it be done in 2 minutes?" prompt) nil)
                                              ((string-match "Can it be delegated?" prompt) nil)
                                              ((string-match "Is it a project?" prompt) nil)
                                              (t nil))))
         ((symbol-function 'read-string) (lambda (&rest _) "")))
  :body (org-gtd-complete-inbox-process-inbox)
  :asserts (progn
             (with-temp-buffer
               (insert-file-contents (expand-file-name "gtd-single-actions.org" temp-dir))
               (should (re-search-forward "Item 1" nil t))
               (should (re-search-forward "Item 2" nil t)))
             (with-temp-buffer
               (insert-file-contents (expand-file-name "gtd-inbox.org" temp-dir))
               (should (string-match-p "^\\s-*$" (buffer-string))))))

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
