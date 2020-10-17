//Class Eval is used to store the evaluator information
//and it is used by evaledit.dart and evalrmv.dart. 
class Eval
{
  String firstName;
  String lastName;
  String email;
  String weight;
  bool choice;

  Eval({this.firstName, this.lastName, this.email, this.weight, this.choice = false});

  factory Eval.fromJson(dynamic json) 
  {
    return Eval(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      weight: json['weight'],
      choice: false,
    );
  }
}