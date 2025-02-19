import 'package:drawer_panel/MODEL/ORDER/address_model.dart';
import 'package:drawer_panel/WIDGETS/ORDER_ELEMENTS/order_details_displayer.dart';
import 'package:flutter/material.dart';

class AddressHelpers {
  static List<Widget> buildAddressDetails(AddressModel? address) {
    Map<String, String?> details = {
      "Name:": address?.name,
      "Phone:": address?.phone,
      "Alternate Phone:": address?.alternatePhone ?? "Not Provided",
      "Address Type:": address?.addressType,
    };

    return details.entries.map((entry) {
      return OrderDetailsDisplayer(
          lines: 2, label: entry.key, value: entry.value ?? "N/A");
    }).toList();
  }

  static List<Widget> buildFullAddress(AddressModel? address) {
    Map<String, String?> details = {
      "House No:": address?.house,
      "Road:": address?.road,
      "Landmark:": address?.landmark,
      "City:": address?.city,
      "State:": address?.state,
      "PIN:": address?.pin,
    };

    return details.entries.map((entry) {
      return OrderDetailsDisplayer(
          lines: 2, label: entry.key, value: entry.value ?? "N/A");
    }).toList();
  }
}
