import 'package:artivatic_task/Model/itemfields.dart';
import 'package:artivatic_task/Provider/itemlist.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Items>>? itemsData;
  bool _isLoading =true;
  final TextEditingController _titlecontroller = new TextEditingController();
  final TextEditingController _bodyController = new TextEditingController();

  ItemList? itemsDataprovider;

  @override
  void initState(){
    Future.delayed(Duration.zero, () async {
      debugPrint('hello1');
      Provider.of<ItemList>(context,listen: false).fecthList().then((_) {
        debugPrint('hello');
        setState(() {
          // itemsData = ItemList().fecthList();
          itemsDataprovider = Provider.of<ItemList>(context, listen: false) ;
          itemsData= itemsDataprovider!.fecthList();
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _titlecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //adding item widget
    _dialogforAdd(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState1) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                child: Container(
                    height: 300.0,
                    width:200,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Add List",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          controller: _titlecontroller,
                          decoration: InputDecoration(
                            hintText: "Title *",
                            contentPadding: EdgeInsets.all(16),
                            border: OutlineInputBorder(),
                          ),
                          minLines: 1,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextField(
                          controller: _bodyController,
                          decoration: InputDecoration(
                            hintText: "Body (Optional)",
                            contentPadding: EdgeInsets.all(16),
                            border: OutlineInputBorder(),
                          ),
                          minLines: 2,
                          maxLines: 2,
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              color:Colors.purple,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancle",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                if(_titlecontroller.text==null){
                                  Fluttertoast.showToast(msg: "Please Enter title",
                                    fontSize: MediaQuery.of(context).textScaleFactor *13,);
                                }else {
                                  setState(() {
                                    if (itemsDataprovider != null)
                                      itemsData = itemsDataprovider!.AddList(
                                          _titlecontroller.text,
                                          _bodyController.text);
                                  });
                                  _titlecontroller.clear();
                                  _bodyController.clear();
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              color:Colors.purple,
                            ),
                          ],
                        ),
                      ],
                    )),
              );
            });
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('List Of Data',style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Expanded(
              child:FutureBuilder(
                  future: itemsData,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    return  (snapshot.data!=null) ?
                    ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, i) {
                          return Card(
                            margin: EdgeInsets.all(5),
                            elevation: 2,
                            color: Colors.white,
                            child:
                            ListTile(
                              title: Text(snapshot.data[i].title.toString(),
                                style: TextStyle(fontSize: 16),),
                              trailing: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if(itemsDataprovider!=null)
                                        itemsData =  itemsDataprovider!.RemoList(i);
                                    });
                                  },
                                  child: Icon(
                                    Icons.delete, size: 20,
                                    color: Colors.red,)),
                            ),
                          );
                        }):SizedBox.shrink();
                  }
              )
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add,size:20,color: Colors.white,),
        onPressed: (){
          _dialogforAdd(context);
        },
      ),
    );
  }
}
