(ns data-fetcher-lambda.s3
  (:require [clojure.java.io :as io])
  (:import (com.amazonaws.services.s3 AmazonS3Client AmazonS3ClientBuilder)
           (com.amazonaws.services.s3.model ObjectMetadata PutObjectRequest)
           (java.io ByteArrayInputStream)))

(def s3-client (AmazonS3ClientBuilder/defaultClient))

(defn payload->input-stream
  "Convert payload to inputstream."
  [payload]
  (io/input-stream
    (ByteArrayInputStream. (.getBytes payload))))

(defn put-object
  [^AmazonS3Client client ^String bucket ^String key ^String payload]
  (->> (PutObjectRequest. bucket key (payload->input-stream payload) (ObjectMetadata.))
       (.putObject client)))
