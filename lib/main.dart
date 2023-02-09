import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:staggered_view_1/globals/globals.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatefulWidget {
  const myApp({Key? key}) : super(key: key);

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => HomePage(),
        "view": (context) => ViewPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Staggered View',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
        ),
      ),
      body: MasonryGridView.count(
        crossAxisCount: 2,
        itemCount: category.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = category[index];
                Navigator.pushNamed(context, 'view');
              });
            },
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Image.network(category[index]['photo']),
                  ),
                  Text(
                    category[index]['name'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ViewPage extends StatefulWidget {
  const ViewPage({Key? key}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  int currentpg = 0;
  List list = selected['list'];
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selected['name'],
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider(
            carouselController: carouselController,
            items: list
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(e),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                                offset: Offset(7, 10),
                              ),
                            ]),
                      ),
                    ))
                .toList(),
            options: CarouselOptions(
              initialPage: currentpg,
              onPageChanged: (val, _) {
                setState(() {
                  currentpg = val;
                });
              },
              height: 600,
              viewportFraction: 0.75,
              enlargeCenterPage: true,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            child: Container(
              height: 100,
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: list
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          setState(() {
                            carouselController.animateToPage(list.indexOf(e),
                                curve: Curves.easeInOut);
                          });
                        },
                        child: CircleAvatar(
                          radius: (currentpg == list.indexOf(e)) ? 10 : 8,
                          backgroundColor: (currentpg == list.indexOf(e))
                              ? Colors.grey
                              : Colors.grey.shade300,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
