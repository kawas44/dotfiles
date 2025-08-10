{:user
 {:dependencies [;; nREPL libs & tools
                 [nrepl/nrepl "1.3.1"]

                 ;; REPL tooling
                 [vlaaad/reveal "1.3.284"]
                 [vvvvalvalval/scope-capture "0.3.3"]
                 [vvvvalvalval/scope-capture-nrepl "0.3.1"]

                 [zcaudate/lucid.core.inject "1.4.7"]

                 ;; Debug
                 [org.clojure/tools.trace "0.8.0"]

                 ;; Bench
                 [criterium/criterium "0.4.6"]]

  :plugins [[cider/cider-nrepl "0.57.0"]
            [refactor-nrepl "3.11.0"]
            [lein-ancient "0.7.0"]
            [lein-cljfmt "0.9.2"]
            [lein-cloverage "1.2.4"]
            [lein-eftest "0.6.0"]
            [lein-pprint "1.3.2"]
            [lein-shell "0.5.0"]]

  :repl-options {:nrepl-middleware [vlaaad.reveal.nrepl/middleware
                                    sc.nrepl.middleware/wrap-letsc]}

  :eftest {:multithread? false}

  :cljfmt {; tonsky-style :indents ^:replace {#".*" [[:inner 0]]}
           ; :remove-consecutive-blank-lines? false
           :indents {go-try [[:block 0]]
                     go-ctx [[:block 0]]
                     defrecord [[:inner 1]]}}}

 :gitflow-pre {:release-tasks
               [["shell" "git-branch-is" "devel"]
                ["vcs" "assert-committed"]
                ["shell" "git" "checkout" "master"]
                ["shell" "git" "pull"]
                ["shell" "git" "merge" "--ff-only" "devel"]
                ["change" "version" "leiningen.release/bump-version" "release"]
                ["vcs" "commit"]
                ["shell" "echo" "\n[GIT master] you must now review the changes and push!"]]}

 :gitflow-post {:release-tasks
                [["shell" "git-branch-is" "master"]
                 ["vcs" "assert-committed"]
                 ["vcs" "tag" "--no-sign"]
                 ["shell" "git" "checkout" "devel"]
                 ["shell" "git" "merge" "master"]
                 ["change" "version" "leiningen.release/bump-version" ":minor"]
                 ["vcs" "commit"]
                 ["shell" "echo" "\n[GIT devel] you are back on snapshot. Review and push (branches and tags)"]
                 ["shell" "echo" "            git push --tags origin devel"]]}}
