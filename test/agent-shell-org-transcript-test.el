;;; agent-shell-org-transcript-test.el --- Tests -*- lexical-binding: t; -*-

;;; Code:

(require 'ert)
(require 'agent-shell-org-transcript)

(ert-deftest agent-shell-org-transcript-parse-md-bold ()
  (let ((m (agent-shell--org-transcript-parse-md
            "# Agent Shell Transcript\n\n**Agent:** Claude Code\n**Started:** 2024-01-15 14:30:00\n**Working Directory:** /p/x\n\n---\n\n## User\n\n**Agent:** bogus\n")))
    (should (equal (map-elt m :agent) "Claude Code"))
    (should (equal (map-elt m :date) "2024-01-15 14:30:00"))
    (should (equal (map-elt m :working-dir) "/p/x"))
    (should-not (map-elt m :session-id))
    (should (equal (map-elt m :body) "## User\n\n**Agent:** bogus\n"))))

(ert-deftest agent-shell-org-transcript-parse-md-yaml ()
  (let ((m (agent-shell--org-transcript-parse-md
            "Session: s1\nTitle: t\n---\nagent: \"Claude Code\"\nstarted: \"2024-01-15T14:30:00-08:00\"\nworking_directory: \"/p/x\"\nsession_id: \"abc-123\"\n---\n\n# Agent Shell Transcript\n\n## User\n\nagent: bogus\n**Agent:** bogus\n")))
    (should (equal (map-elt m :agent) "Claude Code"))
    (should (equal (map-elt m :date) "2024-01-15 14:30:00"))
    (should (equal (map-elt m :working-dir) "/p/x"))
    (should (equal (map-elt m :session-id) "abc-123"))
    (should (equal (map-elt m :body) "## User\n\nagent: bogus\n**Agent:** bogus\n"))))

(ert-deftest agent-shell-org-transcript-migration-header-session ()
  (should (string-match-p "^#\\+PROPERTY: Session abc$"
                          (agent-shell--org-transcript-migration-header
                           "A" "2024-01-15 14:30:00" "/p/x" "abc"))))

;;; agent-shell-org-transcript-test.el ends here
