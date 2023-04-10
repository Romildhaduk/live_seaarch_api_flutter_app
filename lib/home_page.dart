// import 'package:flutter/material.dart';
// import 'apihelper.dart';
// import 'model.dart';
//
// class Homepage extends StatefulWidget {
//   const Homepage({Key? key}) : super(key: key);
//
//   @override
//   State<Homepage> createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage> {
//   @override
//   void initState() {
//     super.initState();
//     APIHelper.apiHelper.fetchImagesData();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.green,
//           centerTitle: true,
//           title: const Text("Api Calling"),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//                 flex: 2,
//                 child: Column(
//                   children: [
//                     const Spacer(),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       width: MediaQuery.of(context).size.width * 0.95,
//                       child: TextField(
//                         onSubmitted: (val) {
//                           setState(() {
//                             APIHelper.apiHelper.search = val;
//                           });
//                         },
//                         decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: APIHelper.apiHelper.search),
//                       ),
//                     ),
//                   ],
//                 )),
//             const SizedBox(
//               height: 8,
//             ),
//             Expanded(
//               flex: 12,
//               child: FutureBuilder(
//                 future: APIHelper.apiHelper.fetchImagesData(),
//                 builder: (context, AsyncSnapshot snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text(snapshot.error.toString()),
//                     );
//                   } else if (snapshot.hasData) {
//                     List<Images> allDetails = snapshot.data;
//                     return ListView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: allDetails.length,
//                       itemBuilder: (context, i) {
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             height: 250,
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(10),
//                               image: DecorationImage(
//                                   image: NetworkImage("${allDetails[i].url}"),
//                                   fit: BoxFit.cover),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   } else {
//                     return const Center(
//                         child: CircularProgressIndicator(
//                       color: Colors.green,
//                       backgroundColor: Colors.grey,
//                     ));
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'apihelper.dart';
import 'model.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ScrollController _scrollController = ScrollController();

  List<Images>? user = [];
  List useradddata = [];
  bool isLoading = true;
  //int offset = 0;

  @override
  void initState() {
    super.initState();
    calling();
    handalnext();
  }

  void calling() async {
    final userfromapi = await APIHelper.apiHelper.fetchImagesData();
    APIHelper.apiHelper.page++;
    user?.addAll(userfromapi as Iterable<Images>);
    setState(() {});
    isLoading = false;
    print("====>${user!.length}");
  }

  void handalnext() {
    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        calling();
        APIHelper.apiHelper.page++;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Text("Api Calling"),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: TextField(
                        onSubmitted: (val) {
                          setState(() {
                            APIHelper.apiHelper.search = val;
                            print("======>$val");
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: APIHelper.apiHelper.search),
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              flex: 12,
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: user?.length ?? 0,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage("${user![i].url}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
