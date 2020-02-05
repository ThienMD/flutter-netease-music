import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:quiet/material/dialogs.dart';
import 'package:quiet/model/region_flag.dart';
import 'package:quiet/pages/welcome/login_sub_navigation.dart';
import 'package:quiet/part/part.dart';

import '_repository.dart';

class PageLoginWithPhone extends StatefulWidget {
  @override
  _PageLoginWithPhoneState createState() => _PageLoginWithPhoneState();
}

class _PageLoginWithPhoneState extends State<PageLoginWithPhone> {
  final _phoneInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneInputController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile number login'),
        leading: IconButton(
          icon: const BackButtonIcon(),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).maybePop();
          },
        ),
      ),
      body: Loader<_InputModel>(
        loadTask: () =>
            WelcomeRepository.getRegions().then((value) => Result.value(_InputModel(value, _phoneInputController))),
        builder: (context, data) {
          return ScopedModel<_InputModel>(
            model: data,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 30),
                  Text(
                    'Account will be created automatically after login without registered mobile phone number',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: _PhoneInput(controller: _phoneInputController),
                  ),
                  _ButtonNextStep(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InputModel extends Model {
  final List<RegionFlag> flags;

  final TextEditingController phoneInputController;

  _InputModel(this.flags, this.phoneInputController) {
    final countryCode = window.locale.countryCode;
    final region = flags.firstWhere((region) => region.code == countryCode) ?? flags[0];
    _region = region;
  }

  RegionFlag _region;

  RegionFlag get region => _region;

  set region(RegionFlag flag) {
    if (_region == flag) return;
    _region = flag;
    notifyListeners();
  }

  String get phoneNumber => phoneInputController.text;
}

class _PhoneInput extends StatelessWidget {
  final TextEditingController controller;

  _PhoneInput({Key key, this.controller}) : super(key: key);

  Color _textColor(BuildContext context) {
    if (controller.text.isEmpty) {
      return Theme.of(context).disabledColor;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.body1.copyWith(
          fontSize: 16,
          color: _textColor(context),
        );
    final inputModel = ScopedModel.of<_InputModel>(context, rebuildOnChange: true);
    return DefaultTextStyle(
      style: style,
      child: TextField(
        controller: controller,
        style: style,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixIcon: InkWell(
            onTap: () async {
              final region = await showDialog<RegionFlag>(
                  context: context, builder: (context) => _RegionSelectionDialog(regions: inputModel.flags));
              if (region != null) {
                inputModel.region = region;
              }
            },
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(inputModel.region.emoji + " " + inputModel.region.dialCode),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegionSelectionDialog extends StatelessWidget {
  final List<RegionFlag> regions;

  const _RegionSelectionDialog({Key key, @required this.regions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListTileTheme(
        style: ListTileStyle.drawer,
        child: ListView.builder(
            itemCount: regions.length,
            itemBuilder: (context, index) {
              final region = regions[index];
              return ListTile(
                leading: Text(region.emoji),
                title: Text(region.name),
                trailing: Text(region.dialCode),
                onTap: () {
                  Navigator.of(context).pop(region);
                },
              );
            }),
      ),
    );
  }
}

class _ButtonNextStep extends StatelessWidget {
  const _ButtonNextStep({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      textColor: Theme.of(context).primaryTextTheme.body1.color,
      child: Text('Next step'),
      onPressed: () async {
        final model = ScopedModel.of<_InputModel>(context);
        final text = model.phoneNumber;
        if (text.isEmpty) {
          toast('Please enter phone number');
          return;
        }
        final result = await showLoaderOverlay(
            context,
            WelcomeRepository.checkPhoneExist(
              text,
              model.region.dialCode.replaceAll("+", "").replaceAll(" ", ""),
            ));
        if (result.isError) {
          toast(result.asError.error.toString());
          return;
        }
        final value = result.asValue.value;
        if (!value.isExist) {
          toast('Registration process development is not complete, welcome to contribute code ...');
          return;
        }
        if (!value.hasPassword) {
          toast('The development of the passwordless login process has not been completed, please submit your PR contribution code...');
          return;
        }
        Navigator.pushNamed(context, pageLoginPassword, arguments: {'phone': text});
      },
    );
  }
}
