;;; test-org-gtd-complete.el --- Tests for org-gtd-complete  -*- lexical-binding: t; -*-

;; Copyright (C) 2026 OverbearingPearl

;; Author: OverbearingPearl <OverbearingPearl@outlook.com>
;; Maintainer: OverbearingPearl <OverbearingPearl@outlook.com>
;; URL: https://github.com/OverbearingPearl/org-gtd-complete
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (ert "1.0") (org-gtd-complete "0.1.0"))
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

(ert-deftest test-org-gtd-complete-inbox-test ()
  "Test org-gtd-complete-inbox-process-inbox function."
  (let ((test-item "* Test item [Captured at: 2023-01-01 12:00:00]")
        (expected-output "Inbox processing complete, but some items remain."))
    ;; Set up test environment, e.g., simulate inbox file
    (with-temp-file (expand-file-name "gtd-inbox.org" org-gtd-complete-base-directory)
      (insert test-item))
    (should (string= (org-gtd-complete-inbox-process-inbox) expected-output))))  ; Replace with actual expected output

(ert-deftest test-org-gtd-complete-capture-test ()
  "Test org-gtd-complete-capture function."
  (let ((input "New test item"))
    (org-gtd-complete-capture input)
    (should (file-exists-p (expand-file-name "gtd-inbox.org" org-gtd-complete-base-directory)))))

(provide 'test-org-gtd-complete)

;;; test-org-gtd-complete.el ends here
