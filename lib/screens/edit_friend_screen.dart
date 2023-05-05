import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../utils/theme/theme.dart';
import '../models/friend.dart';
import '../widgets/image_input.dart';
import '../providers/friends.dart';

class EditFriendScreen extends HookWidget {
  static const routeName = '/edit-friend';
//////CHANGE IMAGEURL TO IMAGE PICKER
  File? _pickedImage;
  var _editedFriend = Friend(
      id: '',
      name: '',
      about: '',
      image: null,
      rating: 0,
      wNumber: '',
      birthDay: '');
  var _initValues = {
    'name': '',
    'about': '',
    //'imageUrl': '',
    'rating': '', 'wNumber': '', 'birthDay': '',
  };

  void _selectImage(File selectedImage) {
    _pickedImage = selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    //var buttonCheck = useState(0);

    final nameFocusNode = useFocusNode();
    final aboutFocusNode = useFocusNode();
    final ratingFocusNode = useFocusNode();
    final wNumberFocusNode = useFocusNode();
    final birthDayFocusNode = useFocusNode();
    final birthDayController = useTextEditingController();

    final selectedDate = useState(DateTime(2023, 1, 1));

    final formKey = useMemoized(GlobalKey<FormState>.new);
    final friendId =
        useMemoized(() => ModalRoute.of(context)?.settings.arguments);

    useEffect(() {
      // final friendId =
      //     ModalRoute.of(useContext())?.settings.arguments as String;
      if (friendId != null) {
        _editedFriend = Provider.of<Friends>(useContext(), listen: false)
            .searchById(friendId);
        _initValues = {
          'name': _editedFriend.name,
          'about': _editedFriend.about,
          //'imageUrl': _editedFriend.image,
          'rating': _editedFriend.rating.toString(),
          'wNumber': _editedFriend.wNumber.substring(3),
          //'birthDay': _editedFriend.birthDay
        };
        birthDayController.text = _editedFriend.birthDay;
      }
      // print(friendId);
      // print(_editedFriend.id);

      // print(_initValues);
    }, []);

    void _saveForm() {
      final isValid = formKey.currentState!.validate();
      print('It has saved o');
      if (!isValid) {
        print('It has saved, but is not valid');
        return;
      }
      if (_editedFriend.image == null && _pickedImage == null) {
        return;
      }
      formKey.currentState!.save();

      if (_editedFriend.id != '') {
        print('${_editedFriend.id} is edited');
        Provider.of<Friends>(context, listen: false)
            .editFriend(_editedFriend, _pickedImage ?? _editedFriend.image!);
      } else {
        print(_editedFriend.id);
        Provider.of<Friends>(
          context,
          listen: false,
        ).addFriend(_editedFriend, _pickedImage!);
      }
      Navigator.of(context).pop();
    }

    //print(_initValues);

    return Scaffold(
      backgroundColor: MyAppTheme.lightTheme.backgroundColor,
      appBar: AppBar(
          title: Text('${friendId == null ? 'Add New' : 'Edit'} Friend')),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              /// REMEMBER THIS IS SUPPOSED TO BE AN ImageInput() custom widget WITH IMAGE PICKER,
              friendId == null
                  ? ImageInput(_selectImage, _pickedImage)
                  : ImageInput(_selectImage, _editedFriend.image),

              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: _initValues['name'],
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'What is the name of your friend?'),
                textInputAction: TextInputAction.next,
                focusNode: nameFocusNode,
                onEditingComplete: () {
                  //print('you have left the rating field');
                  if (_pickedImage != null) {
                    print('there is an image');
                    //buttonCheck.value++;
                  } else {
                    print('there is no image');
                  }
                },
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(ratingFocusNode),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'Name cannot be empty.';
                  }
                  if (double.tryParse(value) != null) {
                    return 'Name cannot be a number.';
                  }
                  return null;
                }),
                onSaved: (value) => _editedFriend = Friend(
                  id: _editedFriend.id,
                  name: value!,
                  about: _editedFriend.about,
                  image: _editedFriend.image,
                  rating: _editedFriend.rating,
                  wNumber: _editedFriend.wNumber,
                  birthDay: _editedFriend.birthDay,
                ),
              ),
              SizedBox(
                height: 10,
              ), //REPLACE THE INPUT FIELD BELOW WITH A RADIO INPUT?
              TextFormField(
                initialValue: _initValues['rating'],
                decoration: const InputDecoration(
                    labelText: 'Rating',
                    hintText:
                        'Between 1 and 5, how close is this friend to you?'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(wNumberFocusNode),
                maxLines: 1,
                maxLength: 1,
                keyboardType: TextInputType.number,
                focusNode: ratingFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid Integer.';
                  }
                  if (int.parse(value) > 5 || int.parse(value) < 1) {
                    return 'Please enter an integer between 1 and 5.';
                  }
                  return null;
                },
                onSaved: (value) => _editedFriend = Friend(
                  id: _editedFriend.id,
                  name: _editedFriend.name,
                  about: _editedFriend.about,
                  image: _editedFriend.image,
                  rating: int.parse(value!),
                  wNumber: _editedFriend.wNumber,
                  birthDay: _editedFriend.birthDay,
                ),
                //onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              TextFormField(
                initialValue: _initValues['wNumber'],
                decoration: const InputDecoration(
                    labelText: 'Whatsapp Number',
                    hintText: 'Do not include the first 0 or +234.'),
                //textInputAction: TextInputAction.next,
                //smartDashesType: SmartDashesType.enabled,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(birthDayFocusNode),
                maxLength: 10,
                keyboardType: TextInputType.number,
                focusNode: wNumberFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid phone number.';
                  }
                  return null;
                },
                onSaved: (value) => _editedFriend = Friend(
                  id: _editedFriend.id,
                  name: _editedFriend.name,
                  about: _editedFriend.about,
                  image: _editedFriend.image,
                  rating: _editedFriend.rating,
                  wNumber: value!,
                  birthDay: _editedFriend.birthDay,
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              InkWell(
                child: IgnorePointer(
                  child: TextFormField(
                    //initialValue: _initValues['birthDay'],
                    decoration: const InputDecoration(
                        labelText: 'Birth Month & Day',
                        hintText: 'Tap to select day of birth'),
                    // textInputAction: TextInputAction.next,
                    // smartDashesType: SmartDashesType.enabled,
                    controller: birthDayController,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(aboutFocusNode),
                    //maxLines: 1,
                    //keyboardType: TextInputType.number,
                    //focusNode: ratingFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please tap to select a day of birth.';
                      }
                      return null;
                    },
                    onSaved: (value) => _editedFriend = Friend(
                      id: _editedFriend.id,
                      name: _editedFriend.name,
                      about: _editedFriend.about,
                      image: _editedFriend.image,
                      rating: _editedFriend.rating,
                      wNumber: _editedFriend.wNumber,
                      birthDay: value!,
                    ),
                  ),
                ),
                onTap: () async {
                  final DateTime? pickedDay = await showDatePicker(
                      context: context,
                      initialDate: selectedDate.value,
                      firstDate: DateTime(2023, 1, 1),
                      lastDate: DateTime(2023, 12, 31),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialDatePickerMode: DatePickerMode.day);

                  if (pickedDay != null) {
                    //&& pickedDay != selectedDate.value
                    selectedDate.value = pickedDay;
                    birthDayController.text =
                        DateFormat.MMMd().format(selectedDate.value);
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                initialValue: _initValues['about'],
                decoration: const InputDecoration(
                  labelText: 'About',
                  hintText:
                      'Anything you\'d like to remeber about this person like how you met them, what they mean to you, etc',
                ),
                //textInputAction: TextInputAction.next,
                maxLines: 3,
                focusNode: aboutFocusNode,
                // onFieldSubmitted: (_) =>
                //     FocusScope.of(context).requestFocus(ratingFocusNode),
                keyboardType: TextInputType.multiline,

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'Description cannot be less than 10 characters.';
                  }
                  return null;
                },

                onSaved: (value) => _editedFriend = Friend(
                  id: _editedFriend.id,
                  name: _editedFriend.name,
                  about: value!,
                  image: _editedFriend.image,
                  rating: _editedFriend.rating,
                  wNumber: _editedFriend.wNumber,
                  birthDay: _editedFriend.birthDay,
                ),
              ),

              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('${friendId == null ? 'Add' : 'Edit'} Friend'),
              ),
            ],
          ),
        )),
      ),
    );
    ;
  }
}
