(ns hystrix-test.core
  (:require
   [org.httpkit.client :as http-kit]
   [com.netflix.hystrix.core :as hystrix]))

(defn get-req [port]
  (let [res @(http-kit/get (format "http://localhost:%d/" port))]
    (when (not (= 200 (:status res)))
      (throw (RuntimeException. (format "Non-200 Response: %s" res))))
    res))

(hystrix/defcommand wrapped-get [port]
            (get-req port))

(comment
  (hystrix/execute #'wrapped-get 8080)
  (wrapped-get 8080)

  (def obs (hystrix/observe #'wrapped-get 8080))
  (-> obs .toBlockingObservable .single)

  (def cmd1
   (hystrix/command
    {:type        :command
     :group-key   "hystrix-test.core"
     :command-key "hystrix-test.core/get-req"
     :run-fn      (fn wrapped-get [port] (assoc (get-req port)
                                           :from :run-fn))
     :fallback-fn (fn fallback [port] (assoc (get-req port)
                                        :from :fallback))
     ;; :cache-key-fn (fn [port] (str port))
     ;; :init-fn      (fn [cmd-map setter] ... setter)
     }))

  (take 100
   (map :from
        (repeatedly
         #(hystrix/execute cmd1 8080))))

  (wrapped-get 8080)

  (take 10
   (map (fn [_] (wrapped-get 8080))
        (range 1000)))


  )