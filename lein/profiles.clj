{:user

 {:dependencies [;; nREPL libs
                 [nrepl/nrepl "1.0.0"]
                 [cider/cider-nrepl "0.30.0"]
                 [refactor-nrepl/refactor-nrepl "3.6.0"]

                 ;; REPL tooling
                 [zcaudate/lucid.core.inject "1.4.7"]
                 [vvvvalvalval/scope-capture "0.3.3"]
                 [vvvvalvalval/scope-capture-nrepl "0.3.1"]
                 [vlaaad/reveal "RELEASE"]

                 ;; Debug
                 [org.clojure/tools.trace "0.7.11"]

                 ;; Bench
                 [criterium "0.4.6"]]

  :injections [(clojure.core/require '[clojure.core :refer :all])

               ;; load reader macros

               ;; inject useful vars
               (require 'lucid.core.inject)
               (lucid.core.inject/in
                [clojure.tools.trace :refer [deftrace trace trace-forms
                                             trace-ns trace-vars
                                             untrace-ns untrace-vars]]
                [clojure.repl :refer [dir pst root-cause]]
                [clojure.pprint :refer [pprint]])

               ;; debug with tap>
               (def tap-> (fn
                            ([x] (tap> x) x)
                            ([x tag] (tap> [tag x]) x)))
               (def tap->> (fn
                             ([x] (tap> x) x)
                             ([tag x] (tap> [tag x]) x)))
               (lucid.core.inject/inject-single (create-ns '.) 'tap-> #'tap->)
               (lucid.core.inject/inject-single (create-ns '.) 'tap->> #'tap->>)]

  :plugins [[lein-ancient "0.7.0"]
            [lein-cljfmt "0.8.0"]
            [lein-cloverage "1.2.4"]
            [lein-eftest "0.5.9"]
            [lein-pprint "1.3.2"]
            [lein-shell "0.5.0"]]

  ; :jvm-opts ["-XX:-OmitStackTraceInFastThrow" "-XX:+CMSClassUnloadingEnabled"]
  :bootclasspath false

  :repl-options {:host "0.0.0.0"
                 :timeout 80000
                 :nrepl-middleware [cider.nrepl/wrap-apropos
                                    cider.nrepl/wrap-classpath
                                    cider.nrepl/wrap-clojuredocs
                                    cider.nrepl/wrap-complete
                                    cider.nrepl/wrap-debug
                                    cider.nrepl/wrap-format
                                    cider.nrepl/wrap-info
                                    cider.nrepl/wrap-inspect
                                    cider.nrepl/wrap-macroexpand
                                    cider.nrepl/wrap-ns
                                    cider.nrepl/wrap-out
                                    cider.nrepl/wrap-profile
                                    cider.nrepl/wrap-refresh
                                    cider.nrepl/wrap-resource
                                    cider.nrepl/wrap-spec
                                    cider.nrepl/wrap-stacktrace
                                    cider.nrepl/wrap-test
                                    cider.nrepl/wrap-trace
                                    cider.nrepl/wrap-undef
                                    cider.nrepl/wrap-version
                                    cider.nrepl/wrap-xref
                                    ; ;; scope-capture
                                    sc.nrepl.middleware/wrap-letsc
                                    ;; reveal
                                    vlaaad.reveal.nrepl/middleware
                                    ;; refactor
                                    refactor-nrepl.middleware/wrap-refactor]}

  :eftest {:multithread? false}

  :cljfmt {; tonsky-style :indents ^:replace {#"^\w" [[:inner 0]]}
           ; :remove-consecutive-blank-lines? false
           :indents {go-try [[:block 0]]
                     go-ctx [[:block 0]]
                     defrecord [[:inner 1]]}}

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
                  ["shell" "echo" "            git push --tags origin devel"]]}}}
