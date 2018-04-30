{:user

 {:dependencies [;; Begin dependency resolution
                 [org.clojure/tools.nrepl "0.2.13" :exclusions [org.clojure/clojure]]
                 ;; End

                 ;; REPL tooling
                 [zcaudate/lucid.core.inject "1.4.4"]

                 ;; Debug
                 [spyscope "0.1.6"]
                 [aprint "0.1.3"]
                 [zcaudate/lucid.core.debug "1.4.4"]
                 [inspector-jay "0.3" :exclusions [org.clojure/core.memoize]]
                 [jsofra/data-scope "0.1.2"]
                 [org.clojure/tools.trace "0.7.9"]

                 ;; Bench & Profile
                 [criterium "0.4.4"]
                 [com.clojure-goes-fast/clj-async-profiler "0.1.2"]

                 ;; Test
                 [pjstadig/humane-test-output "0.8.3"]
                 ]

  :injections [;; load reader macros
               (require 'spyscope.core)
               (require 'data-scope.inspect)
               (require 'data-scope.pprint)

               ;; activate test output reformat
               (require 'pjstadig.humane-test-output)
               (pjstadig.humane-test-output/activate!)

               ;; inject vars
               (require '[lucid.core.inject :as inject])
               (inject/in
                 ;; debug
                 [aprint.core :refer [aprint ap nprint np]]
                 [lucid.core.debug :refer [dbg-> dbg->> ->doto ->>doto ->prn]]
                 [inspector-jay.core :refer [inspect]]
                 [clojure.tools.trace]
                 ;; bench & profile
                 [criterium.core :refer [with-progress-reporting bench quick-bench]]
                 )]

  :plugins [
            [cider/cider-nrepl "0.16.0"]
            [jonase/eastwood "0.2.5"]
            [lein-ancient "0.6.15"]
            [lein-bikeshed "0.5.1" :exclusions [org.clojure/tools.namespace]]
            [lein-cloverage "1.0.10"]
            [lein-kibit "0.1.6"]
            [lein-pprint "1.2.0"]
            [refactor-nrepl "2.3.1"]
            [venantius/yagni "0.1.4"]
            ]

  :jvm-opts ["-XX:-OmitStackTraceInFastThrow" "-XX:+CMSClassUnloadingEnabled"]

  :bikeshed {:max-line-length 180
             :trailing-whitespace false
             :trailing-blank-lines false}

  :eastwood {:linters [:all]
             :exclude-linters [:non-clojure-file :unused-locals :keyword-typos :unused-fn-args]
             :add-linters []}

  }}
