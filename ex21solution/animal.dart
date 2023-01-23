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
  stdout.write("Enter animal name: ");
  var name = stdin.readLineSync(encoding: utf8);
  stdout.write("Enter animal type: ");
  var type = stdin.readLineSync(encoding: utf8);
  stdout.write("Enter animal sound: ");
  var sound = stdin.readLineSync(encoding: utf8);
  var beast = Animal(name!, type!, sound!);
  print(beast);
}