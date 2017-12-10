(def input [147 37 249 1 31 2 226 0 161 71 254 243 183 255 30 70])
(def baselist (take 256 (range)))
(def lng (count baselist))

(defn -main []
    (loop [current_list baselist
        skip_size 0
        current_input_idx 0
        index_offset 0]
        (if (= skip_size (count input))
            (do
                (def start_idx (mod index_offset (count baselist)))
                (println (* (nth current_list start_idx) (nth current_list (mod (+ 1 start_idx) lng)))))
            (do
                (def cycled (take lng (cycle current_list)))
                (def length (nth input current_input_idx))
                (def to_reverse (take length cycled))
                (def tail (drop length cycled))
                (def reversed (reverse to_reverse))
                (def new_tmp_list (concat reversed tail))
                (def offset (mod (+ skip_size length) lng))
                (def new_list (concat (drop offset new_tmp_list) (take offset new_tmp_list)))
                (recur (take lng new_list) (inc skip_size) (inc current_input_idx) (- index_offset offset))))))

(try (require 'leiningen.exec)
    (when @(ns-resolve 'leiningen.exec '*running?*)
      (apply -main (rest *command-line-args*)))
    (catch java.io.FileNotFoundException e))