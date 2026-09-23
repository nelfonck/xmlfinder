import 'package:comprassj/models/razonsocial.dart';
import 'package:comprassj/repositories/razonsocialrepository.dart';
import 'package:comprassj/services/razonsocialservice.dart';
import 'package:flutter/material.dart';

class RazonSocialViewModel extends ChangeNotifier{
  final RazonSocialRepository _repository = RazonSocialRepository(RazonSocialService());
  List<RazonSocial> razonesSociales = [];
  bool _disposed = false;

  Future<void> init() async {
    await getRazonesSociales();
  }

  Future<void> getRazonesSociales() async {
    razonesSociales = await _repository.getRazonesSociales();
    safeNotifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

}