import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    InvoiceEditState state, Dispatch dispatch, ViewService viewService) {
  // TODO: implement build

  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: const Text('Edit Invoice'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(viewService.context).pop();
              // dispatch(HDWalletListActionCreator.onShowCardInfoList());
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: PageDataLoadingView(
        loadStatus: state.loadStatus,
        errorMsg: state.errorMsg,
        onLoadSuccess: () {
          return Column(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
//
                    Container(
                      color: Colors.white24,

                      ///距离顶部
                      margin: const EdgeInsets.only(top: 45),
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 50),

                      ///Alignment 用来对齐 Widget
                      alignment: const Alignment(0, 0),

                      ///文本输入框
                      child: TextField(
                        ///是否可编辑
                        enabled: state.isEnable,
                        onChanged: (value) {
                          dispatch(
                              InvoiceEditActionCreator.onTextChanged(value));
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(
                        //       RegExp(r'^(0|[1-9]\d*)(\.\d+)?$')),
                        // ],
                        maxLines: null,
                        style: const TextStyle(color: Colors.orange),

                        ///焦点获取
                        focusNode: state.focusNode2,

                        ///用来配置 TextField 的样式风格
                        decoration: InputDecoration(
                          ///设置输入文本框的提示文字
                          ///输入框获取焦点时 并且没有输入文字时
                          hintText: "Amount to receive",

                          ///设置输入文本框的提示文字的样式
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            textBaseline: TextBaseline.ideographic,
                          ),

                          ///输入框内的提示 输入框没有获取焦点时显示
                          labelText: "Amount",
                          labelStyle: const TextStyle(color: Colors.orange),

                          ///显示在输入框下面的文字
                          // helperText: "这里是帮助提示语",
                          // helperStyle: TextStyle(color: Colors.green),

                          ///显示在输入框下面的文字
                          ///会覆盖了 helperText 内容
                          errorText: state.errorTip,

                          ///输入框获取焦点时才会显示出来 输入文本的前面
                          // prefixText: "prefix",
                          // prefixStyle: TextStyle(color: Colors.deepPurple),

                          ///输入框获取焦点时才会显示出来 输入文本的后面
                          // suffixText: "suf ",
                          // suffixStyle: TextStyle(color: Colors.black),

                          ///文本输入框右下角显示的文本
                          ///文字计数器默认使用
                          counterText:
                              state.mount.isEmpty ? "" : "≈ \$ ${state.mount}",
                          counterStyle: const TextStyle(color: Colors.orange),

                          ///输入文字前的小图标
                          // prefixIcon: Icon(Icons.phone),

                          ///输入文字后面的小图标
                          ///
                          suffixIcon: DropdownButton<String>(
                            value: state.seletUnit,
                            icon: const Image(
                                image:
                                    AssetImage('assets/images/expand_more.png'),
                                height: 15,
                                width: 15),
                            onChanged: (newValue) {
                              dispatch(InvoiceEditActionCreator.dropdownSelect(
                                  newValue as String));
                            },
                            items: state.units
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          // suffixIcon:
                          //     IconButton(onPressed: () {

                          //     }, icon: ),

                          // ///与 prefixText 不能同时设置
//                prefix: Text("A") ,
                          /// 与 suffixText 不能同时设置
//                suffix:  Text("B") ,
                          ///设置边框
                          ///   InputBorder.none 无下划线
                          ///   OutlineInputBorder 上下左右 都有边框
                          ///   UnderlineInputBorder 只有下边框  默认使用的就是下边框
                          /// OutlineInputBorder

                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),

                          //设置输入框可编辑时的边框样式
                          enabledBorder: const OutlineInputBorder(
                            ///设置边框四个角的弧度
                            borderRadius: BorderRadius.all(Radius.circular(10)),

                            ///用来配置边框的样式
                            borderSide: BorderSide(
                              ///设置边框的颜色
                              color: Colors.black,

                              ///设置边框的粗细
                              width: 2.0,
                            ),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            ///设置边框四个角的弧度
                            borderRadius: BorderRadius.all(Radius.circular(10)),

                            ///用来配置边框的样式
                            borderSide: BorderSide(
                              ///设置边框的颜色
                              color: Colors.black,

                              ///设置边框的粗细
                              width: 2.0,
                            ),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black), // 错误时的边框颜色
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black), // 聚焦错误时的边框颜色
                          ),

                          // ///用来配置输入框获取焦点时的颜色
                          focusedBorder: const OutlineInputBorder(
                            ///设置边框四个角的弧度
                            borderRadius: BorderRadius.all(Radius.circular(20)),

                            ///用来配置边框的样式
                            borderSide: BorderSide(
                              ///设置边框的颜色
                              color: Colors.black,

                              ///设置边框的粗细
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 590.0, // 固定宽度
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // 水平居中
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              dispatch(InvoiceEditActionCreator.onPress());
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Row(children: [
                              Image(
                                  image:
                                      AssetImage('assets/images/qr_code1.png'),
                                  height: 20,
                                  width: 20),
                              SizedBox(
                                width: 4,
                              ),
                              Text('Create invoice')
                            ]),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // ),
            ],
          );
        },
      ));
}
