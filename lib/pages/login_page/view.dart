import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../custom_widget/custom_button.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(LoginState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: const Text(
        'Login',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        onTap: () {
          Navigator.of(viewService.context).pop();
        },
      ),
    ),
    backgroundColor: Colors.grey[200],
    body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 20, 10.0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            color: Colors.white,
            child: Row(
              children: [
                const Icon(
                  Icons.phone_android,
                  color: Colors.grey,
                ),
                Expanded(
                    child: TextField(
                  maxLines: 1,
                  controller: state.phoneController,
                  focusNode: state.focusNodePhone,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'input phone number',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            color: Colors.white,
            child: Row(
              children: [
                const Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    obscureText: !state.showPwd,
                    controller: state.pwdController,
                    focusNode: state.focusNodePwd,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'input password',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () =>
                        dispatch(LoginActionCreator.onShowPwd(!state.showPwd)),
                    icon: Icon(
                      state.showPwd
                          ? Icons.visibility
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ))
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => dispatch(LoginActionCreator.onKeepPwdClick()),
                  child: Row(
                    children: [
                      Icon(
                        state.keepPwd
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_outlined,
                        color: state.keepPwd ? const Color(0xFF2337f9) : Colors.grey,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      const Text(
                        'Keep password',
                        style: TextStyle(color: Colors.black, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    'Forgot password',
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: CCButton(
              child: const Text('Login'),
              onPressed: () => dispatch(LoginActionCreator.onLogin()),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Text('Register now'),
          )
        ],
      ),
    ),
  );
}
