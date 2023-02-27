import 'package:flutter/material.dart';
import 'cancer_prediction.dart';
// import 'main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        // height: 256,
        // child : Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     ListView.separated(
        //     padding: const EdgeInsets.all(12),
        //     scrollDirection: Axis.horizontal,
        //     // The number of itemCount depends on the number of appointment
        //     itemCount : 5,
        //     separatorBuilder:  (context, index) => SizedBox(width: 12),
        //     itemBuilder: (context, index) => upcomingappointment(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //metadoc
            Container(
              color: Color.fromARGB(255, 220, 237, 249),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Meet a doctor now!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text('Just a few simple steps',
                          style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const NetworkImage(
                            'https://cdn.imgbin.com/16/14/21/imgbin-physician-hospital-medicine-doctor-dentist-doctor-MvjeZ7XWhJkkxsq5WJJQFWNcK.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //home_page
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      height: 23,
                      width: 201,
                      child: const Text('Upcoming Appointments',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(12),
                      // The number of itemCount depends on the number of appointment
                      itemCount: 5,
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 12);
                      },
                      itemBuilder: (context, index) {
                        return upcomingappointment(index);
                      },
                    ),
                  ),
                  // i is the number of appointment, 3 is for testing only
                ],
              ),
            ),

            //home
            Container(
              color: Color.fromARGB(255, 217, 217, 217),
              child: DefaultTextStyle(
                style: TextStyle(color: Color.fromARGB(255, 123, 141, 158)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.home,
                              color: Color.fromARGB(255, 123, 141, 158)),
                          const Text('Home')
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.calendar_month,
                              color: Color.fromARGB(255, 123, 141, 158)),
                          const Text('Calendar'),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.message,
                              color: Color.fromARGB(255, 123, 141, 158)),
                          const Text('Message'),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.person),
                            color: Color.fromARGB(255, 123, 141, 158),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CancerPredict())),
                          ),
                          const Text('My Profile'),
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget home_page = DefaultTextStyle.merge(
//   child: Container(
//     padding: const EdgeInsets.all(20),
//     child: Column(
//       children: [
//         Align(alignment: Alignment.centerLeft,
//           child: Container(
//             margin: const EdgeInsets.all(12),
//             height: 23,
//             width: 201,
//             child:
//               const Text('Upcoming Appointments', style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//         ),
//         SizedBox(
//           height: 120,
//           child: ListView.separated(
//             physics: const AlwaysScrollableScrollPhysics(),
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.all(12),
//             // The number of itemCount depends on the number of appointment
//             itemCount : 5,
//             separatorBuilder:  (context, index) {
//               return const SizedBox(width: 12);
//             },
//             itemBuilder: (context, index) {
//               return upcomingappointment(index);
//             },
//           ),
//         ),
//         // i is the number of appointment, 3 is for testing only
//       ],
//     ),
//   ),
// );

// Widget home = DefaultTextStyle.merge(
//   child: Container(
//     color : Color.fromARGB(255, 217, 217, 217),
//     child : DefaultTextStyle(
//       style : TextStyle(color : Color.fromARGB(255, 123, 141, 158)),
//       child : Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Column(
//             children: [
//             Icon(Icons.home,color: Color.fromARGB(255, 123, 141, 158)),
//             const Text('Home')
//             ],
//           ),
//           Column(
//             children: [
//             Icon(Icons.calendar_month,color: Color.fromARGB(255, 123, 141, 158)),
//             const Text('Calendar'),
//             ],
//           ),
//           Column(
//             children: [
//             Icon(Icons.message,color: Color.fromARGB(255, 123, 141, 158)),
//             const Text('Message'),
//             ],
//           ),
//           Column(
//             children: [
//             IconButton(
//               icon: Icon(Icons.person),
//               color: Color.fromARGB(255, 123, 141, 158),
//               onPressed: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const MyHomePage(title: 'Home'))),
//             ),
//             const Text('My Profile'),
//             ],
//           ),

//         ]
//       ),
//     ),
//   ),
// );

Widget upcomingappointment(int index) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Text('This is the appointment $index'),
          height: 90,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
            boxShadow: [
              BoxShadow(color: Colors.green, spreadRadius: 3),
            ],
          ),
        )
      ],
    );

// Widget meetadoctor = DefaultTextStyle.merge(
//   child: Container(
//     color: Color.fromARGB(255, 220, 237, 249),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Column(
//           children: [
//           const Text('Meet a doctor now!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//           const Text('Just a few simple steps', style: TextStyle(fontSize: 11)),
//           ],
//         ),
//         Container(
//           width: 150,
//           height: 150,
//           decoration : BoxDecoration(
//             image: DecorationImage(
//               image: const NetworkImage('https://cdn.imgbin.com/16/14/21/imgbin-physician-hospital-medicine-doctor-dentist-doctor-MvjeZ7XWhJkkxsq5WJJQFWNcK.jpg'),
//             fit: BoxFit.cover,
//             ),
//           ),

//           ),
//       ],
//     ),
//   ),
// );
