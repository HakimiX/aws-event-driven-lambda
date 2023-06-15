(ns data-fetcher-lambda.lambda
  "Responsible for handling incomming events"
  (:require [clojure.tools.logging :as log])
  (:gen-class
    :methods [^:static [handle
                        [com.amazonaws.services.lambda.runtime.events.CloudWatchLogsEvent
                         com.amazonaws.services.lambda.runtime.Context]
                        Object
                        ]]))

(defn -handle [event context]
    (log/info :message "Incomming event" :event event))

