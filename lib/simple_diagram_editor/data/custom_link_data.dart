class MyLinkData {
  String startLabel;
  String endLabel;

  MyLinkData({
    this.startLabel = '',
    this.endLabel = '',
  });

  MyLinkData.copy(MyLinkData customData)
      : this(
          startLabel: customData.startLabel,
          endLabel: customData.endLabel,
        );
}
