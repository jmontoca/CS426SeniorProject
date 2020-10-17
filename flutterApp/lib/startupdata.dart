//template class for setting up the StartUpData data type.
class StartUpData
{
  String name;
  String email;
  String startUpName;
  double weight;
  List<int> vals;

  StartUpData({this.name, this.email, this.startUpName, this.vals, this.weight = 0});
}