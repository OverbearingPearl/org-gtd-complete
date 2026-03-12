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

(ert-deftest test-org-gtd-complete-capture-item-to-inbox ()
  "Should capture an item to the inbox successfully."
  (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))  ; Create a temporary directory
         (input "New test item")
         (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))
    ;; Override org-gtd-complete-base-directory for this test
    (let ((org-gtd-complete-base-directory temp-dir))
      (org-gtd-complete-capture input)
      (should (file-exists-p inbox-file)))))

(ert-deftest test-org-gtd-complete-process-inbox-items-correctly ()
  "Should process inbox items correctly."
  (let* ((temp-dir (make-temp-file "test-org-gtd-complete-" t))  ; Create a temporary directory
         (test-item "* Test item [Captured at: 2023-01-01 12:00:00]")
         (expected-output "Inbox processing complete, but some items remain.")
         (inbox-file (expand-file-name "gtd-inbox.org" temp-dir)))  ; Use temporary directory for inbox file
    ;; Set up test environment using temporary file
    (with-temp-file inbox-file
      (insert test-item))
    ;; Override org-gtd-complete-base-directory for this test
    (let ((org-gtd-complete-base-directory temp-dir))
      (should (string= (org-gtd-complete-inbox-process-inbox) expected-output)))))  ; Replace with actual expected output

(provide 'test-org-gtd-complete)

;;; test-org-gtd-complete.el ends here
