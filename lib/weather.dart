import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/inforamtion_card.dart';
import 'package:weather_app/weather_card.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/api_key.dart';

class Weatherwidget extends StatefulWidget {
  const Weatherwidget({super.key, required});

  @override
  State<Weatherwidget> createState() => _WeatherwidgetState();
}

class _WeatherwidgetState extends State<Weatherwidget> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    String city = 'Beirut';
    String country = 'leb';

    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city,$country&APPID=$api_key',
        ),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "Something went wrong";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    getCurrentWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    getCurrentWeather();
                  });
                }),
          ),
        ],
      ),
      body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Text(snapshot.hasError.toString());
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('There is no data. Please come back later.'),
              );
            }

            final data = snapshot.data;
            final currentData = data!['list'][0];
            final currentTemp = currentData['main']['temp'];
            final currentSky = currentData['weather'][0]['main'];
            final currentPressure = currentData['main']['pressure'];
            final currentHumidity = currentData['main']['humidity'];
            final currentWind = currentData['wind']['speed'] * 3.6;

            double tempInt = currentTemp - 273.15;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // main card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      color: const Color.fromARGB(129, 33, 33, 33),
                      shadowColor: const Color.fromARGB(255, 0, 0, 0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      surfaceTintColor:
                          const Color.fromARGB(255, 255, 255, 255),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '${tempInt.toStringAsFixed(2)} °C',
                                style: const TextStyle(
                                    fontSize: 32,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 70,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                '$currentSky',
                                style: const TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                            child: Text(
                              'Weather Forcast',
                              style: TextStyle(fontSize: 25),
                            ),
                          )),
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     children: [
                      //       for (int i = 1; i < 6; i++)
                      //         CardWidget(
                      //           time: data['list'][i]['dt'].toString(),
                      //           icons: data['list'][i]['weather'][0]['main'] ==
                      //                       'Clouds' ||
                      //                   data['list'][i]['weather'][0]['main'] ==
                      //                       'Rain'
                      //               ? Icons.cloud
                      //               : Icons.sunny,
                      //           temp:
                      //               '${(data['list'][i]['main']['temp'] - 273.15).toStringAsFixed(2)} °C',
                      //         ),
                      //     ],
                      //   ),
                      // )
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              final currentForcast = data['list'][index + 1];
                              final currentSky =
                                  currentForcast['weather'][0]['main'];
                              final time = DateTime.parse(
                                  currentForcast['dt_txt'].toString());
                              return CardWidget(
                                time: DateFormat.j().format(time),
                                icons: currentSky == 'Clouds' ||
                                        currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                temp:
                                    '${(currentForcast['main']['temp'] - 273.15).toStringAsFixed(2)} °C',
                              );
                            }),
                      )
                    ],
                  ),
                  // last card
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Additional Information',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfo(
                        icons: Icons.water_drop,
                        label: 'Humidity',
                        value: '${currentHumidity.toStringAsFixed(0)} %',
                      ),
                      AdditionalInfo(
                        icons: Icons.air,
                        label: 'Wind speed',
                        value: '${currentWind.toStringAsFixed(1)} km/h',
                      ),
                      AdditionalInfo(
                        icons: Icons.beach_access,
                        label: 'pressure',
                        value: '${currentPressure.toStringAsFixed(0)} HPA',
                      )
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
