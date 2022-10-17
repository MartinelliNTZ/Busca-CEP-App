import 'package:cep_app/models/endereco_model.dart';
import 'package:cep_app/repositories/cep_repository.dart';
import 'package:cep_app/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  const HomePage({ super.key });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///Variaveis
final CepRepository cepRepository = CepRepositoryImpl();
bool loading = false;
EnderecoModel? enderecoModel;
final formKey =GlobalKey<FormState>();
final cepEc = TextEditingController();

@override
  void dispose() {   
    super.dispose();
    cepEc.dispose();
  }
///Métodos
   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(title: const Text('Buscar CEP'),),
           body: SingleChildScrollView(
            child: Form(
              key:formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: cepEc,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Cep é obrigatório';
                      }
                      return null;
                    }
                  ),
                  ElevatedButton(
                    onPressed: ()async{
                      loading = true;
                      final valid = formKey.currentState?.validate() ?? false;
                      if(valid){
                        try {                          
                          final endereco = await cepRepository.getCep(cepEc.text);                          
                          setState(() {
                            enderecoModel = endereco;
                            loading = false;
                          });
                        } catch (e) {
                          setState(() {
                            enderecoModel=null;
                            loading = false;
                          });
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: 
                              Text('Erro ao buscar Endereço.'  )),);
                        }
                      }
                    },
                    child: const Text('Buscar')),
                  Visibility(
                    visible: loading,
                    child: const CircularProgressIndicator()
                    ),  
                  Visibility(
                    visible: enderecoModel !=null,
                    child: Text('${enderecoModel?.logradouro} ${enderecoModel?.complemento} ${enderecoModel?.cep}'),
                  
                  )  
                ],
              )),
           ),
       );
  }
}