import 'dart:convert';
import 'dart:io';

class Animal {
  String name;
  String type;
  String sound;
  Animal(this.name, this.type, this.sound);
  @override
  String toString() {
    return "Animal $name is of type $type and says $sound";
  }
}

main() {
  // String? answer = 'n';
  // do {
  stdout.write("Enter animal name: ");
  var name = stdin.readLineSync();
  stdout.write("Enter animal type: ");
  var type = stdin.readLineSync();
  stdout.write("Enter animal sound: ");
  var sound = stdin.readLineSync();
  var beast = Animal(name!, type!, sound!);
  print(beast);
  // stdout.write("Add another?");
  // answer = stdin.readLineSync(encoding: utf8);
  // } while (answer!=null && answer.toLowerCase()[0] == 'y');
}
