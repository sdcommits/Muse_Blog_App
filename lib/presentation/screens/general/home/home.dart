import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bogging_app/core/constant/my_assests.dart';
import 'package:bogging_app/presentation/router/router_import.gr.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_bloc/cubit/velocity_cubit/velocity_cubit.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../data/repositories/repository.dart';
import '../../auth/widgets/home_details.dart';
import '../../auth/widgets/home_model.dart';
import '../../auth/widgets/home_view_model.dart';


// @RoutePage()
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeViewModel homeViewModel;

  @override
  void initState(){
    homeViewModel = HomeViewModel(repository: context.read<Repository>());
    homeViewModel.fetchAllPosts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<VelocityBloc<HomeModel>,
            VelocityState<HomeModel>>(
          bloc: homeViewModel.postsBloc,
          builder: (context, state) {
            if(state is VelocityInitialState ){
              return const Center(
                child: CircularProgressIndicator.adaptive(),
            );
          }
          else if(state is VelocityUpdateState){
            return SingleChildScrollView(
              //padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  
                  VxSwiper.builder(
                    autoPlay:  true,
                      enlargeCenterPage: true,
                      itemCount: state.data.popularPosts!.length,
                      itemBuilder: (context, index){
                        var latestPost = state.data.popularPosts![index];
                        var imagePath = latestPost.featuredimage
                            .toString()
                        //.prepend('https://techblog.codersangam.com/')
                            .replaceAll("public", "storage");
                  //   return Image.asset(MyAssests.assetsImageNetFlix).cornerRadius(10);
                  return CachedNetworkImage(imageUrl: imagePath, fit: BoxFit.cover,)
                      .cornerRadius(20).pSymmetric(h : 10);
                        }),
                      
                  20.h.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      "Latest Posts".text.size(16).make(),
                      "See All".text.size(16).make(),
                    ],
                  ).pSymmetric(h : 24.w),
                  15.h.heightBox,


            ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
            shrinkWrap: true,
            itemCount: state.data.allPosts!.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index)=> SizedBox(height: 15,),
            itemBuilder: (context,index){

            var latestPost = state.data.allPosts![index];
            var imagePath = latestPost.featuredimage
                .toString()
            //.prepend('https://techblog.codersangam.com/')
                .replaceAll("public", "storage");
            return Row(
              children: [
                GestureDetector(
                    onTap: ()=> AutoRouter.of(context).
                          push( HomeDetailsRoute(
                        post: latestPost,
                        imagePath: imagePath)),
                    child: Hero(
                      tag: Key(latestPost.id.toString()),
                      child: CachedNetworkImage(
                            imageUrl: imagePath,
                            height: 100,
                            width: 140,
                            fit: BoxFit.cover )
                .cornerRadius(20),
                    ),
            ),
            10.w.widthBox,
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    latestPost.title!
                        .text
                        .size(16)
                        .maxLines(2)
                          .bold
                          .make(),
            6.h.heightBox,
            FadedScaleAnimation(
              child: Row(
              children: [
              const Icon(FeatherIcons.clock, color: Colors.grey, size:  16,),
                                  8.horizontalSpace,
                                  latestPost.createdAt!
                                          .timeAgo()
                                          .toString()
                                          .text
                                          .size(16)
                                          .color(Colors.grey)
                                          .size(16)
                                          .make(),

                    ],
                  ),
            ),
                  6.h.heightBox,
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
            // const Icon(FeatherIcons.eye),
                                " ${latestPost.views} views"
                .text.size(16).make(),
            const Icon(FeatherIcons.bookmark, size: 18)

                ],
                ),
            6.h.heightBox,
                ]   ,
                  ).expand()

            ],
            );
            },

            ),
                ],


              ),
            );


          }
          return const SizedBox();

  },
),
      ),
    );
  }
}
