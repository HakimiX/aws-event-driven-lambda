(defproject data-fetcher-lambda "0.1.2-SNAPSHOT"
  :description "AWS Lambda function that fetches data from multiple external data sources."
  :dependencies [[org.clojure/clojure "1.11.1"]
                 [cheshire "5.10.2"]
                 [clj-http "3.12.3"]
                 [org.clojure/tools.logging "1.2.4"]

                 ;; AWS dependencies
                 [com.amazonaws/aws-java-sdk-s3 "1.12.323"]
                 [com.amazonaws/aws-java-sdk-lambda "1.12.323"]
                 [com.amazonaws/aws-lambda-java-core "1.2.1"]
                 [com.amazonaws/aws-lambda-java-events "3.11.0"]]
  :main ^:skip-aot data-fetcher-lambda.lambda
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all
                       :jvm-opts ["-Dclojure.compiler.direct-linking=true"]}})
