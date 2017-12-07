package main

import (
    "bufio"
    "fmt"
    "os"
    "regexp"
    "strings"
    "strconv"
)

type Program struct {
    name string
    weight int
    weight_held int
    child_names []string
    children []Program
}

func build_real_tree(programs map[string]Program, node *Program) Program {
    for _, name := range node.child_names {
        child := programs[name]
        node.children = append(node.children, build_real_tree(programs, &child))
    }
    
    return *node
}

func calculate_held_weight(node *Program) {
    if node.weight_held == 0 {         
        calculated_weight := 0

        for i := 0; i < len(node.children); i++ {
            ch := &node.children[i]
            calculate_held_weight(ch)
            calculated_weight += ch.weight + ch.weight_held
        }
        node.weight_held = calculated_weight
    }
}

func pretty_p(node Program) {
    fmt.Print(node.name, ": (")
    for _, c := range node.children {
        fmt.Print(c.name, ": ", c.weight + c.weight_held, " ")
    }
    fmt.Println(")")
}

func all_weights_same(nodes []Program) bool {
    base_node := nodes[0]
    for i := 0; i < len(nodes); i++ {
        current_node := nodes[i]
        if current_node.weight_held + current_node.weight != base_node.weight_held + base_node.weight {
            return false
        }
    }
    return true
}

func find_wrong_node(nodes []Program) (Program, int) {
    weights := make(map[int][]Program)
    for _, n := range nodes {
        w := n.weight + n.weight_held
        list := weights[w]
        if list == nil {
            list = make([]Program, 0)
        }
        list = append(list, n)
        weights[w] = list
    }

    program := Program{}
    desired_weight := 0
    
    for i, n := range weights {
        if len(n) == 1 {
            program = n[0]
        } else {
            desired_weight = i
        }
    }

    return program, desired_weight
}

func find_rogue_program(node Program, weight_expectation int) (Program, int) {
    if len(node.children) > 0 && !all_weights_same(node.children) {
        candidate, num := find_wrong_node(node.children)
        return find_rogue_program(candidate, num)
    }
    return node, weight_expectation
}

func main() {
    file, _ := os.Open("input")
    defer file.Close()

    non_leaf_regexp := regexp.MustCompile(`(\w+) \((\d+)\) -> ([a-z, ]+)`)
    base_regexp := regexp.MustCompile(`([\w]+) \((\d+)\)`)

    programs := make(map[string]Program)

    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        line := scanner.Text()

        groups := base_regexp.FindStringSubmatch(line)
        name := groups[1]
        weight, _ := strconv.ParseInt(groups[2], 10, 32)
        var leaves []string;

        if(non_leaf_regexp.Match([]byte(line))) {
            leaves_string := non_leaf_regexp.FindStringSubmatch(line)[3]
            leaves = strings.Split(leaves_string, ", ")
        }

        programs[name] = Program{name, int(weight), 0, leaves, nil}
    }

    root := programs["fbgguv"]
    root = build_real_tree(programs, &root)
    calculate_held_weight(&root)
    node, weight_expectation := find_rogue_program(root, 0)
    fmt.Println(weight_expectation - node.weight_held)
}