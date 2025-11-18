class mr_user{
  final String name;
  final DateTime timestamp;
  final String phone;
  final String email;
  mr_user({
  required this.name,
  required this.timestamp,
  required this.phone,
    required this.email,
});
factory mr_user.fromJson(Map<String,dynamic> json, String docId){
  return mr_user(
    name: json['name'],
    timestamp: json['timestamp'].toDate(),
    phone: json['phone'],
    email: json['email'] ,
  );
}
Map<String,dynamic> toJson(){
  return {
  'name': name,
  'timestamp': timestamp,
  'phone': phone,
};
}
}