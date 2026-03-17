class MyLinkData {
  String startLabel;
  String endLabel;

  MyLinkData({
    this.startLabel = '',
    this.endLabel = '',
  });

  MyLinkData.copy(MyLinkData other)
      : this(
          startLabel: other.startLabel,
          endLabel: other.endLabel,
        );
}
