import 'package:facecam/auth/Profile/model.dart';
// ignore: depend_on_referenced_packages
import 'package:graphql/client.dart';


final _httpLink = HttpLink(
  "https://countries.trevorblades.com/",
);

final GraphQLClient client = GraphQLClient(
  link: _httpLink,
  cache: GraphQLCache(),
);



// returns a country with the given country code
Future<Country> getCountry(String code) async {
  var result = await client.query(
    QueryOptions(
      document: gql(_getCountry),
      variables: {
        "code": code,
      },
    ),
  );

  var json = result.data!["country"];

  var country = Country.fromJson(json);
  return country;
}


const _getCountry = r'''
query getCountry($code:ID!){
  country(code:$code){
    name
    capital
    code
    native
    currency
    phone
    emoji

  }
}

''';