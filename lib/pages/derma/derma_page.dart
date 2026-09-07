import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prim_derma_app/bloc/auth/login/login_bloc.dart';
import 'package:prim_derma_app/bloc/derma/derma_bloc.dart';
import 'package:prim_derma_app/models/derma.dart';
import 'package:prim_derma_app/models/user.dart';
import 'package:prim_derma_app/pages/derma/derma_function.dart';
import 'package:prim_derma_app/pages/derma/derma_webpage.dart';
import 'package:prim_derma_app/service/notification_service.dart';

import 'package:prim_derma_app/widget/style.dart';

class DermaPage extends StatefulWidget {
  const DermaPage({super.key});

  @override
  State<DermaPage> createState() => _DermaPageState();
}

class _DermaPageState extends State<DermaPage> {
  static List<String> headerList = [];
  static List<Derma> dermaList = [];
  static List<Derma> dermaHistoryList = [];
  List<Derma> tempDermaList = [];
  List<Derma> _baseDermaList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  String _selectedType = '';
  late ScrollController _scrollController;

  // Custom setter for selectedType
  set selectedType(String value) {
    _selectedType = value;

    if (_selectedType == 'Sejarah Derma Anda') {
      _baseDermaList = dermaHistoryList;
    } else if (_selectedType == 'Semua') {
      _baseDermaList = dermaList;
    } else {
      _baseDermaList = _filterByDonationType(selectedType);
      // tempDermaList =
      //     dermaList.where((x) => x.donationType == selectedType).toList();
    }
    _applySearchFilters();
  }

  String get selectedType => _selectedType;

  Future<void> retrieveDermaHistory() async {
    var list = await Derma.getDermaHistory();
    dermaHistoryList = list;
    setState(() {});
  }

  void _animateScroll() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // Scroll to the end
      duration: const Duration(seconds: 5), // Duration of the animation
      curve: Curves.easeInOut, // Animation curve
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    retrieveDermaHistory();
    BlocProvider.of<DermaBloc>(context).add(RequestDermaList());
    searchController.addListener(_onSearchChanged);

    pendingRandomAnonDonationNotifier.addListener(_onPendingDonationChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeTriggerRandomAnonDonation();
    });
  }

  void _onPendingDonationChanged() {
    _maybeTriggerRandomAnonDonation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pendingRandomAnonDonationNotifier.removeListener(_onPendingDonationChanged);
    _scrollController.dispose();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = searchController.text.trim().toLowerCase();
      _applySearchFilters();
    });
  }

  void _applySearchFilters() {
    if (_searchQuery.isEmpty) {
      tempDermaList = _baseDermaList;
    } else {
      tempDermaList = _baseDermaList
          .where((x) => x.dermaName.toLowerCase().contains(_searchQuery))
          .toList();
    }
  }

  List<Derma> _filterByDonationType(String type) {
    return dermaList.where((x) => x.donationType == type).toList();
  }

  Future<void> _startDonation(Derma derma, String type) async {
    if (await User.validateLogin()) {
      var token = await User.retrieveToken();
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DonateWebView(
          donation_id: derma.id.toString(),
          desc: type,
          token: token!,
          derma: derma,
        ),
      ));
      await retrieveDermaHistory();
    } else {
      BlocProvider.of<LoginBloc>(context).add(AutoLogin());
    }
  }

  void _maybeTriggerRandomAnonDonation() {
    if (!pendingRandomAnonDonationNotifier.value || dermaList.isEmpty) {
      return;
    }
    pendingRandomAnonDonationNotifier.value = false;
    final randomDerma = dermaList[Random().nextInt(dermaList.length)];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startDonation(randomDerma, 'Derma Tanpa Nama');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DermaBloc, DermaState>(
      listener: (context, state) {
        if (state is DermaFetched) {
          dermaList = state.dermaList;
          headerList = state.dermaTypeList;
          headerList.sort((a, b) {
            return Random().nextInt(20) - Random().nextInt(20);
          });

          dermaList.sort((a, b) {
            return Random().nextInt(20) - Random().nextInt(20);
          });
          //headerList = [];

          // Moved logic to Jenis Derma ListBuilder
          // if (dermaHistoryList.isEmpty) {
          //   //headerList.insert(0, 'Sejarah Derma Anda');
          // }
          selectedType = headerList.isNotEmpty ? headerList[0] : '';

          setState(() {});
          _maybeTriggerRandomAnonDonation();
        } else if (state is UpdateDermaType) {
          selectedType = state.type;

          setState(() {});
        }
      },
      child: body(),
    );
  }

  Widget animatedTypeCard(String type) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1, end: 0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: 1 - value,
          child: Transform.translate(
            offset: Offset(50 * value, 0),
            child: child,
          ),
        );
      },
      child: typeCard(type),
    );
  }

  Widget typeCard(String type) {
    return GestureDetector(
      onTap: () {
        // Handle option selection
        selectedType = type;
        setState(() {});
      },
      child: Card(
        shadowColor: Colors.black,
        elevation: 3,
        color: type == selectedType ? PRIMARY_PURPLE : Colors.white,
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(type,
                style: TextStyle(
                    color: type == selectedType
                        ? Colors.white
                        : HIGHLIGHT_TEXT_COLOR,
                    fontWeight: type == selectedType
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 16,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Cari derma...',
            prefixIcon: Icon(Icons.search, color: cs.primary),
            suffixIcon: searchController.text.isEmpty
                ? null
                : IconButton(
                    icon: Icon(Icons.close, color: cs.primary),
                    onPressed: () {
                      searchController.clear();
                    },
                  ),
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget dermaCard(Derma derma) {
    return Card(
      elevation: 5,
      shadowColor: Colors.grey[700],
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: PrimPrimaryGradient()),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                derma.dermaName,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 16, color: Colors.grey[900], letterSpacing: 1.1
                    // fontFamily: fon, // Custom font
                    ),
              ),
              SizedBox(height: 8),
              Align(
                  alignment: Alignment.centerRight,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      primaryColor:
                          Colors.white, // Change this to your desired color
                    ),
                    child: CupertinoButton.filled(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        child: Text(
                          'Derma',
                          style: TextStyle(
                              color: HIGHLIGHT_TEXT_COLOR,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () async {
                          _searchFocusNode.unfocus();
                          var result = await showDermaActionSheet(context,
                              ['Derma Dengan Nama', 'Derma Tanpa Nama']);
                          if (result == null) {
                            return;
                          }

                          await _startDonation(derma, result);
                        }),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _searchFocusNode.unfocus(),
      child: Scaffold(
        appBar: PrimAppBar(
          'Jom Derma',
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final mq = MediaQuery.of(context);
            final double availableHeight =
                mq.size.height - kToolbarHeight - kBottomNavigationBarHeight;
            final double availableWidth = mq.size.width;

            double containerHeight = min(availableHeight * 0.23, 250);
            double cardFontSize = availableWidth < 600 ? 24 : 28;

            containerHeight += (availableHeight < availableWidth)
                ? (availableHeight * 0.24)
                : 0;

            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5, left: 5),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    border: Border(
                      bottom: BorderSide(color: PRIMARY_PURPLE, width: 6),
                      left: BorderSide(color: PRIMARY_PURPLE, width: 1.5),
                      top: BorderSide(color: PRIMARY_PURPLE, width: 1.5),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  height: containerHeight,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      if (constraints.maxHeight > constraints.maxWidth)
                        Text(
                          'Jenis Derma',
                          style: TextStyle(
                            fontSize: cardFontSize,
                            fontWeight: FontWeight.bold,
                            color: HIGHLIGHT_TEXT_COLOR,
                          ),
                        ),
                      SizedBox(
                        height: min(containerHeight * 0.55, 120),
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: headerList.length +
                              1 +
                              (dermaHistoryList.isNotEmpty ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (dermaHistoryList.isNotEmpty && index == 0) {
                              return animatedTypeCard('Sejarah Derma Anda');
                            }

                            if (index ==
                                (dermaHistoryList.isNotEmpty ? 1 : 0)) {
                              return animatedTypeCard('Semua');
                            }

                            final headerIndex = index -
                                1 -
                                (dermaHistoryList.isNotEmpty ? 1 : 0);

                            return animatedTypeCard(headerList[headerIndex]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.01),
                searchBar(),
                SizedBox(height: constraints.maxHeight * 0.01),
                Expanded(
                  child: tempDermaList.isEmpty
                      ? Center(
                          child: Text(
                            'Tiada hasil jumpai',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: tempDermaList.length,
                          itemBuilder: (context, index) {
                            return dermaCard(tempDermaList[index]);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
