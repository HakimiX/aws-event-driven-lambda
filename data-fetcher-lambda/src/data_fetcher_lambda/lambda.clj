(ns data-fetcher-lambda.lambda
  "Responsible for handling incomming events"
  (:require [clojure.tools.logging :as log]
            [clj-http.client :as client]
            [cheshire.core :as json]
            [data-fetcher-lambda.s3 :as s3])
  (:gen-class
    :methods [^:static [handle
                        [com.amazonaws.services.lambda.runtime.events.ScheduledEvent
                         com.amazonaws.services.lambda.runtime.Context]
                        Object
                        ]]))

(def data-store-s3-bucket (System/getenv "DATA_STORE_S3_BUCKET"))
(def api-endpoint (System/getenv "API_ENDPOINT"))

(defn fetch-data
  "Fetches a specific amount of data of a certain type from an API endpoint.
  Parses the JSON response into Clojure data structures and takes the first
  'data-amount' elements from the parsed data.

  Args:
   - data-type: The type of data to fetch from the API.
   - data-amount: The amount of data elements to fetch."
  [data-type data-amount]
  (try
    (log/info :message "Fetching data" :data-type data-type)
    (take data-amount (json/parse-string (:body (client/get (str api-endpoint "/" data-type))) keyword))
    (catch Exception e
      (log/error :message "Error fetching data" :error (.getMessage e))
      {:status 500 :body nil})))

(defn -handle [event context]
  (log/info :message "Incoming event" :event event :context context)
  (s3/put-object s3/s3-client data-store-s3-bucket "posts.json" (fetch-data "posts" 10))
  (log/info :message "Finished handling event"))
