{:user

 {:dependencies [;; Begin dependency resolution
                 [nrepl "0.6.0"]
                 [cider/cider-nrepl "0.21.1"]
                 [refactor-nrepl "2.4.0"]
                 ;; End

                 ;; REPL tooling
                 [zcaudate/lucid.core.inject "1.4.7"]

                 ;; Debug
                 [spyscope "0.1.6"]
                 [inspector-jay "0.3" :exclusions [org.clojure/core.memoize]]
                 [vvvvalvalval/scope-capture "0.3.2"]

                 ;; Bench & Profile
                 #_[criterium "0.4.4"]
                 #_[com.clojure-goes-fast/clj-async-profiler "0.1.3"]

                 ;; Test
                 [pjstadig/humane-test-output "0.9.0"]]

  :injections [(clojure.core/require '[clojure.core :refer :all])
               ;; load reader macros
               (require 'spyscope.core)

               ;; activate test output reformat
               (require 'pjstadig.humane-test-output)
               (pjstadig.humane-test-output/activate!)

               ;; activate scope capture
               (require 'sc.api)

               ;; inject vars
               (require '[lucid.core.inject :as inject])
               (inject/in
                 ;; debug
                 [inspector-jay.core :refer [inspect]]
                 ;; bench & profile
                 #_[criterium.core :refer [with-progress-reporting bench quick-bench]])]

  :plugins [[com.jakemccrary/lein-test-refresh "0.24.1"]
            [lein-ancient "0.6.15"]
            [lein-cljfmt "0.6.4"]
            [lein-cloverage "1.1.1"]
            [lein-eftest "0.5.8"]
            [lein-pprint "1.2.0"]
            [lein-shell "0.5.0"]]


  :jvm-opts ["-XX:-OmitStackTraceInFastThrow" "-XX:+CMSClassUnloadingEnabled"]
  :bootclasspath false

  :repl-options {:nrepl-middleware [cider.nrepl/wrap-classpath
                                    cider.nrepl/wrap-complete
                                    cider.nrepl/wrap-debug
                                    cider.nrepl/wrap-format
                                    cider.nrepl/wrap-info
                                    cider.nrepl/wrap-macroexpand
                                    cider.nrepl/wrap-ns
                                    cider.nrepl/wrap-out
                                    cider.nrepl/wrap-spec
                                    cider.nrepl/wrap-test
                                    cider.nrepl/wrap-trace
                                    cider.nrepl/wrap-undef
                                    refactor-nrepl.middleware/wrap-refactor]}

  :test-refresh {:quiet true}

  :eftest {:multithread? false}

  :cljfmt {; tonsky-style :indents ^:replace {#"^\w" [[:inner 0]]}
           :remove-consecutive-blank-lines? false}

  :eastwood {:linters [:all]
             :exclude-linters [:non-clojure-file :unused-locals :keyword-typos :unused-fn-args]
             :add-linters []}

  }}
