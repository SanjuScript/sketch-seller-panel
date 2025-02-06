class OrderUpdateMsgs {
  static Map<String, String> getNotificationData(String stage) {
    switch (stage) {
      case 'Drawing Started':
        return {
          'title': 'Drawing Process Started',
          'body': 'Your drawing process has started!'
        };
      case 'Drawing Completed':
        return {
          'title': 'Drawing Completed',
          'body': 'Your drawing is complete and ready for the next step.'
        };
      case 'Shipped':
        return {
          'title': 'Shipped',
          'body': 'Your order has been shipped!'
        };
      case 'Out for Delivery':
        return {
          'title': 'Out for Delivery',
          'body': 'Your order is out for delivery and will reach you soon!'
        };
      case 'Delivered':
        return {
          'title': 'Order Delivered',
          'body': 'Your order has been delivered!'
        };
      case 'Refunded':
        return {
          'title': 'Order Refunded',
          'body': 'Your order has been refunded.'
        };
      case 'Delivery Failed':
        return {
          'title': 'Delivery Failed',
          'body':
              'Delivery attempt failed. Please check your address or contact support.'
        };
      default:
        return {
          'title': 'Order Status Updated',
          'body': 'Your order status has been updated.'
        };
    }
  }
}
