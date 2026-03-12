(require 'ert)
(require 'org-gtd-complete)

(ert-deftest org-gtd-complete-inbox-test ()
  "Test org-gtd-complete-inbox-process-inbox function."
  (let ((test-item "* Test item [Captured at: 2023-01-01 12:00:00]")
        (expected-output "Inbox processing complete, but some items remain."))
    ;; 设置测试环境，例如模拟 inbox 文件
    (with-temp-file (expand-file-name "gtd-inbox.org" org-gtd-complete-base-directory)
      (insert test-item))
    (should (string= (org-gtd-complete-inbox-process-inbox) expected-output))))  ; 替换为实际预期输出

(ert-deftest org-gtd-complete-capture-test ()
  "Test org-gtd-complete-capture function."
  (let ((input "New test item"))
    (org-gtd-complete-capture input)
    (should (file-exists-p (expand-file-name "gtd-inbox.org" org-gtd-complete-base-directory)))))
