{:user

 {:dependencies [ ;;debugging [redl "0.2.4"]
                 [slamhound "1.5.5"]
                 [alembic "0.3.2"]
                 [cljfmt "0.5.6"]
                 [spyscope "0.1.6"]
                 [org.clojure/tools.nrepl "0.2.12"]]

  :injections [   ;;debugging (require '[redl complete core])
               (require 'spyscope.core)]

  :plugins [[cider/cider-nrepl "0.13.0"]
            [lein-pprint "1.1.2"]
            [lein-cljfmt "0.5.6"]
            ;;[com.palletops/lein-shorthand "0.4.0"]
            ]

  ;;:shorthand {. [^:lazy alembic.still/load-project
  ;;               ^:lazy ^:macro alembic.still/lein]}
  }}
