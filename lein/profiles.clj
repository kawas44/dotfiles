{:user

 {:dependencies [ ;;debugging [redl "0.2.4"]
                 [slamhound "1.5.5"]
                 [alembic "0.3.2"]
                 [cljfmt "0.5.7"]
                 [spyscope "0.1.6"]
                 [org.clojure/tools.nrepl "0.2.13"]]

  :injections [   ;;debugging (require '[redl complete core])
               (require 'spyscope.core)]

  :plugins [[cider/cider-nrepl "0.15.1"]
            [lein-pprint "1.1.2"]
            [lein-cljfmt "0.5.7"]
            ;;[com.palletops/lein-shorthand "0.4.0"]
            ]

  :aliases  {"slamhound"  ["run" "-m" "slam.hound"]}

  }}
