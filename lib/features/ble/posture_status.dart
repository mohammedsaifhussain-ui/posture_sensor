enum PostureStatus {
  uninit,
  calibrating,
  good,
  pending,
  alert,
  fault;

  static PostureStatus fromByte(int value) {
    switch (value) {
      case 0x00:
        return PostureStatus.uninit;
      case 0x01:
        return PostureStatus.calibrating;
      case 0x02:
        return PostureStatus.good;
      case 0x03:
        return PostureStatus.pending;
      case 0x04:
        return PostureStatus.alert;
      default:
        return PostureStatus.fault;
    }
  }
}

