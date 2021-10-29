import 'package:flutter/material.dart';
import 'package:isura_system/widget/theme.dart';

class TaxBenefits extends StatefulWidget {
  @override
  _TaxBenefitsState createState() => _TaxBenefitsState();
}

class _TaxBenefitsState extends State<TaxBenefits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tax Benefits'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              buildCard(
                'Section 80C',
                'Section 80C: Premiums paid on life insurance policies, such as endowment, whole life, money back policies, term insurance policies, and Unit Linked Insurance Plans, are tax deductible under Section 80C of the Income Tax Act of 1961. The maximum deduction available is Rs. 1,50,000.',
              ),
              buildCard(
                'Section 10(10D)',
                'Section 10(10D) of Income Tax Act exempts you from paying taxes on the amount that you receive from the life insurance provider. Under this section, the amount of sum assured and bonus (if any) received on maturity or surrender of policy or on death of the life assured are completely tax free in the hands of the receiver, subject to certain conditions.',
              ),
              buildCard(
                'Section 80D',
                'Section 80D: Tax deduction under Section 80D of the Income Tax Act, 1961, can be claimed for premiums paid toward a health insurance policy. The total deductions that can be claimed under Section 80D are as under.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(title, description) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text(
              title,
              textColor: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 19.0,
            ),
            Divider(
              height: 5.0,
              color: Colors.grey,
            ),
            text(
              description,
              textColor: Colors.black,
              isLongText: true,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
