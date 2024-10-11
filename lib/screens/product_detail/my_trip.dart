// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:tripwonder/widgets/appbar.dart';
// //
// // import '../../widgets/t_circular_icon.dart';
// //
// // class MyTripScreen extends StatelessWidget {
// //   const MyTripScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: TAppBar(
// //         title:
// //         Text('My Trip', style: Theme.of(context).textTheme.headlineMedium), showBackArrow: true,
// //         actions: [
// //           TCircularIcon(
// //             icon: Iconsax.add,
// //             onPressed: () {},
// //           )
// //         ],
// //       ),
// //
// //
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:tripwonder/widgets/appbar.dart';
// import '../../widgets/t_circular_icon.dart';
//
// class MyTripScreen extends StatelessWidget {
//   const MyTripScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final tripController = Get.put(TripController());
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: TAppBar(
//         title: Text('My Trip', style: Theme.of(context).textTheme.headlineMedium),
//         showBackArrow: true,
//         actions: [
//           TCircularIcon(
//             icon: Iconsax.add,
//             onPressed: () {},
//           ),
//         ],
//       ),
//
//       /// Body with list of days and schedule display
//       body:
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 16),
//
//           /// Horizontal list of days
//           SizedBox(
//             height: 45,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: tripController.tripDays.length,
//               itemBuilder: (context, index) {
//                 final day = tripController.tripDays[index];
//                 return GestureDetector(
//                   onTap: () => tripController.selectDay(index), // Update selected day
//                   child: Obx(() => Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     margin: const EdgeInsets.symmetric(horizontal: 8),
//                     decoration: BoxDecoration(
//                       color: tripController.selectedDay.value == index
//                           ? Color(0xFF55B97D)
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(30),
//                       border: Border.all(color: Color(0xFFC7C5CC), width: 2), // Add border here
//                     ),
//                     child: Center(
//                       child: Text(
//                         day,
//                         style: TextStyle(
//                           color: tripController.selectedDay.value == index
//                               ? Colors.white
//                               : Colors.black,
//                           fontWeight: FontWeight.normal,
//                         ),
//                       ),
//                     ),
//                   )),
//                 );
//               },
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           /// Schedule display based on selected day
//           Expanded(
//             child: Obx(() {
//               final selectedDay = tripController.selectedDay.value;
//               final schedule = tripController.schedules[selectedDay];
//               return ListView.builder(
//                 itemCount: schedule.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(schedule[index]),
//                     leading: Icon(Icons.schedule, color: Colors.blueAccent),
//                   );
//                 },
//               );
//             }),
//           ),
//
//
//         ],
//       ),
//     );
//   }
// }
//
// class TripController extends GetxController {
//   var selectedDay = 0.obs;
//
//   /// List of trip days
//   List<String> tripDays = [
//     "July 2nd",
//     "July 3rd",
//     "July 4th",
//     "July 5th",
//     "July 6th",
//     "July 7th",
//   ];
//
//   /// Sample schedules for each day
//   List<List<String>> schedules = [
//     ["Visit Eiffel Tower", "Lunch at local cafe", "River cruise in the evening"],
//     ["Day trip to Versailles", "Dinner at Le Jules Verne"],
//     ["Explore Louvre Museum", "Lunch at Louvre cafe", "Evening at Montmartre"],
//     ["Shopping at Champs-Élysées", "Relaxing at hotel", "Farewell dinner"],
//     ["Shopping at Champs-Élysées", "Relaxing at hotel", "Farewell dinner"],
//     ["Shopping at Champs-Élysées", "Relaxing at hotel", "Farewell dinner"],
//   ];
//
//   /// Update selected day
//   void selectDay(int index) {
//     selectedDay.value = index;
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../styles&text&sizes/image_strings.dart';
import '../../widgets/appbar.dart';
import '../../widgets/my_trip_card.dart';
import '../../widgets/t_circular_icon.dart';

class MyTripScreen extends StatefulWidget {
  const MyTripScreen({super.key});

  @override
  State<MyTripScreen> createState() => _MyTripScreenState();
}

class _MyTripScreenState extends State<MyTripScreen> {
  // This is the selected day
  int selectedDay = 0;

  // List of available days for the trip
  final List<String> days = ["July 2nd", "July 3rd", "July 4th"];

  // Method to change the displayed day content
  void changeDay(int index) {
    setState(() {
      selectedDay = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TAppBar(
        title: Text('My Trip', style: Theme.of(context).textTheme.headlineMedium),
        showBackArrow: true,
        actions: [
          TCircularIcon(
            icon: Iconsax.add,
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Selector
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => changeDay(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: selectedDay == index ? Colors.blueAccent : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        days[index],
                        style: TextStyle(
                          color: selectedDay == index ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mount Fuji',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fuji-Hakone-Izu National Park',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'May 28 - May 30, 2024',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'A Couple - Luxury',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildActionButton(
                      context,
                      icon: Iconsax.edit,
                      label: 'Edit Address',
                      onPressed: () {
                        // Add your logic for Edit Address here
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildActionButton(
                      context,
                      icon: Iconsax.note_text,
                      label: 'Add Note',
                      onPressed: () {
                        // Add your logic for Add Note here
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
              ],
            ),
          ),
          // Display the content for the selected day
          Expanded(
            child: _buildDayContent(selectedDay),
          ),
        ],
      ),
    );
  }

  // This method returns the content for the selected day
  // Widget _buildDayContent(int dayIndex) {
  //   switch (dayIndex) {
  //     case 0: // July 2nd
  //       return
  //         const MyTripCard(); // Your custom card widget
  //     case 1: // July 3rd
  //       return Center(
  //         child: Text('Schedule for July 3rd'),
  //       );
  //     case 2: // July 4th
  //       return Center(
  //         child: Text('Schedule for July 4th'),
  //       );
  //     default:
  //       return const SizedBox.shrink();
  //   }
  // }

  Widget _buildDayContent(int dayIndex) {
    switch (dayIndex) {
      case 0: // July 2nd
      // Sử dụng ListView để hiển thị nhiều thẻ MyTripCard
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: const [
             MyTripCard(cafeName: 'Cafe de I’ambre', cafeImage: TImages.canada, rating: 4.9, time: '9:00 - 10:00 AM', price: 30.0, reviewCount: 230,), // Thẻ đầu tiên
            // MyTripCard(), // Thẻ thứ hai
            // MyTripCard(), // Thẻ thứ ba
            // Có thể thêm nhiều thẻ hơn tùy ý
          ],
        );
      case 1: // July 3rd
        return Center(
          child: Text('Schedule for July 3rd'),
        );
      case 2: // July 4th
        return Center(
          child: Text('Schedule for July 4th'),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
