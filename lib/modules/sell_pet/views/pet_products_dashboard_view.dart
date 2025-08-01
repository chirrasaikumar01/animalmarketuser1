import 'package:animal_market/core/common_widgets/common_app_bar.dart';
import 'package:animal_market/core/common_widgets/loader_class.dart';
import 'package:animal_market/core/common_widgets/no_data_class.dart';
import 'package:animal_market/core/export_file.dart';
import 'package:animal_market/modules/buy/models/seller_model.dart';
import 'package:animal_market/modules/sell/widgets/sell_profile_container.dart';
import 'package:animal_market/modules/sell_pet/models/add_pet_sell_products_arguments.dart';
import 'package:animal_market/modules/sell_pet/providers/pet_sell_products_provider.dart';
import 'package:animal_market/modules/sell_pet/widgets/all_product_pet_list_widget.dart';
import 'package:animal_market/routes/routes.dart';

class PetProductsDashboardView extends StatefulWidget {
  const PetProductsDashboardView({super.key});

  @override
  State<PetProductsDashboardView> createState() => _PetProductsDashboardViewState();
}

class _PetProductsDashboardViewState extends State<PetProductsDashboardView> {
  int index = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isShrink = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    bool shrink = _scrollController.offset > 200;
    if (shrink != _isShrink) {
      setState(() {
        _isShrink = shrink;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetSellProductsProvider>(builder: (context, state, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          appBar: _isShrink
              ? null
              : PreferredSize(
                  preferredSize: Size.fromHeight(75.h),
                  child: CommonAppBar(
                    title: "myDashboard",
                    action: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.addPetSellProducts, arguments: AddPetSellProductsArguments(isEdit: false, categoryId: state.categoryId, id: ''));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: ColorConstant.white,
                          borderRadius: BorderRadius.circular(4.dm),
                          border: Border.all(color: ColorConstant.appCl, width: 1.w),
                        ),
                        child: TText(
                          keyName: "sellNow",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.appCl,
                            fontFamily: FontsStyle.regular,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          body: ProductsDashboard(
            scrollController: _scrollController,
            isShrink: _isShrink,
          ),
        ),
      );
    });
  }
}

class ProductsDashboard extends StatefulWidget {
  final ScrollController scrollController;
  final bool isShrink;

  const ProductsDashboard({super.key, required this.scrollController, required this.isShrink});

  @override
  State<ProductsDashboard> createState() => _ProductsDashboardState();
}

class _ProductsDashboardState extends State<ProductsDashboard> {
  late PetSellProductsProvider sellProductsProvider;
  int index = 0;
  List<String> tabTitles = ["allListing", "underVerify", "verified", "sold", "cancel"];
  List<String> tabTypes = ['', 'under_verification', 'verified', 'sold', 'cancel'];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sellProductsProvider = context.read<PetSellProductsProvider>();
      sellProductsProvider.sellerDashboard("", true);
    });
    super.initState();
  }

  @override
  void dispose() {
    sellProductsProvider.isLoading1 = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetSellProductsProvider>(builder: (context, state, child) {
      return NestedScrollView(
        controller: widget.scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: false,
              surfaceTintColor: Colors.white,
              automaticallyImplyLeading: false,
              stretch: true,
              elevation: 0,
              forceElevated: true,
              expandedHeight: 240.h,
              backgroundColor: ColorConstant.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  children: [
                    SizedBox(height: widget.isShrink ? 0 : 10.h),
                    AnimatedOpacity(
                      opacity: widget.isShrink ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: SellProfileContainer(
                          seller: state.seller ?? Seller(),
                          totalListed: state.totalListed,
                          totalCallsReceived: state.totalCallsReceived,
                          totalViewsReceived: state.totalViewsReceived,
                          listedName: "petListed",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Column(
                  children: [
                    widget.isShrink
                        ? CommonAppBar(
                            title: "myDashboard",
                            action: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: ColorConstant.white,
                                borderRadius: BorderRadius.circular(4.dm),
                                border: Border.all(color: ColorConstant.appCl, width: 1.w),
                              ),
                              child: TText(
                                keyName: "sellNow",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstant.appCl,
                                  fontFamily: FontsStyle.regular,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    _buildTabBar(state),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Builder(builder: (context) {
          if (state.isLoading1) {
            return LoaderClass(height: double.infinity);
          }
          if (state.petList.isEmpty) {
            return NoDataClass(
              height: double.infinity,
              text: noDataFound,
            );
          }
          return Column(
            children: [
              widget.isShrink ? SizedBox(height: 120) : SizedBox(),
              Expanded(child: _buildTabContent(state)),
            ],
          );
        }),
      );
    });
  }

  Widget _buildTabBar(PetSellProductsProvider state) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.w), // Optional padding
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabTitles.length, (i) {
            return InkWell(
              onTap: () {
                setState(() {
                  index = i;
                  state.sellerDashboard(tabTypes[i], true);
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                margin: EdgeInsets.only(right: 2.w), // Space between tabs
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: index == i
                          ? ColorConstant.darkAppCl
                          : Colors.transparent,
                      width: 2.w,
                    ),
                  ),
                ),
                child: TText(
                  keyName: tabTitles[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: index == i
                        ? ColorConstant.darkAppCl
                        : ColorConstant.gray1Cl,
                    fontStyle: FontStyle.normal,
                    fontFamily: FontsStyle.medium,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }


  Widget _buildTabContent(PetSellProductsProvider state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: AllProductPetListWidget(
        type: tabTypes[index],
        cattleList: state.petList,
        categoryId: state.categoryId,
      ),
    );
  }
}
