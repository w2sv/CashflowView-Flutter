import 'package:cashflow_view/utils/dart/collections.dart';
import 'package:test/test.dart';

void main(){
  test('test indexWhereRaising', (){
    expect([1, 2, 3].indexWhereRaising((element) => element == 1), 0);
    expect(() => [1, 2, 3].indexWhereRaising((element) => element == 4), throwsArgumentError);
  });
}