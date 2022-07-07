
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/shared/cubit/cubit.dart';
import 'package:untitled/shared/cubit/states.dart';

class donescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var tasks=AppCubit.get(context).doneTasks;
        return ConditionalBuilder(
          condition: tasks.length>0,
          builder: (context)=> ListView.separated(
            scrollDirection:Axis.vertical,
            itemBuilder:(context,index)=>buildTaskItem(tasks[index],context),
            separatorBuilder:(context,index)=>Container(
              width: double.infinity,
              height: 1.4,
              color: Colors.grey[300],
            ),
            itemCount:tasks.length,
          ),
          fallback: (context)=>Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                    width: 200,
                    height: 200,
                    image:NetworkImage('https://new-girls.ws/images/img_1/ed7b760fbdb111d6c6ef5cb3bf881912.gif')),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'No Tasks Yet,Pleas Add Some Tasks!!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
Widget buildTaskItem(Map model,context)=>Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      children:
      [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.lightGreenAccent[700],
          child: Text(
            '${model['time']}',
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.arrow_back_outlined,
          color: Colors.amber,
        ),
        Expanded(
          child: Container(
            color: Colors.grey[50],
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${model['date']} ',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        IconButton(
            color: Colors.green,
            onPressed: (){
              AppCubit.get(context).UpdateDate(status: 'done',id: model['id'],);
            },
            icon:Icon(
              Icons.domain_verification_outlined,
            )
        ),
        SizedBox(
          width: 10,
        ),
        IconButton(
            color: Colors.amber,
            onPressed: (){
              AppCubit.get(context).UpdateDate(status: 'archived',id: model['id'],);
            },
            icon:Icon(
              Icons.archive,
            )
        ),
      ],
    ),
  ),
  onDismissed:(direction){
    AppCubit.get(context).DeletDate(id:model['id']);
  },
);
