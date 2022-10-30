class UserTransaction {
  String? _id;
  String? sender;
  String? receipent;
  double? amount;
  String? date;
  String? time;
  String? remarks;

  UserTransaction(
    this._id,
    this.sender,
    this.receipent,
    this.amount,
    this.date,
    this.time,
    this.remarks,
  ) {}

  String? get id => this._id;

  set id(String? value) => this._id = value;

  get getSender => this.sender;

  set setSender(sender) => this.sender = sender;

  get getReceipent => this.receipent;

  set setReceipent(receipent) => this.receipent = receipent;

  get getAmount => this.amount;

  set setAmount(amount) => this.amount = amount;

  get getDate => this.date;

  set setDate(date) => this.date = date;

  get getTime => this.time;

  set setTime(time) => this.time = time;

  get getRemarks => this.remarks;

  set setRemarks(remarks) => this.remarks = remarks;
}
