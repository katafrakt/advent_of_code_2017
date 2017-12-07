package main

import (
    "bufio"
    "fmt"
    "os"
    "regexp"
    "strings"
)

func main() {
    file, _ := os.Open("input")
    defer file.Close()

    non_leaf_regexp := regexp.MustCompile(`(\w+) \((\d+)\) -> ([a-z, ]+)`)
    base_regexp := regexp.MustCompile(`([\w]+) \((\d+)\)`)

    var names []string
    var non_root []string

    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        line := scanner.Text()

        groups := base_regexp.FindStringSubmatch(line)
        names = append(names, groups[1])

        if(non_leaf_regexp.Match([]byte(line))) {
            leaves_string := non_leaf_regexp.FindStringSubmatch(line)[3]
            leaves := strings.Split(leaves_string, ", ")
            non_root = append(non_root, leaves...)
        }
    }

    var roots []string
    for _, i := range names {
        found := false
        for _, j := range non_root {
            if i == j {
                found = true
                break
            }
        }

        if !found {
            roots = append(roots, i)
        }
    }

    fmt.Println(roots) // should be only one
}