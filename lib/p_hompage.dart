import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipe_widget/swipe_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main page',
      theme: ThemeData(
        // This is the theme of the application.
      ),
      home: const p_HomePage(title: 'Flutter Patient Home Page'),
    );
  }
}

class p_HomePage extends StatefulWidget {
  const p_HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  
  State<p_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<p_HomePage> {


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   //title: Text(widget.title),
      // ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            heading(width, height),
            // Todo: Change to another news
            news(width, height),
            services(width, height),
            meetadoctor(width, height),
            upcomingappointmentlist(width, height),
            home(width, height),
          ],
        ),
    );
  }
}

String getCurrentDate() {
    var date = DateTime.now();
    var formattedDate = DateFormat('EEEE, d MMM yyyy').format(date);
    return formattedDate.toString();
  }

String greetingMessage() {
  var timeNow = DateTime.now().hour;
  if (timeNow <= 11.59) {
    return 'Good Morning!';
  } else if (timeNow > 12 && timeNow <= 16) {
    return 'Good Afternoon!';
  } else if (timeNow > 16 && timeNow < 20) {
    return 'Good Evening!';
  } else {
    return 'Good Night!';
  }
}

Widget heading(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Container(
    //color: Color.fromARGB(255, 220, 237, 249),
    margin: const EdgeInsets.only(left: 12),
    height: globalheight*0.07,
    width: globalwidth,
    child: Align(
      alignment: Alignment.centerLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getCurrentDate(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            Text(greetingMessage(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ]
        ),
      ),
    ),
  ),
);

// Todo: Change to another news
Widget news(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: SwipeWidget(
    angle: 0,
    child: Container(
      width: globalwidth*0.9,
      height: globalheight*0.15,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 220, 237, 249),
      ),      
    ),
    // Change to another page
    onSwipeRight: () => news(globalwidth, globalheight),
    ),
);

Widget services(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Container(
    child: Column(
      children: [
        Align(alignment: Alignment.centerLeft,
          child: FittedBox(
              fit: BoxFit.scaleDown,
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              height: globalheight*0.03,
              width: globalwidth,
              child:
                const Text('Services:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 12, right: 12),
          height: globalheight*0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [   
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                    height: globalheight*0.1,
                    width: globalheight*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 220, 237, 249),
                      ),
                    // Todo: Change the icon
                    child: const Icon(Icons.home,color: Color.fromARGB(255, 28, 107, 164)),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                    height: globalheight*0.1,
                    width: globalheight*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 250, 240, 219),
                      ),
                          child: const Icon(Icons.medical_services_rounded,color: Color.fromARGB(255, 224, 159, 31)),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                    height: globalheight*0.1,
                    width: globalheight*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(38, 247, 56, 89),
                      ),
                          child: const Icon(Icons.chat,color: Color.fromARGB(255, 247, 56, 89)),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                    height: globalheight*0.1,
                    width: globalheight*0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 242, 227, 233),
                      ),
                          child: const Icon(Icons.coronavirus,color: Color.fromARGB(255, 157, 76, 108)),
                ),
              ),
            ]
          ),
        ),
      ],
    ),
  ),
);

Widget meetadoctor(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Container(
    padding: const EdgeInsets.all(10),
    height: globalheight*0.2,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    color: Color.fromARGB(255, 220, 237, 249),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [           
        Container(
          width: globalwidth*0.4,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: [
              const Text('Meet a doctor now!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              const Text('Just a few simple steps', style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
        Container(
          width: globalwidth*0.4,
          height: globalheight*0.2,
          decoration : BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: const NetworkImage('https://cdn.imgbin.com/16/14/21/imgbin-physician-hospital-medicine-doctor-dentist-doctor-MvjeZ7XWhJkkxsq5WJJQFWNcK.jpg'),
            fit: BoxFit.cover,
            ),
          ),
              
          ),
      ],
    ),
  ),
);

Widget upcomingappointmentlist(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Container(
    child: Column(
      children: [
        Align(alignment: Alignment.centerLeft,
          child: FittedBox(
              fit: BoxFit.scaleDown,
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              height: globalheight*0.03,
              width: globalwidth,
              child:
                const Text('Upcoming Appointments:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        SizedBox(
          height: globalheight*0.2,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            // The number of itemCount depends on the number of appointment
            itemCount : 5,
            separatorBuilder:  (context, index) {
              return const SizedBox(width: 20);
            },
            itemBuilder: (context, index) {
              return upcomingappointment(index, globalheight);
            },
          ),
        ),
        // i is the number of appointment, 3 is for testing only
      ],
    ),
  ),
);

Widget upcomingappointment(int index, double globalheight) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Container(
      child: Text ('This is the appointment $index'),
      height: globalheight*0.15,
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

Widget home(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Container(
    width: globalwidth,
    height: globalheight*0.07,
    color : Color.fromARGB(255, 217, 217, 217),
    child : DefaultTextStyle(
      style : TextStyle(color : Color.fromARGB(255, 123, 141, 158)),
      child : Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [   
          FittedBox(
            fit: BoxFit.scaleDown,        
            child: Column(
              children: [
                Icon(Icons.home,color: Color.fromARGB(255, 123, 141, 158)),
                const Text('Home'),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: [
                Icon(Icons.calendar_month,color: Color.fromARGB(255, 123, 141, 158)),
                const Text('Calendar'),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: [
                Icon(Icons.message,color: Color.fromARGB(255, 123, 141, 158)),
                const Text('Message'),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: [
                Icon(Icons.person,color: Color.fromARGB(255, 123, 141, 158)),
                const Text('My Profile'),
              ],
            ),
          ),
        ]
      ),
    ),
  ),
);