import 'package:appinterface/firstpage.dart';
import 'package:appinterface/global_bloc.dart';
import 'package:appinterface/models/medicine.dart';
import 'package:appinterface/page1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails(this.medicine, {super.key});
  final Medicine? medicine;

  Hero makeIcon(double size) {
    String tag = (medicine?.medicineName ?? 'Unknown') +
        (medicine?.medicineType ?? 'Unknown');
    String assetPath = 'assets/icons/bottle.svg';

    switch (medicine?.medicineType) {
      case 'Pill':
        assetPath = 'assets/icons/pill.svg';
        break;
      case 'Insulin':
        assetPath = 'assets/icons/syringe.svg';
        break;
      case 'Tablet':
        assetPath = 'assets/icons/tablets.svg';
        break;
    }

    return Hero(
      tag: tag,
      child: SvgPicture.asset(
        assetPath,
        color: Colors.white70,
        height: size,
      ),
    );
  }

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            MainSection(medicine: widget.medicine, icon: widget.makeIcon(80)),
            ExtendedSection(medicine: widget.medicine),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 400.0,
                height: 90.0,
                child: TextButton(
                  onPressed: () {
                    if (widget.medicine != null) {
                      openAlertBox(context, _globalBloc);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//delete a reminder
  openAlertBox(BuildContext context, GlobalBloc _globalBloc) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0))),
          contentPadding: const EdgeInsets.only(top: 1.0),
          title: Text(
            'Delete This Reminder?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.purple,
              fontSize: 25,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                //navigator to be fixed
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Page1(),
                    ));
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                    color: Colors.deepPurpleAccent, fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                if (widget.medicine != null) {
                  _globalBloc.removeMedicine(widget.medicine!);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }
              },
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                    color: Colors.deepPurpleAccent, fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MainSection extends StatelessWidget {
  const MainSection({super.key, required this.medicine, required this.icon});
  final Medicine? medicine;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        icon,
        const SizedBox(width: 5.0),
        Column(
          children: [
            Hero(
              tag: medicine?.medicineName ?? 'Unknown',
              child: Material(
                color: Colors.transparent,
                child: MainInfoTab(
                  fieldTitle: 'Medicine Name',
                  fieldInfo: medicine?.medicineName ?? 'Unknown',
                ),
              ),
            ),
            MainInfoTab(
              fieldTitle: 'Dosage',
              fieldInfo: (medicine?.dosage ?? 0) == 0
                  ? 'Not Specified'
                  : "${medicine?.dosage} mg",
            ),
          ],
        )
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  const MainInfoTab(
      {super.key, required this.fieldTitle, required this.fieldInfo});
  final String fieldTitle;
  final String fieldInfo;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190.0,
      height: 90.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldTitle,
              style: GoogleFonts.poppins(
                  color: Colors.deepPurpleAccent, fontSize: 20),
            ),
            const SizedBox(height: 3.0),
            Text(
              fieldInfo,
              style: GoogleFonts.poppins(
                  color: Colors.purpleAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({super.key, this.medicine});
  final Medicine? medicine;
  @override
  Widget build(BuildContext context) {
    if (medicine == null) {
      return const Center(
        child: Text(
          'No medicine details available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
          fieldTitle: 'Medicine Type',
          fieldInfo: medicine!.medicineType ?? 'Not Specified',
        ),
        ExtendedInfoTab(
          fieldTitle: 'Dose Intervals',
          fieldInfo: medicine!.interval != null
              ? 'Every ${medicine!.interval} hours  |  ${medicine!.interval == 24 ? "One time a day" : "${(24 / medicine!.interval!).floor()} times a day"}'
              : 'Not Specified',
        ),
        ExtendedInfoTab(
          fieldTitle: 'Start Time',
          fieldInfo: (medicine!.startTime != null &&
                  medicine!.startTime!.length >= 4)
              ? '${medicine!.startTime![0]}${medicine!.startTime![1]}:${medicine!.startTime![2]}${medicine!.startTime![3]}'
              : 'Not Specified',
        ),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  const ExtendedInfoTab(
      {Key? key, required this.fieldTitle, required this.fieldInfo})
      : super(key: key);
  final String fieldTitle;
  final String fieldInfo;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 1.0),
            child: Text(
              fieldTitle,
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
          Text(
            fieldInfo,
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
