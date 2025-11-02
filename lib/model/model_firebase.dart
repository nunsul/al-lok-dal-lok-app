class mr_user{
  final String name;
  final String nickname;
  final DateTime timestamp;
  final String phone;
  final String age;
  final String nicknameLowercase;
  mr_user({
  required this.name,
  required this.timestamp,
  required this.phone,
  required this.age,
  required this.nickname,
  required this.nicknameLowercase
});
factory mr_user.fromJson(Map<String,dynamic> json, String docId){
  return mr_user(
    name: json['name'],
    nickname: json['nickname'],
    timestamp: json['timestamp'].toDate(),
    phone: json['phone'],
    age: json['age'],
    nicknameLowercase: json['nickname']
  );
}
Map<String,dynamic> toJson(){
  return {
  'name': name,
  'timestamp': timestamp,
  'phone': phone,
  'age': age,
  'nickname': nickname,
  'nicknameLowercase' : nicknameLowercase
};
}
}