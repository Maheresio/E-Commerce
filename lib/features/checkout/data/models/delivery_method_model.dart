import '../../../../core/utils/app_images.dart';

List<DeliveryMethodModel> deliveryMethods = [
  DeliveryMethodModel(
    name: 'FedEx Delivery',
    duration: '2-3 days',
    image: AppImages.fedex,
  ),
  // DeliveryMethodModel(
  //   name: 'DHL Delivery',
  //   duration: '2-3 days',
  //   image: AppImages.usps,
  // ),
  // DeliveryMethodModel(
  //   name: 'DHL Delivery',
  //   duration: '2-3 days',
  //   image: AppImages.dhl,
  // ),
  // DeliveryMethodModel(
  //   name: 'Stripe Delivery',
  //   duration: '2-3 days',
  //   image: AppImages.stripe,
  // ),
  DeliveryMethodModel(
    name: 'USPS Delivery',
    duration: '2-3 days',
    image: AppImages.paypal,
  ),
  DeliveryMethodModel(
    name: 'USPS Delivery',
    duration: '2-3 days',
    image: AppImages.dhl,
  ),
];

class DeliveryMethodModel {
  final String name;
  final String duration;
  final String image;

  DeliveryMethodModel({
    required this.name,
    required this.duration,
    required this.image,
  });
}
