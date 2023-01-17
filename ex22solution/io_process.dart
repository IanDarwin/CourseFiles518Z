import 'dart:io';

main()
  //-
  async
  //+
  {
  //T Examine the contents of this file
  String filename = "../data/observations.txt";
  //T Get a Future for a List of Lines from that file
  //T Get the list from the Future
  //T Pass the list through the process method below
  //T Finally print the totals for each person
  //-
  Future<List<String>> lines = File(filename).readAsLines();
  var linesList = await lines;
  var results = process(linesList);
  for (String k in results.keys) {
    print("$k total ${results[k]}");
  }
  //+
}

// A program this small doesn't really need to be split
// into a separate function, but this will make it easier
// to test (Chapter 4) and maintain as the app grows.
Map<String,int> process(List<String> linesList) {
  Map<String, int> results = {};
  //T For each line, split the line, use the first part
  //T as the key, and the second part as the value after
  //T converting it to an integer.
  //T Add the results for each person
  //T The results are to be accumulated,
  //T and returned, in a Map<String,int>
  //-
  for (var line in linesList) {
    var twoParts = line.split(' ');
    var key = twoParts[0];
    var count = int.parse(twoParts[1]);
    results.putIfAbsent(key, () => 0);
    int n = results[key]! + count;
    results[key] = n;
  }
  //+
  return results;
}