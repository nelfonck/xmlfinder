import 'package:comprassj/models/razonsocial';

class RazonSocialRepository {
  final RazonSocialRepository  _service ;
  RazonSocialRepository(this._service) ;

  Future<List<RazonSocial>> getRazonesSociales() async {
    return _service.getRazonesSociales();
  }


}