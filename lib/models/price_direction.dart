enum PriceDirection {
  up,
  down,
  flat;

  static PriceDirection fromChange(num change) {
    if (change > 0) {
      return PriceDirection.up;
    }
    if (change < 0) {
      return PriceDirection.down;
    }
    return PriceDirection.flat;
  }
}
