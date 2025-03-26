import 'package:appinterface/Todo/todo_list.dart';
import 'package:appinterface/global_bloc.dart';
import 'package:appinterface/medicine_details/medicine_details.dart';
import 'package:appinterface/models/medicine.dart';
import 'package:appinterface/page1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg1.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 120.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Be on Time.\nYour pill awaits',
                    style: GoogleFonts.poppins(
                      fontSize: 39,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //number of saved data
          StreamBuilder<List<Medicine>>(
              stream: globalBloc.medicineList$,
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 300.0),
                  child: Text(
                    !snapshot.hasData ? '0' : snapshot.data!.length.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 35,
                    ),
                  ),
                );
              }),
          // Add BottomContainer to Stack
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.0), // Adjust bottom spacing
              child: BottomContainer(),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TodoList()));
              },
              backgroundColor: Colors.purple,
              child: Icon(
                Icons.edit_note_rounded,
                size: 40,
              ),
            ),
            Expanded(child: Container()),
            InkResponse(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Page1(),
                  ),
                );
              },
              child: Card(
                color: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.all(10.0), // Adjusted padding for better size
                  child: Icon(
                    Icons.add_outlined,
                    size: 50,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // return const Center(
    //   child: Text(
    //     'No Medicine',
    //     style: TextStyle(
    //       color: Colors.white70, // Red color remains for visibility
    //       fontSize: 39, // Increased size for better readability
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    return StreamBuilder(
      stream: globalBloc.medicineList$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          //if data is saved
          return Container();
        } else if (snapshot.data!.isEmpty) {
          return Center(
            child:
                Text('No Medicine', style: GoogleFonts.poppins(fontSize: 20)),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 300.0),
            child: Align(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10, // Space between rows
                  crossAxisSpacing: 10, // Space between columns
                  childAspectRatio: 1, // Square shape
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return MedicineCard(medicine: snapshot.data![index]);
                },
              ),
            ),
          );
        }
      },
    );
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({super.key, required this.medicine});
  final Medicine medicine;
  //for getting the current details of the saved items

  //type icon

  Hero makeIcon(double size) {
    //here is the icon issue
    if (medicine.medicineType == 'Bottle') {
      return Hero(
        tag: (medicine.medicineName ?? 'Unknown') +
            (medicine.medicineType ?? 'Unknown'),
        child: SvgPicture.asset(
          'assets/icons/bottle.svg',
          color: Colors.white70,
          height: 50.0,
        ),
      );
    } else if (medicine.medicineType == 'Pill') {
      return Hero(
        tag: (medicine.medicineName ?? 'Unknown') +
            (medicine.medicineType ?? 'Unknown'),
        child: SvgPicture.asset(
          'assets/icons/pill.svg',
          color: Colors.white70,
          height: 50.0,
        ),
      );
    } else if (medicine.medicineType == 'Insulin') {
      return Hero(
        tag: (medicine.medicineName ?? 'Unknown') +
            (medicine.medicineType ?? 'Unknown'),
        child: SvgPicture.asset(
          'assets/icons/syringe.svg',
          color: Colors.white70,
          height: 50.0,
        ),
      );
    } else if (medicine.medicineType == 'Tablet') {
      return Hero(
        tag: (medicine.medicineName ?? 'Unknown') +
            (medicine.medicineType ?? 'Unknown'),
        child: SvgPicture.asset(
          'assets/icons/tablets.svg',
          color: Colors.white70,
          height: 50.0,
        ),
      );
    }
    //incase of no medicine type icon selection
    return Hero(
      tag: (medicine.medicineName ?? 'Unknown') +
          (medicine.medicineType ?? 'Unknown'),
      child: Icon(
        Icons.error,
        color: Colors.white70,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.grey,
      onTap: () {
        //go to details

        Navigator.of(context).push(
          PageRouteBuilder<void>(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, Widget? child) {
                  return Opacity(
                    opacity: animation.value,
                    child: MedicineDetails(medicine),
                  );
                },
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
          padding:
              EdgeInsets.only(left: 7.0, right: 5.0, top: 4.0, bottom: 4.0),
          margin: EdgeInsets.all(7.7),
          decoration: BoxDecoration(
              color: Colors.purple, borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // call the function here icon type
              //later finish
              makeIcon(30.0),
              const Spacer(),
              //animation incoming
              Hero(
                tag: medicine.medicineName!,
                child: Text(medicine.medicineName!,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w700)),
              ),
              SizedBox(
                height: 0.5,
              ),
              //time will be linked
              Text(
                  medicine.interval == 1
                      ? "Every ${medicine.interval} hour"
                      : "Every ${medicine.interval} hour",
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 17,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500)),
            ],
          )),
    );
  }
}
