import 'package:flutter/material.dart';
import 'package:simple_login/helper/firebase_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widget/loading_screen.dart';


class ChartData {
  final String lesion;
  final double acc;

  ChartData(this.lesion, this.acc);
}

class viewSurvey extends StatefulWidget {
  String date;
  String time;
  String fullname;
  String PID;

  viewSurvey(this.date, this.time, this.fullname, this.PID, {super.key});

  @override
  State<viewSurvey> createState() => _viewSurveyState(this.date, this.time, this.fullname, this.PID);
}

class _viewSurveyState extends State<viewSurvey> {

  bool startDone = false;
  String date;
  String time;
  String fullname;
  String PID;
  Map<String, dynamic>? results;
  String? imgURL;

  _viewSurveyState(this.date, this.time, this.fullname, this.PID);

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    return !startDone
        ? LoadingScreen()
        : Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          heading(width, height),
          detaillist(width, height),

        ],
      ),
    );
  }

  bool mdshow = false;
 String diagnosis = '';
 String medicine= '';
 String notes= '';
 String prediction= '';
 String probability= '';


  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    String uid = getUID();
    Map<String, dynamic>? data =
    await readFromServer('doctor/$uid/appointment/$date/survey/$time');
    print(data);
    if(data == null) return;
    var survey = data[time];
    print(survey);
    String url = '';
    if(survey['imgURL'] != null){
      url = await loadStorageUrl(survey['imgURL']);
    }
    setState(() {
        diagnosis = survey['diagnosis'];
        medicine = survey['medicine'];
        notes = survey['extra_notes'];
        results = survey['prediction'];
        imgURL = url == ''? null : url;
      startDone = true;
    });
  }

  Widget heading(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: Stack(
          children: [
            Container(
              width: globalwidth,
              height: globalheight * 0.31,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            Container(
              width: globalwidth,
              height: globalheight * 0.25,
              color: const Color.fromARGB(255, 28, 107, 164),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, top: 20),
                        height: globalheight * 0.06,
                        width: globalheight * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: const Icon(Icons.arrow_back_rounded),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Patient Symptom form',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  margin: const EdgeInsets.only(left: 15, top: 10),
                  height: globalheight * 0.12,
                  width: globalwidth * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 220, 237, 249),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0),
                        blurRadius: 0.5,
                        offset: Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        width: globalheight * 0.1,
                        height: globalheight * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.cover,
                          child: Icon(Icons.person,
                              color: Color.fromARGB(255, 123, 141, 158)),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Text('Patient: $fullname',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget detaillist(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child:
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:
            Column(
              children: [
                  Container(
                      margin: const EdgeInsets.only(left: 12, bottom: 12),
                      width: globalwidth,
                      // height: globalheight * 0.3,
                      // child: SingleChildScrollView(
                        // scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Self Estimated Symptoms:',
                                style: TextStyle(fontSize: 18)),
                            Text(diagnosis,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const Text('Medication:',
                                style: TextStyle(fontSize: 18)),
                            Text(medicine,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const Text('Notes:',
                                style: TextStyle(fontSize: 18)),
                            Text(notes,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const Text('Skin Cancer Prediction:',
                                style: TextStyle(fontSize: 18)),
                            // Text(prediction + " " + probability,
                            //     style: const TextStyle(
                            //         fontSize: 16, fontWeight: FontWeight.bold)),
                            if (imgURL != null)
                              Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  child: Image.network(imgURL!)),
                            if (results != null)
                              SfCartesianChart(
                                title: ChartTitle(text: 'Likelyhood by Skin Lesion'),
                                legend: Legend(isVisible: true),
                                series: <ChartSeries>[
                                  BarSeries<ChartData, String>(
                                    name: 'Acc',
                                    dataSource: <ChartData>[
                                      ChartData('Acti(akiec)', double.parse(results?['0']) ?? 0),
                                      ChartData('Basal(bcc)', double.parse(results?['1']) ?? 0),
                                      ChartData('Benign(bkl)', double.parse(results?['2']) ?? 0),
                                      ChartData('Derm(df)', double.parse(results?['3']) ?? 0),
                                      ChartData('Mel(mel)', double.parse(results?['4']) ?? 0),
                                      ChartData('Mel_nevi(nv)', double.parse(results?['5']) ?? 0),
                                      ChartData('Vas(vasc)', double.parse(results?['6']) ?? 0),
                                      ChartData('Unknown', double.parse(results?['7']) ?? 0),
                                    ],
                                    xValueMapper: (ChartData acc, _) => acc.lesion,
                                    yValueMapper: (ChartData acc, _) => acc.acc,
                                    dataLabelSettings: DataLabelSettings(isVisible: true),
                                  ),
                                ],
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis: NumericAxis(
                                  title: AxisTitle(text: 'Probability'),
                                  maximum: 1,
                                ),
                              ),
                          ],
                        ),
                      // ),
                    ),



              ],
            ),
        ),
      );
  
}