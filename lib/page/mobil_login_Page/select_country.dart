import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/state/stateController.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({Key? key}) : super(key: key);

  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  List<dynamic>? dataRetrieved; // data decoded from the json file
  List<dynamic>? data; // data to display on the screen
  var _searchController = TextEditingController();
  var searchValue = "";
  Rx<KeyViewducts> keysView = KeyViewducts().obs;
  allUser() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: countryColl,
//   queries: [
//  query.Query.equal('userId',model.)
//       ]
      )
          .then((data) {
        // Map map = data.toMap();

        var value = data.documents
            .map((e) => CountryModel.fromSnapshot(e.data))
            .toList();
        //data.documents;
        setState(() {
          feedState.country!.value = value;
        });
        // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
        //cprint('${feedState.feedlist?.value.map((e) => e.key)}');
      });

      // database
      //     .getDocument(collectionId: countryColl, documentId: countryId)
      //     .then((item) {
      //   // Map map = data.toMap();

      //   // var value =
      //   //     data.data.map((e) => ViewductsUser.fromJson(e.data));
      //   //data.documents;

      //   feedState.country.value = CountryModel.fromSnapshot(item.data);
      //   // cprint('${item.toMap()}');
      //   // cprint('${feedState.keywords.value.keywords?.map((e) => e.keyword)}');
      // });
    } on AppwriteException catch (e) {
      cprint('$e signupPage');
    }
  }

  @override
  void initState() {
    super.initState();
    allUser();
    _getData();
  }

  Future _getData() async {
    final String response =
        await rootBundle.loadString('assets/CountryCodes.json');
    dataRetrieved = await json.decode(response) as List<dynamic>;
    setState(() {
      data = dataRetrieved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text("Select Country",
                  style: TextStyle(color: CupertinoColors.darkBackgroundGray)),
              previousPageTitle: "Edit Number",
            ),
            SliverToBoxAdapter(
              child: CupertinoSearchTextField(
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                  });
                },
                controller: _searchController,
              ),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((context, index) => Container()),
              // delegate: SliverChildListDelegate((data != null)
              //     ? feedState.country!
              //         .where((e) => e.country
              //             .toString()
              //             .toLowerCase()
              //             .contains(searchValue.toLowerCase()))
              //         .map((e) {
              //         return CupertinoListTile(
              //           onTap: () {
              //             print(e.country);
              //             Navigator.pop(context, {
              //               "name": e.country,
              //               "code": e.dial_code,
              //               "countrycode": e.code
              //             });
              //           },
              //           title: Text(e.country.toString(),
              //               style: TextStyle(
              //                   color: CupertinoColors.darkBackgroundGray)),
              //           trailing: Text(e.dial_code.toString()),
              //         );
              //       }).toList()
              //     : [Center(child: Text("Loading"))]),
            )
          ],
        ),
      ),
    );
  }
}
