#include <iostream>
#include <fstream>
#include "gason.h"

using namespace std;
//
//void recurse(std::ostream & out, JsonValue & value){
//
//}
//
//void toCmake(){
//	ifstream f;
//  f.open(path);
//  f.seekg(0, std::ios::end);
//  auto length = f.tellg();
//  f.seekg(0, std::ios::end); 
//  char* source = new char[length];
//  char * endptr;
//
//  f.read(source, length);
//  f.close();
//
//  JsonValue value;
//  JsonAllocator allocator;
//  JsonParseStatus status = jsonParse(source, &endptr, &value, allocator);
//  if (status != JSON_PARSE_OK){
//    fprintf(stderr, "error at %zd, status: %d\n", endptr - source, status);
//    exit(EXIT_FAILURE);
//  }
//
//  auto tag = value.getTag();
//  switch (value.getTag()) {
//  case JSON_TAG_NUMBER:
//
//    break;
//  case JSON_TAG_BOOL:
//    break;
//  case JSON_TAG_STRING:
//    break;
//  case JSON_TAG_ARRAY:
//    break;
//  case JSON_TAG_OBJECT:
//    break;
//  case JSON_TAG_NULL:
//    break;
//  }
//}
void cmake_string(std::ostream & out, char *val){

  out << "val(";
  int i = 0;
  while (char c = val[i++]){
    switch (c){
    case '\\':
    case '"':
    case '(':
    case ')':
    case '$':
    case '#':
    case '^':
    case ';':
    case ' ':
      out << '\\';
      out << c;
      break;
    case '\t':
      out << "\\t";
      break;
    case '\n':
      out << "\\n";
      break;
    case '\r':
      out << "\\r";
      break;
    case '\0':
      out << "\\0";
      break;
    default:
      out << c;
      break;
    }
  }
  out << ")" << endl;
}
void doit(JsonValue & value, std::ostream & out){

  auto tag = value.getTag();

  switch (value.getTag()) {
  case JSON_TAG_NUMBER:
    out << "val(" << value.toNumber() << ")" << endl;
    break;
  case JSON_TAG_BOOL:
    if (value.toBool()){
      out << "val(true)" << endl;
    }
    else{
      out << "val(false)" << endl;
    }
    break;
  case JSON_TAG_STRING:
    cmake_string(out,value.toString());
    break;
  case JSON_TAG_ARRAY:
  {
    auto node = value.toNode();
    while (node){
      doit(node->value, out);
      node = node->next;
    }
  }
    break;
  case JSON_TAG_OBJECT:
  {
    auto node = value.toNode();
    out << "map()" << endl;
    while (node){
      out << "key(\"" << node->key << "\")" << endl;
      doit(node->value, out);
      node = node->next;
    }
    out << "end()" << endl;
  }
    break;
  case JSON_TAG_NULL:
    out << "val()" << endl;
    break;
  }
}
void parse(char * in, char ** end, std::ostream & out){
  JsonValue value;
  JsonAllocator allocator;
  JsonParseStatus status = jsonParse(in, end, &value, allocator);
  if (status != JSON_PARSE_OK){
    //fprintf(stderr, "error at %zd, status: %d\n", end - in, status);
    exit(EXIT_FAILURE);
  }


  out << "map()" << endl;
  out << "key(val)" << endl;
  // do
  doit(value, out);
  out << "end()" << endl;
  out << "map_tryget(${__ans} val)" << endl;


}
int main(int argc, char ** argv){
  if (argc < 3)return 1;

  auto path = argv[1];
  auto opath = argv[2];


  ifstream f;
  ofstream o;
  o.open(opath);
  if (!o)return 3;
  f.open(path);
  if (!f)return 2;
  f.seekg(0, std::ios::end);
  long length = f.tellg();
  f.seekg(0, std::ios::beg);
  char* source = new char[length + 1];
  char* end;
  source[length] = 0;

  f.read(source, length);
  f.close();
  parse(source, &end, o);
  o.close();
  return 0;
}