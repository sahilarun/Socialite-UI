import 'package:foap/helper/common_import.dart';

class FaqList extends StatefulWidget {
  const FaqList({Key? key}) : super(key: key);

  @override
  State<FaqList> createState() => _FaqListState();
}

class _FaqListState extends State<FaqList> {
  List<Map<String, String>> faqs = [
    {'question' :'1.Faq1', 'answer': 'Faq answer1'},
    {'question' :'2.Faq2', 'answer': 'Faq answer2'},
    {'question' :'3.Faq3', 'answer': 'Faq answer3'},
    {'question' :'4.Faq4', 'answer': 'Faq answer4'},
    {'question' :'5.Faq5', 'answer': 'Faq answer5'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(context:context, title:LocalizationString.faq),
          divider(context: context).tP8,
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 50),
                itemCount: faqs.length,
                itemBuilder: (ctx, index) {
                  return ExpansionTile(
                    title: Text(faqs[index]['question']!, style: Theme.of(context).textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w900)),
                    children:  <Widget>[
                      ListTile(title: Text(faqs[index]['answer']!, style: Theme.of(context).textTheme.bodyLarge)),
                    ],
                    onExpansionChanged: (bool expanded) {},
                  );
                }),
          )
        ],
      ),
    );
  }
}
