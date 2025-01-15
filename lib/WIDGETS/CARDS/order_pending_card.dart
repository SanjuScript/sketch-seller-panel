import 'package:drawer_panel/WIDGETS/helper_text.dart';
import 'package:flutter/material.dart';

class OrderPendingCard extends StatelessWidget {
  
  const OrderPendingCard({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      height: size.height * .20,
      width: size.width * .95,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(-2, 2), blurRadius: 5),
            BoxShadow(
                color: Colors.black12, offset: Offset(2, -2), blurRadius: 5)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          HelperText1(
            text: " Date - 2023-234-34",
            color: Colors.grey,
            fontSize: size.width * .04,
          ),
          Row(
            children: [
              InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ItemBuyingPage(
                    //             presetModel: purchaseModel.productDetails!)));
                  },
                  child: SizedBox(
                    height: size.height * .13,
                    width: size.width * .30,
                    //   child: ItemBuyingPageProductDisplay(
                    //       imageUrl: purchaseModel.productDetails!.presets!.first,
                    //       borderRadius: 5),
                    // ),
                    child: Container(
                      color: Colors.black,
                      height: 50,
                      width: 50,
                    ),
                  )),
              const Spacer(),
              SizedBox(
                // color: Colors.red,
                height: size.height * .15,
                width: size.width * .60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Detail;s",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: size.width * .06,
                          fontFamily: 'hando'),
                    ),
                    Text(
                      "Product",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: size.width * .04,
                        fontFamily: 'hando',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
