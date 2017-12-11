(def input_raw "147,37,249,1,31,2,226,0,161,71,254,243,183,255,30,70")
(def input_once (concat (map (fn [x] (int x)) (into-array input_raw)) [17 31 73 47 23]))
(def baselist (take 256 (range)));
;(def input [3 4 1 5])
;(def baselist (take 5 (range)))
(def lng (count baselist))

(defn -main []
    (def input (take (* 64 (count input_once)) (cycle input_once)))
    (loop [current_list baselist
        skip_size 0
        current_input_idx 0
        index_offset 0]
        (if (= skip_size (count input))
            (do
                (def start_idx (mod index_offset (count baselist)))
                (def sparse (concat (drop start_idx current_list) (take start_idx current_list)))
                (def parts (partition 16 sparse))
                (def result (map (fn [part] (map (fn [num] (Integer/toString (reduce (fn [result num] (bit-xor result num)) part) 16)) part)) parts))
                (println (clojure.string/replace (clojure.string/join (map (fn [a] (format "%2s" (nth a 0))) result)) " " "0")))
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