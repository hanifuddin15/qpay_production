class EMIRequestDto{
  String transactionId;
  String cardId;
  String amount;
  String transactionCode;
  String approvalCode;

  EMIRequestDto(this.transactionId, this.cardId, this.amount,
      this.transactionCode, this.approvalCode);
}