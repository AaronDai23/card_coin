import 'package:card_coin/bean/card_info_bean.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:flutter/material.dart';

class SmartDetailView extends StatelessWidget {
  final SmartCardDetail smartCardDetail;

  const SmartDetailView(this.smartCardDetail, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: LoadImage(
              smartCardDetail.background!,
              fit: BoxFit.fill,
              width: double.infinity,
              height: 150,
            )),
        Positioned(
            top: 40,
            right: 8,
            child: LoadImage(
              smartCardDetail.logo!,
              width: 80,
              height: 120,
            )),
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                smartCardDetail.contact ?? '',
                maxLines: 4,
                style: const TextStyle(color: Colors.black, fontSize: 24),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    color: Colors.black,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    smartCardDetail.mobile ?? '',
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              if (smartCardDetail.email?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        smartCardDetail.email ?? '-',
                        style: const TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      smartCardDetail.address ?? '-',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 26.0,
              )
            ],
          ),
        ),
      ],
    );
  }
}
