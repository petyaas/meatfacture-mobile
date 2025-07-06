// // ignore: implementation_imports
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:smart/bloc_files/client_address_bloc.dart';
// import 'package:smart/models/client_address_model.dart';
// import 'package:smart/models/geocoding_model.dart';
// import 'package:smart/services/services.dart';
// import 'package:smart/core/constants/source.dart';
// import 'package:yandex_mapkit/yandex_mapkit.dart';

// class AddressPicker extends StatefulWidget {
//   final ClientAddressDataModel clientAddressDataModel;

//   const AddressPicker({this.clientAddressDataModel});
//   @override
//   State<AddressPicker> createState() => _AddressPickerState();
// }

// class _AddressPickerState extends State<AddressPicker> {
//   List<String> addressGeocodingDataList = [];
//   Point addressMapPoint;
//   final TextEditingController intercomCodeTextController =
//       TextEditingController();
//   final TextEditingController entranceTextController = TextEditingController();
//   final TextEditingController floorTextController = TextEditingController();
//   final TextEditingController deliveryAppartmentnumberTextController =
//       TextEditingController();
//   TextEditingValue textEditingValue = TextEditingValue();
//   GeocodingModel _geocodingModel;

//   @override
//   void dispose() {
//     _googleMapController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     if (widget.clientAddressDataModel != null) {
//       intercomCodeTextController.text =
//           widget.clientAddressDataModel.intercomCode == null
//               ? ""
//               : widget.clientAddressDataModel.intercomCode.toString();
//       entranceTextController.text =
//           widget.clientAddressDataModel.entrance == null
//               ? ""
//               : widget.clientAddressDataModel.entrance.toString();
//       floorTextController.text = widget.clientAddressDataModel.floor == null
//           ? ''
//           : widget.clientAddressDataModel.floor.toString();
//       deliveryAppartmentnumberTextController.text =
//           widget.clientAddressDataModel.apartmentNumber == null
//               ? ""
//               : widget.clientAddressDataModel.apartmentNumber.toString();
//       textEditingValue = TextEditingValue(
//           text:
//               "${widget.clientAddressDataModel.city} ${widget.clientAddressDataModel.street} ${widget.clientAddressDataModel.house}");

//       if (widget.clientAddressDataModel != null && _geocodingModel == null) {
//         getAutoCompleteData(
//             "${widget.clientAddressDataModel.city} ${widget.clientAddressDataModel.street} ${widget.clientAddressDataModel.street} ${widget.clientAddressDataModel.house}");
//       }
//       super.initState();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ignore: close_sinks
//     ClientAddressBloc _clientAddressBloc =
//         BlocProvider.of<ClientAddressBloc>(context);
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.only(
//             // bottom: Platform.isIOS ? MediaQuery.of(context).viewInsets.bottom : 0,
//             bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//           // height: MediaQuery.of(context).size.height / 4 * 3.2
//           // height: ,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(15), topRight: Radius.circular(15)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "changeDeliveryAddress".tr(),
//                 style: GoogleFonts.raleway(
//                     fontSize: 20, fontWeight: FontWeight.w500),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Card(
//                 clipBehavior: Clip.hardEdge,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15)),
//                 child: Container(
//                   alignment: Alignment.center,
//                   height: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(),
//                   child: GoogleMap(
//                       markers: {
//                         if (addressMapMarker != null) addressMapMarker,
//                       },
//                       onMapCreated: (controller) =>
//                           _googleMapController = controller,
//                       zoomControlsEnabled: false,
//                       liteModeEnabled: false,
//                       initialCameraPosition: CameraPosition(
//                           target: LatLng(44.2285995, 42.0470964), zoom: 15)),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Autocomplete(
//                   // optionsViewBuilder: (context, onSelected, options) =>
//                   //     ListView.separated(
//                   //       padding: EdgeInsets.zero,
//                   //       itemCount: options.length,
//                   //       separatorBuilder: (BuildContext context, int index) {
//                   //         return Divider();
//                   //       },
//                   //       itemBuilder: (BuildContext context, int index) {
//                   //         final option = options.elementAt(index);
//                   //         return Material(
//                   //             child: InkWell(
//                   //           child: Container(
//                   //               decoration: BoxDecoration(
//                   //                 color: Colors.white,
//                   //               ),
//                   //               padding:
//                   //                   const EdgeInsets.symmetric(vertical: 10),
//                   //               child: Text(option.toString())),
//                   //         ));
//                   //       },
//                   //     ),
//                   // fieldViewBuilder: (context, textEditingController, focusNode,
//                   //         onFieldSubmitted) =>
//                   //     TextField(
//                   //       decoration: InputDecoration(border: InputBorder.none),
//                   //       controller: textEditingController,
//                   //       focusNode: focusNode,
//                   //       onEditingComplete: onFieldSubmitted,
//                   //     ),
//                   initialValue: textEditingValue,
//                   optionsBuilder: (textEditingValue) {

                    
//                     if (textEditingValue.text.isEmpty ||
//                         textEditingValue.text.length < 6) {
//                       return const Iterable<String>.empty();
//                     } else {
//                       getAutoCompleteData(textEditingValue.text);
//                       return addressGeocodingDataList;
//                     }
//                   }),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Домофон
//                   Container(
//                     width: 70,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Домофон",
//                           style: GoogleFonts.raleway(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: colorBlack04),
//                         ),
//                         TextField(
//                             controller: intercomCodeTextController,
//                             maxLines: 1,
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500),
//                             decoration:
//                                 InputDecoration(border: InputBorder.none)),
//                         Divider(),
//                       ],
//                     ),
//                   ),

//                   //Подъезд
//                   Container(
//                     width: 70,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Подъезд",
//                           style: GoogleFonts.raleway(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: colorBlack04),
//                         ),
//                         TextField(
//                             controller: entranceTextController,
//                             keyboardType: TextInputType.number,
//                             maxLines: 1,
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500),
//                             decoration:
//                                 InputDecoration(border: InputBorder.none)),
//                         Divider(),
//                       ],
//                     ),
//                   ),

//                   //Этаж

//                   Container(
//                     width: 40,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Этаж",
//                           style: GoogleFonts.raleway(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: colorBlack04),
//                         ),
//                         TextField(
//                             controller: floorTextController,
//                             keyboardType: TextInputType.number,
//                             maxLines: 1,
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500),
//                             decoration:
//                                 InputDecoration(border: InputBorder.none)),
//                         Divider(),
//                       ],
//                     ),
//                   ),

//                   //Квартира
//                   Container(
//                     width: 75,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Квартира",
//                           style: GoogleFonts.raleway(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: colorBlack04),
//                         ),
//                         TextField(
//                             controller: deliveryAppartmentnumberTextController,
//                             keyboardType: TextInputType.number,
//                             maxLines: 1,
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500),
//                             decoration:
//                                 InputDecoration(border: InputBorder.none)),
//                         Divider(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: InkWell(
//                       onTap: () async {
//                         if (_geocodingModel != null ||
//                             widget.clientAddressDataModel != null) {
//                           if (widget.clientAddressDataModel == null) {
//                             if (await ClientAddressProvider()
//                                 .addClientAddressResponse(
//                                     city: _geocodingModel.data.first.locality,
//                                     apartmentNumber:
//                                         deliveryAppartmentnumberTextController
//                                             .text,
//                                     entrance: entranceTextController.text,
//                                     floor: floorTextController.text,
//                                     house:
//                                         _geocodingModel.data.first.streetNumber,
//                                     intercomCode:
//                                         intercomCodeTextController.text,
//                                     title: "address",
//                                     street: _geocodingModel
//                                         .data.first.streetName)) {
//                               _clientAddressBloc.add(ClientAddressLoadEvent());
//                               Navigator.pop(context);
//                             } else {
//                               Fluttertoast.showToast(msg: "errorText".tr());
//                             }
//                           } else {
//                             if (await ClientAddressProvider()
//                                 .changeClientAddressResponse(
//                                     addressId:
//                                         widget.clientAddressDataModel.uuid,
//                                     city: _geocodingModel.data.first.locality,
//                                     apartmentNumber:
//                                         deliveryAppartmentnumberTextController
//                                             .text,
//                                     entrance: entranceTextController.text,
//                                     floor: floorTextController.text,
//                                     house:
//                                         _geocodingModel.data.first.streetNumber,
//                                     intercomCode:
//                                         intercomCodeTextController.text,
//                                     title: "address",
//                                     street: _geocodingModel
//                                         .data.first.streetName)) {
//                               _clientAddressBloc.add(ClientAddressLoadEvent());
//                               Navigator.pop(context);
//                             } else {
//                               Fluttertoast.showToast(msg: "errorText".tr());
//                             }
//                           }
//                         }
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           gradient: LinearGradient(
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                               colors: [
//                                 firstColorButtonsOrangeGradient,
//                                 secondColorButtonsOrangeGradient
//                               ]),
//                         ),
//                         child: Text("saveText".tr(),
//                             style: GoogleFonts.raleway(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 18)),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 15),
//                   Expanded(
//                     child: InkWell(
//                       onTap: () async {
//                         if (widget.clientAddressDataModel != null) {
//                           if (await ClientAddressProvider()
//                               .deleteClientAddressResponse(
//                                   addressId:
//                                       widget.clientAddressDataModel.uuid)) {
//                             _clientAddressBloc.add(ClientAddressLoadEvent());
//                             Navigator.pop(context);
//                           } else {
//                             Fluttertoast.showToast(msg: "errorText".tr());
//                           }
//                         } else {
//                           Navigator.pop(context);
//                         }
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: mainColor),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text("deleteText".tr(),
//                             style: GoogleFonts.raleway(
//                                 fontWeight: FontWeight.w500, fontSize: 18)),
//                       ),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void getAutoCompleteData(String text) async {
//     _geocodingModel =
//         await GeocodingProvider().getGeocodingResponse(address: text);
//     setState(() {
//       if (_geocodingModel.data.isNotEmpty) {
//         addressMapPoint = LatLng(_geocodingModel.data[0].latitude,
//             _geocodingModel.data[0].longitude);

//         _googleMapController
//             .animateCamera(CameraUpdate.newLatLng(addressMapPoint));
//         addressMapMarker =
//             Marker(markerId: MarkerId("address"), position: addressMapPoint);

//         addressGeocodingDataList = [
//           "${_geocodingModel.data[0].locality} ${_geocodingModel.data[0].streetName} ${_geocodingModel.data[0].streetNumber}"
//               .replaceAll("null", "")
//         ];
//       }
//     });
//   }
// }
// // 