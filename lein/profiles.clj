{:user

 {:dependencies [ ;;debugging [redl "0.2.4"]
                 [alembic "0.3.2"]
                 [aprint "0.1.3"]
                 [cljfmt "0.5.7"]
                 [criterium "0.4.4"]
                 [im.chit/lucid.core.inject "1.3.13"]
                 [im.chit/lucid.core.namespace "1.3.13"]
                 [inspector-jay "0.3"]
                 [jsofra/data-scope "0.1.2"]
                 [org.clojure/tools.trace "0.7.9"]
                 [pjstadig/humane-test-output "0.8.3"]
                 [slamhound "1.5.5"]
                 ]

  :injections [   ;;debugging (require '[redl complete core])
               (require 'pjstadig.humane-test-output)
               (pjstadig.humane-test-output/activate!)

               (require 'data-scope.inspect)
               (require 'data-scope.pprint)

               (require '[lucid.core.inject :as inject])
               (inject/in
                 [aprint.core :refer [aprint ap nprint np]]
                 [inspector-jay.core :refer [inspect]]
                 ;[clojure.inspector :refer [inspect inspect-table inspect-tree]]
                 [clojure.pprint :refer [pprint pp]]
                 [clojure.tools.trace :refer [deftrace dotrace trace trace-forms]]
                 [criterium.core :refer [with-progress-reporting bench quick-bench]]
                 [lucid.core.namespace :refer [clear-aliases clear-mappings]]
                 )
               ]

  :plugins [ ;;[com.palletops/lein-shorthand "0.4.0"]
            [cider/cider-nrepl "0.15.1"]
            [jonase/eastwood "0.2.5"]
            [lein-ancient "0.6.12"]
            [lein-bikeshed "0.5.0"]
            [lein-cloverage "1.0.9"]
            [lein-kibit "0.1.6"]
            [lein-pprint "1.1.2"]
            ]

  :repl-options {:init (require 'cljfmt.core)}

  :jvm-opts ["-XX:-OmitStackTraceInFastThrow" "-XX:+CMSClassUnloadingEnabled"]

  :cljfmt {:remove-consecutive-blank-lines? false}

  :bikeshed {:max-line-length 180
             :trailing-whitespace false
             :trailing-blank-lines false}

  :eastwood {:linters [:all]
             :exclude-linters [:non-clojure-file :unused-locals :keyword-typos :unused-fn-args]
             :add-linters []}

  }}
