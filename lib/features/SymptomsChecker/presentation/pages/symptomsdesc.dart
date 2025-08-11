import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/features/medical_record/presentation/widgets/separator.dart';

class SymptomsDesc extends StatefulWidget {
  SymptomsDesc({super.key, required this.title});
  String title;
  @override
  State<SymptomsDesc> createState() => _SymptomsDescState();
}

class _SymptomsDescState extends State<SymptomsDesc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          titleSpacing: 0.1,
          foregroundColor: Colors.black,
          titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          title: Text(
            widget.title,
            style: const TextStyle(fontSize: 16),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Symptom Information:',
                style: TextStyle(fontSize: 13),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('images/dot.svg'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.82,
                    child: const Text(
                      'Fever is a temporary increase in body temperature, often in response to an infection or illness. It\'s a natural defense mechanism as it helps the body fight off infections.',
                      style: TextStyle(fontSize: 13),
                    ),
                  )
                ],
              )
            ]),
            const Gap(20),
            const MySeparator(),
            const Gap(20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Common Causes::',
                style: TextStyle(fontSize: 13),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('images/dot.svg'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.82,
                    child: const Text(
                      'Fever can be caused by various factors, including viral or bacterial infections, the flu, common cold, urinary tract infections, or other health conditions.',
                      style: TextStyle(fontSize: 13),
                    ),
                  )
                ],
              )
            ]),
            const Gap(20),
            const MySeparator(),
            const Gap(20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Self-Help Tips:',
                style: TextStyle(fontSize: 13),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('images/dot.svg'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.82,
                    child: const Text(
                      'If you have a mild fever, it\'s essential to rest, stay hydrated, and keep cool by taking a lukewarm bath. Over-the-counter fever reducers like acetaminophen or ibuprofen can help lower the fever. However, if your fever is severe, persistent, or accompanied by other concerning symptoms, it\'s important to seek medical advice.',
                      style: TextStyle(fontSize: 13),
                    ),
                  )
                ],
              )
            ]),
            const Gap(20),
            const MySeparator(),
            const Gap(20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'When to Seek Medical Attention:',
                style: TextStyle(fontSize: 13),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('images/dot.svg'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.82,
                    child: const Text(
                      'Contact a healthcare provider if your fever persists for more than a few days, is very high (above 39°C), is accompanied by severe headache, difficulty breathing, chest pain, rash, or confusion, or if you have underlying health conditions.',
                      style: TextStyle(fontSize: 13),
                    ),
                  )
                ],
              )
            ]),
          ],
        ),
      ),
    );
  }
}
