import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/cubit/login_cubit.dart';
import 'package:shopapp/cubit/login_states.dart';
import 'package:shopapp/modules/register_screen.dart';
import 'package:shopapp/shared/shared_components.dart';
import 'package:shopapp/shared/shared_pref_helper.dart';
import 'package:shopapp/shop_layout/shop_layout.dart';

class LoginScreen extends StatelessWidget {

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  GlobalKey<FormState> formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

   return BlocProvider(create:(context){return LoginCubit();} ,
    child:BlocConsumer<LoginCubit,LoginStates>(listener: (context,state){

    },
    builder:(context,state){
      if(state is LoginSuccessState){
        if(state.loginModel.status==true){
         SharedPrefHelper.saveString(key: "token", value: state.loginModel.data.token).
         then((value) {
           token=state.loginModel.data.token;
           navigateAndFinish(context, ShopLayout());
         });
        }else{
          toast(state.loginModel.message,Colors.red);
        }
      }
     LoginCubit cubit= LoginCubit.get(context);
      return Scaffold(appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Login",style: TextStyle(fontSize: 40),),
                  SizedBox(height: 10),
                  Text("Login now to browse our hot offers",
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(color:Colors.grey),),
                  SizedBox(height: 30),
                  defaultFormField(
                      controller: emailController,
                      inputType: TextInputType.emailAddress,
                      labeltext: "Email", prefixicon: Icons.email_outlined,
                      validator: (String value){
                        if(value.isEmpty){
                          return" please enter email address";
                        }
                        return null;
                      }),
                  SizedBox(height: 15,),
                  defaultFormField(
                      controller: passwordController,
                      inputType: TextInputType.visiblePassword,
                      suffexicon: cubit.passwordSuffixIcon,
                      suffexPressed: (){
                       cubit.changePasswordVisibility();},
                      obscureText: cubit.obscure,
                      labeltext: "Password", prefixicon: Icons.lock_outline,
                      validator: (String value){
                        if(value.isEmpty){
                          return" password is too short";
                        }
                        return null;
                      }),
                  SizedBox(height: 30,),

                  ConditionalBuilder(condition: state is! LoginLoadingState,
                    builder:(context) {
                    return defaultButton(buttonText: "Login",onPressed: (){
                      if(formKey.currentState!.validate()){
                        LoginCubit.get(context).login(email: emailController.text,
                            password: passwordController.text);
                      }
                    });},
                    fallback:(context){
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  SizedBox(height: 10,),
                  Row(children: [
                    Text("Don't have an account?",),
                    TextButton(onPressed: (){
                      navigateTo(context, RegisterScreen());
                    }, child: Text("Register Now",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
                  ],),

                ],),
            ),
          ),
        ),
      ),
    );} ,) ,);

  }
}
