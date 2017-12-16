import 'dart:io';

rotateList(list, at) {
  at = list.length - at;
  var head = list.sublist(0, at);
  var tail = list.sublist(at);
  return new List.from(tail)..addAll(head);
}

swapElements(list, from, to) {
  var tmp = list[to];
  list[to] = list[from];
  list[from] = tmp;
}

performSteps(list, steps) {
  for (var step in steps) {
    var code = step[0];
    var data = step.substring(1);
    switch(code) {
      case 's':
        data = int.parse(data, onError: (source) => null);
        list = rotateList(list, data);
        break;
      case 'x':
        var parts = data.split("/");
        var from = int.parse(parts[0], onError: (source) => null);
        var to = int.parse(parts[1], onError: (source) => null);
        swapElements(list, from, to);
        break;
      case 'p':
        var parts = data.split("/");
        var from = list.indexOf(parts[0]);
        var to = list.indexOf(parts[1]);
        swapElements(list, from, to);
    }
  }
  return list;
}

main() async {
  const billion = 1000000000;
  const start = "abcdefghijklmnop";
  var list = start.split("");
  var instructions = await new File('input').readAsString();
  var steps = instructions.split(",");
  var period = billion;

  for (var i = 0; i < billion; i++) {
    list = performSteps(list, steps);

    var configuration = list.join();
    
    if (i == 0) print(configuration);
    
    if (configuration == start) {
      period = i + 1;
      break;
    }
  }
  
  var times = billion % period;
  for (var i = 0; i < times; i++) {
    list = performSteps(list, steps);
  }
  print(list.join(""));
}