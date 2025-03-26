import 'dart:math';

import 'package:appinterface/common/convert_time.dart';
import 'package:appinterface/global_bloc.dart';
import 'package:appinterface/models/errors.dart';
import 'package:appinterface/models/medicine.dart';
import 'package:appinterface/models/medicine_type.dart';
import 'package:appinterface/new_entry_bloc.dart';
import 'package:appinterface/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late TextEditingController nameController;
  late TextEditingController dosageController;

  late NewEntryBloc _newEntryBloc;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    super.dispose();
    _newEntryBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _newEntryBloc = NewEntryBloc();
    initializeErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFD70ADC),
        title: const Text(
          'Add new',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: Provider<NewEntryBloc>.value(
        value: _newEntryBloc,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PanelTitle(title: 'Medicine name', isRequired: true),
            TextFormField(
              maxLength: null,
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(width: 0.7),
                ),
              ),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.purple),
            ),
            const PanelTitle(title: 'Dosage in Mg', isRequired: false),
            TextFormField(
              maxLength: null,
              controller: dosageController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(width: 0.7),
                ),
              ),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.purple),
            ),
            const SizedBox(height: 15.0),
            const PanelTitle(title: 'Medicine Type', isRequired: false),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: StreamBuilder<MedicineType>(
                  stream: _newEntryBloc
                      .selectedMedicineType, // Replace with the actual stream
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MedicineTypeColumn(
                            medicineType: MedicineType.Bottle,
                            name: "Bottle",
                            svgPath: 'assets/icons/bottle.svg',
                            isSelected: snapshot.data == MedicineType.Bottle
                                ? true
                                : false // Fixed condition
                            ),
                        MedicineTypeColumn(
                            medicineType: MedicineType.Pill,
                            name: "Pill",
                            svgPath: 'assets/icons/pill.svg',
                            isSelected: snapshot.data == MedicineType.Pill
                                ? true
                                : false // Fixed condition
                            ),
                        MedicineTypeColumn(
                            medicineType: MedicineType.Tablets,
                            name: "Tablets",
                            svgPath: 'assets/icons/tablets.svg',
                            isSelected: snapshot.data == MedicineType.Tablets
                                ? true
                                : false // Fixed condition
                            ),
                        MedicineTypeColumn(
                            medicineType: MedicineType.Syringe,
                            name: "Insulin",
                            svgPath: 'assets/icons/syringe.svg',
                            isSelected: snapshot.data == MedicineType.Syringe
                                ? true
                                : false // Fixed condition
                            ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const PanelTitle(title: 'Interval Selection', isRequired: true),
            const IntervalSelection(),
            const PanelTitle(title: 'Starting time', isRequired: true),
            const SelectTime(),
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.only(right: 20.0, left: 20.0),
              child: SizedBox(
                width: 380.0,
                height: 45.0,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: const StadiumBorder()),
                  child: Center(
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    //add medicine side
                    //redirect to main
                    String? medicineName;
                    int? dosage;
                    //medicineName
                    if (nameController.text == "") {
                      _newEntryBloc.submitError(EntryError.nameNull);
                      return;
                    }
                    if (nameController.text != "") {
                      medicineName = nameController.text;
                    }
                    //dosage
                    if (dosageController.text == "") {
                      dosage = 0;
                    }
                    if (dosageController.text != "") {
                      dosage = int.parse(dosageController.text);
                    }
                    for (var medicine in globalBloc.medicineList$!.value) {
                      if (medicineName == medicine.medicineName) {
                        _newEntryBloc.submitError(EntryError.nameDuplicate);
                        return;
                      }
                    }
                    if (_newEntryBloc.selectedIntervals!.value == 0) {
                      _newEntryBloc.submitError(EntryError.interval);
                      return;
                    }
                    if (_newEntryBloc.selectedTimeOfDay$!.value == 'None') {
                      _newEntryBloc.submitError(EntryError.startTime);
                      return;
                    }

                    String medicineType = _newEntryBloc
                        .selectedMedicineType!.value
                        .toString()
                        .substring(13);

                    int interval = _newEntryBloc.selectedIntervals!.value;
                    String startTime = _newEntryBloc.selectedTimeOfDay$!.value;

                    List<int> intIDs =
                        makeIDs(24 / _newEntryBloc.selectedIntervals!.value);
                    List<String> notificationIDs =
                        intIDs.map((i) => i.toString()).toList();

                    Medicine newEntryMedicine = Medicine(
                      notificationIDs: notificationIDs,
                      medicineName: medicineName,
                      dosage: dosage,
                      medicineType: medicineType,
                      interval: interval,
                      startTime: startTime,
                    );

                    //update medicine list via global bloc
                    globalBloc.updateMedicineList(newEntryMedicine);

                    //schedule notification

                    //got to success screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SuccessScreen()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initializeErrorListen() {
    _newEntryBloc.errorState$!.listen((EntryError error) {
      switch (error) {
        case EntryError.nameNull:
          displayError("Please enter the medicine's name");
          break;
        case EntryError.nameDuplicate:
          displayError("Medicine name already exist");
          break;
        case EntryError.dosage:
          displayError("Please enter the dosage required");
          break;
        case EntryError.interval:
          displayError("Please select the reminder's interval");
          break;
        case EntryError.startTime:
          displayError("Please select the reminder's starting time");
          break;
        default:
      }
    });
  }

  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.deepPurpleAccent,
        content: Text(error),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }
}

class SelectTime extends StatefulWidget {
  const SelectTime({super.key});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay> _selectedTime() async {
    final NewEntryBloc newEntryBloc =
        Provider.of<NewEntryBloc>(context, listen: false);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.purple,
            hintColor: Colors.purple,
            dialogBackgroundColor: Colors.black,
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.black,
              hourMinuteColor: Colors.purple,
              dialHandColor: Colors.purple,
              dialBackgroundColor: Colors.white10,
              hourMinuteTextColor: Colors.white,
              dayPeriodColor: Colors.purple,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
        newEntryBloc.updateTime(convertTime(_time.hour.toString()) +
            convertTime(_time.minute.toString()));
      });
    }
    return picked!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.0,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.purple, shape: const StadiumBorder()),
            onPressed: () {
              _selectedTime();
            },
            child: Center(
              child: Text(
                _clicked == false
                    ? "Select Time"
                    : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )),
      ),
    );
  }
}

class IntervalSelection extends StatefulWidget {
  const IntervalSelection({super.key});

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [1, 3, 6, 12];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Text(
              'Remind me every',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20), // Reduced font size slightly
            ),
          ),
          const SizedBox(width: 20), // Added spacing to prevent squeezing
          DropdownButton<int>(
            iconEnabledColor: Colors.white,
            dropdownColor: Colors.purple,
            hint: _selected == 0
                ? Text(
                    'Select an interval',
                    style: TextStyle(
                        color: Colors.purple, fontSize: 20), // Adjusted size
                  )
                : null,
            elevation: 4,
            value: _selected == 0 ? null : _selected,
            items: _intervals.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  value.toString(),
                  style: TextStyle(
                      color: Colors.white, fontSize: 20), // Adjusted size
                ),
              );
            }).toList(),
            onChanged: (newVal) {
              setState(() {
                _selected = newVal!;
                newEntryBloc.updateInterval(newVal);
              });
            },
          ),
          Text(
            _selected == 1 ? "hour" : "hours",
            style: TextStyle(color: Colors.white, fontSize: 20),
          )
        ],
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return const Placeholder();
}

class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn({
    Key? key,
    required this.medicineType,
    required this.name,
    required this.svgPath,
    required this.isSelected,
  }) : super(key: key);

  final MedicineType medicineType;
  final String name;
  final String svgPath;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return GestureDetector(
      onTap: () {
        newEntryBloc.updateSelectedMedicine(medicineType);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Container(
              width: 100.0,
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Color(0xFFD70ADC),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  svgPath,
                  fit: BoxFit.contain,
                  color: Color(0xFFFFFFFF), // Fixed color syntax
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 14.0),
            child: Container(
              width: 80.0,
              height: 28.0,
              decoration: BoxDecoration(
                color: Color(0xFFD70ADC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle({Key? key, required this.title, required this.isRequired})
      : super(key: key);
  final String title;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: title,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text: isRequired ? " *" : "",
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
