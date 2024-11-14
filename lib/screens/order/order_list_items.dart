import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:ticket_resell/api/global_variables/user_manage.dart';
import '../../api/response/transaction.dart';
import '../../styles&text&sizes/colors.dart';
import '../../styles&text&sizes/sizes.dart';
import '../../widgets/helper_functions.dart';
import '../../widgets/rounded_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class TOrderListItems extends StatefulWidget {
  const TOrderListItems({super.key});

  @override
  _TOrderListItemsState createState() => _TOrderListItemsState();
}

class _TOrderListItemsState extends State<TOrderListItems> {
  late Future<List<Transaction>> transactions;

  Future<List<Transaction>> fetchTransactions() async {
    final response = await http.get(
      Uri.parse('https://ticketresellapi-ckhsduaycsfccjek.eastasia-01.azurewebsites.net/api/Transaction/get-all-transaction?userId=4'),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        }
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['content'];
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  @override
  void initState() {
    super.initState();
    transactions = fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return FutureBuilder<List<Transaction>>(
      future: transactions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No transactions found.'));
        }

        final transactions = snapshot.data!;

        return ListView.separated(
          shrinkWrap: true,
          itemCount: transactions.length,
          separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final transaction = transactions[index];

            return TRoundedContainer(
              showBorder: true,
              padding: const EdgeInsets.all(TSizes.md),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Iconsax.ship),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.status,
                              style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.primary, fontWeightDelta: 1),
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    transaction.platformFee?.name ?? 'Unknown',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ),
                                Text(
                                  transaction.price.toString(),
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    color: TColors.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Iconsax.tag),
                            const SizedBox(width: TSizes.spaceBtwItems),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order', style: Theme.of(context).textTheme.labelMedium),
                                  Text('[#${transaction.orderCode}]', style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Iconsax.calendar),
                            const SizedBox(width: TSizes.spaceBtwItems),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date', style: Theme.of(context).textTheme.labelMedium),
                                  // Text(transaction.transactionDate, style: Theme.of(context).textTheme.titleMedium),

                                  Text(
                                    DateFormat('dd/MM/yyyy HH:mm').format(transaction.transactionDate), // Format the DateTime
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwSections),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Iconsax.activity),
                            const SizedBox(width: TSizes.spaceBtwItems),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Slots', style: Theme.of(context).textTheme.labelMedium),
                                  Text(transaction.platformFee?.quantity.toString() ?? '0', style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
