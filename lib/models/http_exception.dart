class HttpException implements Exception{
  final String message;
  HttpException(this.message);
  
  // every class in dart has a toString method  i wanna overide it for this class
  @override
  String toString() {

    return message;
    // this is default to string which i wanna overide 
    // return super.toString();
  }
}