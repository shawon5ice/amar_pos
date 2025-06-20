// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginDataAdapter extends TypeAdapter<LoginData> {
  @override
  final int typeId = 1;

  @override
  LoginData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginData(
      token: fields[0] as String,
      name: fields[1] as String,
      status: fields[2] as String,
      email: fields[3] as String,
      phone: fields[4] as String,
      business: fields[5] as Business,
      address: fields[6] as String,
      permissions: (fields[7] as List).cast<String>(),
      photo: fields[8] as String?,
      subscription: fields[9] as Subscription,
      store: fields[10] as Store,
      cashHead: fields[11] as CashHead,
      businessOwner: fields[12] as bool,
      id: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LoginData obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.business)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.permissions)
      ..writeByte(8)
      ..write(obj.photo)
      ..writeByte(9)
      ..write(obj.subscription)
      ..writeByte(10)
      ..write(obj.store)
      ..writeByte(11)
      ..write(obj.cashHead)
      ..writeByte(12)
      ..write(obj.businessOwner)
      ..writeByte(13)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BusinessAdapter extends TypeAdapter<Business> {
  @override
  final int typeId = 2;

  @override
  Business read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Business(
      id: fields[0] as int,
      name: fields[1] as String,
      phone: fields[2] as String,
      email: fields[3] as String,
      logo: fields[4] as String?,
      address: fields[5] as String,
      currencyId: fields[6] as int,
      ownerId: fields[7] as int,
      timeZone: fields[8] as String,
      photoUrl: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Business obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.logo)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.currencyId)
      ..writeByte(7)
      ..write(obj.ownerId)
      ..writeByte(8)
      ..write(obj.timeZone)
      ..writeByte(9)
      ..write(obj.photoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubscriptionAdapter extends TypeAdapter<Subscription> {
  @override
  final int typeId = 3;

  @override
  Subscription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subscription(
      slNo: fields[0] as String,
      businessId: fields[1] as int,
      packageId: fields[2] as int,
      startDate: fields[3] as String,
      endDate: fields[4] as String,
      packagePrice: fields[5] as int,
      paymentStatus: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Subscription obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.slNo)
      ..writeByte(1)
      ..write(obj.businessId)
      ..writeByte(2)
      ..write(obj.packageId)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.packagePrice)
      ..writeByte(6)
      ..write(obj.paymentStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StoreAdapter extends TypeAdapter<Store> {
  @override
  final int typeId = 4;

  @override
  Store read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Store(
      id: fields[0] as int,
      name: fields[1] as String,
      phone: fields[2] as String,
      address: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Store obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CashHeadAdapter extends TypeAdapter<CashHead> {
  @override
  final int typeId = 5;

  @override
  CashHead read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CashHead(
      id: fields[0] as int,
      name: fields[1] as String,
      root: fields[2] as int,
      type: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CashHead obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.root)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashHeadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
